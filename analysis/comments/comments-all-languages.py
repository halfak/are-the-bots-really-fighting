# This just categorizes the comments and exports to pickle. From comments-all-languages.ipynb
# In[ ]:

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import glob
import pickle
import numpy as np
import mwapi


# In[ ]:

import datetime



with open("../../datasets/pandas_df_all.pickle", "rb") as f:
    df_all = pickle.load(f)


# ### Final data format

# In[ ]:

df_all[0:2].transpose()


# # Comments analysis

# Function for removing text within square brackets or parentheses, which is useful for aggregating comment messages.

# In[ ]:
def remove_brackets(str test_str):
    """
    Takes a string and returns that string with text in brackets and parentheses removed
    """
    
    test_str = str(test_str)
    ret = ''
    skip1c = 0
    skip2c = 0
    for i in test_str:
        if i == '[':
            skip1c += 1
        elif i == '(':
            skip2c += 1
        elif i == ']' and skip1c > 0:
            skip1c -= 1
        elif i == ')'and skip2c > 0:
            skip2c -= 1
        elif skip1c == 0 and skip2c == 0:
            ret += i
            
    return " ".join(ret.split())
# In[ ]:

df_all['reverting_comment_nobracket'] = df_all['reverting_comment'].apply(remove_brackets)


# ### Comment parsing functions

# There are two functions that are used to parse comments. `comment_categorization()` runs first and applies a series of pattern matching to comments. If a match is not found, then `interwiki_confirm()` is called, which checks for languages codes in certain patterns that indicate interwiki links.

# In[ ]:

def interwiki_confirm(str comment, str langcode):
    """
    Takes a comment string, searches for language codes bordered by 
    two punctuation marks from [](){},: or one punctuation mark and
    one space. Beginning and end of a comment string counts as a
    space, not a punctuation mark.
    
    Does not recognize the current langcode.
    """
    import string, re
    
    with open("lang_codes.tsv", "r") as f:
        lang_codes = f.read().split("\n")
        
    lang_codes.pop() # a blank '' is in the list that gets returned
    
    lang_codes.remove(langcode)
    
    #print(langcode in lang_codes)
    
    try:
        comment = str(comment)
        comment = comment.lower()
        comment = comment.replace(": ", ":")
        comment = " " + comment + " "  # pad start and end of string with non-punctuation
        #print(comment)
        
    except Exception as e:
        return 'other'
    
    for lang_code in lang_codes:
        
        lang_code_pos = comment.find(lang_code)
        lang_code_len = len(lang_code)
        
        char_before = " "
        char_after = " "
        
        if lang_code_pos >= 0:
            char_before = comment[lang_code_pos-1]
        
            #print("Char before: '", char_before, "'", sep='')
             
            char_after = comment[lang_code_pos+lang_code_len]

            #print("Char after: '", char_after, "'", sep='')
            
            if char_before in string.punctuation and char_after in "[]{}(),:":
                #print(comment, lang_code)
                return 'interwiki link cleanup -- method2'
            
            elif char_after in string.punctuation and char_before in "[]{}(),:":
                #print(comment, lang_code)
                return 'interwiki link cleanup -- method2'
            
            elif char_before == " " and char_after in "[]{}(),:":
                #print(comment, lang_code)
                return 'interwiki link cleanup -- method2'
            
            elif char_after == " " and char_before in "[]{}(),:":
                #print(comment, lang_code)
                return 'interwiki link cleanup -- method2'               
    return 'other'
    

