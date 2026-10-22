Write-Host "Installing python"
& choco.exe install -y python
# Make sure the versions we're currently using
# for our build scripts is installed
& choco.exe install -y python314
& choco.exe install -y python312
