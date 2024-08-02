import boto3
import json

# Initialize the AWS session with IAM role
session = boto3.Session(region_name='us-east-1')
ec2_client = session.client('ec2')

# Use describe_instances to get information about your instances
response = ec2_client.describe_instances()

# Initialize an empty dictionary to store private IPs by environment tag
private_ips_by_environment = {}

# Loop through the instances and collect private IPs by environment
for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        private_ip = instance.get('PrivateIpAddress')  # Use get() to avoid KeyError
        if private_ip is not None:  # Check if 'PrivateIpAddress' exists
            for tag in instance.get('Tags', []):  # Use get() to handle missing 'Tags'
                if tag.get('Key') == 'Name':  # Use get() to handle missing 'Key'
                    environment = tag.get('Value')  # Use get() to handle missing 'Value'
                    if environment:
                        if environment not in private_ips_by_environment:
                            private_ips_by_environment[environment] = []
                        private_ips_by_environment[environment].append(private_ip)

# Convert the collected private IPs to JSON format
updated_inventory = {
    "_meta": {
        "hostvars": {}
    }
}

for environment, private_ips in private_ips_by_environment.items():
    updated_inventory[environment] = {
        "hosts": private_ips
    }

# Write the updated inventory to a JSON file
with open('inventory.json', 'w') as f:
    f.write(json.dumps(updated_inventory, indent=4))

# Update the Ansible hosts file
with open('/etc/ansible/hosts', 'w') as ansible_hosts:
    ansible_hosts.write("# Auto-generated Ansible hosts file\n\n")
    for environment, private_ips in private_ips_by_environment.items():
        ansible_hosts.write(f"[{environment}]\n")
        for private_ip in private_ips:
            ansible_hosts.write(f"{private_ip}\n")