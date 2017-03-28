import logging

import mwapi
import pywikibase

logger = logging.getLogger(__name__)

logging.basicConfig(
    format='%(asctime)s %(levelname)s:%(name)s -- %(message)s'
)
logger.setLevel(logging.INFO)

wiki_bot_pages = {}
session = mwapi.Session(
    "https://wikidata.org",
    user_agent="Bot name extractor ahalfaker@wikimedia.org")

doc = session.get(
    titles='Q3681760', action='query', prop='revisions', rvprop='content',
    formatversion=2)
content = doc['query']['pages'][0]['revisions'][0]['content']

item = pywikibase.ItemPage('Q10992054')
item.get(content=content)

logger.info("Q3681760 has sitelinks for the following wikis:")
for wikidb, page_name in item.sitelinks.items():
    logger.info(" * {0} '{1}'".format(wikidb, page_name))
    wiki_bot_pages[wikidb] = {'category_name': page_name}


doc = session.get(action='sitematrix', formatversion=2)
sitematrix = {}
for i_str, lang_group in doc['sitematrix'].items():
    try:
        int(i_str)
    except ValueError:
        continue
    for site in lang_group['site']:
        if site['dbname'] in wiki_bot_pages:
            wiki_bot_pages[site['dbname']]['host'] = site['url']

bot_users = set()

for dbname, wiki_bot_page in wiki_bot_pages.items():
    if 'host' not in wiki_bot_page:
        logger.warning("Couldn't find a host for {0} in the sitematrix"
                       .format(dbname))
        continue
    else:
        logger.debug("Connecting to " + wiki_bot_page['host'])
    session = mwapi.Session(
        wiki_bot_page['host'],
        user_agent="Bot name extractor ahalfaker@wikimedia.org")
    docs = session.get(
        action='query', list='categorymembers',
        cmtitle=wiki_bot_page['category_name'],
        cmnamespace=2, formatversion=2, continuation=True)
    old_len = len(bot_users)
    for doc in docs:
        for page in doc['query']['categorymembers']:
            username = page['title'].split(":", 1)[1].replace("_", " ")
            bot_users.add(username)

    logger.info("Found {0} more bots via {1}'s {2}"
                .format(len(bot_users) - old_len, dbname, wiki_bot_page['category_name']))


for user_name in sorted(bot_users):
    print(user_name)
