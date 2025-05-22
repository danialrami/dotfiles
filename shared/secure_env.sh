#if ! bw unlock --check >/dev/null 2>&1; then
#    export BW_SESSION=$(bw unlock --raw)
#fi
#export ANTHROPIC_API_KEY=$(bw get item claude.ai | jq -r '.fields[] | select(.name=="API-Key-2025-01-01").value')
