## Cross-account Access 
- Account [Prod-Account]
  - AWS User
    - cli-prod
    - 1019@awS
  - Access and Secret Access Keys
    - AWS_ACCESS_KEY_ID : **AKIA55UCBXVQYP4MPYOD**
    - AWS_SECRET_ACCESS_KEY : **uQ+1oxCjGh1ABPuuUca8+7VLctOE9BDdxoz4i5vt**

- Account [Dev-Account]
  - AWS User
    - cli-dev
    - 1019@awS
  - Access and Secret Access Keys
    - AWS_ACCESS_KEY_ID : **AKIA55UCBXVQYP4MPYOD**
    - AWS_SECRET_ACCESS_KEY : **uQ+1oxCjGh1ABPuuUca8+7VLctOE9BDdxoz4i5vt**


### Task 1: [Prod-Account]  Create an IAM role in your Prod account (the account that users want to sign in to Dev-account-ID)

This role will need with it a trust policy, which specifies who is allowed to assume the associated role. 
(Replace the placeholder ID with your own Dev account ID.)
```sh

nano prod_trust_policy.json 
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::Dev-account-ID:user/username"
      },
    "Action": "sts:AssumeRole"
  }]
}
```
With the trust policy as defined, you can create the role.
```sh
aws iam create-role 
  --role-name CrossAccountPowerUser 
  --assume-role-policy-document file://./prod_trust_policy.json 
```
Running this in your terminal will produce some information about your role, including the Amazon Resource Name (ARN), which you should take note of before moving on to Task 2. The ARN should look like: “AWS”: “arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser”.

By default, IAM resources (such as roles) are created without any permissions, so you need to define what this role is capable of doing when it is assumed by attaching a policy. Attach the ReadOnlyAccess managed policy.

```sh
aws iam attach-role-policy 
  --role-name CrossAccountPowerUser 
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess 
```

### Task 2: [Dev-Account]  Create a user in the Dev account with permission to assume the IAM role in the Prod account
Now that you have an appropriate IAM role in place, create a policy that allows its principal to assume the role in Prod. Using the ARN returned from Task 1 as the Resource, the policy looks like the following.

Granting a User Permission to Switch Roles 
```sh
dev_assume_role_prod.json

{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser"
    }
}```

The trust policy in Task 1 only allowed the IAM user bjwagner from the Dev account to assume the role, so you will use create-policy to create an IAM managed policy that you will associate with an IAM user.

```sh
nano ./dev_assume_role_prod.json

aws iam create-policy 
  --policy-name ProdAccountAccess 
  --policy-document file://./dev_assume_role_prod.json

```

Notice that you didn’t use the –profile option. This is because without that option, the CLI will use the default credentials that were defined with aws configure, which should be configured to use the Dev account.

Upon success, this will return some information about the newly created policy. You will need to take note of the ARN that is part of the output. If you are using JSON, your output format will look similar to the following.
```sh

{
    "Policy": {
        "PolicyName": " ProdAccountAccess",
        "CreateDate": "2015-11-10T15:01:32.772Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "ANPAKSKWUJMXAERMQUNK",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::Dev-account-ID:policy/ProdAccountAccess",
        "UpdateDate": "2015-11-10T15:01:32.772Z"
    }
}

```
Using the resulting ARN, your last step for this task is to associate the newly created policy with the IAM user in the Dev account. This is achieved with the use of attach-user-policy command.
```sh

aws iam attach-user-policy 
  --user-name bjwagner 
  --policy-arn arn:aws:iam::Dev-account-ID:policy/ProdAccountAccess
```

If nothing is returned, the operation was successful. At this point you have established the permissions needed to achieve cross-account access, and now must configure the AWS CLI to utilize it.


## AWS Command Line Interface (AWS CLI)
The AWS Command Line Interface (AWS CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

### Task-1 :: Create IAM Uses Grant Policy Privileges
### Task-2 :: Install the Configure AWS CLI
```sh
sudo apt update -y
sudo apt install python3-pip -y
pip install --upgrade pip -y
pip3 install awscli
aws --version
```
### Task-3 :: Configure AWS CLI with Profile Name 
The “magic” behind the CLI’s ability to assume a role is the use of named profiles. You can easily create profiles in your configuration and credentials file by using the aws configure set command:

  #### Method 1 : set profile cli-prod
  ```sh
  aws configure --profile cli-prod
  AWS Access Key ID [None]:  $AWS_ACCESS_KEY_ID
  AWS Secret Access Key [None]: $AWS_SECRET_ACCESS_KEY
  Default region name [None]: "ap-south-1"
  Default output format [None]: json
  ```

  #### Method 2 : set profile cli-prod
  ```sh
  aws configure set profile.cli-prod.aws_access_key_id $AWS_ACCESS_KEY_ID
  aws configure set profile.cli-prod.aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  aws configure set profile.cli-prod.region ap-south-1
  aws configure set profile.cli-prod.output json
```
The AWS CLI organizes configuration and credentials into two separate files found in the home directory of your operating system. They are separated to isolate your credentials from the less sensitive configuration options of region and output.
```sh
cat ~/.aws/config
cat ~/.aws/credentials
```

### Task-4 :: Establish cross-account trust and access from the user to the role
Now set the AWS CLI to leverage these changes. To create a profile that will use the role in your Prod account, first apply it to your configuration.

```sh
aws configure set profile. cli-prod.role_arn arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser
aws configure set profile. cli-prod.source_profile default
```

Your ~/.aws/config file will look like the following.
```sh
cat  ~/.aws/config

[default]
region = us-west-1
output = json

[profile cli-prod]
role_arn = arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser
source_profile = default
And the ~/.aws/credentials file will remain the same.
```

Your ~/.aws/credentials file will look like the following.
```sh
cat ~/.aws/credentials
[default]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY>
aws_secret_access_key = <YOUR_AWS_SECRET_KEY>

[profile cli-prod]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY>
aws_secret_access_key = <YOUR_AWS_SECRET_KEY>
```

### Task-4 :: Excercising your power
Without specifying the –profile option in your AWS CLI command, you will automatically use the default profile, which is configured to interact with your Dev account using the long-term credentials that were input when calling aws configure.

```sh
aws ec2 describe-instances --region us-west-1
```
This should return your Amazon EC2 resources in your Dev account in the US West (N. California) region. With the addition of –profile prod in the same command, you should get a very different result set back, which are your EC2 resources from the Prod account in US West (N. California).


```sh
aws ec2 describe-instances --region us-west-1 --profile cli-prod
```

## AWS Command Line Interface (AWS CLI V2)
aws configure import command to import credentials from the .csv files generated in the AWS Console.
```sh
aws configure import --csv file://path/to/creds.csv```



## Refrance
- https://aws.amazon.com/blogs/security/how-to-use-a-single-iam-user-to-easily-access-all-your-accounts-by-using-the-aws-cli/
- https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html
- https://aws.amazon.com/blogs/developer/aws-cli-v2-is-now-generally-available/

