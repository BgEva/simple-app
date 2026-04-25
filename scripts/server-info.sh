#!/bin/bash
set -euo pipefail

LOG_FILE="server-info-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

print_help() {
    echo ""
    echo "Usage: $0 [--help] [URL...]"
    echo ""
    echo "Collects server information and checks service availability."
    echo ""
    echo "Arguments"
    echo "      --help     Show this help message"
    echo "      URL...     One or more HTTP URLs to check (e.g., http://localhost:5000/health)"
    echo ""
    echo "Examples:"
    echo "      $0                                      # System info only"
    echo "      $0 http://localhost:5000/health         # Check one service"
    echo "      $0 http://site1.com http://site2.com    # Check multiple services"
    echo "      $0 --help                               # Show this help"
    echo ""
    echo "Note: Script requires 'curl' for service checks."
}

print_system_info() {
    echo "=== Server Diagnostics ==="
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"
    echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"')"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p | sed 's/up //')"
    echo ""
}

print_resources() {
    echo "=== Resources ==="
    echo " CPU: $(nproc) cores, load average: $(uptime | awk -F'load average:' '{print $2}')"
    free | awk '/^Mem:/ {printf "RAM: %.1fG / %.1fG (%.1f%%)\n", $3/1048576, $2/1048576, ($3/$2)*100}'
    df -h /| awk 'NR==2 {printf "Disk /: %s / %s (%s)\n", $3, $2, $5}'
    echo ""
}

print_docker_info() {
    echo "=== Docker ==="

    if command -v docker &> /dev/null; then
        echo "Docker installed"
        echo ""
        echo "Running containers:"
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" 2>/dev/null || echo " No running containers"
    else
        echo "Docker not installed"
    fi

    echo ""
}

check_services() {
    echo "=== Service Health Checks ==="

    local ok=0
    local fail=0

    for url in "$@"; do
        echo -n "[CHECK] $url ... "
        local start=$(date +%s%3N)
        local status=$(curl -s -o /dev/null -w "%{http_code}" -L --connect-timeout 5 "$url" 2>/dev/null)
        local end=$(date +%s%3N)
        local time_ms=$((end - start))

        if [[ "$status" == "200" ]]; then
            echo "[OK] (${status}, ${time_ms}ms)"
            ((ok++))
        else
            echo "[FAIL] (code: ${status})"
            ((fail++))
        fi
    done

    echo ""
    echo "Result: $ok/$((ok + fail)) services healthy"

    if [[ $fail -gt 0 ]]; then
        return 1
    else
        return 0
    fi
}

main () {
    local urls=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                print_help
                exit 0
                ;;
            *)
                urls+=("$1")
                ;;
        esac
        shift
    done

    print_system_info
    print_resources
    print_docker_info

    if [[ ${#urls[@]} -gt 0 ]]; then
        check_services "${urls[@]}" || true
    fi

    echo ""
    echo "Log saved to: $LOG_FILE"
}


main "$@"
