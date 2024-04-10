# Initializes a new or existing Terraform configuration, downloading required plugins and modules.
terraform init
# Reconfigures and reinstalls plugins, useful when changing provider configurations.
terraform init -reconfigure
# Migrates the Terraform state to a new backend, such as changing from local to remote state.
terraform init -migrate-state

# Downloads and installs the modules needed for the configuration.
terraform get

# Formats the code according to Terraform conventions.
terraform fmt

# Checks the configuration for syntax errors and other issues.
terraform validate

# Lists all resources in the Terraform state.
terraform state list
# Shows details about a specific resource in the Terraform state.
terraform state show <resource_type>.<resource_name>
# Locks the state file to prevent concurrent modifications.
terraform state lock

# Displays the current state of your infrastructure as recorded by Terraform.
terraform show

# Generates and shows an execution plan for changes to be applied to your infrastructure.
terraform plan

# Generates an execution plan for destroying the infrastructure.
terraform plan -destroy

# Generates an execution plan and saves it to a file called "tfplan."
terraform plan -out=tfplan

# Rollback Applies the execution plan saved in "tfplan" to destroy or create resources.
terraform apply tfplan

# Applies the last generated execution plan. If no plan file is specified, Terraform will generate a new plan.
terraform apply

# Applies the plan and sets a variable (region in this case) to a specific value.
terraform apply -var="region=us-east-1"

# Applies the plan, targeting only the specified resource for creation or modification.
terraform apply -target=<resource_type>.<resource_name>

# Marks a resource as tainted, forcing it to be recreated on the next apply.
terraform taint <resource_type>.<resource_name>

# Applies the plan, replacing the specified resource.
terraform apply -replace=aws_instance.example

# Applies the plan using a specific state file.
terraform apply -state=path/to/previous/terraform.tfstate

# Destroys all resources defined in the Terraform configuration.
terraform destroy
# Destroys a specific resource identified by its type and name.
terraform destroy -target=<resource_type>.<resource_name>

# Creates a new Terraform workspace.
terraform workspace new <workspace_name>

# Lists all available Terraform workspaces.
terraform workspace list

# Check the Current Workspace:
terraform workspace show

# Switches to a specific Terraform workspace.
terraform workspace select <workspace_name>

# Delete a Workspace:
terraform workspace delete <workspace_name>

element
length
substr