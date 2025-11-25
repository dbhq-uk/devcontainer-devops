Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$env:POSH_GIT_ENABLED=$true
$env:POSH_THEME="$HOME/.config/powershell/ps_theme.json"

oh-my-posh init pwsh --config $env:POSH_THEME | Invoke-Expression

# NOTE: You can override the above env var from the devcontainer.json "args" under the "build" key.

# Aliases
Set-Alias -Name ac -Value Add-Content