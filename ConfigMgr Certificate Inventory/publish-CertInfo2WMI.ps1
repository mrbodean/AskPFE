## Delete any existing instances
$CurrentEA = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
(Get-WmiObject -Namespace root\cimv2 -class cm_CertInfo).Delete()
$ErrorActionPreference = $CurrentEA

## Create Class if it doesn't exist in root\cimv2
$newClass = New-Object System.Management.ManagementClass ("root\cimv2", [String]::Empty, $null);
$newClass["__CLASS"] = "cm_CertInfo";
$newClass.Qualifiers.Add("Static", $true)
$newClass.Properties.Add("Location", [System.Management.CimType]::String, $false)
$newClass.Properties["Location"].Qualifiers.Add("Key", $true)
$newClass.Properties.Add("Handle", [System.Management.CimType]::String, $false)
$newClass.Properties["Handle"].Qualifiers.Add("Key", $true)
$newClass.Properties.Add("Thumbprint", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("Subject", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("Issuer", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("NotBefore", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("NotAfter", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("FriendlyName", [System.Management.CimType]::String, $false)
$newClass.Properties.Add("ExpiresinDays", [System.Management.CimType]::uint32, $false)
$newClass.Properties.Add("ScriptLastRan", [System.Management.CimType]::String, $false)
$newClass.Put()|Out-Null

function Publish-Certs2WMI{
    [CmdletBinding()]
    Param
    (
    # Path to Cert store to Publish
    [Parameter(Mandatory=$true,
    ValueFromPipelineByPropertyName=$true
    )]
    [ValidateScript({
        If(Test-Path "Cert:\$_"){$true}
        else{
            throw "Unable to access Certificates in $_ !!"
        }
    })]
    $Path
    )
    foreach ($Cert in (Get-ChildItem -Recurse cert:\$Path)){
        # Expires in...
            $ExpiresInDays = ($cert.NotAfter-(Get-Date)).TotalDays
            $ExpiresInDays = [int]$ExpiresInDays
            if ($ExpiresInDays -lt 0){
                $ExpiresInDays = 0
            }
            $Today = (Get-Date)
            # UnComment the If statement to exclude certificates that have already expired
            #If($ExpiresInDays -ne 0){
                set-wmiinstance -Namespace root\cimv2 -class cm_CertInfo -ErrorAction SilentlyContinue -argument @{
                    Location=$Path
                    Handle=$cert.Handle
                    Subject=$cert.subject
                    Issuer=$cert.Issuer
                    Thumbprint=$cert.thumbprint
                    NotBefore=$cert.NotBefore
                    NotAfter=$cert.NotAfter
                    FriendlyName=$cert.Friendlyname
                    ExpiresInDays=$ExpiresInDays
                    ScriptLastRan=$Today
                }|Out-Null
            #}
    }
}
$CertPaths = 'LocalMachine\TrustedPublisher','LocalMachine\Root','LocalMachine\My'
foreach($CertPath in $CertPaths){Publish-Certs2WMI -Path $CertPath}

If((Get-WmiObject -Namespace root\cimv2 -class cm_CertInfo).count -gt 0){Write-Host "Compliant"}