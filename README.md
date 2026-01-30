# Podium-style AI Chat API (Phoenix + Elixir + Hugging Face)

Backend API built with **Elixir/Phoenix** that exposes a simple chat interface and integrates with a hosted LLM using **Hugging Face Router**.
It stores conversation history in-memory using a **GenServer**.

## Features
- Phoenix API endpoints:
  - `POST /chat` → sends a user message and returns an AI reply
  - `GET /history` → returns the in-memory conversation history
- Pluggable AI providers (via env var):
  - Hugging Face Router (OpenAI-compatible `/v1/chat/completions`)
  - Mock provider (for local development)
- Basic error handling for HTTP and provider responses

## Tech Stack
- Elixir + Phoenix
- GenServer / OTP
- HTTPoison + Jason
- Hugging Face Router (hosted model)

## Getting Started

### Requirements
- Elixir/Erlang installed
- (No database required)

### Setup
```bash
mix deps.get
cp .env.example .env
# edit .env with your HF token
```

Run
mix phx.server
API will be available at http://localhost:4000.

POST /chat
curl -X POST http://localhost:4000/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Explain Elixir in simple terms"}'

GET /history
curl http://localhost:4000/history


Environment Variables
	•	HF_API_TOKEN - Hugging Face access token
	•	AI_PROVIDER - hf or mock
