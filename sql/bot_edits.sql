SELECT LEFT(rev_timestamp, 6) AS month, page_namespace, COUNT(*) AS n
FROM revision
INNER JOIN staging.crosswiki_unified_bot ON rev_user_text = username
INNER JOIN page ON rev_page = page_id
GROUP BY 1, 2;
