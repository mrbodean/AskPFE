 <# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
 THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING 
 BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
 We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce # 
 and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market
Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code
is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees,
that arise or result from the # use or distribution of the Sample Code.
#>

Function ByeByeCompliant {
$StrCompliant = "Compliant"
write-host $StrCompliant
Exit 0

} #Ends Function

Function RegistryValueCounter
{
    param($regkey, $name)
    $exists = Get-ItemProperty -path $regkey -name $name -ErrorAction SilentlyContinue
    #Write-Host "Test-RegistryValue: $exists"
    if (($exists -eq $null) -or ($exists.Length -eq 0))
    {
        return $false
    }
    else
    {
        return $true
    }
}

$RegPathShort = "HKLM:\Software"
$RegPath = "HKLM:\Software\ESU_Remediation"
$RegValue = "Counter"
$Keyname = "ESU_Remediation"

$FSO = RegistryValueCounter -regkey $RegPath -name $RegValue


If ($FSO -ne $True){
New-Item –Path $RegPathShort -Name $Keyname -Value $RegValue

New-ItemProperty $RegPath -Name $RegValue -Value 1 -PropertyType DWORD
}
Else {$CounterTemp = Get-ItemProperty $RegPath -Name $RegValue
      #write-host "countertemp:" $CounterTemp.Counter
      $CounterFinal =  $CounterTemp.counter +1
      set-itemProperty -Path $RegPath -Name $RegValue  -Value $CounterFinal
     }

#Main Script Routine
#Instructions on ESU:  https://techcommunity.microsoft.com/t5/Windows-IT-Pro-Blog/How-to-get-Extended-Security-Updates-for-eligible-Windows/ba-p/917807
 #Sample code that was repurposed toward this effort:  
 # https://gallery.technet.microsoft.com/scriptcenter/OS-Activation-by-MAK-using-e8a8ad2c 

 $strCompliant = "Non-Compliant"
 
 $LicenseInstallation = "Non-Compliant"
 $LicenseStatus = "Non-Compliant"
 

 # Get OS & role information, then set activationid based on the detected OS 
 ##UPDATE the ESUKEY WITH PROPER VALUE FOR EACH OS.

 $OS = Get-WmiObject Win32_OperatingSystem
    foreach ($ObjItem in $OS){
        $SystemRole = $SystemRole = $ObjItem.ProductType
        Switch ($SystemRole){ 
            1{$Type = "Desktop"}
            2{$Type = "UNSUPPORTED"}
            3{$Type = "Server"}
        } #End Switch Statement
     } #End foreach loop


If (($OS.version -like '6.0*' -and $Type -eq "Server")){
    #$OSVersion = "Windows2008" 
    $ESUActivationID ="553673ed-6ddf-419c-a153-b760283472fd"
    $ESUKEY = "<INSERT-ESU-KEY-HERE>"}

If (($OS.version -like '6.1*' -and $Type -eq "Desktop")){
    #$OSVersion = "Windows7" 
    $ESUActivationID ="77db037b-95c3-48d7-a3ab-a9c6d41093e0"
    $ESUKEY="<INSERT-ESU-KEY-HERE>"}
                               
If (($OS.version -like '6.1*' -and $Type -eq "Server")){
    #$OSVersion = "Windows2008R2"
    $ESUActivationID ="553673ed-6ddf-419c-a153-b760283472fd"
    $ESUKEY="<INSERT-ESU-KEY-HERE>"}
    

$partialProductKey = $ESUKEY.Substring($ESUKEY.Length - 5)


#This section will determine if endpoint is already compliant & exit the script without trying to activate if compliance is detected.
#It was implemented because there are CI/Baseline scenarios using SCCM/MEMCM that resulted in a baseline executing Windows activation unnecessarily.
 
 # This section verifies ESU key activation.
		$licensingProductInitial = Get-WmiObject -Query ('SELECT LicenseStatus FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)

        if (!$licensingProductInitial.LicenseStatus -eq 1) {
			        $LicenseStatusInitial = "Non-Compliant"
		        }
	    Else {$LicenseStatusInitial = "Compliant"}

#This section checks that the license key was installed.
      $licensingProductInitial2 = Get-WmiObject -Query ('SELECT ID, Name, OfflineInstallationId, ProductKeyID FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)
        
		if(!$licensingProductInitial2) {
			$LicenseInstallationInitial2 = "Non-Compliant"
		}
        Else {$LicenseInstallationInitial2 = "Compliant"}

        #If both conditions are already compliant, we call ByeByeCompliant to exit the script.
        If ($LicenseStatusInitial -eq "Compliant" -and $LicenseInstallationInitial2 -eq "Compliant"){byebyeCompliant}       

 #1)  First, install the ESU product key 

 $installESUKey = cscript.exe //nologo c:\windows\system32\slmgr.vbs //nologo /ipk $ESUKey #replace ESU_KEY with proper value downloaded from VLS site.


      #check license key
      $licensingProduct = Get-WmiObject -Query ('SELECT ID, Name, OfflineInstallationId, ProductKeyID FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)
        
		if(!$licensingProduct) {
			$LicenseInstallation = "Non-Compliant"
		}
        Else {$LicenseInstallation = "Compliant"}

        
 #2) Next, find the ESU Activation ID (we already defined this using the ids from the article in the opening section of the script.)

  <#NOTE:  Activation IDs from https://techcommunity.microsoft.com/t5/Windows-IT-Pro-Blog/How-to-get-Extended-Security-Updates-for-eligible-Windows/ba-p/917807
                Windows 7 SP1 (Client) Year 1 
                77db037b-95c3-48d7-a3ab-a9c6d41093e0 
                Year 2
                0e00c25d-8795-4fb7-9572-3803d91b6880 
                Year 3;
                4220f546-f522-46df-8202-4d07afd26454 

                Windows Server 2008/R2 (Server) 
                Year 1 
                553673ed-6ddf-419c-a153-b760283472fd 
                Year 2
                04fa0286-fa74-401e-bbe9-fbfbb158010d 
                Year 3
                16c08c85-0c8b-4009-9b2b-f1f7319e45f9 
                #>

#3) Next, activate the ESU Product Key

#$activateESUKey = cscript c:\windows\system32\slmgr.vbs /ato $ESUActivationID
$activateESUKey = cscript //nologo c:\windows\system32\slmgr.vbs /ato $ESUActivationID
#cscript.exe //nologo c:\windows\sysnative\slmgr.vbs /dlv

#4) Verify the activation was successful.
		$licensingProduct = Get-WmiObject -Query ('SELECT LicenseStatus FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)

        if (!$licensingProduct.LicenseStatus -eq 1) {
			        $LicenseStatus = "Non-Compliant"
		        }
	    Else {$LicenseStatus = "Compliant"}


#5) Return overall compliance state

If (($LicenseInstallation -eq "Compliant" -and $LicenseStatus -eq "Compliant")){$strCompliant = "Compliant"}

write-host $strCompliant