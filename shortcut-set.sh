# Note: This script uses 'gsettings' to write the keybinding to the GNOME DConf database.

# Define the unique path for the new shortcut (e.g., custom99)
KEY_PATH='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom99/'

# 1. Add the new path to the list of custom keybindings
gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | grep "$KEY_PATH" || \
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed "s/]$/, '$KEY_PATH']/")"

# 2. Set the Command (Exec)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH command 'gnome-terminal --title="Ranger" -- /usr/bin/ranger'

# 3. Set the Name
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH name 'Launch Ranger'

# 4. Set the Key Combination (Binding) for Super+E
# '<Super>' is the key, 'e' is the letter.
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH binding '<Super>e'

echo "Keyboard shortcut kbd:[Super+E] has been configured to launch Ranger."