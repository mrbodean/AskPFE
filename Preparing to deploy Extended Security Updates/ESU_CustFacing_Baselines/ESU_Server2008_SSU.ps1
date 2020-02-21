<# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
 THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING 
 BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
 We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce # 
 and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market
Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code
is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees,
that arise or result from the # use or distribution of the Sample Code.
#>	

$strCompliant = "Non-Compliant"

#SECTION BELOW NEEDS TO BE UPDATED AS NEW SERVICING STACK UPDATES ARE RELEASED
# 4526478 Servicing stack update for Windows Server 2008 SP2: November 12, 2019
# 4517134 Servicing stack update for Windows Server 2008 SP2: September 10, 2019
# 4531787 Servicing stack update for Windows Server 2008 SP2: December 10, 2019
# 4536953 Servicing stack update for Windows Server 2008 SP2: January 14, 2020

$patches = 'KB4526478','KB4517134','KB4531787','KB4536953'

#Evaluate the updates & set Initial compliance
If (get-hotfix -id $patches){$StrCompliant = "Compliant"}else{$strCompliant = "Non-Compliant"}



write-host $StrCompliant









