# Microsoft.ML.onnxruntime_UWP_fix
My workaround for deps.json error when .net core 3 project containing onnxruntime-nuget is packad as an UWP using Windows Application Packaging Project in Visual Studio 2019.

## Error to solve:
Error in eventlog:
```
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
doesn't work either in the packaging project or in the referenced project. I even tried to build my own version of the nuget, excluding the pdb, but I couldn't get it to output a nuget (big project with wierd build-scripts)

## Works:
My workaround is to add a postbuildscript on the packaging project that alters the referenced project output target files. The script replaces the lines referencing the pdb-file in the deps.json-file (which is auto-generated in reference projects output build-paths). This is done before the packaging project is bundeling everything in an .appxbundle and .appxupload.

Doesn't work to run the script towards the deps.json files created in the packaging project! It has to be the referenced project (even if the referenced project it self doesn't have the nuget containing the pbd-files, but has a referenced project/lib that does).

## How to: 
1. You would expect to be able to just add a reference to this script to the "Post-build event command line" section of the Build Events dialog in VS. Unfortunately, if you try to use macros like $(ProjectDir) or $(ConfigurationName), those get wiped away when you attempt to save. Instead, edit project xml and add a new Target, like this:

```
  <Target Name="PostBuild" BeforeTargets="PostBuildEvent">
    <Exec Command="powershell.exe -ExecutionPolicy Bypass -NoProfile -File $(ProjectDir)alter_deps.json.ps1 -Path $(ProjectDir).. -Config $(ConfigurationName)" />
  </Target>
```

2. Alter the file "alter_deps.json.ps1" to match your output-target project (remember that the target outputs should be for the referenced project using the onnxruntime-nuget, not the UWP-packaging project target!) 
You might need to add more runtimes than x86 and x64 which I am using...
