# Adding Anaconda PowerShell to Windows Terminal

In my opinion Windows Terminal (wt) is one of the best applications Microsoft has added to Windows 10 (ever). It is a nice terminal app similar to some of the good Linux terminal apps. It is a modern tabbed, customizable terminal. On my typical daily desktop I will have wt open with several tabs, including, PowerShell, several WSL2 Linux shells and a SSH session or two.

Whn running Python on Windows I use conda with either Miniconda or full Anaconda. And, I use it from PowerShell. 

When you install Miniconda3 or Anaconda3 on Windows it adds a PowerShell shortcut that has the necessary environment setup for conda called "Anaconda Powershell Prompt (Anaconda3)".

Examining the properties of this shortcut the system I'm using right now shows,

```
%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\don\Anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\don\Anaconda3' "
```

This is reflective of my user name and Anaconda install location on this machine.

This is a nice way to start up your Python "Base" conda environment. However, this opens a separate/detached PowerShell instance and it would be nice to have this as an optional shell from Windows Terminal!

## Adding a new custom shell to Windows Terminal

Note: I am using "Windows Terminal Preview Version: 1.3.2382.0". If you are using an older version of Windows Terminal your setting.json file may be different than what I show below!

From wt go to the settings option on the drop-down menu,


Clicking that will open the wt settings.json file in vscode (you are using vscode aren't you?!)

We will add a new profile to the end of the profiles list in this setting.json file.

Copy the profile entry for the default PowerShell terminal entry (should be the first entry). Past this to the end of the profiles. Don't forget to add a comma after the previously last profile. 

```
            ,
            {
                // Make changes here to the powershell.exe profile.
                "colorScheme": "Campbell Powershell",
                "guid": "{}",
                "name": "Windows PowerShell",
                "commandline": "powershell.exe",
                "hidden": false
            }
```
I have removed the "guid" that was there since we will need to generate a new unique one for this profile.

### Generate a new "guid"
You will need a new unique guid for your terminal profile. In PowerShell run "New-Guid",
```
PS C:\> New-Guid
Guid
----
0352cf0f-2e7a-4aee-801d-7f27f8344c77
```
Don't use the one listed above. Make a new one! Copy your new guid to between the curly braces in the profile setting. For example,
```
"guid": "{0352cf0f-2e7a-4aee-801d-7f27f8344c77}",
```

### Complete the profile configuration

The finial profile configuration I settled on looks like,
```
{
    // custom PowerShell profile for conda.
    "colorScheme": "Campbell",
    "guid": "{c21af556-a74c-4df7-b0be-a7eed98b751f}",
    "name": "conda PowerShell",
    "commandline": "pwsh.exe -WorkingDirectory-ExecutionPolicy ByPass -NoExit -Command \"& '~/Anacondshell/condabin/conda-hook.ps1' ; conda activate Anaconda3'\" ",
    "icon": "C:/Users/don/Documents/Icons/python.png",
    "hidden": false
}
```

https://docs.microsoft.com/en-us/windows/terminal/customize-settings/profile-settings