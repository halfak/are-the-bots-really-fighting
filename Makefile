
b2b_revert_datasets: \
	datasets/frwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/dewiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/ptwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2 \
	datasets/enwiki_20161201_reverted_bot2bot.tsv.bz2

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


############### Revert datasets ################

datasets/reverts/enwiki_20161201_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/enwiki/20161201/enwiki-20161201-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/enwiki_20161201_reverts.json.bz2

datasets/enwiki_20161201_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/enwiki_20161201_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/enwiki_20161201_reverted_bot2bot.tsv.bz2

datasets/reverts/dewiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/dewiki/20161001/dewiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/dewiki_20161001_reverts.json.bz2

datasets/dewiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/dewiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/dewiki_20161001_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/dewiki_20161001_reverted_bot2bot.tsv.bz2

datasets/reverts/frwiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/frwiki/20161001/frwiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/frwiki_20161001_reverts.json.bz2

datasets/frwiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/frwiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/frwiki_20161001_reverted_bot2bot.tsv.bz2

datasets/reverts/jawiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/jawiki/20161001/jawiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/jawiki_20161001_reverts.json.bz2

datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/jawiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/jawiki_20161001_reverted_bot2bot.tsv.bz2

datasets/reverts/eswiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/eswiki/20161001/eswiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/eswiki_20161001_reverts.json.bz2

datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/eswiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/eswiki_20161001_reverted_bot2bot.tsv.bz2

datasets/reverts/zhwiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/zhwiki/20161001/zhwiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/zhwiki_20161001_reverts.json.bz2

datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/zhwiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/zhwiki_20161001_reverted_bot2bot.tsv.bz2

datasets/reverts/ptwiki_20161001_reverts.json.bz2:
	mwreverts dump2reverts \
	  /mnt/data/xmldatadumps/public/ptwiki/20161001/ptwiki-20161001-stub-meta-history*.xml.gz \
	  --radius 15 --use-sha1 | \
	bzip2 -c > \
	datasets/reverts/ptwiki_20161001_reverts.json.bz2

datasets/ptwiki_20161001_reverted_bot2bot.tsv.bz2: \
		datasets/reverts/ptwiki_20161001_reverts.json.bz2 \
		datasets/crosswiki_unified_bot_20170319.tsv
	bzcat datasets/reverts/enwiki_20161201_reverts.json.bz2 | \
	python revert_json_2_tsv.py \
	  --users datasets/crosswiki_unified_bot_20170319.tsv | \
	bzip2 -c > \
	datasets/ptwiki_20161001_reverted_bot2bot.tsv.bz2
