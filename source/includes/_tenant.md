# Tenant

## Create new tenant

```shell
curl -i -X POST \
     -H "Authorization: token ${API_TOKEN}" \
     -H "Content-type: application/json" \
     -d ${JSON_PAYLOAD} \
     https://api.kivra.com/v1/tenant/

HTTP/1.1 201 Created
server: Cowboy
date: Mon, 26 Mar 2018 09:50:09 GMT
content-length: 254
content-type: application/json
kivra-objkey: 1522057810adc62537a9cc41a0afefddb2481ed821
location: http://localhost:8000/v1/tenant/1522057810adc62537a9cc41a0afefddb2481ed821

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

This endpoints creates new tenants.

### HTTP Request

`POST http://api.kivra.com/v1/tenant`

### Request payload

> Example of a tenant creation json payload

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
