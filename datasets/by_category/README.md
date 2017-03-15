Bots from [Wikipedia bots by status category](https://en.wikipedia.org/wiki/Category:Wikipedia_bots_by_status)

Queries 

```
select user_id, user_name from categorylinks inner join page on cl_from=page_id inner join user on user_name = page_title where cl_to='Unapproved_Wikipedia_bots' and page_namespace=2;
```
