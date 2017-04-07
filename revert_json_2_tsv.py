"""
Convert a revert.json dataset into reverted TSV format.  Removes self-reverts
and limits reverted edits to the last edit before the revert.

Usage:
    revert_json_2_tsv.py -h | --help
    revert_json_2_tsv.py [--users=<path>]

Options:
    -h --help        Prints this documentation
    --users=<path>   A file containing usernames to limit the dataset to
"""
import json
import sys

import docopt
import mysqltsv
from mwtypes import Timestamp


def main():
    args = docopt.docopt(__doc__)

    HEADINGS = [
        "rev_id",
        "rev_timestamp",
        "rev_user",
        "rev_user_text",
        "rev_page",
        "rev_sha1",
        "rev_minor_edit",
        "rev_deleted",
        "rev_parent_id",
        "archived",
        "reverting_id",
        "reverting_timestamp",
        "reverting_user",
        "reverting_user_text",
        "reverting_page",
        "reverting_sha1",
        "reverting_minor_edit",
        "reverting_deleted",
        "reverting_parent_id",
        "reverting_archived",
        "reverting_comment",
        "rev_revert_offset",
        "revisions_reverted",
        "reverted_to_rev_id",
        "page_namespace"
    ]

    if args['--users']:
        users = {u.strip() for u in open(args['--users'])}
    else:
        users = None

    writer = mysqltsv.Writer(sys.stdout, headers=HEADINGS)

    for doc in (json.loads(l) for l in sys.stdin):
        reverted_username = doc['reverteds'][-1].get('user', {}).get('text')
        reverting_username = doc['reverting'].get('user', {}).get('text')
        if reverted_username == reverting_username:
            continue
        if users is not None and \
           not (reverted_username in users and reverting_username in users):
            continue

        writer.write([
            doc['reverteds'][-1]['id'],  # rev_id
            Timestamp(doc['reverteds'][-1]['timestamp']).short_format(),  # rev_timestamp
            doc['reverteds'][-1].get('user', {}).get('id'),  # rev_user
            doc['reverteds'][-1].get('user', {}).get('text'),  # rev_user_text
            doc['reverteds'][-1]['page']['id'],  # rev_page
            doc['reverteds'][-1].get('sha1'),  # rev_sha1
            doc['reverteds'][-1]['minor'],  # rev_minor_edit
            doc['reverteds'][-1]['deleted']['text'],  # rev_deleted
            doc['reverteds'][-1].get('parent_id'),  # rev_parent_id
            False,  # archived
            doc['reverting']['id'],  # reverting_id
            Timestamp(doc['reverting']['timestamp']).short_format(),  # reverting_timestamp
            doc['reverting'].get('user', {}).get('id'),  # reverting_user
            doc['reverting'].get('user', {}).get('text'),  # reverting_user_text
            doc['reverting']['page']['id'],  #  reverting_page
            doc['reverting'].get('sha1'),  # reverting_sha1
            doc['reverting']['minor'],  # reverting_minor_edit
            doc['reverting']['deleted']['text'],  # reverting_deleted
            doc['reverting'].get('parent_id'),  # reverting_parent_id
            False,  # reverting_archived
            doc['reverting'].get('comment', '-'),  # reverting_comment
            len(doc['reverteds']),  # rev_revert_offset
            len(doc['reverteds']),  # revisions_reverted
            doc['reverted_to']['id'],  # reverted_to_rev_id
            doc['reverting']['page']['namespace']  # page_namespace
        ])
        sys.stderr.write(".")
        sys.stderr.flush()

    sys.stderr.write("\n")


if __name__ == "__main__":
    main()
