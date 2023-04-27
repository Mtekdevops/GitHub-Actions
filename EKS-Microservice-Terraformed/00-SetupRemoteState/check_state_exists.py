import boto3
import os 

env_file = os.getenv('GITHUB_ENV')

bucket_name = "tfstate-mtekdevops"
table_name = "tflockDDB-mtekdevops-dev"

# Create an S3 client
s3_client = boto3.client("s3")

# Create a DynamoDB client
ddb_client = boto3.client("dynamodb")

# Check if the S3 bucket exists
def check_s3_bucket_exists(bucket_name):
    try:
        s3_client.head_bucket(Bucket=bucket_name)
        return True
    except:
        return False

# Check if the DynamoDB table exists
def check_dynamodb_table_exists(table_name):
    try:
        ddb_client.describe_table(TableName=table_name)
        return True
    except:
        return False

# Check if both the S3 bucket and DynamoDB table exist
if check_s3_bucket_exists(bucket_name) and check_dynamodb_table_exists(table_name):
    status = "REMOTE_STATE_EXISTS=True"
else:
    status = "REMOTE_STATE_EXISTS=False"

# Write the status to the file
with open(env_file, "a") as file:
    file.write(status)