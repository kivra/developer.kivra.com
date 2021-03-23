# Kivra digital receipt json schema

## [Version 1.0 (2020-01-28)](../../../schemas/json/retail/v1.0.json)

We decided to release a version 1.0 so that everyone can get ready for production. It is based on RC2 (above) with some additional restrictions:

- totals/paid only allows sub*totals of type \_received* and _returned_. Example:

```json
{
  "type": "paid",
  "amount": 46.0,
  "refund": false,
  "sub_totals": [
    {
      "type": "received",
      "amount": 50.0,
      "text": {
        "type": "array",
        "collection": ["Mottaget"]
      }
    },
    {
      "type": "returned",
      "amount": 4.0,
      "text": {
        "type": "array",
        "collection": ["Växel"]
      }
    }
  ]
}
```

- totals/vat: _net_amount_ is required in sub_totals. Example:

```json
{
  "type": "vat",
  "amount": 7.0,
  "refund": false,
  "sub_totals": [
    {
      "amount": 7.0,
      "taxable_amount": 46.0,
      "net_amount": 39.0,
      "tax_percentage": 12,
      "refund": false
    }
  ]
}
```

The content-type/profile for v1.0 is:
_application/json;profile=https://se.digitalreceipts.net/schemas/json/retail/v1.0_
