# Kivra digital receipt json schema

## [Version 1.1 (2026-02-10)](../../../schemas/json/retail/v1.1.json)

Release of retail schema retail/v1.1. Introducing enhanced tender_creditdebit with additional ISO 8583 fields.

### Changes to tender_creditdebit

Added new optional fields to support more detailed payment card information:

- `acquiring_institution_id_code` - ISO 8583 field 32, Acquiring institution identification code
- `card_acceptor_id` - ISO 8583 field 42, Card Acceptor Identification Code
- `card_acceptor_name` - ISO 8583 field 43, Card Acceptor Name/Location
- Updated `approval_code` pattern to support broader character set

Example:

```json
{
  "tender": {
    "type": "creditdebit",
    "bank_identification_number": "************3602",
    "acquiring_institution_id_code": "722660",
    "retrieval_reference_number": "000295749077",
    "card_acceptor_id": "10565281",
    "card_acceptor_terminal_id": "73200801",
    "card_acceptor_name": "Kivra AB",
    "approval_code": "025965",
    "card_token": {
      "value": "123455",
      "scheme": "par"
    }
  }
}
```

The content-type/profile for v1.1 is:
_application/json;profile=https://se.receipts.kivra.com/schemas/json/retail/v1.1
