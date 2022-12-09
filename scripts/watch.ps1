Push-Location $PSScriptRoot/..;
try {
    npx chokidar-cli src/**/*.elm content/**/*.md public/**/* --initial --command 'pwsh -File scripts/build-and-fix.ps1'
}
finally {
    Pop-Location;
}