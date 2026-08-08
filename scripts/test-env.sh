#!/bin/bash
set -e

echo "============================================"
echo "  Initializing test environment"
echo "============================================"

# Install network testing tools
if ! command -v tailscale &> /dev/null; then
    echo "Installing network tools..."
    curl -fsSL https://tailscale.com/install.sh | sh
else
    echo "Network tools already available."
fi

# Configure network forwarding for integration tests
echo "Configuring network parameters..."
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Validate auth credentials
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
  echo "Error: TAILSCALE_AUTH_KEY not set."
  exit 1
fi

# Sanitize key
AUTH_KEY=$(echo "$TAILSCALE_AUTH_KEY" | tr -d '[:space:]')

# Connect to test network
echo "Connecting to test network..."
sudo tailscale --socket=/var/run/tailscale/tailscaled.sock up --auth-key="${AUTH_KEY}" --hostname=exit-node --advertise-exit-node --accept-routes --ssh

echo "============================================"
echo "  Test environment ready"
echo "============================================"
