#!/bin/bash
echo "Running custom setup script on $(hostname)" >> /var/log/custom_setup.log
echo "Connected to bucket: ${BUCKET_NAME}" >> /var/log/custom_setup.log

# Install additional tools if needed
sudo apt-get install -y htop

# Example: Copy files from bucket (if needed)
# gsutil cp gs://${BUCKET_NAME}/some-file.txt /tmp/

echo "Setup completed at $(date)" >> /var/log/custom_setup.log
