
dump_date=20170420

################################################################################
####################      Datasets       #######################################
################################################################################


datasets: \
	reverted_bot2bot_datasets \
	monthly_bot_revert_datasets \
	monthly_bot_edit_datasets

reverted_bot2bot_datasets: \
	datasets/frwiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/dewiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/ptwiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/jawiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/zhwiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/eswiki_$(dump_date)_reverted_bot2bot.tsv.bz2 \
	datasets/enwiki_$(dump_date)_reverted_bot2bot.tsv.bz2

monthly_bot_revert_datasets: \
	datasets/frwiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/dewiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/ptwiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/jawiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/zhwiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/eswiki_$(dump_date)_monthly_bot_reverts.tsv \
	datasets/enwiki_$(dump_date)_monthly_bot_reverts.tsv

monthly_bot_edit_datasets: \
	datasets/frwiki_20170427_monthly_bot_edits.tsv \
	datasets/dewiki_20170427_monthly_bot_edits.tsv \
	datasets/ptwiki_20170427_monthly_bot_edits.tsv \
	datasets/jawiki_20170427_monthly_bot_edits.tsv \
	datasets/zhwiki_20170427_monthly_bot_edits.tsv \
	datasets/eswiki_20170427_monthly_bot_edits.tsv \
	datasets/enwiki_20170427_monthly_bot_edits.tsv

############### Bot username datasets ####################

datasets/crosswiki_category_bot_20170328.tsv:
	python get_category_bots.py > datasets/crosswiki_category_bot_20170328.tsv

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
# datasets/enwiki_monthly_bot_edits_20170427.tsv:
#	wget ???.tsv -qO- > \
#	datasets/enwiki_monthly_bot_edits_20170427.tsv
# This dataset was generated using a long-running query

# https://quarry.wmflabs.org/query/18265
datasets/dewiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/0/tsv?download=true -qO- > \
	datasets/dewiki_20170427_monthly_bot_edits.tsv
datasets/frwiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/3/tsv?download=true -qO- > \
	datasets/frwiki_20170427_monthly_bot_edits.tsv
datasets/eswiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/2/tsv?download=true -qO- > \
	datasets/eswiki_20170427_monthly_bot_edits.tsv
datasets/ptwiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/1/tsv?download=true -qO- > \
	datasets/ptwiki_20170427_monthly_bot_edits.tsv
datasets/jawiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/5/tsv?download=true -qO- > \
	datasets/jawiki_20170427_monthly_bot_edits.tsv
datasets/zhwiki_20170427_monthly_bot_edits.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/4/tsv?download=true -qO- > \
	datasets/zhwiki_20170427_monthly_bot_edits.tsv

############### Revert datasets ################

datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/enwiki/$(dump_date)/enwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2

datasets/enwiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/enwiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/enwiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/enwiki_$(dump_date)_monthly_bot_reverts.tsv

datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/dewiki/$(dump_date)/dewiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2

datasets/dewiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/dewiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/dewiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/dewiki_$(dump_date)_monthly_bot_reverts.tsv


datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/frwiki/$(dump_date)/frwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2

datasets/frwiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/frwiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/frwiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/frwiki_$(dump_date)_monthly_bot_reverts.tsv


datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/jawiki/$(dump_date)/jawiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2

datasets/jawiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/jawiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/jawiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/jawiki_$(dump_date)_monthly_bot_reverts.tsv

datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/eswiki/$(dump_date)/eswiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2

datasets/eswiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/eswiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/eswiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/eswiki_$(dump_date)_monthly_bot_reverts.tsv

datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/zhwiki/$(dump_date)/zhwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2

datasets/zhwiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/zhwiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/zhwiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/zhwiki_$(dump_date)_monthly_bot_reverts.tsv

datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/ptwiki/$(dump_date)/ptwiki-$(dump_date)-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 --resort | \
	bzip2 -c > \
	datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2

datasets/ptwiki_$(dump_date)_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/ptwiki_$(dump_date)_reverted_bot2bot.tsv.bz2

datasets/ptwiki_$(dump_date)_monthly_bot_reverts.tsv: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/ptwiki_$(dump_date)_monthly_bot_reverts.tsv
