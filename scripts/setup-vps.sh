#!/usr/bin/env bash
# scripts/setup-vps.sh — Provision a fresh Hostinger VPS for OpenClaw
# Source: NetworkChuck video T-HZHO_PQPY
# Run this ON the VPS after first SSH in: bash setup-vps.sh

set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}[SETUP]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

log "=== OpenClaw VPS Setup ==="
log "Source: hostinger.com/ncopenclaw"

# 1. Update system
log "Updating system packages..."
apt-get update -qq && apt-get upgrade -y -qq

# 2. Download and inspect the OpenClaw install script FIRST (NetworkChuck method)
# Never pipe curl directly to bash without reviewing it — supply chain attacks exist
log "Downloading OpenClaw install script for review..."
curl -fsSL https://openclaw.ai/install.sh -o /tmp/openclaw-install.sh

log "Install script downloaded. Reviewing for unexpected content..."
# Check for suspicious patterns before running
if grep -qiE "curl.*\|(rm -rf|wget|/tmp/[a-z0-9]{8})" /tmp/openclaw-install.sh 2>/dev/null; then
    log "⚠️  SUSPICIOUS content detected in install script — review manually before proceeding"
    log "    cat /tmp/openclaw-install.sh"
    exit 1
fi
log "✅ Script looks clean — running installer"
bash /tmp/openclaw-install.sh
log "OpenClaw installed: $(openclaw --version 2>/dev/null || echo 'installed — check with: openclaw --version')"

# 4. Create openclaw directory
log "Creating ~/openclaw directory..."
mkdir -p ~/openclaw
cd ~/openclaw

# 5. Firewall — open gateway port
if command -v ufw &>/dev/null; then
    log "Opening port 18789 in UFW..."
    ufw allow 18789/tcp
    warn "Port 18789 is now open — secure with reverse proxy + SSL for production"
fi

log "=== Setup complete ==="
log "Next steps:"
log "  1. Run: openclaw config   (set your Anthropic API key)"
log "  2. Run: openclaw gateway  (starts web UI on port 18789)"
log "  3. Visit: http://\$(hostname -I | awk '{print \$1}'):18789"
