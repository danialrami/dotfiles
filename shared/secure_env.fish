# ~/.dotfiles/shared/secure_env.fish
# Bitwarden integration (when you uncomment it)
# if not bw unlock --check > /dev/null 2>&1
#     set -gx BW_SESSION (bw unlock --raw)
# end
# set -gx ANTHROPIC_API_KEY (bw get item claude.ai | jq -r '.fields[] | select(.name=="API-Key-2025-01-01").value')
