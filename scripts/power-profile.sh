#!/bin/bash  
# ~/scripts/power-profile.sh - Switch between power profiles (NBFC compatible)

case "$1" in
    "performance")
        echo "🔥 Switching to Performance Mode"
        
        # Set CPU to performance mode
        if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
            echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            echo "✓ CPU governor set to performance"
        else
            echo "⚠ Could not set CPU governor (may need sudo)"
        fi
        
        # Set NBFC to performance profile
        if command -v nbfc &> /dev/null; then
            # You may need to adjust this based on your NBFC config
            sudo nbfc set -s 100 2>/dev/null && echo "✓ NBFC fan speed set to maximum" || echo "⚠ Could not adjust NBFC settings"
        else
            echo "⚠ NBFC not found"
        fi
        
        echo "🚀 Performance mode activated"
        ;;
        
    "powersave")
        echo "🔋 Switching to Power Save Mode"
        
        # Set CPU to powersave mode
        if [ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
            echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            echo "✓ CPU governor set to powersave"
        else
            echo "⚠ Could not set CPU governor (may need sudo)"
        fi
        
        # Set NBFC to auto/quiet profile
        if command -v nbfc &> /dev/null; then
            sudo nbfc set -a 2>/dev/null && echo "✓ NBFC set to auto mode" || echo "⚠ Could not adjust NBFC settings"
        else
            echo "⚠ NBFC not found"
        fi
        
        # Kill unnecessary NVIDIA processes
        echo "🔍 Checking for unnecessary NVIDIA processes..."
        nvidia_pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader,nounits 2>/dev/null)
        if [ ! -z "$nvidia_pids" ]; then
            echo "Found NVIDIA processes running - consider closing applications if not needed"
        else
            echo "✓ No active NVIDIA processes"
        fi
        
        echo "💚 Power save mode activated"
        ;;
        
    "status")
        echo "📊 Current System Status:"
        echo "CPU Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'unknown')"
        echo "CPU Frequency: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{print $1/1000 " MHz"}' || echo 'unknown')"
        echo ""
        echo "NBFC Status:"
        sudo nbfc status 2>/dev/null || echo "NBFC not running or accessible"
        echo ""
        echo "GPU Status:"
        nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,power.draw --format=csv,noheader,nounits 2>/dev/null || echo "NVIDIA GPU not accessible"
        ;;
        
    *)
        echo "Usage: $0 {performance|powersave|status}"
        echo ""
        $0 status
        ;;
esac
