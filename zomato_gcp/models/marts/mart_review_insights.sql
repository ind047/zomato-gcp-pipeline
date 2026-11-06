SELECT
    r.city,
    e.topic,
    e.sentiment,
    count(*) as review_count,
    avg(r.rating) as avg_rating
from {{source('ai','review_enriched')}} e
join {{ref('stg_reviews')}} r on e.review_id = r.review_id
group by r.city, e.topic, e.sentiment