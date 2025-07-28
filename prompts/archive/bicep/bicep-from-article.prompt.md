---
mode: 'agent'
description: Convert Microsoft Learn article Azure deployment procedures to a Bicep template and test deployment
tools:
  - azure_development-get_code_gen_best_practices
  - azure_development-get_deployment_best_practices
  - azure_bicep_schemas-get_bicep_resource_schema
  - azure_resources-query_azure_resource_graph
  - azure_cli-generate_azure_cli_command
  - run_in_terminal
  - create_file
  - read_file
  - get_errors
variables:
  - name: article_name_or_url
    description: Microsoft Learn article name or URL containing Azure deployment procedures
    type: string
---

# Bicep Template Generation from Microsoft Learn Article

You will convert Azure deployment procedures from a Microsoft Learn article into a Bicep template and test the deployment.

## Task Overview

1. **Analyze** the article **${input:article_name_or_url}** using Microsoft Learn website https://learn.microsoft.com/en-us/azure/?product=popular
2. **Convert** deployment procedures to a Bicep template
3. **Test** the template deployment in Azure
4. **Verify** resources are created correctly

## Article Analysis

Search the Microsoft Learn article for deployment procedures using:
- Azure Portal instructions
- Azure CLI commands  
- PowerShell commands

Prioritize Azure CLI instructions when available.

## Template Generation Requirements

**Create only:** `main.bicep` file

**Template specifications:**
- Convert all hardcoded values to parameters matching article naming
- Remove unnecessary `dependsOn` entries
- Use `generateUsername()` and `generatePassword()` functions for VM credentials
- For Linux VMs: Copy SSH configuration exactly from `example.bicep`
  - Set default `authenticationType` to `'password'`
  - Include SSH parameters and `linuxConfiguration`
- For non-Linux deployments: Omit SSH configuration
- For Windows VMs: Ensure computer names don't exceed 15 characters

**Do not create:**
- README files
- `azure.yaml` files
- Deployment scripts

## Testing Workflow

1. **Prepare environment:**
   - Delete existing `test-rg` resource group if present
   - Create fresh `test-rg` resource group

2. **Deploy template:**
   - Use Azure CLI to deploy `main.bicep` to `test-rg`
   - Include only auto-generated username/password parameters

3. **Verify deployment:**
   - Report all errors verbatim
   - List created resources on success
   - Query Azure subscription to confirm expected resources exist

4. **Cleanup:**
   - Prompt to delete `test-rg` if deployment successful with no issues

## Expected Output

- **Success:** List of created resources and cleanup prompt
- **Errors:** Verbatim error messages with suggested solutions
- **Warnings:** Report any deployment warnings

Begin by analyzing the specified Microsoft Learn article and generating the Bicep template.