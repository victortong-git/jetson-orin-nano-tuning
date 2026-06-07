#!/usr/bin/env bash

echo "=== Memory Usage ==="
free -m | awk '
BEGIN { printf "%-10s %10s %10s %10s %10s %10s\n", "", "Total", "Used", "Free", "Shared", "Available" }
/Mem:/ { printf "%-10s %10d %10d %10d %10d %10d\n", "RAM:", $2, $3, $4, $6, $7 }
/Swap:/ { printf "%-10s %10d %10d %10d %10s %10s\n", "Swap:", $2, $3, $4, "", "" }
'

echo ""
echo "=== Details ==="
awk '
/^MemTotal:/    { printf "MemTotal:      %s kB (%.1f GB)\n", $2, $2/1048576 }
/^MemFree:/     { printf "MemFree:       %s kB (%.1f GB)\n", $2, $2/1048576 }
/^MemAvailable:/ { printf "MemAvailable:  %s kB (%.1f GB)\n", $2, $2/1048576 }
/^Buffers:/     { printf "Buffers:       %s kB (%.1f MB)\n", $2, $2/1024 }
/^Cached:/      { printf "Cached:        %s kB (%.1f MB)\n", $2, $2/1024 }
/^SwapTotal:/   { printf "SwapTotal:     %s kB (%.1f GB)\n", $2, $2/1048576 }
/^SwapFree:/    { printf "SwapFree:      %s kB (%.1f GB)\n", $2, $2/1048576 }
' /proc/meminfo
