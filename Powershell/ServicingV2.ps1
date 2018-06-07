if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

workflow UWFService {
    uwfmgr.exe filter disable

    $Log = "Filter Disabled: $(Get-Date)"
    $Log | Out-file C:\UWFServicinglog.txt -Append
    
    
    #Create startup file, in startup file run UpdateGUILaunch.ps1, then it deletes itself from startup
    
    $itemParms = @{
        'Path'='C:\Users\Labuser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup';
        'Name'='UpdateGUI.ps1';
        'ItemType'='file';
        'Value'='if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
         {Start-Process powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Verb RunAs; exit} 
         gpupdate /force 
         Start ms-settings:windowsupdate Read-Host -Prompt'
              }
    New-Item @itemParms -Force
    
    schtasks /create /tn "start" /sc onstart /delay 0000:30 /rl highest /ru system /tr "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass C:\Users\Labuser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpdateGUI.ps1"
    
    
    #Read-Host -Prompt "Press Enter to Exit"
    
    #shutdown -r -t 0

}





#Servicing mode creates a servicing account on the machine named UWF-Servicing. 
#It is important that you do not have a user account that has that same name on 
#the thin client before starting UWF servicing mode. Unfortunately, servicing is 
#not currently working with our image. Machines fail to pull down updates as well
#as GP. Due to this, we are proceeding with standard 