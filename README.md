# g4f-infrlo

gpt4free (xtekky/gpt4free) API server deployed on Infrlo as a Docker app.
The Dockerfile must stay in the repository root, otherwise Infrlo falls
back to a buildpack build.

## Runtime

- Starts with `python -m g4f api --port $PORT` (default 8080).
- Source is cloned from GitHub at image build time; the package is used
  in place with `requirements-slim.txt` (the PyPI `gpt4free` artifact is
  a stale 0.0.0 build and must not be used).

## Environment variables

- `G4F_API_KEY` — key clients must present to the API (set in the
  Infrlo dashboard, never in this repo).
- `HAR_JSON` — optional. Full `.har` export of a logged-in chatgpt.com
  session; the entrypoint writes it to the cookies dir as
  `chatgpt.har` on start. Without it the server runs, but the
  ChatGPT-backed provider has no account to work with.
- `PORT` — listen port if the platform assigns one.

## Data

g4f config/cookies/cache live under `/data` when writable
(`G4F_CONFIG_DIR=/data/g4f`), otherwise under `/tmp`.
