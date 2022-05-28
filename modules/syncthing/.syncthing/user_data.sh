#!/bin/bash

log() {
    echo "[$(date)] $(hostname): $@"
}

set -e

USER=admin
EC2_GATEWAY=http://169.254.169.254

log "Add syncthing registry"
sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

log "Install dependencies"
sudo apt update                   # Update registries
sudo apt install -y jq            # Dependency for JSON manipulation
sudo apt install -y libxml2-utils # Dependency for xmllint
sudo apt install -y syncthing     # The actual service

log "Setup syncthing service"
sudo systemctl enable syncthing@$USER.service
sudo systemctl start syncthing@$USER.service

# TODO: find a more sustainable way to do that.
log "Wait for service to be up and running"
sleep 30

log "Configure AWS CLI"
AWS_REGION=$(curl -s $EC2_GATEWAY/latest/dynamic/instance-identity/document | jq -r .region)
aws configure set region $AWS_REGION

log "Get EC2 istance ID"
INSTANCE_ID=$(curl -s $EC2_GATEWAY/latest/meta-data/instance-id)

log "Configure AWS SSM"
PROJECT=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Project'].Value" --output text)
ENVIRONMENT=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Environment'].Value" --output text)
AWS_SSM_PATH="${PROJECT}/${ENVIRONMENT}/syncthing"
AWS_SSM_SYNCTHING_GUI_USERNAME_PATH="/${AWS_SSM_PATH}/gui/username"
AWS_SSM_SYNCTHING_GUI_PASSWORD_PATH="/${AWS_SSM_PATH}/gui/password"
AWS_SSM_SYNCTHING_DEVICE_NAME_PATH="/${AWS_SSM_PATH}/device/name"
AWS_SSM_SYNCTHING_DEFAULTS_FOLDER_PATH="/${AWS_SSM_PATH}/defaults/folder/path"

log "Get syncthing parameters from AWS SSM"
GUI_USERNAME=$(aws ssm get-parameter --name $AWS_SSM_SYNCTHING_GUI_USERNAME_PATH --with-decryption --query "Parameter.Value" --output text)
GUI_PASSWORD=$(aws ssm get-parameter --name $AWS_SSM_SYNCTHING_GUI_PASSWORD_PATH --with-decryption --query "Parameter.Value" --output text)
DEVICE_NAME=$(aws ssm get-parameter --name $AWS_SSM_SYNCTHING_DEVICE_NAME_PATH --with-decryption --query "Parameter.Value" --output text)
DEFAULT_FOLDER=$(aws ssm get-parameter --name $AWS_SSM_SYNCTHING_DEFAULTS_FOLDER_PATH --with-decryption --query "Parameter.Value" --output text)

log "Get Syncthing API"
XML_FILE="/home/$USER/.config/syncthing/config.xml"
SYNCTHING_API_KEY=$(xmllint --xpath 'string(/configuration/gui/apikey)' $XML_FILE)
SYNCTHING_REST_CONFIG_ENDPOINT="localhost:8384/rest/config"

log "Renaming syncthing device"
DEVICE_ID=$(curl -H "X-API-Key: $SYNCTHING_API_KEY" $SYNCTHING_REST_CONFIG_ENDPOINT/devices | jq -r .[0] | jq -r .deviceID)
curl -s -X PATCH -H "X-API-Key: $SYNCTHING_API_KEY" $SYNCTHING_REST_CONFIG_ENDPOINT/devices/$DEVICE_ID -d "{ \"name\": \"$DEVICE_NAME\" }"

log "Deleting default sync folder"
curl -s -X DELETE -H "X-API-Key: $SYNCTHING_API_KEY" $SYNCTHING_REST_CONFIG_ENDPOINT/folders/default

log "Updating default config"
curl -s -X PATCH -H "X-API-Key: $SYNCTHING_API_KEY" $SYNCTHING_REST_CONFIG_ENDPOINT/defaults/folder -d "{ \"path\": \"$DEFAULT_FOLDER\" }"

log "Updating syncthing GUI"
CONFIG_PAYLOAD="{ \"useTLS\": true, \"address\": \"0.0.0.0:8384\", \"user\": \"$GUI_USERNAME\", \"password\": \"$GUI_PASSWORD\" }"
curl -s -X PATCH -H "X-API-Key: $SYNCTHING_API_KEY" $SYNCTHING_REST_CONFIG_ENDPOINT/gui -H "Content-Type: application/json" -d "$CONFIG_PAYLOAD"

log "Restarting the syncthing service, just in case"
sudo systemctl restart syncthing@$USER.service

log "All set!"
