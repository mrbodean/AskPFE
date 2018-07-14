Select sys.Name0 as 'Name', Location0 as 'Certificate Location', FriendlyName0 as 'Friendly Name', 
ExpiresinDays0 as 'Expires in Days', Issuer0 as Issuer, NotAfter0 as 'Not After', NotBefore0 as 'Not Before', 
Subject0 as Subject, Thumbprint0 as Thumbprint, ScriptLastRan0 as 'Script last Ran'
from v_GS_CM_CERTINFO
Inner Join v_R_System as sys ON v_GS_CM_CERTINFO.ResourceID = sys.ResourceID
