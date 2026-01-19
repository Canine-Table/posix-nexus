Install-Installer()
{
    param(
	[Parameter(Mandatory = $true)]
	[hashtable]$Config
    )

    # Explicitly check if Chocolatey exists
    if (-not (Get-Command -Name "choco" -ErrorAction SilentlyContinue)) {

	Write-Host -ForegroundColor Green "Installing Chocolatey..."

	# Explicitly set execution policy for this process only
	Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

	# Explicitly enforce TLS 1.2
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Explicitly download the installer script as a string
	[string]$InstallerScript = (New-Object System.Net.WebClient).DownloadString(
	    'https://community.chocolatey.org/install.ps1'
	)

	# Explicitly execute the downloaded script
	Invoke-Expression -Command $InstallerScript

    } else {

	Write-Host -ForegroundColor Red "Chocolatey already installed."

    }

    # Explicitly iterate over each key in the configuration hashtable
    foreach ($Key in $Config.Keys) {

	# Explicitly check if the command exists
	if (-not (Get-Command -Name $Key -ErrorAction SilentlyContinue)) {

	    # Explicitly extract message and command
	    [string]$Message = $Config[$Key][0]
	    [string]$Command = $Config[$Key][1]

	    Write-Host -ForegroundColor Yellow $Message

	    # Explicitly execute the install command
	    Invoke-Expression -Command $Command
	}
    }
}

# Explicitly create a new hashtable
[hashtable]$Config = [hashtable]::new()

# Git install entry
$Config.Add(
    "git",
    [string[]]@(
	"Git is missing, installing now...",
	"choco install git -y"
    )
)

# PowerShell 7 installs
$Config.Add(
    "pwsh",
    [string[]]@(
	"PowerShell 7 is missing, installing now...",
	"choco install powershell-core -y"
    )
)

# Windows Terminal installs
$Config.Add(
    "wt",
    [string[]]@(
	"Windows Terminal is missing, installing now...",
	"choco install microsoft-windows-terminal -y"
    )
)

# Explicitly call the installer function
Install-Installer -Config $Config

Install-LocalUser()
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserName,

        [string]$Groups = "Users",

        [string]$FullName = "Local User",

        [Parameter(Mandatory = $true)]
        [string]$Password,

        [string]$Description = "Local workstation account"
    )

    # Explicitly check if the user exists
    if (Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue) {

        Write-Host -ForegroundColor Yellow "User '$UserName' already exists."

    } else {

        Write-Host -ForegroundColor Green "User '$UserName' does not exist. Creating now..."

        # Convert password to a secure string
        [securestring]$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

        # Create the user
        New-LocalUser `
            -Name $UserName `
            -Password $SecurePassword `
            -FullName $FullName `
            -Description $Description `
            -PasswordNeverExpires:$true `
            -UserMayNotChangePassword:$false `
            || return $false

        Write-Host -ForegroundColor Green "User '$UserName' created successfully."
    }

    # Explicitly split groups and iterate
    $Groups.Split(" ") | ForEach-Object {

        [string]$GroupName = $_

        # Get group members
        $Members = Get-LocalGroupMember -Group $GroupName -ErrorAction SilentlyContinue

        if ($Members.Name -contains $UserName) {

            Write-Host -ForegroundColor Yellow "User '$UserName' is already in group '$GroupName'."

        } else {

            Write-Host -ForegroundColor Green "Adding '$UserName' to group '$GroupName'..."
            Add-LocalGroupMember -Group $GroupName -Member $UserName
        }
    }

    return $true
}

Install-LocalUser -UserName user -Groups 'Administrators Users' -Password 'something'

