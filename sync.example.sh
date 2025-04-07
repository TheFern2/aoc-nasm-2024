#!/bin/bash

# Parse command line arguments
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run]"
            exit 1
            ;;
    esac
done

# Build rsync command
RSYNC_OPTS="-avz"
if [ "$DRY_RUN" = true ]; then
    RSYNC_OPTS="$RSYNC_OPTS -n"
fi

# Variables
USER="your_username"            # your VM username
HOST="your_vm_ip_or_hostname"   # your VM IP address or hostname
REMOTE_PATH="/path/to/remote/folder/"  # path to the folder on the VM
LOCAL_PATH="/path/to/local/repo/"       # path to your local Git repository

# Sync using rsync
rsync $RSYNC_OPTS "${USER}@${HOST}:${REMOTE_PATH}" "${LOCAL_PATH}"

# Optional: Change to local repo directory and run git commands if needed
cd "${LOCAL_PATH}" || exit
# uncomment if you want git commits automatically
# git add .
# git commit -m "Sync changes from VM"
# git push origin main  # or your relevant branch name