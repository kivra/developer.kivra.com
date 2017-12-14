# Payment service

## Post payment

```shell
curl -i -X POST
     -H "Authorization: token ${API_TOKEN}" \
     -H "Content-type: application/json" \
     -d ${JSON_PAYLOAD} \
     https://api.kivra.com/v1/tenant/${TENANT_KEY}/content
```

> The above command returns JSON structured like this:

```

```

This endpoints tries to pay a content


### HTTP Request

`PUT http://api.kivra.com/v2/user/${USER_KEY}/content/${CONTENT_KEY}/pay`

## JSON-payload (Metadata)

### Example metadata

> Example JSON to pay a content

```json
    { "action"   : "se.oneclick"
    , "account"  : "${MANDATE_KEY}"
    , "amount"   : "1337"
    }
```
