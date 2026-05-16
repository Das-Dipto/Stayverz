Get-ChildItem -Path 'lib' -Filter '*.dart' -Recurse | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw
    
    # Check if comment already exists
    if ($content -notmatch "// Hello I am Tamim") {
        # Add comment at the end
        Add-Content $path "`n// Hello I am Tamim" -NoNewline
        Write-Host "Added comment to: $path"
    }
}
