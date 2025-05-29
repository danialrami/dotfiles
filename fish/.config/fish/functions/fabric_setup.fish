# ~/.config/fish/functions/fabric_setup.fish
function fabric_setup --description "Set up fabric pattern functions"
    set obsidian_base "$HOME/Nextcloud/ore/Notes/Life/Chachi/fabric"
    
    for pattern_file in ~/.config/fabric/patterns/*
        if test -f "$pattern_file"
            set pattern_name (basename "$pattern_file")
            
            # Create function dynamically
            eval "function $pattern_name --description 'Fabric pattern: $pattern_name'
                set title \$argv[1]
                set date_stamp (date +'%Y-%m-%d')
                set output_path '$obsidian_base/\$date_stamp-\$title.md'
                
                if test -n '\$title'
                    fabric --pattern '$pattern_name' -o '\$output_path'
                else
                    fabric --pattern '$pattern_name' --stream
                end
            end"
        end
    end
end
