#!/usr/bin/env fish

function bplate --description "Create a new project from boilerplate templates"
    # Parse arguments
    argparse h/help \
        t/type= \
        d/dry-run \
        a/author= \
        l/license= \
        -- $argv
    or return

    # Show help
    if set -ql _flag_help
        echo "bplate - Create a new project from templates"
        echo ""
        echo "Usage: bplate [OPTIONS] <project_name>"
        echo ""
        echo "Options:"
        echo "  -t, --type <type>      Template type (default: typescript-node)"
        echo "                          Available: typescript-node, python, generic"
        echo "  -a, --author <name>    Author name (default: from git config)"
        echo "  -l, --license <type>   License type (default: GPL-3.0)"
        echo "  -d, --dry-run          Show what would be created without creating"
        echo "  -h, --help             Show this help message"
        echo ""
        echo "Example:"
        echo "  bplate --type typescript-node my-awesome-project"
        echo "  bplate -a 'John Doe' -l Apache-2.0 my-python-project"
        return 0
    end

    # Get project name from positional argument
    set -l project_name $argv[1]
    if test -z "$project_name"
        echo "[ERROR] Project name is required" >&2
        return 1
    end

    # Set defaults
    set -l template_type (set -ql _flag_type && echo $_flag_type || echo "typescript-node")
    set -l author (set -ql _flag_author && echo $_flag_author || git config user.name || echo "Your Name")
    set -l license (set -ql _flag_license && echo $_flag_license || echo "GPL-3.0")
    set -l dry_run (set -ql _flag_dry_run && echo "true" || echo "false")

    # Get current year and today's date
    set -l year (date +%Y)
    set -l today (date +%Y-%m-%d)
    set -l month (date +%m)
    set -l day (date +%d)

    # Convert project name to kebab-case: lowercase, replace underscores/spaces with hyphens, remove non-alphanumeric
    set -l project_kebab (string lower (string replace -ar '[_\s]' '-' $project_name) | string replace -ar '[^a-z0-9-]' '' | string trim -c '-')

    # Determine templates directory - prefer populated directory
    set -l templates_dir
    set -l dotfiles_templates "$HOME/.dotfiles/fish/.config/fish/templates"
    set -l config_templates "$HOME/.config/fish/templates"
    
    if test -d "$dotfiles_templates" && test -d "$dotfiles_templates/typescript-node"
        set templates_dir "$dotfiles_templates"
    else if test -d "$config_templates" && test -d "$config_templates/typescript-node"
        set templates_dir "$config_templates"
    else
        echo "[ERROR] Templates directory not found" >&2
        return 1
    end

    set -l template_path "$templates_dir/$template_type"

    # Determine licenses directory - prefer populated directory
    set -l licenses_dir
    set -l dotfiles_licenses "$HOME/.dotfiles/fish/.config/fish/licenses"
    set -l config_licenses "$HOME/.config/fish/licenses"
    
    if test -d "$dotfiles_licenses" && test -f "$dotfiles_licenses/GPL-3.0"
        set licenses_dir "$dotfiles_licenses"
    else if test -d "$config_licenses" && test -f "$config_licenses/GPL-3.0"
        set licenses_dir "$config_licenses"
    else
        echo "[ERROR] Licenses directory not found" >&2
        return 1
    end

    set -l license_file "$licenses_dir/$license"

    # Validation
    if not test -d "$template_path"
        echo "[ERROR] Template '$template_type' not found at $template_path" >&2
        echo "[INFO] Available templates:" >&2
        if test -d "$templates_dir"
            for dir in (ls "$templates_dir" 2>/dev/null)
                if test -d "$templates_dir/$dir"
                    echo "  - $dir" >&2
                end
            end
        end
        return 1
    end

    # Validate license exists
    if not test -f "$license_file"
        echo "[ERROR] License '$license' not found at $license_file" >&2
        echo "[INFO] Available licenses:" >&2
        if test -d "$licenses_dir"
            for lf in (ls "$licenses_dir" 2>/dev/null)
                echo "  - $lf" >&2
            end
        end
        return 1
    end

    # Check if target directory already exists
    if test -d "$project_name"
        echo "[ERROR] Directory '$project_name' already exists" >&2
        return 1
    end

    # Dry-run mode
    if test "$dry_run" = "true"
        echo "[DRY-RUN] Would create project: $project_name"
        echo "[DRY-RUN] Using template: $template_type"
        echo "[DRY-RUN] Author: $author"
        echo "[DRY-RUN] License: $license"
        echo "[DRY-RUN]"
        echo "[DRY-RUN] Files that would be created:"
        /usr/bin/find "$template_path" -type f -not -path "*/.git/*" 2>/dev/null | while read -l file
            set -l rel_path (string replace "$template_path/" "" "$file")
            echo "[DRY-RUN]   $project_name/$rel_path"
        end
        echo "[DRY-RUN]   $project_name/LICENSE"
        return 0
    end

    # Create project directory
    echo "[INFO] Creating project directory: $project_name"
    mkdir -p "$project_name"
    or begin
        echo "[ERROR] Failed to create project directory" >&2
        return 1
    end

    cd "$project_name"
    or begin
        echo "[ERROR] Failed to change to project directory" >&2
        return 1
    end

    # Copy template files with substitution
    echo "[INFO] Copying template files..."
    /usr/bin/find "$template_path" -type f -not -path "*/.git/*" 2>/dev/null | while read -l source_file
        # Get relative path
        set -l rel_path (string replace "$template_path/" "" "$source_file")
        set -l rel_path (string replace -a "{PROJECT_NAME_KEBAB}" "$project_kebab" "$rel_path")

        # Skip .gitkeep files
        if false && string match -q "*.gitkeep" "$rel_path"
            continue
        end

        # Create directory if needed
        set -l target_dir (dirname "$rel_path")
        if test "$target_dir" != "."
            mkdir -p "$target_dir"
        end

        # Read source file
        set -l content (cat "$source_file")

        # Perform substitutions
        set -l content (string replace -a "{PROJECT_NAME}" "$project_name" "$content")
        set -l content (string replace -a "{PROJECT_NAME_KEBAB}" "$project_kebab" "$content")
        set -l content (string replace -a "{AUTHOR}" "$author" "$content")
        set -l content (string replace -a "{LICENSE_TYPE}" "$license" "$content")
        set -l content (string replace -a "{YEAR}" "$year" "$content")
        set -l content (string replace -a "{MONTH}" "$month" "$content")
        set -l content (string replace -a "{DAY}" "$day" "$content")
        set -l content (string replace -a "{TODAY}" "$today" "$content")

        # Write to target
        echo -n "$content" > "$rel_path"
    end

    # Copy and substitute LICENSE file from central location
    echo "[INFO] Setting up LICENSE file..."
    set -l license_content (cat "$license_file")
    set -l license_content (string replace -a "{AUTHOR}" "$author" "$license_content")
    set -l license_content (string replace -a "{YEAR}" "$year" "$license_content")
    echo -n "$license_content" > LICENSE
    or begin
        echo "[ERROR] Failed to create LICENSE file" >&2
        return 1
    end

    # Copy opencode.json from ~/.config/opencode/opencode.json if it exists
    if test -f "$HOME/.config/opencode/opencode.json"
        echo "[INFO] Copying OpenCode configuration..."
        cp "$HOME/.config/opencode/opencode.json" ./opencode.json
        or echo "[WARN] Failed to copy opencode.json"
    else
        echo "[WARN] OpenCode configuration not found at $HOME/.config/opencode/opencode.json"
    end

    # Git initialization
    echo "[INFO] Initializing git repository..."
    git init
    or begin
        echo "[ERROR] Failed to initialize git repository" >&2
        return 1
    end

    # Add all files to git (required for nix flakes)
    git add .
    or begin
        echo "[ERROR] Failed to add files to git" >&2
        return 1
    end

    # Generate initial commit
    git commit -m "Initial project setup from scaffold template" 2>/dev/null
    or echo "[WARN] Failed to create initial commit (git config may need user.email and user.name)"

    # Nix flake.lock generation
    if command -sq nix
        echo "[INFO] Generating flake.lock from flake.nix..."
        nix flake lock 2>/dev/null
        or echo "[WARN] Failed to generate flake.lock (nix may not be available or experimental features not enabled)"
    else
        echo "[WARN] Nix not found, skipping flake.lock generation"
    end

    # Success!
    echo ""
    echo "[SUCCESS] Project '$project_name' created successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. cd $project_name"
    echo "  2. Configure git: git config user.email 'your@email.com' (if needed)"

    # Template-specific next steps
    if test "$template_type" = "typescript-node"
        echo "  3. For Nix development: nix develop"
        echo "  4. For npm: npm install"
        echo "  5. Start developing: npm run dev"
    else if test "$template_type" = "python"
        echo "  3. Create virtual environment: python -m venv venv"
        echo "  4. Activate environment: source venv/bin/activate"
        echo "  5. Install dependencies: pip install -e '.[dev]'"
        echo "  6. Run tests: pytest"
    else
        echo "  3. Set up your project as needed"
    end

    echo ""
    echo "Files created:"
    if test "$template_type" = "typescript-node"
        echo "  - flake.nix (Nix development environment)"
        echo "  - tsconfig.json (TypeScript configuration)"
        echo "  - package.json (Node.js dependencies)"
    else if test "$template_type" = "python"
        echo "  - pyproject.toml (Python project configuration)"
        echo "  - Makefile (Common tasks)"
        echo "  - src/{PROJECT_NAME_KEBAB}/ (Source code)"
        echo "  - tests/ (Test directory)"
    end
    echo "  - opencode.json (OpenCode configuration)"
    echo "  - README.md"
    echo "  - LICENSE ($license)"
    echo "  - .gitignore"
    echo "  - .env.example"
    echo "  - CHANGELOG.md"
    echo "  - docs/ (directory)"
end
