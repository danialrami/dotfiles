# ~/.config/fish/functions/run_script.fish
function run_script --description "Intelligently run scripts with appropriate interpreter"
    set script $argv[1]
    
    if not test -f "$script"
        echo "Error: Script '$script' not found"
        return 1
    end
    
    # Check file extension and shebang
    set first_line (head -n 1 "$script")
    
    switch "$script"
        case "*.sh"
            echo "🐚 Running shell script with bash..."
            bash $argv
        case "*.bash"
            echo "🐚 Running bash script..."
            bash $argv
        case "*.py"
            echo "🐍 Running Python script..."
            python3 $argv
        case "*.rb"
            echo "💎 Running Ruby script..."
            ruby $argv
        case "*.js"
            echo "📜 Running JavaScript with Node..."
            node $argv
        case "*.ts"
            echo "📘 Running TypeScript with Node..."
            npx ts-node $argv
        case "*.lua"
            echo "🌙 Running Lua script..."
            lua $argv
        case "*.pl"
            echo "🐪 Running Perl script..."
            perl $argv
        case "*"
            # Check shebang
            if string match -q "#!/bin/bash*" "$first_line"
                echo "🐚 Running with bash (shebang detected)..."
                bash $argv
            else if string match -q "#!/bin/sh*" "$first_line"
                echo "🐚 Running with sh (shebang detected)..."
                sh $argv
            else if string match -q "#!/usr/bin/env python*" "$first_line"
                echo "🐍 Running with python (shebang detected)..."
                python3 $argv
            else if string match -q "*python*" "$first_line"
                echo "🐍 Running with python (shebang detected)..."
                python3 $argv
            else if string match -q "#!/usr/bin/env node*" "$first_line"
                echo "📜 Running with node (shebang detected)..."
                node $argv
            else if string match -q "*node*" "$first_line"
                echo "📜 Running with node (shebang detected)..."
                node $argv
            else if test -x "$script"
                echo "⚡ Executing as binary..."
                $argv
            else
                echo "🤷 Unknown script type, trying to execute directly..."
                $argv
            end
    end
end