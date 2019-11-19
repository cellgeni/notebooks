#!/usr/bin/env bash

MOUNTED_DIRS=$(mount | grep sshfs | awk '{print $3}' | grep -E "^(/nfs|/lustre|/warehouse)$")
if [[ ! -z ${MOUNTED_DIRS} ]];
then
   echo "[+] Unmounting previous mounted folders ($(echo $MOUNTED_DIRS | paste -sd "," -))"
   sudo umount ${MOUNTED_DIRS}
fi

read -p "[>] Input your farm user: " SANGER_USER
read -sp "[>] Input your farm password: " SANGER_PASSWORD
echo ""
echo "[+] Mounting:"
for MOUNT_POINT in /nfs /lustre /warehouse; do
    echo -e "\t- ${MOUNT_POINT}"
    if [ ! -d "$MOUNT_POINT" ]; then
        sudo mkdir -p ${MOUNT_POINT}
    fi
    echo "${SANGER_PASSWORD}" | sudo sshfs -o password_stdin,allow_other,auto_unmount,no_remote_lock,StrictHostKeyChecking=no ${SANGER_USER}@farm4-login:${MOUNT_POINT} ${MOUNT_POINT}
done 
