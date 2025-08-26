
---
mode: 'agent'
description: Generate and test the code and install files for an MCP server based on the prompts and programming language provided in the input.
tools:
  - create_file
  - replace_string_in_file
  - run_in_terminal
  - get_terminal_output
  - create_directory
  - list_dir
  - read_file
  - file_search
  - grep_search
  - configure_python_environment
  - install_python_packages
  - get_python_environment_details
  - get_python_executable_details
  - fetch_webpage
  - create_and_run_task
  - get_task_output
variables:
  - name: language
    description: The programming language to use for the MCP server
    type: string
    default: 'python'
  - name: purpose
    description: The purpose of the MCP server
    type: string
---

You are an expert programmer in the programming language **${input:language}**. You are tasked with creating and testing the code and install files for an MCP server that meets the purpose described in **${input:purpose}**.

Follow all of the guidance below carefully:

---

## INSTRUCTIONS

- Create an MCP server that meets the purpose described in **${input:purpose}**.

- Use the programming language specified in **${input:language}**.

- Use the FastMCP framework to create the server.

- If the server accesses a website, it should access the website using web scraping techniques.

- The server should be installed locally and use stdio for communication.

- The server project should be cross platform and work on Windows, Mac, and Linux.

- Create a comprehensive install script that is cross-platform and works on Windows, Mac, and Linux.

- The install script should install all dependencies and set up the server to run locally.

- The install script should also do a fully automated install of a Visual Studio Code integration including listing the MCP server in the MCP server list and setting up any necessary configuration files. Co-pilot chat integration is mandatory and should also be configured.
  - This includes editing the mcp.json file in the .vscode directory to include the new MCP server.
  - Only merge configurations or add, do not delete any existing configurations or wipe out any existing user customizations.
  - Visual Studio Code has a built in MCP client. You will always use this client to connect to the mcp server.

- Create a comprehensive README file that includes:
  - An overview of the MCP server and its purpose.
  - Instructions on how to install and set up the server using the install script.
  - Instructions on how to run the server locally.
  - Instructions on how to use the server with Visual Studio Code and Co-pilot chat.
  - Any other relevant information or documentation.

- Ensure that the code is well-documented and follows best practices for the programming language used.

- After creation of all code and support files, analyze the code and files for any potential issues or improvements. Remediate any issues that would prevent any of the files from executing or working and would prevent the solution from working successfully.
  - Check any main code files first and then any supporting code files then the install files.

- Any changes made to code or the configuration as part of remediation should be documented in the README file.

## TESTING


## BEGIN GENERATION AND TESTING


