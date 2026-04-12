#!/usr/bin/env bash
# Everything in this script must be idempotent — safe to run multiple times with the same result.

# ---------------------------------------------------------------------------
# Disable WSL interop (prevents Windows executables from being invoked inside WSL)
# ---------------------------------------------------------------------------
WSL_CONF=/etc/wsl.conf

# ---------------------------------------------------------------------------
# Disable WSL interop (prevents Windows executables from being invoked inside WSL)
# ---------------------------------------------------------------------------
if grep -qE '^\[interop\]' "$WSL_CONF" 2>/dev/null; then
    # Section exists — ensure 'enabled = false' is set
    if grep -qE '^enabled\s*=' "$WSL_CONF"; then
        sudo sed -i '/^\[interop\]/,/^\[/{s/^enabled\s*=.*/enabled = false/}' "$WSL_CONF"
    else
        sudo sed -i '/^\[interop\]/a enabled = false' "$WSL_CONF"
    fi
else
    # Section does not exist — append it
    printf '\n[interop]\nenabled = false\n' | sudo tee -a "$WSL_CONF" > /dev/null
fi

echo "WSL interop disabled in $WSL_CONF (restart WSL to apply)."
