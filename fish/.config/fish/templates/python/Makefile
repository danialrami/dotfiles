.PHONY: help install dev test lint format type-check clean build

help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make dev          - Install development dependencies"
	@echo "  make test         - Run tests"
	@echo "  make lint         - Run linting checks"
	@echo "  make format       - Format code with black and isort"
	@echo "  make type-check   - Run type checking with mypy"
	@echo "  make check        - Run all checks (lint, type-check, test)"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make build        - Build distribution packages"

install:
	pip install -e .

dev:
	pip install -e ".[dev]"

test:
	pytest

lint:
	flake8 src/ tests/
	isort --check-only src/ tests/

format:
	black src/ tests/
	isort src/ tests/

type-check:
	mypy src/

check: lint type-check test

clean:
	rm -rf build/ dist/ *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build:
	python -m build
