#param([string]$BuildPath)
[IO.Directory]::SetCurrentDirectory((Convert-Path (Get-Location -PSProvider FileSystem)))
$filePath = "C:\.....path_to_your_project_including_onnxruntime-nuget.......\obj\x86\Release\netcoreapp3.0\win-x86\Msix\WinSiftCore.deps.json"
$filetxt = [IO.File]::ReadAllText($filePath)

$regStr = "(?ms)(,[^}]*pdb.*?})"
if ($filetxt -match $regStr) { 
    $matches[0]
    $filetxt = ($filetxt -replace "(?ms)(,[^}]*pdb.*?})", "")
    Set-Content -Path "$filePath" -Value $filetxt
}


$filePath = "C:\.....path_to_your_project_including_onnxruntime-nuget.......\obj\x64\Release\netcoreapp3.0\win-x64\Msix\WinSiftCore.deps.json"
$filetxt = [IO.File]::ReadAllText($filePath)

$regStr = "(?ms)(,[^}]*pdb.*?})"
if ($filetxt -match $regStr) { 
    $matches[0]
    $filetxt = ($filetxt -replace "(?ms)(,[^}]*pdb.*?})", "")
    Set-Content -Path "$filePath" -Value $filetxt
}
