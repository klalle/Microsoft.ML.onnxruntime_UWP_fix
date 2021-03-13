param([string]$Path, [string]$Config)

"Arguments:"
"Path: $Path"
"Config: $Config"

$targetProj = "WinSiftCore" # Replace with your referenced project name
$archs = "x86","x64"
$regStr = "(?ms)(,[^}]*pdb.*?})"
$dotnetVersion = "net5.0"

foreach ($arch in $archs) {
    $filePath = Resolve-Path "$Path\$targetProj\obj\$arch\$Config\$dotnetVersion\win-$arch\Msix\$targetProj.deps.json"
    $exists = [IO.File]::Exists($filePath)
    "$filePath, exists: $exists"
    if ($exists) {
        $content = [IO.File]::ReadAllText($filePath)
        if ($content -match $regStr) {
            $matches[0]
            $content = ($content -replace $regStr, "")
            Set-Content -Path "$filePath" -Value $content
        }
    }
}