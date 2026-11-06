# OpenClaw on Hostinger

## About
- **What it is:** Setup notes for running OpenClaw, an open-source AI agent platform, on Mark's Hostinger server, following a NetworkChuck video.
- **Business:** homelab
- **Status:** inactive since 2026-04
- **Source:** agent research 2026-11-04

Mark's setup for running OpenClaw (open-source AI agent platform) on a Hostinger VPS.

> **Video source**: [NetworkChuck — OpenClaw on Hostinger](https://www.youtube.com/watch?v=T-HZHO_PQPY)  
> **Hostinger deal**: [hostinger.com/ncopenclaw](https://hostinger.com/ncopenclaw)

---

## What is OpenClaw?

OpenClaw is an open-source AI agent platform with:
- A **Node.js gateway** (web UI on port 18789)
- **ClawHub** — plugin/tool marketplace
- **Sub-agent** support (deploy multiple agents like Terry)
- **Cron jobs**, session management, skills system
- Self-hosted — your API keys, your server

---

## Setup: Hostinger VPS

### 1. Get a VPS
Use the deal code at [hostinger.com/ncopenclaw](https://hostinger.com/ncopenclaw) — KVM VPS is what NetworkChuck used.

### 2. SSH into your server
```bash
ssh root@YOUR_VPS_IP
```

### 3. Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version
```

### 4. Install OpenClaw
```bash
npm install -g openclaw
```

### 5. Configure OpenClaw
```bash
cd ~/openclaw
openclaw config
```
Point it at your Anthropic API key when prompted.

### 6. Start the gateway
```bash
openclaw gateway
```
Gateway runs on **port 18789** — access via `http://YOUR_VPS_IP:18789`

### 7. Install ClawHub (plugin marketplace)
```bash
openclaw clawhub install clawhub
```

---

## Project Structure

```
openclaw/
├── scripts/          # Setup and deployment automation scripts
│   ├── setup-vps.sh  # Full VPS provisioning from scratch
│   └── deploy.sh     # Deploy/restart openclaw on VPS
├── config/           # OpenClaw config templates
│   └── gateway.yml   # Gateway configuration
├── docs/             # Notes and learnings
└── .env.example      # Environment variable template
```

---

## Scripts

```bash
# Provision a fresh Hostinger VPS
./scripts/setup-vps.sh

# Deploy/restart OpenClaw on your VPS
./scripts/deploy.sh

# SSH into your VPS quickly
ssh -i ~/.ssh/id_rsa root@$(grep VPS_HOST .env | cut -d= -f2)
```

---

## Security Notes

- OpenClaw gateway is NOT exposed publicly by default — keep it behind SSH or a reverse proxy
- Never commit your `.env` file
- Be careful with ClawHub skills — they run code on your server (12% warning from NetworkChuck)
- Consider setting up Nginx + SSL if exposing the web UI

---

## Evidence

Transcript extracted: `~/.sys/workspaces/bash/transcripts/T-HZHO_PQPY.txt`  
Cursor rule: `~/.cursor/rules/networkchuck-hostinger-vps.mdc`  
Video ID: `T-HZHO_PQPY`
