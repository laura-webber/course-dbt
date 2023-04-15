### 1. How many users do we have?
I ran
```sql
SELECT count(distinct user_guid) 
FROM STG_POSTGRES__USERS
```
and the result was 130

### 2. On average, how many orders do we receive per hour?
I ran
```
SELECT
  COUNT(CASE WHEN event_type = 'checkout' THEN ORDER_GUID END) AS total_checkout_events,
  DATEDIFF('HOUR', MIN(created_at), MAX(created_at)) AS duration_hours,
  COUNT(CASE WHEN event_type = 'checkout' THEN ORDER_GUID END) * 1.0 / NULLIF(DATEDIFF('HOUR', MIN(created_at), MAX(created_at)), 0) AS avg_checkout_events_per_hour
FROM STG_POSTGRES__EVENTS;
```
and got a result of 6.333333 average checkout events per hour

### 3. On average, how long does an order take from being placed to being delivered?
I ran
```
SELECT 
    AVG(TIMESTAMPDIFF(HOUR, created_at, delivered_at)) AS avg_duration
FROM STG_POSTGRES__ORDERS;
```
and got a result of 93.403279 hours

### 4. How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

I ran
```
SELECT
    uoc.order_count,
    COUNT(uoc.user_id)
FROM (
    SELECT
        src_po.user_id,
        COUNT(DISTINCT src_po.order_id) as order_count
    FROM 
        dev_db.dbt_victoriaplum13gmailcom.src_postgres_orders src_po
    GROUP BY src_po.user_id
) AS uoc
GROUP BY uoc.order_count
ORDER BY uoc.order_count ASC;
```
and the results were
| Number of Orders | Number of Distinct Users |
|------------------|-------------------------|
| 1                | 25                      |
| 2                | 28                      |
| 3                | 34                      |
| 4                | 20                      |
| 5                | 10                      |
| 6                | 2                        |
| 7                | 4                        |
| 8                | 1                        |


### 5. On average, how many unique sessions do we have per hour?

I ran
```
SELECT 
  SUM(distinct_session_id_count) / CAST(COUNT(created_at_hour) AS FLOAT)
FROM (
  SELECT 
    DATE_TRUNC('HOUR', created_at) AS created_at_hour,
    COUNT(DISTINCT session_id) AS distinct_session_id_count 
  FROM dev_db.dbt_victoriaplum13gmailcom.src_postgres_events 
  GROUP BY DATE_TRUNC('HOUR', created_at)
) AS session_truncate;
```
and the result was 16.32 unique sessions per hour
