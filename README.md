# Microsoft.ML.onnxruntime_UWP_fix
My workaround for deps.json error when .net core 3 project containing onnxruntime-nuget is packad as an UWP using Windows Application Packaging Project in Visual Studio 2019.

## Error to solve:
```
Error in eventlog:
Description: A .NET Core application failed.
Application: WinSiftCore.exe
Path: C:\Program Files\WindowsApps\38749KarlHagstrom.EasyPhotoOrganizer_1.0.70.0_x86__fqsq6epnrsaem\WinSiftCore.exe
Message: Error:
  An assembly specified in the application dependencies manifest (WinSiftCore.deps.json) was not found:
    package: 'Microsoft.ML.OnnxRuntime', version: '1.1.0'
    path: 'runtimes/win-x86/native/onnxruntime.pdb'
```

## Doesn't work:
I tried all sorts of suggested solutions before finding my own that actually worked. 
Suggestions like 
```
<DebugSymbols>false</DebugSymbols>
<DebugType>None</DebugType>

or

<IncludeSymbolsInSingleFile>true</IncludeSymbolsInSingleFile>
```
doesn't work either in the packaging project or in the original project. I even tried to build my own version of the nuget, excluding the pdb, but I couldn't get it to work (big project with wierd build-scripts)

## Works:
My workaround is to add a postbuildscript on the packaging project that alters the original project output target files. The script replaces the lines referencing the pdb-file in the deps.json-file which is auto-created in output build-paths. This is done before the packaging project is bundeling everything in an .appxbundle and .appxupload.

## How to: 
1. to be able to run a ps1-postbuild-script from visual studio according to https://stackoverflow.com/a/6501719 you have to open powershell (x86) as admin and run 
```
Set-ExecutionPolicy RemoteSigned
(answer Y or A when prompted)
```
Might be a good idea to change back after you have done this. (couldn't get "-ExecutionPolicy Bypass" to work in script)

2. Right-click the Packaging-project and "properties/Build events" and add this to the "Post Build Events":
```
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -file "C:\.......change_this_to_your_script_path.......\scripts\alter_deps.json.ps1" 
(It didn't work when using $(ProjectDir) for some reason...
```
3. Alter the file "alter_deps.json.ps1" to match your output-target-paths (remember that the target outputs should be for the referenced project using the onnxruntime-nuget, not the UWP-packaging project target!) 
You might need to copy the lines for more runtimes than x86 and x64 which I am using...
