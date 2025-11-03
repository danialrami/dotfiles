# {PROJECT_NAME}

A TypeScript/Node.js project.

## Getting Started

### Prerequisites
- Node.js 18+
- Nix (for reproducible development environment)

### Installation

Using Nix:
```bash
nix develop
```

Using npm:
```bash
npm install
```

### Development

Start the development server or run tests:
```bash
npm run dev
```

### Building

```bash
npm run build
```

## Project Structure

```
{PROJECT_NAME}/
├── src/              # TypeScript source files
├── dist/             # Compiled JavaScript (generated)
├── tests/            # Test files
├── flake.nix         # Nix development environment
├── tsconfig.json     # TypeScript configuration
└── package.json      # Node.js dependencies
```

## License

{LICENSE_TYPE}
