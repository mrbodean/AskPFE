#requires -runasadministrator 
$SMS_XML_ActionPath = $env:SMS_ADMIN_UI_PATH -replace "bin\\i386", "XmlStorage\Extensions\Actions"
$devices = "ed9dee86-eadd-4ac8-82a1-7234a4646e62"
$deviceincollection = "3fd01cd1-9e01-461e-92cd-94866b8d1f39"
If(!(Test-Path "$SMS_XML_ActionPath\$devices")){New-Item -Path "$SMS_XML_ActionPath\$devices" -ItemType Directory}
Get-Item -Path ".\PFE_FQDN_Remote_Control.xml" | Copy-Item -Destination "$SMS_XML_ActionPath\$devices" -Force
Get-Item -Path ".\PFE_FQDN_Remote_Control.xml" | Copy-Item -Destination "$SMS_XML_ActionPath\$deviceincollection" -Force
