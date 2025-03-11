# **_Prescription Specification Schema Content_**

The Prescription specification JSON schema is based on the [JSON schema specification](https://json-schema.org/). It contains one schema file and a number of JSON schema definition files. This document gives an overview of the content of each schema/definition file. For more details see each schema/definition file and [prescription schema explained](./prescription-schema-description.md)

An "exploded schema" (schema and definitions files merged) is found here:

- [Json schema and definition files](../../../schemas/json/prescription/v1.0.json)

---

## Schema

### [Prescription specification schema](../../../schemas/json/prescription/v1.0/prescription-specification-schema.json)

This is where it all starts. The schema contains all the properties needed to create a prescription specification. The property details is given by the schema and in the referenced definition files.

```json
{
  "business_unit": {},
  "cashier": {},
  "sales_recording_system": {},
  "receipt_identifier": {},
  "time_of_purchase": "",
  "currency": "",
  "amount_with_benefit": {},
  "amount_without_benefit": {},  
  "amount_paid_by_benefit": {},
  "amount_to_pay": {},
  "expedition": [],
  "human": {},
  "animal": {},
  "customer": {}
}
```

---

## Definition files

This section gives an overview of the definition files and their content. For details see each definition file (JSON).

### [Business definitions](../../../schemas/json/retail/v1.0/business-definitions.json)

Information about the specification producer (pharmacy).

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

### [Customer definitions](../../../schemas/json/prescription/v1.0/customer-definitions.json)

Information about the customer, contact information and/or customer identifier.

- name
- contact information
- identification

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

### [Prescription specification definitions](../../../schemas/json/prescription/v1.0/prescription-specification-definitions.json)

Information about the specific prescription specification data like.

- high cost related
- animal or human related data