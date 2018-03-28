# Tenant

Creation of tenants via API allows clients to create new tenants in an efficient manner. The created tenant is automatically added to the client scope.

## Create new tenant

The endpoint to create a new tenant is:

`https://api.kivra.com/v1/tenant/`

Additional metadata, specified as JSON, is also required containing company name, company VAT number, and display name. The display name is shown in the user inbox whenever they receive content from this tenant.

```shell
curl -i -X POST \
     -H "Authorization: token ${API_TOKEN}" \
     -H "Content-type: application/json" \
     -d ${JSON_PAYLOAD} \
     https://api.kivra.com/v1/tenant/
```

> With the following JSON payload:

```json
{
    "company_id": [
        {
            "name": "Kivra AB",
            "orgnr": "SE556840226601"
        }
    ],
    "name": "Kivra"
}
```

> Example of response:

```
HTTP/1.1 201 Created
server: Cowboy
date: Mon, 26 Mar 2018 09:50:09 GMT
content-length: 254
content-type: application/json
kivra-objkey: ${TENANT_ID}
location: http://localhost:8000/v1/tenant/${TENANT_ID}

{
  "edit_security_level": 25,
  "groups": [],
  "status": "optional",
  "visibility": "visible",
  "class": "opt_out",
  "payment_information": [],
  "phone_numbers": [],
  "adresses": [],
  "urls": [],
  "emails": [],
  "name": "Kivra",
  "company_id": [
    {
      "name": "Kivra AB",
      "orgnr": "SE556840226601"
    }
  ]
}

```

## Authorization with limited access scope

In some particular configuration, for instance when a centralized service wants to provide a satellite service with possibility to only send content to Kivra for a specific tenant, but not allowing any other operation, the centralized service may request an access token for a specific tenant with a limited scope. This access token can be safely provided to the satellite service.

To retrieve this access token, the client performs a new authorization with some extra parameters specifying the limited scope.

```
curl -X POST \
  https://api.kivra.com/v1/auth \
  -d grant_type=client_credentials \
  -d scope=post:kivra.v1.tenant.${TENANT_ID}.content \
  -H "Authorization: Basic ${ENCODED_CLIENT_ID_AND_SECRET}"

```

> The answer will look like the following:

```
{
    "state": "",
    "access_token": "DMWmtGWe9YpXep6FTgVEwWttxLR6D53z",
    "expires_in": 28800,
    "scope": "post:kivra.v1.tenant.${TENANT_ID}.content",
    "token_type": "bearer"
}
```