def comment_categorization(row):
    """
    Takes a row from a pandas dataframe or dict and returns a string with a
    kind of activity based on metadata. Used with df.apply(). Mostly parses
    comments, but makes some use of usernames too.
    """
    
    reverting_user = str(row['reverting_user_text'])
    
    reverted_user = str(row['rev_user_text'])
    
    langcode = str(row['language'])
    
    if reverting_user.find("HBC AIV") >= 0:
        return 'AIV helperbot'
    
    try:
        comment = str(row['reverting_comment'])
    except Exception as e:
        return 'other'
    
    comment_lower = comment.lower().strip()
    comment_lower = " ".join(comment_lower.split())
 
    if comment == 'nan':
        return "deleted revision"
    
    if reverting_user == 'Cyberbot II' and reverted_user == 'AnomieBOT' and comment.find("tagging/redirecting to OCC") >= 0:
        return 'botfight: Cyberbot II vs AnomieBOT date tagging'
        
    if reverting_user == 'AnomieBOT' and reverted_user == 'Cyberbot II' and comment.find("{{Deadlink}}") >= 0:
        return 'botfight: Cyberbot II vs AnomieBOT date tagging'                

    if reverting_user == 'RussBot' and reverted_user == 'Cydebot':
        return 'botfight: Russbot vs Cydebot category renaming'  

    if reverting_user == 'Cydebot' and reverted_user == 'RussBot':
        return 'botfight: Russbot vs Cydebot category renaming'  
    
    elif comment.find("Undoing massive unnecessary addition of infoboxneeded by a (now blocked) bot") >= 0:
        return "botfight: infoboxneeded"
    
    elif comment_lower.find("commonsdelinker") >=0 and reverting_user.find("CommonsDelinker") == -1:
        return "botfight: reverting CommonsDelinker"
        
    elif comment.find("Reverted edits by [[Special:Contributions/ImageRemovalBot") >= 0:
        return "botfight: 718bot vs ImageRemovalBot"
    
    elif comment_lower.find("double redirect") >= 0:
        return "fixing double redirect"
    
    elif comment_lower.find("double-redirect") >= 0:
        return "fixing double redirect"

    elif comment_lower.find("has been moved; it now redirects to") >= 0:
        return "fixing double redirect"
    
    elif comment_lower.find("correction du redirect") >= 0:
        return "fixing double redirect"   
        
    elif comment_lower.find("redirect tagging") >= 0:
        return "redirect tagging/sorting"
    
    elif comment_lower.find("sorting redirect") >= 0:
        return "redirect tagging/sorting"
    
    elif comment_lower.find("redirecciones") >= 0 and comment_lower.find("categoría") >= 0:
        return "category redirect cleanup"    
    
    elif comment_lower.find("change redirected category") >= 0:
        return "category redirect cleanup"
    
    elif comment_lower.find("redirected category") >=0:
        return "category redirect cleanup"
    
    elif comment.find("[[User:Addbot|Bot:]] Adding ") >= 0:
        return "template tagging"
    
    elif comment_lower.find("interwiki") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("langlinks") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("iw-link") >= 0:
        return "interwiki link cleanup"
    
    elif comment_lower.find("changing category") >= 0:
        return "moving category"
    
    elif comment_lower.find("recat per") >= 0:
        return "moving category"
    
    elif comment_lower.find("moving category") >= 0:
        return "moving category"

    elif comment_lower.find("move category") >= 0:
        return "moving category"
    
    elif comment_lower.find("re-categorisation") >= 0:
        return "moving category"
    
    elif comment_lower.find("recatégorisation") >= 0:
        return "moving category"   
    
    elif comment_lower.find("Updating users status to") >= 0:
        return "user online status update"
    
    elif comment_lower.find("{{Copy to Wikimedia Commons}} either because the file") >= 0:
        return "template cleanup"
        
    elif comment_lower.find("removing a protection template") >= 0:
        return "protection template cleanup"
    
    elif comment_lower.find("removing categorization template") >= 0:
        return "template cleanup"    
    
    elif comment_lower.find("rm ibid template per") >= 0:
        return "template cleanup"      
    
    elif comment_lower.find("page is not protected") >= 0:
        return "template cleanup"          
    
    elif comment_lower.find("removing protection template") >= 0:
        return "template cleanup"    
    
    elif comment_lower.find("correcting transcluded template per tfd") >= 0:
        return "template cleanup"   
    
    elif comment_lower.find("removing orphan t") >= 0:
        return "template cleanup"
    
    elif comment_lower.find("non-applicable orphan") >= 0:
        return "template cleanup"
    
    elif comment_lower.find("plantilla") >= 0 and comment_lower.find("huérfano") >= 0:
        return "template cleanup"
    
    elif comment_lower.find("removed orphan t") >= 0:
        return "template cleanup"    
    
    elif comment_lower.find("sandbox") >= 0:
        return "clearing sandbox"
    
    elif comment_lower.find("archiving") >= 0:
        return "archiving"
    
    elif comment_lower.find("duplicate on commons") >= 0:
        return "commons image migration"
    
    elif comment_lower.find("user:mathbot/changes to mathlists") >= 0:
        return "botfight: mathbot mathlist updates"
    
    elif reverting_user == 'MathBot' or reverted_user == 'MathBot' >= 0:
        return "botfight: mathbot mathlist updates"
    
    elif comment_lower.find("link syntax") >= 0:
        return "fixing links"
    
    elif comment_lower.find("links syntax") >= 0:
        return "fixing links" 
    
    elif comment_lower.find("no broken #section links left") >= 0:
        return "fixing links"  
    
    elif comment_lower.find("removing redlinks") >= 0:
        return "fixing links" 
    
    elif comment_lower.find("wikidata") >= 0:
        return "interwiki link cleanup"
    
    elif comment.find("言語間") >=0:
        return "interwiki link cleanup"
        
    elif comment_lower.find("interproyecto") >=0:
        return "interwiki link cleanup"    
        
    elif comment.find("语言链接") >=0:
        return "interwiki link cleanup"  
    
    elif comment.find("双重重定向") >=0 or comment.find("雙重重定向") >= 0:
        return "fixing double redirect"   

    elif comment.find("二重リダイレクト") >=0:
        return "fixing double redirect"  
    
    elif comment_lower.find("doppelten redirect") >=0:
        return "fixing double redirect"  
    
    elif comment_lower.find("doppelte weiterleitung") >=0:
        return "fixing double redirect"      
    
    elif comment_lower.find("redirectauflösung") >=0:
        return "fixing double redirect"      
    
    elif comment_lower.find("doble redirección") >=0 or comment_lower.find("redirección doble") >= 0:
        return "fixing double redirect"  
    
    elif comment_lower.find("redireccionamento duplo") >=0:
        return "fixing double redirect"  

    elif comment_lower.find("duplo redirecionamento") >=0:
        return "fixing double redirect"      
    
    elif comment_lower.find("suppression bandeau") >= 0:
        return "template cleanup"
    
    elif comment_lower.find("archiviert") >= 0:
        return "archiving"

    elif comment_lower.find("revert") >= 0:
        return "other w/ revert in comment"  
    
    elif comment_lower.find("rv ") >= 0 or comment_lower.find("rv") == 0:
        return "other w/ revert in comment"  
    
    elif comment_lower.find(" per ") >= 0:
        return "other w/ per justification"  
    
    elif comment_lower.find(" según") >= 0:
        return "other w/ per justification"      
 
    elif comment_lower.find("suite à discussion") >= 0:
        return "other w/ per justification"  
    
    elif comment_lower.find("suite à conservation") >= 0:
        return "other w/ per justification"     
    
    elif comment_lower.find("conforme pedido") >= 0:
        return "other w/ per justification"
    
    else:
        return interwiki_confirm(comment, langcode)

