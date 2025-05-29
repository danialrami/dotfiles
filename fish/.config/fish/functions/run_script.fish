# ~/.config/fish/functions/run_script.fish
function run_script --description "Universal script runner for virtually any file type"
    if test (count $argv) -eq 0; or test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: run_script <script_file> [arguments...]"
        echo " Universal script runner that detects file types and runs with appropriate interpreter"
        echo ""
        echo "Supported file types:"
        echo " Shell:      .sh, .bash, .zsh, .fish, .csh"
        echo " Python:     .py, .pyw, .py3"
        echo " JavaScript: .js, .mjs, .cjs"
        echo " TypeScript: .ts, .tsx"
        echo " Web:        .html, .htm (opens in browser)"
        echo " Ruby:       .rb, .rbw"
        echo " Perl:       .pl, .pm, .t"
        echo " PHP:        .php, .phtml"
        echo " Lua:        .lua"
        echo " R:          .r, .R"
        echo " Go:         .go"
        echo " Rust:       .rs"
        echo " Java:       .java"
        echo " C/C++:      .c, .cpp, .cc, .cxx (compiles & runs)"
        echo " Swift:      .swift"
        echo " Kotlin:     .kt, .kts"
        echo " Scala:      .scala, .sc"
        echo " Audio:      .scd (SuperCollider), .pd (Pure Data), .maxpat (Max/MSP info)"
        echo " Config:     .json, .yaml, .yml, .toml, .xml (validates/pretty-prints)"
        echo " Markdown:   .md, .markdown (renders preview)"
        echo " Docker:     Dockerfile (builds image)"
        echo " Make:       Makefile, makefile (runs make)"
        echo ""
        echo "Also detects shebang lines for any file without extension"
        echo ""
        echo "Examples:"
        echo " run_script deploy.py"
        echo " run_script build.sh --production"
        echo " run_script server.js 3000"
        return 0
    end

    set script $argv[1]
    
    if not test -f "$script"
        echo "❌ Error: Script '$script' not found"
        return 1
    end
    
    # Check file extension and shebang
    set first_line (head -n 1 "$script")
    
    switch "$script"
        # Shell scripts
        case "*.sh"
            echo "🐚 Running shell script with bash..."
            bash $argv
        case "*.bash"
            echo "🐚 Running bash script..."
            bash $argv
        case "*.zsh"
            echo "🐚 Running zsh script..."
            zsh $argv
        case "*.fish"
            echo "🐟 Running fish script..."
            fish $argv
        case "*.csh"
            echo "🐚 Running csh script..."
            csh $argv
            
        # Python
        case "*.py" "*.pyw" "*.py3"
            echo "🐍 Running Python script..."
            python3 $argv
            
        # JavaScript/Node
        case "*.js" "*.mjs" "*.cjs"
            echo "📜 Running JavaScript with Node..."
            node $argv
            
        # TypeScript
        case "*.ts"
            if command -v tsx > /dev/null
                echo "📘 Running TypeScript with tsx..."
                tsx $argv
            else if command -v ts-node > /dev/null
                echo "📘 Running TypeScript with ts-node..."
                npx ts-node $argv
            else
                echo "📘 Compiling TypeScript and running..."
                set js_file (string replace '.ts' '.js' "$script")
                npx tsc "$script" && node "$js_file"
            end
            
        case "*.tsx"
            echo "⚛️ Running TypeScript React with tsx..."
            if command -v tsx > /dev/null
                tsx $argv
            else
                npx tsx $argv
            end
            
        # Web files
        case "*.html" "*.htm"
            echo "🌐 Opening HTML file in default browser..."
            if test (uname) = "Darwin"
                open "$script"
            else if test (uname) = "Linux"
                xdg-open "$script"
            else
                echo "❌ Browser opening not supported on this platform"
                return 1
            end
            
        # Ruby
        case "*.rb" "*.rbw"
            echo "💎 Running Ruby script..."
            ruby $argv
            
        # Perl
        case "*.pl" "*.pm" "*.t"
            echo "🐪 Running Perl script..."
            perl $argv
            
        # PHP
        case "*.php" "*.phtml"
            echo "🐘 Running PHP script..."
            php $argv
            
        # Lua
        case "*.lua"
            echo "🌙 Running Lua script..."
            lua $argv
            
        # R
        case "*.r" "*.R"
            echo "📊 Running R script..."
            Rscript $argv
            
        # Go
        case "*.go"
            echo "🐹 Running Go script..."
            go run $argv
            
        # Rust
        case "*.rs"
            echo "🦀 Compiling and running Rust..."
            set exe_name (string replace '.rs' '' (basename "$script"))
            rustc "$script" -o "/tmp/$exe_name" && "/tmp/$exe_name" $argv[2..]
            
        # Java
        case "*.java"
            echo "☕ Compiling and running Java..."
            set class_name (string replace '.java' '' (basename "$script"))
            set script_dir (dirname "$script")
            javac "$script" && java -cp "$script_dir" "$class_name" $argv[2..]
            
        # C/C++
        case "*.c"
            echo "🔧 Compiling and running C..."
            set exe_name (string replace '.c' '' (basename "$script"))
            gcc "$script" -o "/tmp/$exe_name" && "/tmp/$exe_name" $argv[2..]
            
        case "*.cpp" "*.cc" "*.cxx"
            echo "🔧 Compiling and running C++..."
            set exe_name (string replace -r '\.(cpp|cc|cxx) '' (basename "$script"))
            g++ "$script" -o "/tmp/$exe_name" && "/tmp/$exe_name" $argv[2..]
            
        # Swift
        case "*.swift"
            echo "🦉 Running Swift script..."
            swift "$script" $argv[2..]
            
        # Kotlin
        case "*.kt"
            echo "🎯 Compiling and running Kotlin..."
            set jar_name (string replace '.kt' '.jar' (basename "$script"))
            kotlinc "$script" -include-runtime -d "/tmp/$jar_name" && java -jar "/tmp/$jar_name" $argv[2..]
            
        case "*.kts"
            echo "🎯 Running Kotlin script..."
            kotlinc -script "$script" $argv[2..]
            
        # Scala
        case "*.scala" "*.sc"
            echo "🎭 Running Scala script..."
            scala "$script" $argv[2..]
            
        # Audio Programming
        case "*.scd"
            echo "🎵 Running SuperCollider script..."
            if command -v sclang > /dev/null
                sclang "$script"
            else if test -f "/Applications/SuperCollider.app/Contents/MacOS/sclang"
                "/Applications/SuperCollider.app/Contents/MacOS/sclang" "$script"
            else
                echo "❌ SuperCollider not found. Install SuperCollider to run .scd files"
                return 1
            end
            
        case "*.pd"
            echo "🎛️ Opening Pure Data patch..."
            if command -v pd > /dev/null
                pd "$script" &
            else
                echo "❌ Pure Data not found. Install Pure Data to open .pd files"
                return 1
            end
            
        case "*.maxpat"
            echo "🎚️ Max/MSP patch detected. Open with Max/MSP manually."
            echo "   This is a binary format that requires Max/MSP to run."
            return 1
            
        # Configuration files (validate/pretty-print)
        case "*.json"
            echo "📋 Validating and pretty-printing JSON..."
            if command -v jq > /dev/null
                jq . "$script"
            else
                python3 -m json.tool "$script"
            end
            
        case "*.yaml" "*.yml"
            echo "📋 Validating YAML..."
            if command -v yq > /dev/null
                yq . "$script"
            else
                python3 -c "import yaml, sys; print(yaml.safe_load(open(sys.argv[1])))" "$script"
            end
            
        case "*.toml"
            echo "📋 Parsing TOML..."
            if command -v toml > /dev/null
                toml "$script"
            else
                python3 -c "import tomllib, sys; print(tomllib.load(open(sys.argv[1], 'rb')))" "$script"
            end
            
        case "*.xml"
            echo "📋 Validating XML..."
            if command -v xmllint > /dev/null
                xmllint --format "$script"
            else
                python3 -c "import xml.etree.ElementTree as ET; ET.parse('$script')"
            end
            
        # Markdown
        case "*.md" "*.markdown"
            echo "📝 Rendering Markdown preview..."
            if command -v glow > /dev/null
                glow "$script"
            else if command -v mdcat > /dev/null
                mdcat "$script"
            else
                echo "💡 Install 'glow' or 'mdcat' for better Markdown rendering"
                cat "$script"
            end
            
        # Docker
        case "Dockerfile" "dockerfile"
            echo "🐳 Building Docker image..."
            set image_name (basename (pwd))
            docker build -t "$image_name" -f "$script" .
            
        # Makefiles
        case "Makefile" "makefile" "GNUmakefile"
            echo "🔨 Running make..."
            make -f "$script" $argv[2..]
            
        # Executable or shebang detection
        case "*"
            # Check shebang first
            if string match -q "#!/bin/bash*" "$first_line"
                echo "🐚 Running with bash (shebang detected)..."
                bash $argv
            else if string match -q "#!/bin/sh*" "$first_line"
                echo "🐚 Running with sh (shebang detected)..."
                sh $argv
            else if string match -q "#!/bin/zsh*" "$first_line"
                echo "🐚 Running with zsh (shebang detected)..."
                zsh $argv
            else if string match -q "#!/usr/bin/fish*" "$first_line"; or string match -q "#!/bin/fish*" "$first_line"
                echo "🐟 Running with fish (shebang detected)..."
                fish $argv
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
            else if string match -q "#!/usr/bin/env ruby*" "$first_line"
                echo "💎 Running with ruby (shebang detected)..."
                ruby $argv
            else if string match -q "*ruby*" "$first_line"
                echo "💎 Running with ruby (shebang detected)..."
                ruby $argv
            else if string match -q "#!/usr/bin/env perl*" "$first_line"
                echo "🐪 Running with perl (shebang detected)..."
                perl $argv
            else if string match -q "*perl*" "$first_line"
                echo "🐪 Running with perl (shebang detected)..."
                perl $argv
            else if string match -q "#!/usr/bin/env lua*" "$first_line"
                echo "🌙 Running with lua (shebang detected)..."
                lua $argv
            else if string match -q "*lua*" "$first_line"
                echo "🌙 Running with lua (shebang detected)..."
                lua $argv
            else if test -x "$script"
                echo "⚡ Executing as binary..."
                $argv
            else
                echo "🤷 Unknown script type, trying to execute directly..."
                $argv
            end
    end
end