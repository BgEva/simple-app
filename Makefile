.PHONY: help install test run lint server-info docker-build compose-up compose-down

help: ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	pip install -r app/requirements.txt

test: ## Run tests
	pytest app/tests/ -v

run: ## Run application locally
	python app/main.py

lint: ## Lint code
	shellcheck scripts/*.sh

server-info: ## Run server diagnostics
	./scripts/server-info.sh

docker-build: ## Build Docker image
	docker build -t simple-app:latest .

compose-up: ## Start Docker compose
	docker compose up -d

compose-down: ## Stop Docker compose
	docker compose down