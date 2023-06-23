import boto3
import paramiko
import argparse
import logging




def create_ec2_connection(instance_id: str, key_pair_path: str, user_name: str, command: str):
    """
    Creates a connection to an EC2 instance using the given instance ID and key pair path.
    """
    ec2 = boto3.resource('ec2')
    logging.info("New EC2 client created.")

    instance = ec2.Instance(id=instance_id)

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    private_key = paramiko.RSAKey.from_private_key_file(key_pair_path)

    # Connect to the instance
    logging.info(f'Connecting to {instance_id} instance ')
    ssh.connect(
        hostname=instance.public_ip_address,
        username=user_name,  # The default username is 'ec2-user', replace with your username if different
        pkey=private_key
    )

    # Execute a command
    logging.info('Executing command...')
    logging.info(f"{command = a}")
    stdin, stdout, stderr = ssh.exec_command(command)

    # Print the output of the command
    logging.info(f"command result : {stdout.read().decode()}")
    ssh.close()


if __name__ == '__main__':

    log_file_name = 'connection.log'

    logging.basicConfig(filename=log_file_name,
                    filemode='a',
                    format='%(levelname)s %(asctime)s %(message)s', 
                    datefmt='%d/%m/%Y %I:%M:%S %p',
                    level=logging.DEBUG)

    logging.info("Running EC2 connection script.")

    #TODO: Loguru
    parser = argparse.ArgumentParser(description="Connect to an EC2 instance and execute a command.")
    parser.add_argument("--instance_id", required=True, help="The instance ID.")
    parser.add_argument("--key_pair_path", required=True, help="The path to the key pair.")
    parser.add_argument("--user_name", required=True, help="The username for the EC2 instance.")
    parser.add_argument("--command", required=True, help="The command to execute on the EC2 instance.")

    args = parser.parse_args()

    create_ec2_connection(args.instance_id, args.key_pair_path, args.user_name, args.command)

    logging.info("\n\n")