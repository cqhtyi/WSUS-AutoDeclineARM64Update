# Update PowerShellGet for Windows PowerShell 5.1 - https://learn.microsoft.com/en-us/powershell/gallery/powershellget/update-powershell-51?view=powershellget-3.x
Install-Module -Name PowerShellGet -AllowClobber -Force
# (When prompted if you want PowerShellGet to install and import the NuGet provider, respond with 'Y')

# Change to Update Services installation directory
Set-Location "$env:ProgramFiles\Update Services"

# Download latest version of the script to "%ProgramFiles%\Update Services\WSUS-AutoDeclineARM64Update.ps1"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/cqhtyi/WSUS-AutoDeclineARM64Update/refs/heads/main/WSUS-AutoDeclineARM64Update.ps1" -OutFile WSUS-AutoDeclineARM64Update.ps1

# Create a new scheduled task to run at midnight daily for up to 2 hours
Register-ScheduledTask -TaskName "WSUS AutoDecline ARM64 Update" `
  -User 'SYSTEM' `
  -Action (New-ScheduledTaskAction -Execute '%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe' `
    -Argument '-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%ProgramFiles%\Update Services\WSUS-AutoDeclineARM64Update.ps1"' `
    -WorkingDirectory '%ProgramFiles%\Update Services') `
  -Settings (New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 2)) `
  -Trigger (New-ScheduledTaskTrigger -At "00:00:00" -Daily)

# Run the scheduled task immediately
Start-ScheduledTask -TaskName "WSUS AutoDecline ARM64 Update"
