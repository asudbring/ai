---
mode: 'agent'
description: Convert Bicep template to Terraform IaC with complete file structure, deployment testing, and resource verification
tools:
  - mcp_microsoft_docs_microsoft_docs_search
  - mcp_microsoft_docs_microsoft_docs_fetch
  - azure_development-get_code_gen_best_practices
  - azure_development-get_deployment_best_practices
  - azure_terraform-get_best_practices
  - azure_resources-query_azure_resource_graph
  - azure_cli-generate_azure_cli_command
  - run_in_terminal
  - create_file
  - read_file
  - get_errors
variables:
  - name: bicep_file_name
    description: The Bicep file to convert to Terraform
    type: string
    default: main.bicep
---

Convert the **${input:bicep_file_name}** Bicep template to equivalent Terraform configuration, deploy it, and verify successful resource creation.

## TERRAFORM CONVERSION

**Analyze** the **${input:bicep_file_name}** using the MCP Server: Microsoft Docs (microsoft_docs_search) and (microsoft_docs_fetch) for terraform best practices and deployment procedures.

**Create** these Terraform files.

- **main.tf**: All Azure resources with `random_pet` naming
- **variables.tf**: Input variables with `random_password` for credentials
- **outputs.tf**: Resource outputs
- **providers.tf**: Azure provider configuration
- **ssh.tf**: SSH configuration (Linux VMs only)

### Requirements

- Include resource group creation in main.tf
- Use Terraform naming conventions and best practices
- Configure Trusted Launch security profiles correctly (no duplicate `maaTenantName`)
- Set `vtpm_enabled` at virtual machine resource level
- Generate secure admin credentials without default values
- Apply SSH authentication for Linux VMs only
- Ensure Windows virtual machine computer names do not exceed 15 characters

## DEPLOYMENT TESTING

Execute deployment workflow:

1. **Format**: `terraform fmt`
2. **Initialize**: `terraform init`
3. **Plan**: `terraform plan -out=tfplan`
4. **Deploy**: `terraform apply tfplan`

### Verification

- Report all errors verbatim
- Query Azure subscription for created resources in the resource group
- List successfully deployed resources
- Suggest fixes for any deployment failures
- Prompt for cleanup with `terraform destroy` if successful

## EXECUTION

Generate Terraform files and execute deployment testing workflow.
