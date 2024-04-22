#!/bin/bash

# Display lsblk output
echo "Available drives:"
lsblk

# Prompt user to select drive
read -p "Enter the device name (e.g., /dev/sdb1) of the drive you want to mount as /home: " DRIVE

# Check if the specified drive exists
if [[ ! -e $DRIVE ]]; then
    echo "Error: Drive $DRIVE does not exist."
    exit 1
fi

# Prompt user for username
read -p "Enter the username for the /home directory: " USERNAME

# Check if the username is valid
if ! id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME does not exist."
    exit 1
fi

# Define mount point
MOUNT_POINT="/mnt/mydrive"

# Step 1: Create a mount point
sudo mkdir -p $MOUNT_POINT

# Step 2: Mount the drive
sudo mount $DRIVE $MOUNT_POINT

# Step 3: Copy existing data (Optional)
sudo rsync -avz /home/ $MOUNT_POINT/

# Step 4: Unmount the existing /home
sudo umount /home

# Step 5: Mount the drive to /home
sudo mount --bind $MOUNT_POINT /home

# Step 6: Update /etc/fstab (Optional)
echo "$DRIVE   $MOUNT_POINT   ext4   defaults   0  2" | sudo tee -a /etc/fstab
echo "$MOUNT_POINT   /home   none   bind   0  0" | sudo tee -a /etc/fstab

# Notify user
echo "Secondary drive $DRIVE mounted as /home for user $USERNAME successfully."

