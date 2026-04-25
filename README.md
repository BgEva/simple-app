# Simple APP

REST API application in Python. DevOps educational project.

## Requirements

- Python 3.12+
- Docker
- Docker compose

## Quick Start

### Local Run
pip install -r app/requirements.txt
pyrhon app/main.py

### Run with Docker
docker build -t simple-app .
docker run -p 5000:5000 simple-app

## API Endpoints

| Method | Path | Desription |
| ------ | ---- | ---------- |
| GET | '/'  | Hello world|
| GET | '/health' | Health check |
| GET | '/api/users' | List all users |
| POST | '/api/users' | Create a user |
| GET | '/api/users/<id>' | Get user by ID |
| DELETE | 'api/users/<id>' | Delete user by ID |

### Examples

# Health check
curl http://localhost:5000/health

# Create user
curl http://localhost:5000/api/users \
    -H "Content-Type: application/json" \
    -d '{"Ivan"}'

# List users
curl http://localhost:5000/api/users

## Server Diagnostics
./scripts/server-info.sh http://localhost:5000/health

## Project Structure


simple-app/
┣━━━━ app/                # Application and tests
┣━━━━ scripts/            # Bash diagnostic script
┣━━━━ Dockerfile          # Docker image build
┣━━━━ docker-compose.yml  # Local deployment
┗━━━━ README.md           # Documentation
