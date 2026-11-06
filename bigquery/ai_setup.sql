create schema if not exists ai;

create or replace table ai.review_enriched(
    review_id int64,
    sentiment string,
    topic string,
    key_issue string,
    enriched_at timestamp
)