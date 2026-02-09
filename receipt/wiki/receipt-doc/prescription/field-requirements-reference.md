# Field Requirements Reference - Prescriptions

This document provides a consolidated reference for all field requirements in the Kivra Prescription Specification JSON Schema.

For detailed explanations of each field, see [Prescription Schema Explained](prescription-schema-description.md).

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
| `business_unit` | **Required** | Pharmacy information |
| `cashier` | **Required** | Operator information |
| `receipt_identifier` | **Required** | Receipt/prescription identifier |
| `time_of_purchase` | **Required** | ISO 8601 timestamp |
| `currency` | Optional | ISO 4217 code (e.g., "SEK") |
| `expedition` | **Required** | Expedition/prescription details |
| `amount_without_benefit` | **Required** | Amount without high-cost benefit |
| `amount_to_pay` | **Required** | Final amount customer pays |
| `amount_with_benefit` | Conditional | Required for human prescriptions |
| `amount_paid_by_benefit` | Optional | Amount covered by benefit |
| `totals` | Optional | VAT totals if applicable |
| `customer` | Optional | Customer/animal owner information |
| `medications` | Optional | List of medications |
| `animal` | Conditional | Required for animal prescriptions |
| `human` | Conditional | Required for human prescriptions |

---

## Prescription Type Requirement

A prescription must be **either** for an animal **or** a human:

| Prescription Type | Required Fields |
|-------------------|-----------------|
| Animal | `animal` |
| Human | `human` + `amount_with_benefit` |

---

## Nested Field Requirements

### business_unit

Same requirements as receipts - see [Receipt Field Requirements](../retail/field-requirements-reference.md#business_unit).

| Field | Requirement |
|-------|-------------|
| `name` | **Required** |
| `service_id` | **Required** |
| `organization_number` | **Required** |
| `contact` | **Required** |

---

### cashier

| Field | Requirement |
|-------|-------------|
| `id` | Optional |
| `name` | Optional |

Note: Unlike receipts, `cashier` is **required** for prescriptions (though its internal fields are optional).

---

### receipt_identifier

| Field | Requirement |
|-------|-------------|
| `sequence_number` | Optional |
| `extended_number` | **Required** |

#### receipt_identifier.extended_number

| Field | Requirement |
|-------|-------------|
| `value` | **Required** |
| `context` | **Required** |
| `type` | Optional |

Note: For prescriptions, `extended_number` is required (unlike receipts where only `sequence_number` is required).

---

### expedition

| Field | Requirement |
|-------|-------------|
| `id` | **Required** |
| `details` | **Required** (array with at least one string) |

---

### animal (for animal prescriptions)

| Field | Requirement |
|-------|-------------|
| `id` | **Required** |

---

### human (for human prescriptions)

| Field | Requirement |
|-------|-------------|
| `high_cost` | **Required** |

#### human.high_cost

| Field | Requirement |
|-------|-------------|
| `previous_period` | **Required** |
| `current_period` | **Required** |
| `next_period` | **Required** |
| `amount_left_to_reimbursement` | Optional |

#### human.high_cost.*_period (previous, current, next)

| Field | Requirement |
|-------|-------------|
| `gross` | **Required** |
| `net` | **Required** |
| `start_date` | **Required** |
| `end_date` | Optional |

#### human.high_cost.amount_left_to_reimbursement (if provided)

| Field | Requirement |
|-------|-------------|
| `gross` | **Required** |
| `net` | **Required** |

---

### medications (array items)

| Field | Requirement |
|-------|-------------|
| `description` | **Required** |
| `amount` | Optional |

---

### totals (array items)

Same structure as receipts - see [Receipt Field Requirements](../retail/field-requirements-reference.md#totals-array-items).

| Field | Requirement |
|-------|-------------|
| `type` | **Required** |
| `amount` | **Required** |

---

## Conditional Requirements Summary

### Animal vs Human Prescription

| Prescription Type | Required at Root Level |
|-------------------|------------------------|
| Animal | `animal` object with `id` |
| Human | `human` object with `high_cost`, plus `amount_with_benefit` |

### Amount Fields by Type

| Field | Animal | Human |
|-------|--------|-------|
| `amount_without_benefit` | **Required** | **Required** |
| `amount_to_pay` | **Required** | **Required** |
| `amount_with_benefit` | Not used | **Required** |
| `amount_paid_by_benefit` | Not used | Optional |

---

## Key Differences from Receipts

| Aspect | Receipts | Prescriptions |
|--------|----------|---------------|
| `cashier` | Optional | **Required** |
| `receipt_identifier.sequence_number` | **Required** | Optional |
| `receipt_identifier.extended_number` | Optional | **Required** |
| `items` / `payments` | **Required** | Not used |
| `animal` / `human` | Not used | One **required** |
| `expedition` | Not used | **Required** |

---

## Common Validation Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Missing prescription type | Neither `animal` nor `human` provided | Add either `animal` or `human` object |
| Missing amount_with_benefit | Human prescription without this field | Add `amount_with_benefit` for human prescriptions |
| Missing high_cost periods | Human prescription missing period data | Add all three periods: `previous_period`, `current_period`, `next_period` |
| Missing extended_number | `receipt_identifier` without extended number | Add `extended_number` with `value` and `context` |
| Missing expedition details | Empty or missing `expedition.details` | Add at least one string to `details` array |

---

## Validation Tools

Use the [Merchant Toolbox](https://merchant-toolbox.kivra.com/) to validate your prescription specification JSON.

For the full JSON Schema, see [prescription-specification-schema.json](../../../schemas/json/prescription/v1.0/prescription-specification-schema.json).
