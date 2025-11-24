from ranger.api.commands import Command
import os
import re

class touchng(Command):
    """
    :touchng <path>
    Creates the directory structure if it doesn't exist and then creates the file.
    Equivalent to running 'mkdir -p $(dirname <path>) && touch <path>'
    """

    def execute(self):
        # 1. Get the path argument(s) passed to the command
        if not self.args[1:]:
            self.fm.notify('Usage: touchng <path>', bad=True)
            return

        for path in self.args[1:]:
            # 2. Extract the directory name and file name
            # We use os.path.split to separate the directory from the file name
            directory, filename = os.path.split(path)

            # 3. Create the directories recursively (like 'mkdir -p')
            if directory:
                try:
                    # os.makedirs ensures the directories are created if they don't exist
                    os.makedirs(directory, exist_ok=True)
                    self.fm.notify(f"Created directory: {directory}", bad=False)
                except Exception as e:
                    self.fm.notify(f"Error creating directory {directory}: {e}", bad=True)
                    return # Stop if directory creation fails

            # 4. Create the file (like 'touch')
            # The 'if filename' check handles cases where only a directory was passed
            if filename:
                full_path = path if directory else os.path.join(self.fm.cwd.path, path)
                try:
                    # Simple touch implementation
                    with open(full_path, 'a'):
                        os.utime(full_path, None) # Update timestamps/create file if needed
                    self.fm.notify(f"Created file: {path}", bad=False)
                except Exception as e:
                    self.fm.notify(f"Error touching file {path}: {e}", bad=True)

