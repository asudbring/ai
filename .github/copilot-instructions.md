# GitHub Copilot Instructions for AI Prompts Repository

## Repository Overview

This repository contains a structured collection of AI prompts designed to automate Azure Infrastructure as Code (IaC) generation from Microsoft Learn articles. The prompts enable conversion of Azure portal, PowerShell, and CLI procedures into Bicep and Terraform templates.

## Project Architecture

### Core Components

- **Prompt Templates**: Structured prompt files with YAML frontmatter defining AI agent behavior
- **IaC Generation**: Automated conversion from tutorial procedures to Infrastructure as Code
- **Testing Integration**: Built-in deployment testing and verification workflows
- **Microsoft Documentation Integration**: MCP server integration for real-time documentation access

### Directory Structure

```
prompts/
├── prompt-template.prompt.md          # Base template for new prompts
├── bicep-prompt/                      # Bicep template generation
│   └── from-article/                  # Convert articles to Bicep
├── terraform-prompt/                  # Terraform template generation
│   ├── from-article/                  # Convert articles to Terraform
│   └── from-bicep-template/           # Convert Bicep to Terraform
├── archive/                           # Archived prompt versions
│   ├── bicep/                        # Legacy Bicep prompts
│   └── terraform/                    # Legacy Terraform prompts
├── authoring/                         # Documentation authoring prompts
└── general-mcp-prompts/              # MCP server usage examples
```

## Key Patterns and Conventions

### Prompt Structure

All prompts follow this standard format:

```yaml
---
mode: 'agent'
description: Brief description of the prompt's purpose
tools:
  - azure_development-get_code_gen_best_practices
  - azure_development-get_deployment_best_practices
  - [additional tools as needed]
variables:
  - name: article_name
    description: The Microsoft Learn article to analyze
    type: string
---
```

### Naming Conventions

- **Prompts**: `{functionality}-{source}-{tool}.prompt.md`
- **MCP Variants**: Files ending with `-mcp.prompt.md` use MCP server integration
- **Archive**: Legacy prompts stored in `archive/` subdirectories
- **Templates**: Generated files follow Azure naming conventions with resource tokens

### Tool Categories

1. **Azure Best Practices**:
   - `azure_development-get_code_gen_best_practices`
   - `azure_development-get_deployment_best_practices`
   - `azure_terraform-get_best_practices`

2. **Documentation Access**:
   - `mcp_microsoft_doc_microsoft_docs_search`
   - `azure_bicep_schemas-get_bicep_resource_schema`

3. **Deployment and Testing**:
   - `azure_cli-generate_azure_cli_command`
   - `run_in_terminal`
   - `azure_resources-query_azure_resource_graph`

## Development Guidelines

### Creating New Prompts

1. **Start with Template**: Use `prompt-template.prompt.md` as base
2. **Define Variables**: Specify required inputs in YAML frontmatter
3. **Select Tools**: Include appropriate Azure and MCP tools
4. **Structure Sections**:
   - Article Analysis
   - Instructions
   - Testing
   - Template Generation

### Best Practices

- **MCP Integration**: Prefer MCP-enabled prompts for real-time documentation access
- **Testing Workflow**: Always include deployment testing and resource verification
- **Resource Cleanup**: Include cleanup procedures in testing sections
- **Error Handling**: Specify error reporting and troubleshooting steps
- **SSH Configuration**: Reference `example.bicep` for SSH parameter templates

### Code Generation Standards

- **Bicep Templates**: Generate `main.bicep` with parameter files
- **Terraform Templates**: Create multiple files (main.tf, outputs.tf, providers.tf, ssh.tf, variables.tf)
- **Resource Naming**: Use resource tokens for unique naming
- **Security**: Follow Azure security best practices and trusted launch configurations
- **Modularity**: Structure templates for reusability and maintainability

## Integration Points

### Microsoft Documentation

- All prompts integrate with Microsoft Learn articles
- MCP server provides real-time documentation access
- Fact-checking against authoritative sources is built-in

### Azure Tools

- Azure CLI for deployment and management
- Resource Graph queries for verification
- Best practices tools for compliance

### Testing Framework

Standard testing workflow:
1. Check resource group existence
2. Deploy template with appropriate tools
3. Verify resource creation
4. Report errors verbatim
5. Clean up resources after testing

## File Types and Purposes

- **`.prompt.md`**: Standard prompts without MCP integration
- **`-mcp.prompt.md`**: Enhanced prompts with Microsoft documentation access
- **`example.bicep`**: SSH configuration reference template
- **`README.md`**: Directory-specific documentation

## Workflow Automation

### Article Analysis Process

1. **Parse Article Structure**: Identify deployment methods (Portal/CLI/PowerShell)
2. **Extract Procedures**: Convert manual steps to IaC templates
3. **Apply Best Practices**: Integrate Azure coding and deployment standards
4. **Generate Templates**: Create complete, deployable IaC files
5. **Test Deployment**: Verify functionality in Azure subscription
6. **Document Results**: Provide deployment logs and verification

### Quality Assurance

- **Schema Validation**: Use latest Bicep/Terraform schemas
- **Error Reporting**: Capture and report all deployment issues
- **Resource Verification**: Confirm expected resources are created
- **Best Practices Compliance**: Apply Azure Well-Architected Framework principles

## Contributing Guidelines

When adding new prompts or modifying existing ones:

1. **Follow Naming Conventions**: Use established patterns for consistency
2. **Include Testing**: Ensure comprehensive testing workflows
3. **Document Variables**: Clearly define all required inputs
4. **Update READMEs**: Maintain directory-level documentation
5. **Archive Appropriately**: Move outdated prompts to archive directories

## Tool Dependencies

Essential tools for prompt functionality:
- Azure CLI configured with valid subscription
- Terraform (for Terraform-based prompts)
- Access to Microsoft Learn documentation
- MCP server for real-time documentation access

## Security Considerations

- **Credential Management**: Never hardcode credentials in templates
- **Resource Cleanup**: Always include cleanup procedures
- **Testing Isolation**: Use dedicated test resource groups
- **SSH Security**: Follow SSH best practices from example templates
