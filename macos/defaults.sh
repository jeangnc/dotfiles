#!/bin/bash
# macOS defaults settings

# Disable App Nap for Orbstack (prevents freeze when monitor off)
defaults write dev.kdrag0n.MacVirt NSAppSleepDisabled -bool YES

# Prevent OrbStack from pausing containers when system sleeps
if command -v orb &> /dev/null; then
    orb config set power.pause_in_sleep false
fi
