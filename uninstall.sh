#!/bin/bash
# Name: Linux Orchestration Uninstaller
# Description: Safely removes split-first orchestration rules and markers from project files.
# Usage: bash uninstall.sh

FILES=("AGENTS.md" "CLAUDE.md" "GEMINI.md")
MARKER_START="<!-- ORCHESTRATION_START -->"
MARKER_END="<!-- ORCHESTRATION_END -->"

uninstall_file() {
    local file_path="$1"
    
    if [ ! -f "$file_path" ]; then
        return
    fi
    
    if grep -q "$MARKER_START" "$file_path"; then
        echo "Removing rules from $file_path..."
        # Use python for safe multi-line removal
        python3 -c "
import sys, re
start_marker = sys.argv[1]
end_marker = sys.argv[2]
path = sys.argv[3]
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()
pattern = re.compile(re.escape(start_marker) + r'.*?' + re.escape(end_marker) + r'[\r\n]*', re.DOTALL)
new_content = pattern.sub('', content).strip()
if not new_content:
    import os
    os.remove(path)
    print(f'File {path} is now empty. Removed.')
else:
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new_content)
" "$MARKER_START" "$MARKER_END" "$file_path"
    fi
}

for file in "${FILES[@]}"; do
    uninstall_file "$file"
done

echo "Orchestration rules removed successfully."