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
# 4520002 October 8, 2019—KB4520002 (Monthly Rollup)
# 4525234 November 12, 2019—KB4525234 (Monthly Rollup)
# 4525239 November 12, 2019—KB4525239 (Security-only update)
# 4530695 December 10, 2019—KB4530695 (Monthly Rollup)
# 4530719 December 10, 2019—KB4530719 (Security-only update)
# 4534303 January 14, 2020—KB4534303 (Monthly Rollup)
# 4534312 January 14, 2020—KB4534312 (Security-only update)

$patches = 'KB4520002','KB4525234','KB4525239','KB4530695','KB4530719','KB4534303','KB4534312'

#Evaluate the updates & set Initial compliance
If (get-hotfix -id $patches){$StrCompliant = "Compliant"}else{$strCompliant = "Non-Compliant"}



write-host $StrCompliant









