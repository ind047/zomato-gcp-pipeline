import os
os.environ['GOOGLE_GENAI_USE_VERTEXAI']='1'

from google import genai

client = genai.Client(
    vertexai = True,
    project="zomato-replica-pipeline",
    location="global",
)

resp = client.models.generate_content(
    model="gemini-3.5-flash",
    contents="Reply with exactly: pipeline ready",
)

print(resp.text)
