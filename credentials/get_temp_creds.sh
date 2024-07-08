#!/bin/bash

# Set your AWS profile
AWS_PROFILE=ays

# Get the username associated with the AWS_PROFILE
USERNAME=$(aws iam get-user --profile $AWS_PROFILE --query 'User.UserName' --output text)

# Get the MFA serial number for the user
MFA_SERIAL=$(aws iam list-mfa-devices --user-name $USERNAME --profile $AWS_PROFILE --query 'MFADevices[0].SerialNumber' --output text)

# Check if MFA serial number is retrieved
if [ -z "$MFA_SERIAL" ]; then
  echo "Unable to retrieve MFA serial number."
  exit 1
fi

# Read the MFA code from the user
read -p "Enter MFA code: " MFA_CODE

# Assume the role using the MFA code to get temporary credentials
TEMP_CREDENTIALS=$(aws sts get-session-token --serial-number $MFA_SERIAL --token-code $MFA_CODE --profile $AWS_PROFILE)

# Export the temporary credentials as environment variables
export AWS_ACCESS_KEY_ID=$(echo $TEMP_CREDENTIALS | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_CREDENTIALS | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $TEMP_CREDENTIALS | jq -r .Credentials.SessionToken)

echo "Temporary credentials set successfully."
