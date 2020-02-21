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

#SECTION BELOW NEEDS TO BE UPDATED AS NEW CUMULATIVE UPDATES ARE RELEASED
# 4519976 October 8, 2019—KB4519976 (Monthly Rollup)
# 4525235 November 12, 2019—KB4525235 (Monthly Rollup)
# 4525233 November 12, 2019—KB4525233 (Security-only update)
# 4530734 December 10, 2019—KB4530734 (Monthly Rollup)
# 4530692 December 10, 2019—KB4530692 (Security-only update)
# 4534310 January 14, 2020—KB4534310 (Monthly Rollup)
# 4534314 January 14, 2020—KB4534314 (Security-only update)

$patches = 'KB4519976','KB4525235','KB4530734','KB4534310','KB4525233','KB4530692','KB4534314'

#Evaluate the updates & set Initial compliance
If (get-hotfix -id $patches){$StrCompliant = "Compliant"}else{$strCompliant = "Non-Compliant"}



write-host $StrCompliant









