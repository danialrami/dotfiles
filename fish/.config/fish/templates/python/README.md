# {PROJECT_NAME}

A Python project generated from the Python boilerplate template.

## Overview

This is a Python project template with all the essentials for getting started:
- Project structure following Python best practices
- pyproject.toml for modern package management
- Pre-configured virtual environment support
- Development dependencies and tooling

## Getting Started

### Prerequisites

- Python 3.9 or higher
- pip and venv (usually included with Python)

### Installation

1. Clone/navigate to the project directory
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

## Project Structure

```
{PROJECT_NAME}/
├── src/
│   └── {PROJECT_NAME_KEBAB}/
│       ├── __init__.py
│       └── main.py
├── tests/
│   └── __init__.py
├── docs/
├── README.md
├── LICENSE
├── pyproject.toml
├── .gitignore
├── .env.example
└── CHANGELOG.md
```

## Development

### Running Tests

```bash
pytest
```

### Code Quality

```bash
# Format code
black src/ tests/

# Type checking
mypy src/

# Linting
flake8 src/

# All checks
make check
```

### Building

```bash
python -m build
```

## Usage

```python
from {PROJECT_NAME_KEBAB} import main

# Use your module here
```

## Author

{AUTHOR}

## License

{LICENSE_TYPE}

Created on {TODAY}
