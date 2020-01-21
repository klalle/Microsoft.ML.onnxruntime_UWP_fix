#param([string]$BuildPath)
[IO.Directory]::SetCurrentDirectory((Convert-Path (Get-Location -PSProvider FileSystem)))

#x86
$filePath = "C:\.....path_to_your_project_referenced_by_UWP.......\obj\x86\Release\netcoreapp3.0\win-x86\Msix\WinSiftCore.deps.json"
$filetxt = [IO.File]::ReadAllText($filePath)
$regStr = "(?ms)(,[^}]*pdb.*?})"
if ($filetxt -match $regStr) { 
    $matches[0]
    $filetxt = ($filetxt -replace $regStr, "")
    Set-Content -Path "$filePath" -Value $filetxt
}

#x64
$filePath = "C:\.....path_to_your_project_referenced_by_UWP.......\obj\x64\Release\netcoreapp3.0\win-x64\Msix\WinSiftCore.deps.json"
$filetxt = [IO.File]::ReadAllText($filePath)
if ($filetxt -match $regStr) { 
    $matches[0]
    $filetxt = ($filetxt -replace $regStr, "")
    Set-Content -Path "$filePath" -Value $filetxt
}
