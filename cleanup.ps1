Get-ChildItem -Path 'lib' -Filter '*.dart' -Recurse | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path
    $originalLength = $content.Length
    
    # Remove lines that are orphaned print/log arguments (string literals with interpolation followed by closing paren)
    $newContent = $content | Where-Object { 
        $_ -notmatch "^\s*['\"][^'\"]*\$\{.*\}[^'\"]*['\"],?\s*$" -or 
        ($_ -match "=>" -or $_ -match "return" -or $_ -match "=" -or $_ -match "\?" -or $_ -match ":")
    }
    
    # Also remove standalone closing parens that were part of print statements
    $newContent = $newContent | Where-Object { $_ -notmatch "^\s*\);\s*$" }
    
    if ($newContent.Length -ne $originalLength) {
        $newContent | Set-Content $path -Force
        Write-Host "Cleaned: $path"
    }
}
