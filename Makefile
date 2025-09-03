SHELL := /bin/bash

.PHONY: help install playwright-install bootstrap run shell lint clean

help: ## Show this help
	@echo "Available targets:" && grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | awk 'BEGIN {FS=":.*?## "} {printf "  %-20s %s\n", $$1, $$2}'

install: ## Install dependencies using Poetry
	poetry install

playwright-install: ## Install Playwright browser binaries in the Poetry environment
	poetry run playwright install

bootstrap: install playwright-install ## Set up the project (install deps + Playwright browsers)
	@echo "Bootstrap complete. You can run the app with 'make run' or enter the env with 'make shell'."

run: ## Run AdSweep
	poetry run python main.py

shell: ## Open an interactive shell inside the project's virtualenv
	poetry shell

lint: ## Placeholder: run linters/tests (not configured)
	@echo "No linters/tests configured. Add lint/test targets as needed."

clean: ## Remove temporary files and outputs
	-find . -name '__pycache__' -type d -exec rm -rf {} + || true
	-rm -rf output/*.html output/screenshots || true
