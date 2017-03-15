Built using the following query:

```
SELECT user_id, user.user_name 
FROM enwiki.user 
INNER JOIN enwiki.user_groups ON ug_user = user_id 
WHERE ug_group = 'bot' 
UNION 
SELECT user_id, user.user_name 
FROM enwiki.user 
INNER JOIN enwiki.user_former_groups ON ufg_user = user_id 
WHERE ufg_group = 'bot';
```
