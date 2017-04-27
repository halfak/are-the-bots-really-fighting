
b2b_revert_datasets: \
	datasets/frwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/dewiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/ptwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/enwiki_20161201_reverted_bot2bot.tsv.bz2

monthly_stats_datasets: \
	datasets/frwiki_20161001_bot_monthly_revert_stats.tsv \
	datasets/dewiki_20161001_bot_monthly_revert_stats.tsv \
	datasets/ptwiki_20161001_bot_monthly_revert_stats.tsv \
	datasets/jawiki_20161001_bot_monthly_revert_stats.tsv \
	datasets/zhwiki_20161001_bot_monthly_revert_stats.tsv \
	datasets/eswiki_20161001_bot_monthly_revert_stats.tsv
	datasets/enwiki_20161201_bot_monthly_revert_stats.tsv

monthly_stats_datasets: \
	datasets/frwiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/dewiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/ptwiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/jawiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/zhwiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/eswiki_20170420_bot_monthly_revert_stats.tsv \
	datasets/enwiki_20170420_bot_monthly_revert_stats.tsv

############### Bot username datasets ####################

datasets/crosswiki_category_bot_20170319.tsv:
	python get_category_bots.py > datasets/crosswiki_category_bot_20170319.tsv

datasets/crosswiki_unified_bot_20170319.tsv: \
		datasets/crosswiki_category_bot_20170319.tsv
	# From https://quarry.wmflabs.org/query/17557
	( \
	  wget https://quarry.wmflabs.org/run/164750/output/0/tsv?download=true -qO- | tail -n+2; \
	  cat datasets/crosswiki_category_bot_20170319.tsv; \
	) | sort | uniq > \
	datasets/crosswiki_unified_bot_20170319.tsv

############### Bot activity ###################

# https://quarry.wmflabs.org/query/18263
datasets/enwiki_monthly_bot_edits_20170427.tsv:
	wget ???.tsv -qO- > \
	datasets/enwiki_monthly_bot_edits_20170427.tsv

# https://quarry.wmflabs.org/query/18265
datasets/dewiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/0/tsv?download=true -qO- > \
	datasets/dewiki_monthly_bot_edits_20170427.tsv
datasets/frwiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/3/tsv?download=true -qO- > \
	datasets/frwiki_monthly_bot_edits_20170427.tsv
datasets/eswiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/2/tsv?download=true -qO- > \
	datasets/eswiki_monthly_bot_edits_20170427.tsv
datasets/ptwiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/1/tsv?download=true -qO- > \
	datasets/ptwiki_monthly_bot_edits_20170427.tsv
datasets/jawiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/5/tsv?download=true -qO- > \
	datasets/jawiki_monthly_bot_edits_20170427.tsv
datasets/zhwiki_monthly_bot_edits_20170427.tsv:
	wget https://quarry.wmflabs.org/run/171700/output/4/tsv?download=true -qO- > \
	datasets/zhwiki_monthly_bot_edits_20170427.tsv

############### Revert datasets ################

datasets/enwiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/enwiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/enwiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/enwiki_20170420_bot_monthly_revert_stats.tsv

datasets/reverts/dewiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/dewiki/20161001/dewiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/dewiki_20161001_reverts.json.bz2

datasets/dewiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/dewiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/dewiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/dewiki_20170420_bot_monthly_revert_stats.tsv


datasets/reverts/frwiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/frwiki/20161001/frwiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/frwiki_20161001_reverts.json.bz2

datasets/frwiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/frwiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/frwiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/frwiki_20170420_bot_monthly_revert_stats.tsv


datasets/reverts/jawiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/jawiki/20161001/jawiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/jawiki_20161001_reverts.json.bz2

datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/jawiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/jawiki_20161001_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2

datasets/jawiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/jawiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/jawiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/jawiki_20170420_bot_monthly_revert_stats.tsv

datasets/reverts/eswiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/eswiki/20161001/eswiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/eswiki_20161001_reverts.json.bz2

datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/eswiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/eswiki_20161001_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2

datasets/eswiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/eswiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/eswiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/eswiki_20170420_bot_monthly_revert_stats.tsv

datasets/reverts/zhwiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/zhwiki/20161001/zhwiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/zhwiki_20161001_reverts.json.bz2

datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/zhwiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/zhwiki_20161001_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2

datasets/zhwiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/zhwiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/zhwiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/zhwiki_20170420_bot_monthly_revert_stats.tsv

datasets/reverts/ptwiki_20170420_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/ptwiki/20161001/ptwiki-20161001-stub-meta-history?*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/ptwiki_20161001_reverts.json.bz2

datasets/ptwiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/ptwiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/ptwiki_20161001_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/ptwiki_20170420_reverted_bot2bot.tsv.bz2

datasets/ptwiki_20170420_bot_monthly_revert_stats.tsv: \
		datasets/reverts/ptwiki_20170420_reverts.json.bz2
	bzcat datasets/reverts/ptwiki_20170420_reverts.json.bz2 | \
	python bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170319.tsv > \
	datasets/ptwiki_20170420_bot_monthly_revert_stats.tsv