# Testing interwiki confirm

# In[ ]:

tests_yes = ["Robot adding [[es:Test]]",
             "adding es:Test",
             "linking es, it, en",
             "modifying fr:",
             "modifying:zh",
             "modifying: ja"]

tests_no = ["test", 
            "discuss policies on enwiki vs eswiki", 
            "it is done", 
            "per [[en:WP:AIV]]",
            "it's not its", 
            "its not it's",
            "modifying it all",
            "modifying italy"]

print("Should return interwiki link cleanup -- suspected")
for test in tests_yes:
    print("\t", interwiki_confirm(test, 'en'))

print("Should return other")
for test in tests_no:
    print("\t", interwiki_confirm(test, 'en'))


# Apply categorization

# In[ ]:

df_all['bottype'] = df_all.apply(comment_categorization, axis=1)

# Consolidate

def bottype_group(bottype):
    if bottype == "interwiki link cleanup -- method2":
        return "interwiki link cleanup"
    
    elif bottype == "interwiki link cleanup":
        return "interwiki link cleanup"
    
    elif bottype.find("botfight") >= 0:
        return 'botfight'
    
    elif bottype == 'other':
        return 'not classified'
    
    elif bottype == 'fixing double redirect':
        return 'fixing double redirect'
    
    elif bottype == 'protection template cleanup':
        return 'protection template cleanup'
    
    elif bottype.find("category") >= 0:
        return 'category work'
    
    elif bottype.find("template") >= 0:
        return 'template work'
    
    elif bottype == "other w/ revert in comment":
        return "other w/ revert in comment"
    
    else:
        return "other classified"
		
df_all['bottype_group'] = df_all['bottype'].apply(bottype_group)

df_all.to_pickle("df_all_comments_parsed.pickle")
