#!/bin/bash
set -e
# Get the image - Image must be names disk.raw
curl -L https://download.fedoraproject.org/pub/fedora/linux/releases/29/Cloud/x86_64/images/Fedora-Cloud-Base-29-1.2.x86_64.raw.xz | xz --decompress > disk.raw
# Create the temp bucket to hold the file
#export BUCKET=$(cat /dev/urandom| tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
BUCKET="fedora_images"
#gsutil mb gs://${BUCKET}
# tar & compress the file and upload it
TARFILE=Fedora-Cloud-Base-29.tar.gz
tar -Sczf ${TARFILE} disk.raw 
gsutil cp ${TARFILE} gs://${BUCKET}
# Register the image in GCE
gcloud compute images create fedora-cloud-29 --source-uri gs://${BUCKET}/${TARFILE}
# Cleanup after ourselves
gsutil rm gs://${BUCKET}/${TARFILE}
gsutil rb gs://${BUCKET}
rm disk.raw

# 
gcloud compute instances create fedora29 --machine-type f1-micro --image fedora-cloud-base-29 --zone us-east1-b

gcloud compute ssh fedora@fedora29
