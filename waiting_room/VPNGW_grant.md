## Grant access to Azure VPN audience

This should be a one off per tenancy. You will need to be Global Admin in AAD.

1. Grant access

    Open the [link](https://login.microsoftonline.com/common/oauth2/authorize?client_id=41b23e61-6c1e-4545-b367-cd054e0ed4b4&response_type=code&redirect_uri=https://portal.azure.com&nonce=1234&prompt=admin_consent
)

1. Click on Accept to grant access to read profiles

    ![Grant Access](images/GrantAccessToAzureVPN.png)

You should be able to list Azure VPN in Enterprise Apps.
