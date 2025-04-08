# Shared between zsh and bash
_configure_fabric() {
  # Loop through pattern files
  for pattern_file in ~/.config/fabric/patterns/*; do
    pattern_name=$(basename "$pattern_file")
    
    # Create alias
    alias "$pattern_name"="fabric --pattern $pattern_name"
    
    # Create function
    eval "
    $pattern_name() {
      local title=\$1
      local date_stamp=\$(date +'%Y-%m-%d')
      local output_path=\"\$obsidian_base/\${date_stamp}-\${title}.md\"
      
      if [ -n \"\$title\" ]; then
        fabric --pattern \"$pattern_name\" -o \"\$output_path\"
      else
        fabric --pattern \"$pattern_name\" --stream
      fi
    }
    "
  done
}

_configure_fabric
