#!/bin/bash
#
# Script to install Ranger File Manager and set up custom configurations
# from the R0tt3nT0m4t0/ranger-configuration repository.
#
# Usage: ./setup_ranger.sh

# --- Configuration Variables ---
RANGER_REPO="https://github.com/R0tt3nT0m4t0/ranger-configuration.git"
TEMP_DIR="ranger-config-temp"
CONFIG_DIR="$HOME/.config/ranger"
LOCAL_APPS_DIR="$HOME/.local/share/applications"

# Function to check if a command exists
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

# --- 1. System Dependency Installation ---
echo "--- 1. Installing Ranger and Dependencies via dnf ---"
if command_exists dnf; then
    sudo dnf install -y ranger git
    if [ $? -eq 0 ]; then
        echo "Ranger and Git installed successfully."
    else
        echo "Error: Failed to install Ranger or Git. Please check dnf permissions."
        exit 1
    fi
else
    echo "Error: 'dnf' command not found. Please adapt the script for your package manager (e.g., 'apt', 'pacman')."
    exit 1
fi

# --- 2. Clone the Repository ---
echo "--- 2. Cloning the custom configuration repository ---"
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone "$RANGER_REPO" "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone the repository $RANGER_REPO."
    exit 1
fi
echo "Repository cloned into $TEMP_DIR."

# --- 3. Copy Configuration Files ---
echo "--- 3. Copying configurations to ~/.config/ranger ---"

# Check if the 'ranger' directory exists in the cloned repo
if [ ! -d "$TEMP_DIR/ranger" ]; then
    echo "Error: 'ranger' configuration directory not found in the cloned repository."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Create the ~/.config/ranger directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy the entire ranger directory
cp -r "$TEMP_DIR/ranger" "$HOME/.config/"
echo "Custom configuration (rc.conf, commands.py, colorschemes) copied to $CONFIG_DIR."

# --- 4. Copy Desktop Launcher ---
echo "--- 4. Copying custom ranger.desktop launcher ---"
mkdir -p "$LOCAL_APPS_DIR"

if [ -f "$TEMP_DIR/ranger.desktop" ]; then
    cp "$TEMP_DIR/ranger.desktop" "$LOCAL_APPS_DIR/"
    echo "Launcher copied to $LOCAL_APPS_DIR/ranger.desktop."
    # Update desktop database
    update-desktop-database "$LOCAL_APPS_DIR" > /dev/null 2>&1
else
    echo "Warning: ranger.desktop file not found in the repository. Skipping launcher copy."
fi

# --- 5. Cleanup ---
echo "--- 5. Cleaning up temporary files ---"
rm -rf "$TEMP_DIR"
echo "Setup complete! Restart Ranger to apply changes."
echo "Launch with your new 'ranger' application shortcut or by typing 'ranger' in your terminal."