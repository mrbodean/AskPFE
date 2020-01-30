  <# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
 THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING 
 BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
 We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce # 
 and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market
Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code
is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees,
that arise or result from the # use or distribution of the Sample Code.
#>

#Instructions on ESU:  https://techcommunity.microsoft.com/t5/Windows-IT-Pro-Blog/How-to-get-Extended-Security-Updates-for-eligible-Windows/ba-p/917807
 # Found sample code that was repurposed toward this effort:  https://gallery.technet.microsoft.com/scriptcenter/OS-Activation-by-MAK-using-e8a8ad2c 

 #Updated for ESU Year 1; additional activation ids are listed later in the script, for subsequent years.
 $strCompliant = "Non-Compliant"

 $LicenseInstallation = "Non-Compliant"
 $LicenseStatus = "Non-Compliant"
 $LicenseStatus2= "Non-Compliant"

 # Get OS & role information, then set activationid based on the detected OS.

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
    
#1) Verify the ESU Product key Installation
$partialProductKey = $ESUKEY.Substring($ESUKEY.Length - 5)
 #write-host "partial:" $partialProductKey
      #check license key
		$licensingProduct = Get-WmiObject -Query ('SELECT ID, Name, OfflineInstallationId, ProductKeyID FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)
        
		if(!$licensingProduct) {
		    $LicenseInstallation = "Non-Compliant"
		}

        Else {$LicenseInstallation = "Compliant"}

         #write-host "licinstallations: " $LicenseInstallation
 
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

#3) Verify activation was successful.
		$licensingProduct2 = Get-WmiObject -Query ('SELECT LicenseStatus FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)

        if (!$licensingProduct2.LicenseStatus -eq 1) {
			        $LicenseStatus2 = "Non-Compliant"
		        }
	    Else {$LicenseStatus2 = "Compliant"}

        #write-host "licstatus: " $LicenseStatus

#4) Return overall compliance state

If (($LicenseInstallation -eq "Compliant" -and $LicenseStatus2 -eq "Compliant")){$strCompliant = "Compliant"}
              
write-host $strCompliant
 