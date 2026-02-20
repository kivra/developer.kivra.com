# Field Requirements Reference

This document provides a consolidated reference for all field requirements in the Kivra Digital Receipt JSON Schema (DRJSON).

For detailed explanations of each field, see [Retail Schema Explained](retail-schema-description.md).

## Quick Reference

### Legend

| Symbol | Meaning |
|--------|---------|
| **Required** | Field must be present |
| Optional | Field may be omitted |
| Conditional | Required under certain conditions |

---

## Root-Level Fields

| Field | Requirement | Notes |
|-------|-------------|-------|
| `copy` | Optional | Defaults to `false` |
| `business_unit` | **Required** | Merchant information |
| `cashier` | Optional | Operator information |
| `sales_recording_system` | **Required** | POS system info |
| `receipt_identifier` | **Required** | Receipt number |
| `time_of_purchase` | **Required** | ISO 8601 timestamp |
| `currency` | **Required** | ISO 4217 code (e.g., "SEK") |
| `totals` | **Required** | Array of totals |
| `header_text` | Optional | Header text lines |
| `footer_text` | Optional | Footer text lines |
| `items` | **Required** | Array of items |
| `retail_price_modifiers` | Optional | Receipt-level discounts |
| `payments` | **Required** | Array of payments |
| `customer` | Conditional | See [Customer Identification](#Customer_Identification) |
| `customer_order` | Optional | Order linking |
| `control_unit` | Conditional | Required if control unit connected |

---

## Nested Field Requirements

### business_unit

| Field | Requirement |
|-------|-------------|
| `business_unit.name` | **Required** |
| `business_unit.service_id` | **Required** |
| `business_unit.organization_number` | **Required** |
| `business_unit.contact` | **Required** |
| `business_unit.unit_id` | Optional |
| `business_unit.geo_location` | Optional |

#### business_unit.contact.address

| Field | Requirement |
|-------|-------------|
| `locality` | **Required** |
| `postal_code` | **Required** |
| `street_address` | Conditional (see below) |
| `post_box` | Conditional (see below) |
| `extended_address` | Optional |
| `region` | Optional |
| `country_name` | Optional |

**Rule:** Either `street_address` OR `post_box` must be provided.

#### business_unit.geo_location

| Field | Requirement |
|-------|-------------|
| `latitude` | **Required** (if geo_location provided) |
| `longitude` | **Required** (if geo_location provided) |

---

### sales_recording_system

| Field | Requirement |
|-------|-------------|
| `id` | Conditional |
| `name` | Conditional |
| `serial_number` | Optional |

**Rule:** At least one of `id` or `name` must be provided.

---

### receipt_identifier

| Field | Requirement |
|-------|-------------|
| `sequence_number` | **Required** |
| `extended_number` | Optional |

#### receipt_identifier.extended_number (if provided)

| Field | Requirement |
|-------|-------------|
| `value` | **Required** |
| `context` | **Required** (`store`, `chain`, or `global`) |
| `type` | Optional (barcode type) |

---

### totals (array items)

Each total in the array requires:

| Field | Requirement |
|-------|-------------|
| `type` | **Required** (`net`, `gross`, `vat`, `paid`, `rounding`, `discount`, `loyalty`) |
| `amount` | **Required** |
| `refund` | Optional (defaults to `false`) |
| `sub_totals` | Optional |

#### totals[].sub_totals for type="vat"

| Field | Requirement |
|-------|-------------|
| `amount` | **Required** |
| `taxable_amount` | **Required** |
| `net_amount` | **Required** |
| `tax_percentage` | **Required** |
| `refund` | Optional |

---

### items (array items)

#### Common fields for all item types

| Field | Requirement |
|-------|-------------|
| `type` | **Required** (`sale`, `return`, `text`, `deposit`) |
| `sequence_number` | **Required** |

#### Sale/Return items

| Field | Requirement |
|-------|-------------|
| `identifiers` | **Required** (array with at least one item) |
| `description` | **Required** |
| `quantity` | **Required** |
| `actual_sales_unit_price` | **Required** |
| `extended_amount` | **Required** |
| `extended_gross_amount` | **Required** |
| `regular_sales_unit_price` | Optional |
| `unit_cost_price` | Optional |
| `tax_percentage` | Optional |
| `tax_amount` | Optional |
| `retail_price_modifiers` | Optional |
| `eligible_for_frequent_shopper_points` | Optional |

#### items[].identifiers (array items)

| Field | Requirement |
|-------|-------------|
| `identifier_type` | **Required** (`pos`, `gtin`, `srs`) |
| `value` | **Required** |

#### items[].quantity

| Field | Requirement |
|-------|-------------|
| `value` | **Required** |
| `unit` | **Required** |
| `entry_method` | Optional (defaults to `scanned`) |

#### Return items: receipt_reference (if provided)

| Field | Requirement |
|-------|-------------|
| `value` | **Required** |
| `context` | **Required** |
| `type` | Optional |

#### Deposit items

| Field | Requirement |
|-------|-------------|
| `type` | **Required** (must be `"deposit"`) |
| `amount` | **Required** |
| `sequence_number` | **Required** |
| `unit_amount` | Optional |
| `quantity` | Optional |
| `refund` | Optional |
| `tax_percentage` | Optional |
| `item_link` | Optional |
| `text` | Optional |
| `sub_deposits` | Optional |

#### Text items

| Field | Requirement |
|-------|-------------|
| `type` | **Required** (must be `"text"`) |
| `text` | **Required** |
| `sequence_number` | **Required** |

---

### payments (array items)

| Field | Requirement |
|-------|-------------|
| `tender` | **Required** |
| `amount` | **Required** |
| `amount_applied_to_bill` | Optional |
| `rounding` | Optional |
| `refund` | Optional |
| `foreign_currency_amount` | Optional |

#### payments[].tender

| Field | Requirement |
|-------|-------------|
| `type` | **Required** (`cash`, `creditdebit`, `giftcard`, `mobile`, `coupon`, `loyalty`, `other`) |

Additional fields vary by tender type (see [Retail Schema Explained](retail-schema-description.md#payments)).

#### payments[].tender (creditdebit) — ISO 8583 fields

| Field | Requirement | Notes |
|-------|-------------|-------|
| `bank_identification_number` | Optional | Masked card number (ISO 8583 field 56) |
| `acquiring_institution_id_code` | Optional | Acquiring institution ID (ISO 8583 field 32) |
| `retrieval_reference_number` | Optional | Retrieval reference (ISO 8583 field 37) |
| `card_acceptor_id` | Optional | Card acceptor ID (ISO 8583 field 42) |
| `card_acceptor_terminal_id` | Optional | Terminal ID (ISO 8583 field 41) |
| `card_acceptor_name` | Optional | Card acceptor name/location (ISO 8583 field 43) |
| `approval_code` | Optional | Approval code (ISO 8583 field 38) |
| `merchant_identifier` | Optional | **Deprecated** — use `card_acceptor_id` instead |
| `card_token` | Conditional | See [Customer Identification](#Customer_Identification) |
| `payment_slip` | Optional | Card terminal information |

---

### customer

| Field | Requirement |
|-------|-------------|
| `id` | **Required** (if customer provided) |
| `contact` | Optional |

#### customer.id

At least one identifier must be provided:

| Field | Requirement |
|-------|-------------|
| `civic_registration_number` | Conditional |
| `email` | Conditional |
| `phone` | Conditional |
| `loyalty` | Conditional |

---

### control_unit

| Field | Requirement |
|-------|-------------|
| `id` | **Required** (if control_unit provided) |
| `code` | **Required** (if control_unit provided) |

---

## Conditional Requirements Summary

This section summarizes all conditional field requirements in one place.

### Customer Identification

A receipt must identify its recipient in one of these ways:

| Method | Fields Required |
|--------|-----------------|
| Card token | `payments[].tender.card_token` with `value` and `scheme` |
| Customer ID | `customer.id` with at least one identifier |
| Greenbin/Anonymous | Neither required (retained receipts) |

### Address Requirements

For `business_unit.contact.address`:
- `locality` and `postal_code` are always required
- Either `street_address` OR `post_box` must be provided (not both required)

### POS System Identification

For `sales_recording_system`:
- At least one of `id` or `name` must be provided

### Control Unit

`control_unit` is required when:
- A control unit (kontrollenhet) is physically connected to the POS system
- Required by Swedish tax law for certain merchant types

### Extended Receipt Number

If `receipt_identifier.extended_number` is provided:
- Both `value` and `context` are required
- `type` (barcode type) is optional

### VAT Sub-totals

If including `sub_totals` for a VAT total:
- All of `amount`, `taxable_amount`, `net_amount`, and `tax_percentage` are required

---

## Common Validation Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Missing required field | A required field is not present | Add the missing field |
| Invalid service_id format | `service_id` must be exactly 42 characters | Verify the store ID from Kivra |
| Missing address field | `locality` or `postal_code` missing | Ensure both are provided |
| No customer identifier | Receipt has no way to identify recipient | Add card token or customer ID |
| Invalid currency format | Currency not in ISO 4217 format | Use 3-letter code (e.g., "SEK") |
| Invalid timestamp | `time_of_purchase` not in ISO 8601 | Use format: `YYYY-MM-DDThh:mm:ssTZD` |
| Missing item identifier | Sale/return item has no identifiers | Add at least one identifier |
| Missing quantity fields | `quantity.value` or `quantity.unit` missing | Provide both fields |

---

## Validation Tools

Use the [Merchant Toolbox](https://merchant-toolbox.kivra.com/) to:
- Preview how your receipt will render
- Validate your JSON against the schema
- See example receipts

For the full JSON Schema, see [v1.1.json](../../../schemas/json/retail/v1.1.json).
