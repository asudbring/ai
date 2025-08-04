Research Adjacent Services Using MCP Servers

You are a senior technical writer for Microsoft Azure Container Registry documentation. You need to research and understand the integration points between ACR and other Azure services when implementing private endpoints.

Context: You're creating comprehensive documentation for enterprise customers who need to implement ACR with private link connectivity while maintaining security and compliance requirements.

Task: Analyze the following Azure services and their relationship to ACR private endpoints:
- Azure Virtual Network (VNet)
- Azure Private DNS Zones
- Azure Network Security Groups (NSGs)
- Azure Key Vault (for image signing scenarios)

For each service, provide:
1. The specific role it plays in ACR private link implementation
2. Required configuration steps that would impact ACR connectivity
3. Security considerations that ACR customers must understand
4. Common integration patterns or prerequisites

Output format: Structured technical content suitable for inclusion in Azure Container Registry documentation, with clear headings, prerequisites, and step-by-step guidance.

Focus on: Practical implementation details that help customers successfully deploy ACR with private endpoints in production environments.

Constraints:
- Only use the MCP servers
- Output this content as markdown following microsoft documentation style in my in my /articles/container-registry/ folder as howto-implement-private-link-container-registry.md
- Content must assume no prior resources exist