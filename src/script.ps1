function Get-GitLabProjects {
    param (
        [int]$groupId,
        [int]$page,
        [int]$perPage
    )
    try {
        $endpoint = "$glHost/api/v4/groups/$groupId/projects" + "?page=" + $page + "&per_page=" + $perPage
        $response = Invoke-RestMethod -Uri $endpoint -Headers @{ "PRIVATE-TOKEN" = $accessToken }
        return $response
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Host "StatusCode:" $statusCode
        Write-Host "StatusDescription:" $statusDescription

        if ($statusCode -eq 401) {
            Write-Host "Please provide a valid access token."
            Write-Host -NoNewLine "Press any key to opening gitlab access token page.."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

            Start-Process "$glHost/-/profile/personal_access_tokens"
        }
        else {
            Write-Host "Unexpected service response received."
        }
        Write-Host "Exited!"
        exit
    }
}

function Get-GitLabGroups {
    param (
    )
    try {
        $endpoint = "$glHost/api/v4/groups"
        $response = Invoke-RestMethod -Uri $endpoint -Headers @{ "PRIVATE-TOKEN" = $accessToken }
        return $response
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription

        Write-Host "StatusCode:" $statusCode
        Write-Host "StatusDescription:" $statusDescription

        if ($statusCode -eq 401) {
            Write-Host "Please provide a valid access token."
            Write-Host -NoNewLine "Press any key to opening gitlab access token page.."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

            Start-Process "$glHost/-/profile/personal_access_tokens"
        }
        else {
            Write-Host "Unexpected service response received."
        }
        Write-Host "Exited!"
        exit
    }
}

$glHost = Read-Host -Prompt "Gitlab Host (example: https://git.example.com)"
if (!$glHost) {
    Write-Host "Provided an invalid gitlab host address."
    exit
}

$accessToken = Read-Host -Prompt "Gitlab Access Token (glpat-*****)"
if (!$accessToken) {
    Write-Host "Please provide an access token. You can read this documentation to do that. (https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)" 
    exit
}

$groupId = Read-Host -Prompt "Gitlab Group Id (Press return key if you don't know what group id is)"
if (!$groupId) {
    $groups = Get-GitLabGroups
    
    if ($groups.Length -eq 0) {
        Write-Host "There is no group."
        exit
    }

    foreach ($group in $groups) {
        Write-Host "`n<----- Group $($group.id) ----->`nid: $($group.id)`nname: $($group.name)`ndescription: $($group.description)`npath: $($group.path)`nurl: $($group.web_url)`n"
    }

    $groupId = Read-Host -Prompt "Gitlab Group Id"

    if(!$groupId){
        Write-Host "Provided an invalid group id."
        exit
    }
}

$workingDir = split-path -parent $MyInvocation.MyCommand.Definition

$page = 1
$perPage = 100
$branchList = @("master", "main")

while ($true) {
    $projects = Get-GitLabProjects -groupId $groupId -page $page -perPage $perPage

    if ($projects.Length -eq 0) {
        break
    }

    foreach ($project in $projects) {
        Set-Location -Path $workingDir

        $projectName = $project.name
        $projectPath = $project.path
        $projectUrl = $project.http_url_to_repo

        if (Test-Path -Path "./$projectPath") {
            Write-Host "The repository has already cloned: $projectPath"
        }
        else {
            Write-Host "The repository has not cloned yet, cloning: $projectName"
            git clone $projectUrl
        }

        Set-Location -Path "./$projectPath" 

        $remoteBranches = git branch -r
        
        $branchCheckedOut = $false
        foreach ($branch in $branchList) {
            if ($remoteBranches -match "origin/$branch") {
                git checkout $branch
                $branchCheckedOut = $true
                break
            }
        }
                
        if ($branchCheckedOut) {
            git pull
        }
        else {
            Write-Host "There is no matching branches, skipped: $projectName"
        }
    }

    $page++
}

Write-Host "All repositories updated."