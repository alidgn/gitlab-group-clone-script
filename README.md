# GitLab Project Management Script

This PowerShell script interacts with the GitLab API to manage projects within a specified group. It allows you to clone repositories and update them based on specified branch names.

## Features

- Retrieve GitLab groups and projects using the GitLab API.
- Clone repositories if they are not already cloned.
- Checkout specified branches and pull the latest changes.

## Prerequisites

- PowerShell installed on your system.
- Git installed and available in your system PATH.
- A valid GitLab account with the necessary permissions.

## Usage

### Getting Started

1. **Clone the Script**: Download the script to your local machine.
2. **Run the Script**: Execute the script in PowerShell.

```powershell
.\script.ps1
```

### Parameters

The script prompts for the following information:

- **GitLab Host**: The base URL of your GitLab instance (e.g., `https://git.example.com`).
- **GitLab Access Token**: A personal access token with the appropriate permissions (e.g., `glpat-*****`).
- **GitLab Group ID**: The ID of the group whose projects you want to manage.

### Example

```powershell
GitLab Host (example: https://git.example.com)
GitLab Access Token (glpat-*****)
GitLab Group Id (Press return key if you don't know what group id is)
```

## Error Handling

The script includes error handling for various scenarios:

- **Invalid GitLab Host**: If an invalid host is provided, the script will terminate.
- **Missing Access Token**: Prompts the user for a valid access token.
- **Invalid Group ID**: If the provided group ID is invalid, it displays available groups.
- **Unauthorized Access**: If the access token is invalid (401 error), the script prompts to provide a valid token and opens the token generation page.

## Cloning and Updating Repositories

- The script checks if each project is already cloned. If not, it clones the repository.
- It attempts to checkout specified branches (e.g., `master`, `main`) and pulls the latest changes. If no matching branches are found, it skips the project.

## Output

The script will output messages indicating the status of cloning and updating repositories, along with any errors encountered.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [GitLab Personal Access Tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)

Feel free to adjust any parts or add specific details relevant to your project! If you need further modifications or additional sections, just let me know.