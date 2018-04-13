# Partner API

The Partner API allows authorized partners to access and retrieve documents from the Kivra inbox of companies. 
This is typically done to allow for further processing of the documents like for instance bookkeeping.

A company must explicitly provide a partner with the right to access its documents, by switching on a corresponding option 
in the settings page of the company in Kivra. Once a company has allowed a partner to retrieve the documents, the partner can 
start retrieving documents, even those that a company received before enabling the access to the partner.

A company can at any time stop providing access to a partner by switching off the corresponding options in the setting 
page of the company in Kivra. 

## Typical process

1. Company "**C**" is using software "**S**" made by "**P**", a Partner of Kivra.
2. **C** chooses to activate the connection between **S** and Kivra by enabling enabling Kivra in the **S** settings. 
3. **S** checks whether **C** exists in Kivras database and obtains a Company Key that identifies this company in all 
communication with Kivra.
4. **S** starts polling Kivra using the partner API to access the documents, however this will not work until next step 
is completed.
5. **C** logs in to Kivra and switches on permission for **S** to access documents, using the Settings page of Kivra.
6. At this point when **S** tries to retrieve documents for **C** using the Partner API, it will receive a 
positive response.
7. **S** can now access and process documents for **C**.


## API Documentation

The API is based on REST API. Authorization is based on OAuth2.0.

The URLs for the endpoints are specified as `https://TYPE.kivra.com/VERSION` where: 
- `TYPE` can be `api` or `sandbox` depending on whether the call is made for the production environment or test environment
- `VERSION` is `v1`

### Querying companies

To access documents for a company, the partner needs first to retrieve a Company Key. 

#### Authorisation for querying companies

To query the Company database, we need an authorization with a specific scope.

```shell
curl -X POST \
  https://TYPE.kivra.com/VERSION/auth \
  -d grant_type=client_credentials \
  -d scope=get:kivra.v1.partner.company \
  -H "Authorization: Basic ${ENCODED_CLIENT_ID_AND_SECRET}"
```

> The answer will look like the following:

```
{
    "state": "",
    "access_token": "DMWmtGWe9YpXep6FTgVEwWetxLR6D53z",
    "expires_in": 28800,
    "scope": "get:kivra.v1.partner.company",
    "token_type": "bearer"
}
```

#### Retrieving a Company Key

To retrieve a CompanyKey, Partner must specify the Company's Vat Number in format `SExxxxxxnnnn01`. 
The company key should be saved for later usage.

```shell
curl -i -X GET -H "Authorization: token <access_token>" \
      https://TYPE.kivra.com/VERSION/partner/company?vat_number=<vat_number>
```

> The answer will look like the following

```
{
    "key": "<company_key>"
}
```

### Retrieving documents

#### Authorisation for retrieving document

Each partner wanting to access the partner API needs to have authorised Client ID / Client Secret credentials. 
The client credentials are used to retrieve an access token with a specific scope allowing to retrieve documents 
for one specific company. The access token has a limited validity and is used to access the Parter API's endpoints

```shell
curl -X POST \
  https://TYPE.kivra.com/VERSION/auth \
  -d grant_type=client_credentials \
  -d scope="get:kivra.v1.partner.company.<company_key>.**" \
  -H "Authorization: Basic ${ENCODED_CLIENT_ID_AND_SECRET}"

```

> The answer will look like the following:

```
{
    "state": "",
    "access_token": "DMWmtGWe9YpXep6FTgVEwWetxLR6D53z",
    "expires_in": 28800,
    "scope": "get:kivra.v1.partner.company.<company_key>.**",
    "token_type": "bearer"
}
```

#### Get company inbox

The first step is to retrieve the company inbox. This request will return all data included in the company inbox. 
It is up to the partner to keep track of which documents have already been received/processed and which not. 

Each content is uniquely identified from a ```key``` that may be used later to retrieve more information on this content.
The sender of the document is provided by name but also by a unique identifier ```sender``` that may be used by the
partner to create automated processing. 

If the company hasn't provided access to the partner via the Kivra setting page, this request will return an error code.

```shell
curl -i -X GET -H "Authorization: token <access_token>" \
      https://TYPE.kivra.com/VERSION/partner/company/<company_key>/content
```

> The answer will look like the following:

```
[
    {
        "key": "15117899401c72e979da634ddcbad5185314fa7a64",
        "sender": "tenant_149510138000eb039324d341ed9702f694d6b6d65a",
        "sender_name": "Kalmar Energi",
        "created_at": "2017-11-27T13:39:00Z",
        "subject": "Faktura från Kalmar Energi Försäljning AB",
    },
    ...
]
```

#### Get content details

After partner has downloaded the complete list of documents, it may want to get more information about a specific content. 
To do this the partner needs to use the ```key``` information that was received with the document list.

The answer to this call will also include one or several ```key``` (under ```parts```) that identifies the file(s) that were 
received by the company. This key(s) could be used later to retrieve the document file.

```shell
curl -i -X GET -H "Authorization: token <access_token>" \
      https://TYPE.kivra.com/VERSION/partner/company/<company_key>/content/<content_key>
```

> The answer will look like the following:

```
{
    "payment": null,
    "parts":
        [
            {
                "name": "1493500000004.pdf",
                "content_type": "application/pdf",
                "size": "30334",
                "checksum": "ea86f443d21e3c6b3fec76e2d14f7bf3",
                "key": "15117899401c72e979da634ddcbad5185314fa7a64",
                "sha256": null
            }
        ],
    "created_at": "2017-11-27T13:39:00Z",
    "receiver_name": "Testbolag 3 bokat av SKV Aktiebolag",
    "sender_name": "Kalmar Energi",
    "subject": "Faktura från Kalmar Energi Försäljning AB",
    "sender": "tenant_149510138000eb039324d341ed9702f694d6b6d65a"
}
```

#### Get file

Using the ```key``` obtained in the content details, it is possible for partner to download the file itself for storage 
or processing. The file can be downloaded as RAW file.

```shell
curl -i -X GET -H "Authorization: token <access_token>" \
      https://TYPE.kivra.com/VERSION/partner/company/<company_key>/content/<content_key>/file/<file_key>/raw
```

> The answer will contain the raw data in binary format

