# Check if Chocolatey is already installed
if (-Not (Test-Path -Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Install Git, Terraform, and other desired packages using Chocolatey
$packages = "git", "terraform", "visualstudiocode", "nodejs", "yarn"

foreach ($package in $packages) {
    choco install $package -y

    # Check if the package was successfully installed
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$package has been successfully installed."
    } else {
        Write-Host "Failed to install $package using Chocolatey. Please check the Chocolatey logs for more information."
    }
}

# Get the current user and hostname
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$hostname = [System.Net.Dns]::GetHostName()

# Check if the SSH key pair doesn't exist
if (-Not (Test-Path -Path "$env:USERPROFILE\.ssh\id_rsa") -or -Not (Test-Path -Path "$env:USERPROFILE\.ssh\id_ed25519")) {
    # Generate the SSH key pair with user@hostname as the comment
    ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_ed25519" -C "$user@$hostname"

    # Check if the key generation was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SSH key pair generated successfully."
    } else {
        Write-Host "Failed to generate SSH key pair."
    }
} else {
    Write-Host "SSH key pair already exists."
}


