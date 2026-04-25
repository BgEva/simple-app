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

### Docker
docker build -t simple-app .
docker run -p 5000:5000 simple-app

### Docker compose
docker compose up -d

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
./scripts/server-info.sh --help
./scripts/server-info.sh
./scripts/server-info.sh http://localhost:5000/health

## Testing

Run tests:
pytest app/tests/ -v

Test cover:
 - Root endpoint ('/')
 - Heatlh check ('/health')
 - User creation and validation
 - User deletion

## Ansible Deployment

Check syntax:
ansible-playbook --syntax-check -i ansible/inventory.ini ansible/playbook.yml

Dry run:
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check

Run:
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

Verbose run:
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -vvv

## Project Structure


simple-app/
├── app/                    # Application and tests
│   ├── main.py             # REST API
│   ├── requirements.txt    # Python dependencies
│   └── tests/
│       └── test_app.py     # pytest tests
├── scripts/
│   └── server-info.sh      # Server diagnostic script
├── ansible/                # Ansible deployment
│   ├── playbook.yml
│   ├── inventory.ini
│   └── roles/
├── .github/workflows/      # GitHub Actions CI
│   └── build.yml
├── Dockerfile              # Docker image build
├── docker-compose.yml      # Local deployment
├── Makefile                # Project commands
└── README.md               # Documentation


## Troubleshooting

**Port 5000 already in use:**
docker compose down

**Docker not running:**
sudo systemctl start docker

**Ansible permission denied:**
chmod +x scripts/server-info.sh