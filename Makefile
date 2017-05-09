dump_date=20170420
dump_dir=/data/wikipedia/xmldatadumps/public
python_path=python3

################################################################################
####################      Datasets       #######################################
################################################################################


datasets: \
	reverted_bot2bot_datasets \
	monthly_bot_revert_datasets \
	monthly_bot_edit_datasets

reverted_bot2bot_datasets: \
	datasets/reverted_bot2bot/frwiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/dewiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/ptwiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/jawiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/zhwiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/eswiki_$(dump_date).tsv.bz2 \
	datasets/reverted_bot2bot/enwiki_$(dump_date).tsv.bz2

monthly_bot_revert_datasets: \
	datasets/monthly_bot_reverts/frwiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/dewiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/ptwiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/jawiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/zhwiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/eswiki_$(dump_date).tsv \
	datasets/monthly_bot_reverts/enwiki_$(dump_date).tsv

monthly_bot_edit_datasets: \
	datasets/monthly_bot_edits/frwiki_20170427.tsv \
	datasets/monthly_bot_edits/dewiki_20170427.tsv \
	datasets/monthly_bot_edits/ptwiki_20170427.tsv \
	datasets/monthly_bot_edits/jawiki_20170427.tsv \
	datasets/monthly_bot_edits/zhwiki_20170427.tsv \
	datasets/monthly_bot_edits/eswiki_20170427.tsv \
	datasets/monthly_bot_edits/enwiki_20170427.tsv

notebooks: \
	analysis/main/0-load-process-data.ipynb \
	analysis/main/4-1-descriptive-stats.ipynb \
	analysis/main/4-2-time-to-revert.ipynb \
	analysis/main/4-3-reverts-per-page-exploratory.ipynb \
	analysis/main/4-3-reverts-per-page-R-enwiki-plots.ipynb \
	analysis/main/6-1-comment-parsing.ipynb \
	analysis/main/6-4-comments-analysis.ipynb \

sample_diffs: \
	analysis/main/6-2-comments-sample-diffs.ipynb 


############### Bot username datasets ####################

datasets/crosswiki_category_bot_20170328.tsv:
	$(python_path) get_category_bots.py > datasets/crosswiki_category_bot_20170328.tsv

datasets/crosswiki_unified_bot_20170328.tsv: \
		datasets/crosswiki_category_bot_20170328.tsv
	# From https://quarry.wmflabs.org/query/17557
	( \
	  wget https://quarry.wmflabs.org/run/164750/output/0/tsv?download=true -qO- | tail -n+2; \
	  cat datasets/crosswiki_category_bot_20170328.tsv; \
	) | sort | uniq > \
	datasets/crosswiki_unified_bot_20170328.tsv

############### Bot activity ###################

# https://quarry.wmflabs.org/query/18263
# datasets/monthly_bot_edits/enwiki_20170427.tsv:
#	wget ???.tsv -qO- > \
#	datasets/monthly_bot_edits/enwiki_20170427.tsv
# This dataset was generated using a long-running query

# https://quarry.wmflabs.org/query/18265
datasets/monthly_bot_edits/dewiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/0/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/dewiki_20170427.tsv
datasets/monthly_bot_edits/frwiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/3/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/frwiki_20170427.tsv
datasets/monthly_bot_edits/eswiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/2/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/eswiki_20170427.tsv
datasets/monthly_bot_edits/ptwiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/1/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/ptwiki_20170427.tsv
datasets/monthly_bot_edits/jawiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/5/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/jawiki_20170427.tsv
datasets/monthly_bot_edits/zhwiki_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/4/tsv?download=true -qO- > \
	datasets/monthly_bot_edits/zhwiki_20170427.tsv

############### Revert datasets ################

datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/enwiki/$(dump_date)/enwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/enwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/enwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/enwiki_$(dump_date).tsv: \
		datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/enwiki_$(dump_date).tsv

datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/dewiki/$(dump_date)/dewiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/dewiki_$(dump_date).tsv.bz2: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/dewiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/dewiki_$(dump_date).tsv: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/dewiki_$(dump_date).tsv


datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/frwiki/$(dump_date)/frwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/frwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/frwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/frwiki_$(dump_date).tsv: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/frwiki_$(dump_date).tsv


datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/jawiki/$(dump_date)/jawiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/jawiki_$(dump_date).tsv.bz2: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/jawiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/jawiki_$(dump_date).tsv: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/jawiki_$(dump_date).tsv

datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/eswiki/$(dump_date)/eswiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/eswiki_$(dump_date).tsv.bz2: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/eswiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/eswiki_$(dump_date).tsv: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/eswiki_$(dump_date).tsv

datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/zhwiki/$(dump_date)/zhwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/zhwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/zhwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/zhwiki_$(dump_date).tsv: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/zhwiki_$(dump_date).tsv

datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  $(dump_dir)/ptwiki/$(dump_date)/ptwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/ptwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/ptwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/ptwiki_$(dump_date).tsv: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	$(python_path) bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/ptwiki_$(dump_date).tsv

######### Notebooks #################################

analysis/main/0-load-process-data.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/0-load-process-data.ipynb --output ../main/0-load-process-data.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/4-1-descriptive-stats.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/4-1-descriptive-stats.ipynb --output ../main/4-1-descriptive-stats.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/4-2-time-to-revert.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/4-2-time-to-revert.ipynb  --output ../main/4-2-time-to-revert.ipynb  --ExecutePreprocessor.timeout=-1
analysis/main/4-3-reverts-per-page-exploratory.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/4-3-reverts-per-page-exploratory.ipynb --output ../main/4-3-reverts-per-page-exploratory.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/4-3-reverts-per-page-R-enwiki-plots.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/4-3-reverts-per-page-R-enwiki-plots.ipynb  --output ../main/4-3-reverts-per-page-R-enwiki-plots.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/6-1-comment-parsing.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/6-1-comment-parsing.ipynb --output ../main/6-1-comment-parsing.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/6-4-comments-analysis.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/6-4-comments-analysis.ipynb --output ../main/6-4-comments-analysis.ipynb --ExecutePreprocessor.timeout=-1
analysis/main/6-2-comments-sample-diffs.ipynb:
	jupyter nbconvert --to notebook --execute analysis/main_src/6-2-comments-sample-diffs.ipynb --output ../main/6-2-comments-sample-diffs.ipynb --ExecutePreprocessor.timeout=-1

