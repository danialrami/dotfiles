function bench --description "Benchmark command execution time using hyperfine"
    if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: bench <command>"
        echo " Benchmark command execution time using hyperfine"
        echo ""
        echo "Arguments:"
        echo " command Command to benchmark"
        echo ""
        echo "Examples:"
        echo " bench 'ls -la'"
        echo " bench 'find . -name \"*.txt\"'"
        echo " bench 'grep -r pattern .'"
        return 0
    end

    if not command -v hyperfine > /dev/null
        echo "Error: This function requires hyperfine"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage: bench <command>"
        return 1
    end

    hyperfine $argv
end
