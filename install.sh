#!/bin/bash
# Name: Linux Orchestration Installer
# Description: Injects and updates split-first orchestration rules into target project files (AGENTS.md, CLAUDE.md, GEMINI.md) without overwriting user-defined rules.
# Usage: bash install.sh

REPO_RAW="https://raw.githubusercontent.com/SpIvanM/split-first-tdd-agent-orchestration-framework/main"
FILES=("AGENTS.md" "CLAUDE.md" "GEMINI.md")
MARKER_START="<!-- ORCHESTRATION_START -->"
MARKER_END="<!-- ORCHESTRATION_END -->"

update_file() {
    local file_path="$1"
    local new_content="$2"
    
    if [ ! -f "$file_path" ]; then
        touch "$file_path"
    fi
    
    local full_content
    full_content=$(cat "$file_path")
    
    # Escape single quotes in new_content for python call
    local escaped_content=$(echo "$new_content" | sed "s/'/'\\\\''/g")
    local injected_content="$MARKER_START\n$new_content\n$MARKER_END"
    
    if grep -q "$MARKER_START" "$file_path"; then
        # Use python for multi-line regex replacement
        python3 -c "
import sys, re
start_marker = sys.argv[1]
end_marker = sys.argv[2]
injected = sys.argv[3]
path = sys.argv[4]
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()
pattern = re.compile(re.escape(start_marker) + r'.*?' + re.escape(end_marker), re.DOTALL)
new_content = pattern.sub(injected, content)
with open(path, 'w', encoding='utf-8') as f:
    f.write(new_content)
" "$MARKER_START" "$MARKER_END" "$MARKER_START\n$new_content\n$MARKER_END" "$file_path"
        echo "Updating $file_path..."
    else
        echo -e "$MARKER_START\n$new_content\n$MARKER_END\n\n$(cat "$file_path")" > "$file_path"
        echo "Installing to $file_path..."
    fi
}

for file in "${FILES[@]}"; do
    echo "Downloading $file..."
    content=$(curl -fsSL "$REPO_RAW/$file")
    if [ $? -eq 0 ]; then
        update_file "$file" "$content"
    else
        echo "Error: Failed to download $file"
    fi
done

echo "Orchestration rules installed successfully."