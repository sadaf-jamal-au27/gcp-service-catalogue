# NexusGrid Backend (API)

## Run locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Open:

- API base: `http://localhost:8000/api/healthz`
- OpenAPI: `http://localhost:8000/docs`

