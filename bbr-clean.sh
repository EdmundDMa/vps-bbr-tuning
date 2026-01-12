#!/usr/bin/env bash
set -e

CONF="/etc/sysctl.d/99-bbr-clean.conf"

echo "==> Writing clean BBR sysctl config to $CONF"

cat > "$CONF" << 'EOF'
############################
# Clean BBR VPS Optimization
# Target: Shared bandwidth VPS
# Goal  : Maximize own throughput
############################

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1

net.core.netdev_max_backlog = 50000
net.ipv4.tcp_max_syn_backlog = 16384
net.core.somaxconn = 4096

net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

net.ipv4.tcp_ecn = 0
net.ipv4.tcp_low_latency = 0

net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_synack_retries = 5
EOF

echo "==> Applying sysctl settings..."
sysctl --system

echo
echo "==> Done."
sysctl net.ipv4.tcp_congestion_control
sysctl net.core.default_qdisc
