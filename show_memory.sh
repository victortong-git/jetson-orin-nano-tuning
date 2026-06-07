#!/usr/bin/env bash

echo "=== Memory Usage ==="
free -m | awk '
BEGIN { printf "%-10s %10s %10s %10s %10s %10s\n", "", "Total", "Used", "Free", "Shared", "Available" }
/Mem:/ { printf "%-10s %10d %10d %10d %10d %10d\n", "RAM:", $2, $3, $4, $5, $7 }
/Swap:/ { printf "%-10s %10d %10d %10d %10s %10s\n", "Swap:", $2, $3, $4, "", "" }
'

echo ""
echo "=== Details ==="
awk '
/^MemTotal:/    { printf "MemTotal:      %s kB (%.1f GB / %.0f MB)\n", $2, $2/1048576, $2/1024 }
/^MemFree:/     { printf "MemFree:       %s kB (%.1f GB / %.0f MB)\n", $2, $2/1048576, $2/1024 }
/^MemAvailable:/ { printf "MemAvailable:  %s kB (%.1f GB / %.0f MB)\n", $2, $2/1048576, $2/1024 }
/^Buffers:/     { printf "Buffers:       %s kB (%.1f MB)\n", $2, $2/1024 }
/^Cached:/      { printf "Cached:        %s kB (%.1f MB)\n", $2, $2/1024 }
/^SwapTotal:/   { printf "SwapTotal:     %s kB (%.1f GB)\n", $2, $2/1048576 }
/^SwapFree:/    { printf "SwapFree:      %s kB (%.1f GB)\n", $2, $2/1048576 }
' /proc/meminfo

echo ""
echo "=== Used Memory Breakdown ==="
awk '
/^Active:/       { printf "Active:        %s kB (%.1f MB)\n", $2, $2/1024 }
/^Inactive:/     { printf "Inactive:      %s kB (%.1f MB)\n", $2, $2/1024 }
/^AnonPages:/    { printf "AnonPages:     %s kB (%.1f MB)\n", $2, $2/1024 }
/^Shmem:/        { printf "Shmem:         %s kB (%.1f MB)\n", $2, $2/1024 }
/^KernelStack:/  { printf "KernelStack:   %s kB (%.1f MB)\n", $2, $2/1024 }
/^SMPRecycled:/  { next }
' /proc/meminfo

echo ""
echo "=== Top 5 Processes by Memory ==="
printf "%-20s %15s %s\n" "USER" "MEM (MB)" "COMMAND"
ps aux --sort=-%mem | tail -n+2 | awk 'NR<=5 { printf "%-20s %8.1f MB  %s\n", $1, $6/1024, $11 }'
