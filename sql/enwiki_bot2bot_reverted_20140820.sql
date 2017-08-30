SELECT reverted.*, page.page_namespace AS page_namespace
FROM staging.enwiki_reverted_20140820 AS reverted
INNER JOIN enwiki.page ON rev_page = page_id
INNER JOIN staging.enwiki_unified_bot_20170315 AS reverted_bot ON
        rev_user = reverted_bot.user_id
INNER JOIN staging.enwiki_unified_bot_20170315 AS reverting_bot ON 
        reverting_user = reverting_bot.user_id
WHERE 
        rev_user != reverting_user AND
        rev_revert_offset = revisions_reverted
UNION ALL
SELECT reverted.*, archive.ar_namespace AS page_namespace
FROM staging.enwiki_reverted_20140820 AS reverted 
INNER JOIN enwiki.archive ON rev_id = ar_rev_id
INNER JOIN staging.enwiki_unified_bot_20170315 AS reverted_bot ON
        rev_user = reverted_bot.user_id
INNER JOIN staging.enwiki_unified_bot_20170315 AS reverting_bot ON
        reverting_user = reverting_bot.user_id
WHERE   
        rev_user != reverting_user AND
        rev_revert_offset = revisions_reverted;
