
dump_date=20170420
dump_dir="/data/wikipedia/xmldatadumps/public"

mkdir datasets/reverts

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

############### Bot username datasets ####################

datasets/crosswiki_category_bot_20170328.tsv:
	python3 get_category_bots.py > datasets/crosswiki_category_bot_20170328.tsv

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
#
# These datasets were generated with the "mwreverts" rules that are now
# commented out.  We've uploaded the intermediate revert datasets to figshare.
# See full citation information:
#
# Halfaker, Aaron; Geiger, R.Stuart (2017):
#   Operationalizing Conflict & Coordination Between Automated Software
#   Agents (datasets). figshare.
#   https://doi.org/10.6084/m9.figshare.5362216.v4
#   Retrieved: 19:26, Sep 01, 2017 (GMT)


#datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/enwiki/$(dump_date)/enwiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/enwiki_$(dump_date)_reverts.json.bz2

datasets/reverts/enwiki_$(dump_date)_reverts.00.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232885 > \
	datasets/reverts/enwiki_$(dump_date)_reverts.00.json.bz2

datasets/reverts/enwiki_$(dump_date)_reverts.01.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232888 > \
	datasets/reverts/enwiki_$(dump_date)_reverts.01.json.bz2

datasets/reverts/enwiki_$(dump_date)_reverts.02.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232894 > \
	datasets/reverts/enwiki_$(dump_date)_reverts.02.json.bz2

datasets/reverts/enwiki_$(dump_date)_reverts.03.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232909 > \
	datasets/reverts/enwiki_$(dump_date)_reverts.03.json.bz2

datasets/reverts/enwiki_$(dump_date)_reverts.04.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232912 > \
	datasets/reverts/enwiki_$(dump_date)_reverts.04.json.bz2

enwiki_reverts_datasets: \
		datasets/reverts/enwiki_$(dump_date)_reverts.00.json.bz2 \
		datasets/reverts/enwiki_$(dump_date)_reverts.01.json.bz2 \
		datasets/reverts/enwiki_$(dump_date)_reverts.02.json.bz2 \
		datasets/reverts/enwiki_$(dump_date)_reverts.03.json.bz2 \
		datasets/reverts/enwiki_$(dump_date)_reverts.04.json.bz2

datasets/reverted_bot2bot/enwiki_$(dump_date).tsv.bz2: \
		enwiki_reverts_datasets \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.??.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/enwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/enwiki_$(dump_date).tsv: \
		enwiki_reverts_datasets
	bzcat datasets/reverts/enwiki_$(dump_date)_reverts.??.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/enwiki_$(dump_date).tsv

#datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/dewiki/$(dump_date)/dewiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2

datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9232567 >
	datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/dewiki_$(dump_date).tsv.bz2: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/dewiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/dewiki_$(dump_date).tsv: \
		datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/dewiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/dewiki_$(dump_date).tsv

#datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/frwiki/$(dump_date)/frwiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2

datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9237628 > \
	datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/frwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/frwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/frwiki_$(dump_date).tsv: \
		datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/frwiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/frwiki_$(dump_date).tsv


#datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/jawiki/$(dump_date)/jawiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2

datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9237637 > \
	datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/jawiki_$(dump_date).tsv.bz2: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/jawiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/jawiki_$(dump_date).tsv: \
		datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/jawiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/jawiki_$(dump_date).tsv

#datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/eswiki/$(dump_date)/eswiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2

datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9237622 > \
	datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/eswiki_$(dump_date).tsv.bz2: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/eswiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/eswiki_$(dump_date).tsv: \
		datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/eswiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/eswiki_$(dump_date).tsv

#datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/zhwiki/$(dump_date)/zhwiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2

datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2:
	wget -qO- https://ndownloader.figshare.com/files/9237655 > \
	datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2

datasets/reverted_bot2bot/zhwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/zhwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/zhwiki_$(dump_date).tsv: \
		datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/zhwiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/zhwiki_$(dump_date).tsv

#datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2:
#	mwreverts dump2reverts \
#	  $(dump_dir)/ptwiki/$(dump_date)/ptwiki-$(dump_date)-stub-meta-history?*.xml.gz \
#	  --radius 15 --use-sha1 --resort | \
#	bzip2 -c > \
#	datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2

datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2:
        wget -qO- https://ndownloader.figshare.com/files/9237652 > \
        datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2



datasets/reverted_bot2bot/ptwiki_$(dump_date).tsv.bz2: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170328.tsv
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	python3 revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170328.tsv | \
	bzip2 -c > \
	datasets/reverted_bot2bot/ptwiki_$(dump_date).tsv.bz2

datasets/monthly_bot_reverts/ptwiki_$(dump_date).tsv: \
		datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2
	bzcat datasets/reverts/ptwiki_$(dump_date)_reverts.json.bz2 | \
	python3 bot_revert_monthly_stats.py \
	  --bots datasets/crosswiki_unified_bot_20170328.tsv > \
	datasets/monthly_bot_reverts/ptwiki_$(dump_date).tsv
