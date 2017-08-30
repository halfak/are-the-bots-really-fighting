# bots-paper-repo
Anonymous repo for a paper in submission to CSCW 2018. This is an updated repo containing new April 2017 datasets, a reorganized structure, better documentation, and Docker/mybinder support. You can launch this repository now in a free mybinder Jupyter Notebook server by clicking the button below (note that this server is temporary and will expire after an hour or so). All the notebooks in `analysis/main/` can be run in your browser from the mybinder server without any additional setup or data processing. Or if you can open any of the notebooks in the `analysis/` folder in GitHub and see static renderings of the analysis.

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org:/repo/anon-cscw2018-author1/bots-paper-repo-binder)

## Requirements
Python >=3.3, with the packages:
```
pip install mwcli mwreverts mwtypes mwxml jsonable docopt mysqltsv pandas seaborn
```
R >= 3.2, with the packages:
```
install.packages("ggplot2")
install.packages("data.table")
```
Jupyter Notebooks >=4.0 for running notebooks, with the [IRKernel](https://github.com/IRkernel/IRkernel) for the R notebooks.

### Docker container
Alternatively, use the `Dockerfile` to create a Docker container with all the prerequsites to run the analyses.

## Datasets

### 0. Bot lists
We have two datasets of bots across language versions of Wikipedia:

- `datasets\crosswiki_category_bot_20170328.tsv` is generated from `get_category_bots.py` (also made in the `Makefile`) and contains a list of bots based on Wikidata categories for various language versions of Wikipedia's equivalent of [Category:All Wikipedia bots](https://www.wikidata.org/wiki/Q3681760)

- `datasets\crosswiki_unified_bot_20170328.tsv` is made in the `Makefile` and contains the above dataset combined with lists of bots from the `user_groups` and `former_user_groups` database tables ("the bot flag") in our seven language versions of Wikipedia. This dataset can be considered as complete of a list of current and historical bots (including unauthorized bots) as is possible to automatically generate for these language versions of Wikipedia.

### 1. Data dumps
This project begins with the the stub-meta-history.xml.gz dumps from the Wikimedia foundation. A BASH script to download these data dumps is in `download_dumps.sh`. Note that these files are large -- approximately 85GB compressed -- and on a 16 core Xeon workstation, it can take a week for the first stage of parsing all reverts from the dumps. As we are not taking issue with how previous researchers have computationally identified reverts (only how to interpret reverts as conflict), replicating this step is not crucial. We recommend those interested in replication start with the bot-bot revert datasets, described below.

### 2. All reverts
The `Makefile` loads the data dumps and runs `mwreverts dump2reverts` to generate .json.bz2 formatted tables of all reverts to all pages across the languages we analyzed, stored in `datasets/reverts/`. These are then parsed by the `Makefile` to generate the monthly bot revert tables in step 3.1 and the bot-bot revert datasets in step 4. These data are not included in the GitHub repo because they are multiple gigabytes, but we will be releasing them publicly on other platforms after peer review.

### 3. Monthly bot activity datasets
#### 3.1 Monthly bot reverts
The `Makefile` loads the full table of reverts and runs `bot_revert_monthly_stats.py` generate TSV formatted tables for each language, which contain namespace-grouped counts of: the number of reverts (reverts), reverts by bots (bot_reverts), bot edits that were reverted (bot_reverteds), and bot-bot-reverts (bot2bot_reverts). This is stored in `datasets/monthly_bot_reverts/` and included in this repo.
#### 3.2 Monthly bot edits
The `Makefile` downloads SQL queries run on the Wikimedia Foundation's open analytics cluster (Tool Labs) to create, for each language, monthly counts by namespace of the number of total bot edits. This is stored in `datasets/monthly_bot_edits/` and included in this repo.

### 4. bot-bot revert datasets
The `Makefile` loads the revert datasets in `datasets/reverts/` and the bot list and runs `revert_json_2_tsv.py` to generate TSV formatted, bz2 compressed datasets of every bot-bot revert across pages in all namespaces for each language. This is stored in `datasets/reverted_bot2bot/` and included in this repo. The format of these datasets can be seen in `analysis/0-load-process-data.ipynb`. Starting with these datasets lets you reproduce the novel parts of our analysis pipeline, and so we recommend starting here.

### 5. Parsed dataframes
Datasets in `datasets/parsed_dataframes/` are created out of the analyses in the Jupyter notebooks in the `analysis/` folder. If you are primarily interested in exploring our results and conducting further analysis, we'd recommend starting with `df_all_comments_parsed_2016.pickle.xz`. These datasets are compressed with xz (extremely compressed to keep them under GitHub's 100mb limit -- we will release many more common data formats when we can de-anonymize and use other platforms). The decompressed pickle file is a serialized pandas dataframe that can be loaded in python, as seen in the notebooks in the `analysis/paper_plots` folder.

- `df_all_2016.pickle.xz` is a pandas dataframe of all bot-bot reverts in the languages in our dataset. It is generated by running the Jupyter notebook `analysis/main/0-load-process-data.ipynb`, which also shows the variables in this dataset.

- `df_all_comments_parsed_2016.pickle.xz` extends `df_all_2016.pickle.xz` with classifications of reverts. It is generated by `analysis/main/6-1-comment-parsing.ipynb`, which also shows the variables in this dataset.

- `possible_botfights.pickle.bz2` and `possible_botfights.tsv.bz2` are bzip2-compressed filtered datasets of `df_all_comments_parsed_2016.pickle`, containing reverts from all langauges in our analysis that are possible cases of bot-bot conflict (part of a bot-bot reciprocation, with time to revert under 180 days). It is generated by `analysis/main/6-4-comments-analysis.ipynb`.

## Analyses
### Analyses in the paper
Analyses that are presented in the paper are in the `analysis/main/` folder, with Jupyter notebooks for each paper section (for example, section 4.2 on time to revert is presented in 4-2-time-to-revert.ipynb). Some of these notebooks include more plots, tables, data, and analyses than we were able to fit in the paper, but we kept them because they could be informative.
### Exploratory analyses
We also have various supplemental and exploratory analyses in `analyses/exploratory/`.

## Sample diff tables
These tables are accessible at [here](https://anon-cscw2018-author1.github.io/bots-paper-repo/sample_tables/) and in raw HTML form at `analysis/sample_tables/`. These were generated by `analysis/6-2-comments-sample-diffs.ipynb`.
