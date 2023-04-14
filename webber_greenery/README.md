### How many users do we have?
I ran
```sql
SELECT count(distinct user_guid) 
FROM STG_POSTGRES__USERS
```
and the result was 130

### On average, how many orders do we receive per hour?
I ran
```
SELECT
  COUNT(CASE WHEN event_type = 'checkout' THEN ORDER_GUID END) AS total_checkout_events,
  DATEDIFF('HOUR', MIN(created_at), MAX(created_at)) AS duration_hours,
  COUNT(CASE WHEN event_type = 'checkout' THEN ORDER_GUID END) * 1.0 / NULLIF(DATEDIFF('HOUR', MIN(created_at), MAX(created_at)), 0) AS avg_checkout_events_per_hour
FROM STG_POSTGRES__EVENTS;
```
and got a result of 6.333333 average checkout events per hour

### On average, how long does an order take from being placed to being delivered?
I ran
```
SELECT 
    AVG(TIMESTAMPDIFF(HOUR, created_at, delivered_at)) AS avg_duration
FROM STG_POSTGRES__ORDERS;
```
and got a result of 93.403279 hours

### How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

### On average, how many unique sessions do we have per hour?