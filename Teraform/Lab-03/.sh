# Initializes the working directory and downloads necessary providers.
terraform init
terraform init -reconfigure
terraform init -migrate-state

terraform get

# List Available States:
terraform state list
# Show State Details:
terraform state show <resource_type>.<resource_name>
# Encourage team members to pull the latest state
# Implement state locking to prevent concurrent modifications:
terraform state lock

# Plan the State:
terraform plan
# Creates an execution plan and saves it to tfplan.
terraform plan -out=tfplan

# Apply the State:
terraform apply
# Rollback to a Specific State:
terraform apply -target=<resource_type>.<resource_name>
# Executes the plan, making the defined changes to the infrastructure.
terraform apply tfplan

# Provide values for variables either through command-line input
terraform apply -var="region=us-east-1"

# Create a Workspace:
terraform workspace new <workspace_name>

# List  Workspace:
terraform workspace list

# Switch to a Workspace:
terraform workspace select <workspace_name>

element
length
substr