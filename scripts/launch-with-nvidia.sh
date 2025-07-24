#!/bin/bash
# ~/scripts/launch-with-nvidia.sh - Launch any application with NVIDIA

if [ $# -eq 0 ]; then
    echo "Usage: $0 <application> [arguments]"
    echo "Example: $0 steam"
    echo "Example: $0 blender --background"
    exit 1
fi

echo "🚀 Launching $1 with NVIDIA GPU..."
prime-run "$@"
