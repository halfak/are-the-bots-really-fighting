
db_options = -h analytics-store.eqiad.wmnet -u research


datasets/tables/staging.enwiki_reverted_20140820.created: \
		sql/staging.enwiki_reverted_20140820.create.sql
	echo "SELECT NOW(), COUNT(*) FROM staging.enwiki_reverted_20140820;" | \
	cat sql/staging.enwiki_reverted_20140820.create.sql - | \
	mysql $(db_options) > \
	datasets/tables/staging.enwiki_reverted_20140820.created

datasets/tables/staging.enwiki_reverted_20140820.loaded: \
		datasets/tables/staging.enwiki_reverted_20140820.created \
		datasets/enwiki_reverted_20140820.tsv
	mysqlimport --local --ignore-lines=1 $(db_options) \
	  staging datasets/enwiki_reverted_20140820.tsv; \
	mysql $(db_options) -e "SELECT NOW(), COUNT(*) FROM staging.enwiki_reverted_20140820;" > \
	datasets/tables/staging.enwiki_reverted_20140820.loaded

datasets/enwiki_bot2bot_reverted_20140820.tsv: \
		datasets/tables/staging.enwiki_reverted_20140820.loaded \
		datasets/tables/staging.enwiki_unified_bot_20170315.loaded \
		sql/enwiki_bot2bot_reverted_20140820.sql
	cat sql/enwiki_bot2bot_reverted_20140820.sql | \
	mysql $(db_options) > \
	datasets/enwiki_bot2bot_reverted_20140820.tsv

datasets/tables/staging.enwiki_unified_bot_20170315.created: \
		sql/staging.enwiki_unified_bot_20170315.create.sql
	echo "SELECT NOW(), COUNT(*) FROM staging.enwiki_unified_bot_20170315;" | \
	cat sql/staging.enwiki_unified_bot_20170315.create.sql - | \
	mysql $(db_options) > \
	datasets/tables/staging.enwiki_unified_bot_20170315.created

datasets/enwiki_unified_bot_20170315.tsv: \
		datasets/bots_by_category/active_bots_cat.tsv \
		datasets/bots_by_category/active_bots_nobrfa_cat.tsv \
		datasets/bots_by_category/global_bots_cat.tsv \
		datasets/bots_by_category/inactive_bots_cat.tsv \
		datasets/bots_by_category/unapproved_bots_cat.tsv \
		datasets/bots_by_category/unknown_status_bots_cat.tsv \
		datasets/bots_by_geiger/geiger_bots_20170315.tsv \
		datasets/bots_listed_on_wikipedia/wiki_bots_20170315.tsv \
		datasets/bots_by_flag/flagged_bots_20170315.tsv
	(echo "user_id\tuser_name"; \
	  (tail -n+2 datasets/bots_by_category/active_bots_cat.tsv; \
	    tail -n+2 datasets/bots_by_category/active_bots_nobrfa_cat.tsv; \
	    tail -n+2 datasets/bots_by_category/global_bots_cat.tsv; \
	    tail -n+2 datasets/bots_by_category/inactive_bots_cat.tsv; \
	    tail -n+2 datasets/bots_by_category/unapproved_bots_cat.tsv; \
	    tail -n+2 datasets/bots_by_category/unknown_status_bots_cat.tsv; \
	    tail -n+2 datasets/bots_by_geiger/geiger_bots_20170315.tsv; \
	    tail -n+2 datasets/bots_listed_on_wikipedia/wiki_bots_20170315.tsv; \
	    tail -n+2 datasets/bots_by_flag/flagged_bots_20170315.tsv) | sort | uniq) > \
	datasets/enwiki_unified_bot_20170315.tsv
	  

datasets/tables/staging.enwiki_unified_bot_20170315.loaded: \
		datasets/tables/staging.enwiki_unified_bot_20170315.created \
		datasets/enwiki_unified_bot_20170315.tsv
	mysqlimport --local --ignore-lines=1 $(db_options) \
          staging datasets/enwiki_unified_bot_20170315.tsv; \
	mysql $(db_options) -e "SELECT NOW(), COUNT(*) FROM staging.enwiki_unified_bot_20170315;" > \
	datasets/tables/staging.enwiki_unified_bot_20170315.loaded
