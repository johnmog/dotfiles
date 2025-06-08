#!/bin/bash

# lsregister utility to update extensions
lsregister_path="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
vscode_bundle="com.microsoft.VSCode"

echo "Updating file associations from Cursor to VSCode..."
is_cursor=false

# Read the lsregister dump line by line
$lsregister_path -dump | while IFS= read -r line; do
    if [[ "$line" =~ ^bundle: ]]; then
        # Check if the line indicates a bundle and that it's Cursor
        if [[ "$line" =~ Cursor ]]; then
            is_cursor=true
        else
            is_cursor=false
        fi
    elif $is_cursor && [[ "$line" =~ ^bindings: ]]; then
        # process the bindings for Cursor
        extensions=$(echo "$line" | grep -o "\.[a-z0-9]*")
        for ext in $extensions; do
            echo "Updating extension: $ext"
            duti -s "$vscode_bundle" "${ext#.}" all
        done

        is_cursor=false
    fi
done

killall Finder
killall Dock

echo "Finished"
