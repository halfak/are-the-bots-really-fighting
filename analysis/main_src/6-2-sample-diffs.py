
# coding: utf-8

# # Section 6.2: Sample diffs
# 
# This is a data analysis script for creating tables of sample diffs for validation as described in section 6.2, which you can run based entirely off the files in this GitHub repository. It loads `datasets/parsed_dataframes/df_all_comments_parsed_2016.pickle.xz` and creates the following files:
# 
# - `datasets/sample_tables/[language]_ns0_sample_dict.pickle`
# - `analysis/main/sample_tables/[language]/ns0/[language]_ns0_sample_all.html`
# - `analysis/main/sample_tables/[language]/ns0/[language]_ns0_sample_[bottype].html`
# 
# This entire notebook can be run from the beginning with Kernel -> Restart & Run All in the menu bar. On a laptop running a Core i5-2540M processor, it takes about 45 minutes to run, as it collects data from the Wikipedia API. 
# 
# ## IF YOU RUN THIS, YOU MUST REPLACE `user_agent_email` WITH YOUR E-MAIL

# In[1]:

user_agent_email = "stuart@stuartgeiger.com"


# In[2]:

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import glob
import pickle
import numpy as np
import mwapi


# In[3]:

import datetime


# In[4]:

start = datetime.datetime.now()


# ## Load data

# In[5]:

get_ipython().system('unxz --keep --force ../../datasets/parsed_dataframes/df_all_comments_parsed_2016.pickle.xz')


# In[6]:

with open("../../datasets/parsed_dataframes/df_all_comments_parsed_2016.pickle", "rb") as f:
    df_all = pickle.load(f)


# ### Final data format

# In[7]:

df_all[0:2].transpose()


# In[8]:

get_ipython().run_cell_magic('bash', '', 'rm -rf sample_tables\nmkdir sample_tables\n\ndeclare -a arr=("de" "en" "es" "fr" "ja" "pt" "zh")\n\nfor i in "${arr[@]}"\ndo\n   mkdir sample_tables/$i/\n   mkdir sample_tables/$i/ns0\n   # or do whatever with individual element of the array\ndone\n\nfind sample_tables/')


# In[9]:

import mwapi
import difflib

session = {}
for lang in df_all['language'].unique():
    session[lang] = mwapi.Session('https://' + str(lang) + '.wikipedia.org', user_agent="Research script by " + user_agent_email)


# In[10]:

def get_revision(rev_id, language):
    
    try:
        rev_get = session[language].get(action='query', prop='revisions', rvprop="content", revids=rev_id)
        rev_pages = rev_get['query']['pages']
        for row in rev_pages.items():
            return(row[1]['revisions'][0]['*'])
    except:
        return np.nan


# In[11]:

def get_diff(row):
    #print(row)
    
    try:
        reverted_content = row['reverted_content'].split("\n")
        reverting_content = row['reverting_content'].split("\n")

        diff = difflib.unified_diff(reverted_content, reverting_content)

        return '<br/>'.join(list(diff))
    
    except:
        return np.nan
      


# In[12]:

def get_diff_api(row):
    #print(row)
    rev_id = row['rev_id']
    reverting_id = row['reverting_id']
    #print(rev_id, reverting_id)
    rev_get = session.get(action='compare', fromrev=rev_id, torev=reverting_id)
    #print(rev_get)
    return rev_get['compare']['*']


# In[13]:

get_ipython().system('mkdir ../../datasets/sample_tables')


# In[16]:

def get_lang_diffs(lang):
    print("-----------")
    print(lang)
    print("-----------")
    import os
    pd.options.display.max_colwidth = -1

    df_lang_ns0 = df_all.query("language == '" + lang + "' and page_namespace == 0").copy()
    #df_lang_ns0['bottype'].unique()
    
    df_lang_ns0_sample_dict = {}
    for bottype in df_lang_ns0['bottype'].unique():
        print(bottype)
        type_df = df_lang_ns0[df_lang_ns0['bottype']==bottype]
      
        
        if len(type_df) > 10000:
            type_df_sample = type_df.sample(round(len(type_df)/100))
        elif len(type_df) > 100:
            type_df_sample = type_df.sample(100)
        else:
            type_df_sample = type_df.copy()

        type_df_sample['reverting_content'] = type_df_sample['reverting_id'].apply(get_revision, language=lang)
        type_df_sample['reverted_content'] = type_df_sample['rev_id'].apply(get_revision, language=lang)

        type_df_sample['diff'] = type_df_sample.apply(get_diff, axis=1)

        df_lang_ns0_sample_dict[bottype] = type_df_sample
        
    with open("../../datasets/sample_tables/df_" + lang + "_ns0_sample_dict.pickle", "wb") as f: 
        pickle.dump(df_lang_ns0_sample_dict, f)
    
    
    for bottype, bottype_df in df_lang_ns0_sample_dict.items():

        bottype_file = bottype.replace(" ", "_")
        bottype_file = bottype_file.replace("/", "_")
        filename = "sample_tables/" + lang + "/ns0/" + lang + "_ns0_sample_" + bottype_file + ".html"

        bottype_df[['reverting_id','reverting_user_text',
                                 'rev_user_text',
                                 'reverting_comment',
                                 'diff']].to_html(filename, escape=False)

        with open(filename, 'r+') as f:
            content = f.read()
            f.seek(0, 0)
            f.write("<a name='" + bottype + "'><h1>" + bottype + "</h1></a>\r\n")
            f.write(content)
            

    call_s = "cat sample_tables/" + lang + "/ns0/*.html > sample_tables/" + lang + "/ns0/" + lang + "_ns0_sample_all.html"
    os.system(call_s)   

            
    with open("sample_tables/" + lang + "/ns0/" + lang + "_ns0_sample_all.html", 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write("<head><meta charset='UTF-8'></head>\r\n<body>")
        f.write("""<style>
                    .dataframe {
                        border:1px solid #C0C0C0;
                        border-collapse:collapse;
                        padding:5px;
                        table-layout:fixed;
                    }
                    .dataframe th {
                        border:1px solid #C0C0C0;
                        padding:5px;
                        background:#F0F0F0;
                    }
                    .dataframe td {
                        border:1px solid #C0C0C0;
                        padding:5px;
                    }
                </style>""")
        f.write("<table class='dataframe'>")
        f.write("<thead><tr><th>Bot type</th><th>Total count in " + lang + "wiki ns0</th><th>Number of sample diffs</th>")

        for bottype, bottype_df in df_lang_ns0_sample_dict.items():

            len_df = str(len(df_lang_ns0[df_lang_ns0['bottype']==bottype]))
            len_sample = str(len(bottype_df))

            toc_str = "<tr><td><a href='#" + bottype + "'>" + bottype + "</a></td>\r\n"
            toc_str += "<td>" + len_df + "</td>"
            toc_str += "<td>" + len_sample + "</td></tr>"
            f.write(toc_str)
        f.write("</table>")
        f.write(content)


# In[ ]:

for lang in df_all['language'].unique():
    get_lang_diffs(lang)


# ## How long did this take to run?

# In[ ]:

end = datetime.datetime.now()


# In[ ]:

time_to_run = end - start
minutes = int(time_to_run.seconds/60)
seconds = time_to_run.seconds % 60
print("Total runtime: ", minutes, "minutes, ", seconds, "seconds")
