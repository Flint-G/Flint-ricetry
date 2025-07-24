#!/bin/bash
# ~/scripts/gpu-status.sh - Check GPU status and power consumption

echo "=== GPU Status Check ==="
echo ""

echo "📊 Available GPUs:"
lspci | grep -E "(VGA|3D)"
echo ""

echo "⚡ NVIDIA GPU Status:"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,power.draw,temperature.gpu,utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "NVIDIA GPU is powered off or not accessible"
else
    echo "nvidia-smi not available"
fi
echo ""

echo "🔋 Active NVIDIA Processes:"
nvidia-smi --query-compute-apps=pid,name --format=csv,noheader,nounits 2>/dev/null | head -10 || echo "No active NVIDIA processes"
echo ""

echo "🌡️  Current Environment Variables:"
echo "LIBVA_DRIVER_NAME: ${LIBVA_DRIVER_NAME:-unset (using iGPU)}"
echo "__GLX_VENDOR_LIBRARY_NAME: ${__GLX_VENDOR_LIBRARY_NAME:-unset (using iGPU)}"
echo ""

echo "💡 Power Management:"
echo "NBFC Status: $(sudo nbfc status 2>/dev/null | head -3 || echo 'NBFC not running')"
echo "CPU Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'unknown')"
echo "CPU Frequency: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{print $1/1000 " MHz"}' || echo 'unknown')"
