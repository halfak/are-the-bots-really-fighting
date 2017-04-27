"""
Aggregate monthly statistics about bot reverts

Usage:
    bot_revert_monthly_stats.py -h | --help
    bot_revert_monthly_stats.py [--bots=<path>]

Options:
    -h --help        Prints this documentation
    --bots=<path>   A file containing bot usernames
"""
import json
import sys
from collections import defaultdict

import docopt
import mysqltsv
from mwtypes import Timestamp


def main():
    args = docopt.docopt(__doc__)

    HEADINGS = [
        "month",
        "page_namespace",
        "reverts",
        "bot_reverts",
        "bot_reverteds",
        "bot2bot_reverts"
    ]

    if args['--users']:
        bots = {u.strip() for u in open(args['--bots'])}
    else:
        bots = None

    writer = mysqltsv.Writer(sys.stdout, headers=HEADINGS)

    nmc = defaultdict(defaultdict(int))

    for doc in (json.loads(l) for l in sys.stdin):
        reverted_username = doc['reverteds'][-1].get('user', {}).get('text')
        reverting_username = doc['reverting'].get('user', {}).get('text')
        if reverted_username == reverting_username:
            continue
        dbts = Timestamp(doc['reverting']['timestamp']).short_format()
        month = dbts[:6] + "01"
        namespace = doc['reverting']['page']['namespace']

        nmc[month][namespace]['reverts'] += 1
        nmc[month][namespace]['bot_reverts'] += reverting_username in bots
        nmc[month][namespace]['bot_reverteds'] += reverted_username in bots
        nmc[month][namespace]['bot2bot_reverts'] += (
            reverting_username in bots and reverted_username in bots)

    for month in sorted(nmc.keys()):
        for page_namespace in sorted(nmc[month].keys()):
            counts = nmc[month][page_namespace]
            writer.write([month, page_namespace, counts['reverts'],
                          counts['bot_reverts'], counts['bot_reverteds'],
                          counts['bot2bot_reverts']])


if __name__ == "__main__":
    main()
