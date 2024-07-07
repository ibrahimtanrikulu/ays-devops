# Set your AWS profile
$AWS_PROFILE = "ays"

# Get the username associated with the AWS_PROFILE
$USERNAME = (aws iam get-user --profile $AWS_PROFILE --query 'User.UserName' --output text)

# Get the MFA serial number for the user
$MFA_SERIAL = (aws iam list-mfa-devices --user-name $USERNAME --profile $AWS_PROFILE --query 'MFADevices[0].SerialNumber' --output text)

# Check if MFA serial number is retrieved
if (-not $MFA_SERIAL) {
  Write-Host "Unable to retrieve MFA serial number."
  exit 1
}

# Read the MFA code from the user
$MFA_CODE = Read-Host -Prompt "Enter MFA code"

# Assume the role using the MFA code to get temporary credentials
$TEMP_CREDENTIALS = aws sts get-session-token --serial-number $MFA_SERIAL --token-code $MFA_CODE --profile $AWS_PROFILE | ConvertFrom-Json

# Export the temporary credentials as environment variables
[System.Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", $TEMP_CREDENTIALS.Credentials.AccessKeyId, [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", $TEMP_CREDENTIALS.Credentials.SecretAccessKey, [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("AWS_SESSION_TOKEN", $TEMP_CREDENTIALS.Credentials.SessionToken, [System.EnvironmentVariableTarget]::Process)

Write-Host "Temporary credentials set successfully."
