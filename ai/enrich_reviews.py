import json
import os
from datetime import datetime, timezone

os.environ['GOOGLE_GENAI_USE_VERTEXAI'] = '1'

from google import genai
from google.cloud import bigquery

PROJECT = "zomato-replica-pipeline"
MODEL="gemini-3.5-flash"
SAMPLE_N= int(os.getenv("SAMPLE_N", 50))
BATCH_SIZE = 25

genai_client = genai.Client(
    vertexai = True,
    project=PROJECT,
    location="global",
)
bq = bigquery.Client(project=PROJECT)

PROMPT = """You are a review analyzer and enrichment tool. You will be given a. JSON array of
review_id and text. Your job is to return a JSON array of review_id, sentiment, topic and key_issue.
The sentiment should be one of: positive, neutral, negative. The topic should be one of: food_quality,
delivery_time,packaging,pricing, app_experience, other.
key_issue is a <= 6 word phrase naming the specific issue . Only when sentiment is negative or the review names a 
concrete problem; otherwise, null. Respond with JSON only, no markdown fences and classify conservatively
(if unsure, return neutral and other).Return exactly one object per input review_id - none skipped, none added. Do not include any extra text or commentary.
Example input:  {"review_id": 7, "text": "biryani was cold and took forever"}
Example output: {"review_id": 7, "sentiment": "negative", "topic": "food_quality",
                 "key_issue": "food arrived cold"}

"""


def fetch_reviews(limit:int) -> list[dict]:
    """Reviews not yet enriched, capped at LIMIT"""
    sql = f"""
    select review_id, comment from `zomato-replica-pipeline.staging.stg_reviews`
    where review_id not in (select review_id from `ai.review_enriched`)
    limit {limit}
    """
    return [dict(row) for row in bq.query(sql).result()]


def enrich_batch(batch:list[dict]) -> list[dict]:
    """Enrich a batch of reviews using the GenAI model"""
    payload = [{
        "review_id": r["review_id"],
        "text": r["comment"]
    } for r in batch]
    resp = genai_client.models.generate_content(
        model=MODEL,
        contents=f"{PROMPT}\n\n{json.dumps(payload)}",
    )
    text = resp.text
    parsed = json.loads(text[text.find("["): text.rfind("]")+1])
    assert len(parsed) == len(batch), f"batch incomplete: {len(parsed)} vs {len(batch)}"

    now = datetime.now(timezone.utc).isoformat()
    return[{
        "review_id": r["review_id"],
        "sentiment": r.get("sentiment"),
        "topic": r.get("topic"),
        "key_issue": r.get("key_issue"),
        "enriched_at": now
    } for r in parsed]

def write_rows(rows:list[dict]):
    """Write enriched reviews to BigQuery"""
    table = f"{PROJECT}.ai.review_enriched"
    errors = bq.insert_rows_json(table, rows)
    if errors:
        print(f"Error writing to {table}: {errors}")

def main():
    reviews = fetch_reviews(SAMPLE_N)
    print(f"Fetched {len(reviews)} reviews to enrich")
    for i in range(0, len(reviews), BATCH_SIZE):
        batch = reviews[i:i+BATCH_SIZE]
        enriched = enrich_batch(batch)
        write_rows(enriched)
        print(f"Enriched and wrote {len(enriched)} reviews")

if __name__ == "__main__":
    main()