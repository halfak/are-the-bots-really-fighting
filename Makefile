
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
