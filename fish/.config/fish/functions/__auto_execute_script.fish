# ~/.config/fish/functions/__auto_execute_script.fish
function __auto_execute_script --on-event fish_command_not_found --description "Auto-execute scripts with appropriate interpreter"
    set cmd $argv[1]
    
    # Check if it's an executable file
    if test -f "$cmd" -a -x "$cmd"
        # Read the first line to check for shebang
        set first_line (head -n 1 "$cmd")
        
        if string match -q "#!/bin/bash*" "$first_line"
            echo "🐚 Auto-running bash script: $cmd"
            bash $argv
            return 0
        else if string match -q "#!/bin/sh*" "$first_line"
            echo "🐚 Auto-running sh script: $cmd"
            sh $argv
            return 0
        else if string match -q "*\.sh" "$cmd"
            echo "🐚 Auto-running .sh script with bash: $cmd"
            bash $argv
            return 0
        end
    end
    
    # If not handled, let fish show the normal error
    return 1
end