# **_DR - Retail Schema Content_**

The DR Retail JSON schema is based on the [JSON schema specification](https://json-schema.org/). It is contains one schema file and a number of JSON schema definition files. This document gives an overview of the content of each schema/definition file. For more details see each schema/definition file and [retail schema explained](./retail-schema-description.md)

An "exploded schema" (schema and definitions files merged) is found here:

- [Json schema and definition files](../../../schemas/json/retail/v1.0.json)

---

## Schema

### [Digital receipt schema](../../../schemas/json/retail/v1.0/digital-receipt-schema.json)

This is where it all starts. The schema contains all the properties needed to create a digital receipt. The property details is given in the referenced definition files.

```json
{
  "copy": "",
  "business_unit": {},
  "cashier": {},
  "sales_recording_system": {},
  "receipt_identifier": {},
  "time_of_purchase": "",
  "currency": "",
  "totals": [],
  "header_text": {},
  "footer_text": {},
  "items": [],
  "retail_price_modifiers": [],
  "payments": [],
  "customer": {},
  "customer_order": {},
  "control_unit": {}
}
```

---

## Definition files

This section gives an overview of the definition files and their content. For details see each definition file (JSON).

### [Business definitions](../../../schemas/json/retail/v1.0/business-definitions.json)

Information about the receipt producer (merchant).

- name
- contact information
  - address
  - email
  - phone
  - etc
- identification
  - organisation number
  - internal shop id
  - service id

### [Customer definitions](../../../schemas/json/retail/v1.0/customer-definitions.json)

Information about the customer, contact information and/or customer identifier.

- name
- contact information
- identification
- loyalty program

### [Customer order definitions](../../../schemas/json/retail/v1.0/customer-order-definitions.json)

If the receipt has a connection to a customer order/booking reference or similar.

- customer order information
- customer information

### [Item definitions](../../../schemas/json/retail/v1.0/item-definitions.json)

Properties for each item. Items is one of sale/return/text/deposit

- item type
- item identifiers
- serial number/lot number
- amounts/taxes/discounts
- number of items sold/returned
- item description
- link to related items

### [Monetary definitions](../../../schemas/json/retail/v1.0/monetary-definitions.json)

Information about

- totals/sub totals
- amounts/taxes
- currencies
- retail price modifiers

### [Sales recording system definitions](../../../schemas/json/retail/v1.0/sales-recording-system-definitions.json)

Information related to the cash register:

- POS id, serial number, etc.
- cashier
- receipt identifier
  - sequence number
  - extended number
  - barcode representation

### [Service common definitions](../../../schemas/json/retail/v1.0/service-common-definitions.json)

General receipt information referenced from other definition files/schemas:

- identifier types and formats
- phone number
- address information
- text types
- quantity definitions

### [Tender-definitions](../../../schemas/json/retail/v1.0/tender-definitions.json)

Paymern information:

- tender type and type related information
  - cash
  - debit/credit
  - coupon
  - giftcard
  - etc
- tender
  - amounts
  - refunds
  - rounding
  - foreign currencies
