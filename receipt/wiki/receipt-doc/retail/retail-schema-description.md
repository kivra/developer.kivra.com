# **_DR - Retail Schema Explained_**

## Introduction

The purpose of this document is to explain the structure of a digital receipt based on the Kivra DR Retail JSON Schema (DRJSON).

DRJSON is made to conform to the Swedish fiscal law for cash registers. For detailed information, see [digital-receipt-schema.json](../../../schemas/json/retail/v1.0.json).

## Field Requirements

Throughout this document, fields are marked with requirement indicators:

- **Required** - Field must be present
- **Optional** - Field may be omitted
- **Conditional** - Field is required under certain conditions (explained in context)

For a consolidated reference of all field requirements, see [Field Requirements Reference](field-requirements-reference.md).

## Recommended reading

This document focuses on details in the digital receipt JSON structure. To simplify the understanding of the content of this document the following resources should be studied alongside:

- [Sample receipts](example-receipts.md)
- [Json schema and definition files](retail-schema-content.md)
- [Chapter 7.1, required receipt content according to Swedish tax authories](https://www4.skatteverket.se/download/18.71e5c03417f5a7815e81e74/1647357497170/SKVFS%202014%209.pdf)

## Scope

This document focuses on the construction and content of the digital receipt. It does not describe how the receipt is transferred from the issuer to the customer and how it is presented.

## Troubleshooting
Try the receipt preview tool at [merchant-toolbox.kivra.com](https://merchant-toolbox.kivra.com/) to see exactly how your JSON payload will render in the Kivra web interface. 
This tool helps you validate your receipt structure and troubleshoot formatting issues.

## Terminology

### POS

POS - Point of Sales, the system creating and delivering receipts to the customer. The term POS in this document can be any system creating a digital receipt.

### JSON - JavaScript Object Notation

In computing, JavaScript Object Notation, [JSON](https://www.json.org/), is an open-standard file format that uses human-readable text to transmit data objects consisting of attribute–value pairs and array data types (or any other serializable value). [(Wikipedia)](https://en.wikipedia.org/wiki/JSON)

### JSON Schema

JSON Schema is a powerful tool for validating the structure of JSON data. [(Understanding JSON Schema)](https://json-schema.org/understanding-json-schema/)

## DRJSON

This section covers the digital receipt schema and their corresponding POS data terms where relevant. For more information see the documentation in the [JSON schema specification](../../../schemas/json/retail/v1.0.json).

Main properties of the digital receipt schema.

| Property | Requirement | Description |
|----------|-------------|-------------|
| `copy` | Optional | Whether this is a copy of the receipt |
| `business_unit` | **Required** | Merchant information |
| `cashier` | Optional | Operator/cashier information |
| `sales_recording_system` | **Required** | POS system information |
| `receipt_identifier` | **Required** | Receipt sequence number and optional extended number |
| `time_of_purchase` | **Required** | ISO 8601 timestamp |
| `currency` | **Required** | ISO 4217 currency code |
| `totals` | **Required** | Total amounts (net, gross, vat, paid, etc.) |
| `header_text` | Optional | Text displayed at top of receipt |
| `footer_text` | Optional | Text displayed at bottom of receipt |
| `items` | **Required** | List of sold/returned items |
| `retail_price_modifiers` | Optional | Receipt-level discounts |
| `payments` | **Required** | Payment/tender information |
| `customer` | Conditional | Customer identifier (see [Customer](#customer)) |
| `customer_order` | Optional | Order reference for linked receipts |
| `control_unit` | Conditional | Required when control unit is connected to POS |

The coming sections will describe each property in more detail.

### copy (Optional)

_copy_ (boolean), indicates if the digital receipt is a copy (value _true_) or an original (value _false_). Defaults to _false_ if omitted.

### business_unit (Required)

Information about the merchant.

**Required fields within `business_unit`:**
- `name` - Merchant/store name
- `service_id` - Store ID from Kivra (42 characters)
- `organization_number` - Swedish organisationsnummer
- `contact` - Contact information object

**Optional fields:**
- `unit_id` - Internal shop/business unit ID
- `geo_location` - Geographic coordinates (if provided, both `latitude` and `longitude` are required)

**`contact.address` requirements:**
- `locality` and `postal_code` are always required
- Either `street_address` OR `post_box` must be provided (not both required)

Example:

```json
{
  "business_unit": {
    "service_id": "15594097555922f97bfeb148d6b9a6ef76f76ebdce",
    "organization_number": "112233-4444",
    "name": "My store",
    "contact": {
      "address": {
        "street_address": "Merchant street",
        "locality": "Town",
        "postal_code": "11111"
      },
      "phone": "+4601122334455"
    }
  }
}
```

- _service_id_: The id given to the store when it is created in the Kivra Digital Receipt Platform.
- _organization_number_: The merchant [_organisationsnummer_](https://sv.wikipedia.org/wiki/Organisationsnummer)

### cashier (Optional)

Information about the operator. All fields within `cashier` are optional.

Example:

```json
{
  "cashier": {
    "id": "5",
    "name": "Anna Andersson"
  }
}
```

### sales_recording_system (Required)

Identifies the system (POS/ECR) creating the receipt.

**Conditional requirement:** At least one of `id` or `name` must be provided.

**Available fields:**
- `id` - System identifier (required if `name` not provided)
- `name` - System name (required if `id` not provided)
- `serial_number` - Optional serial number

Example:

```json
{
  "sales_recording_system": {
    "serial_number": "EA38329",
    "name": "kassa 3",
    "id": "k3"
  }
}
```

### receipt_identifier (Required)

**Required fields:**
- `sequence_number` - Receipt sequence number (required by Swedish fiscal law)

**Optional fields:**
- `extended_number` - Extended receipt identifier for unique identification

**If `extended_number` is provided, the following are required:**
- `extended_number.value` - The identifier value
- `extended_number.context` - Uniqueness context: `store`, `chain`, or `global`

The _sequence_number_ is a counter that is reset when it reaches a certain value making it non-unique.
The _extended_number_ can be used as a unique receipt identifier within a given _context_.
Supported contexts:

- store
- chain
- global

The _extended_number_ can be used as a receipt reference between related receipts. Example a sales and return receipt.

```json
{
  "receipt_identifier": {
    "sequence_number": 123456,
    "extended_number": {
      "value": "0123456123",
      "type": "EAN8",
      "context": "store"
    }
  }
}
```

### currency (Required)

The currency code for all amounts in the receipt, in [ISO-4217 format](https://en.wikipedia.org/wiki/ISO_4217) (e.g., "SEK", "EUR", "USD").

If a payment is done in a foreign currency, it is defined in the tender part.

Example:

```json
{
  "currency": "SEK"
}
```

### totals (Required)

An array of total amounts. Each total object requires:
- `type` - The total type (see below)
- `amount` - The amount value

**Total types:**

- _paid_: The amount the customer pays/hands over or is given in case of e.g. return of goods. The gross amount taking discount and rounding into account.
- _net_: Total including discounts, excluding vat, of all products/services bought/returned.
- _gross_: Total including vat, excluding discounts, of all products/services bought/returned.
- _vat_: The vat of all products/services bought/returned.
- _rounding_: If applicable (e.g. cash payment).
- _discount_: Total discount given customer.

Each total can have subtotals, example:

- _paid_: Example cash payment: You pay 46SEK (total/type: paid), you hand over a 50SEK bill (sub_total/type: received) and get 4SEK (sub_total/type: returned).
- _gross_: Can have sub*total/type \_eligible_for_frequent_shopper_points*
- _vat_: Different tax levels used depending on service/product bought. **Note!** _taxable_amount_ should be given including vat.
- _discount_: Discount given to loyalty customer, general discounts, etc.

All totals and subtotals have a _refund_ flag. If _refund: true_ the money goes to the customer, example return receipts. Default is _false_.

Example sales:

```json
{
  "totals": [
    {
      "type": "net",
      "amount": 41.10,
      "refund": false
    },
    {
      "type": "vat",
      "amount": 4.90,
      "refund": false,
      "sub_totals": [
        {
          "amount": 4.90,
          "taxable_amount": 46.0,
          "net_amount": 41.10,
          "tax_percentage": 12,
          "refund": false
        }
      ]
    },
    {
      "type": "gross",
      "amount": 66.0,
      "refund": false,
      "sub_totals": [
        {
          "type": "eligible_for_frequent_shopper_points",
          "amount": 60.0,
          "points": 20,
          "refund": false,
          "text": {
            "type": "array",
            "collection": ["Bonusgrundande belopp"]
          }
        }
      ]
    },
    {
      "type": "rounding",
      "amount": 0.0
    },
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
    },
    {
      "type": "discount",
      "amount": 20.0,
      "refund": true,
      "sub_totals": [
        {
          "amount": 13.0,
          "refund": true,
          "type": "loyalty"
        }
      ]
    }
  ]
}
```

Example return:

```json
{
  "totals": [
    {
      "type": "net",
      "refund": true,
      "amount": 19.64
    },
    {
      "type": "vat",
      "refund": true,
      "amount": 2.36,
      "sub_totals": [
        {
          "refund": true,
          "amount": 2.36,
          "taxable_amount": 22.0,
          "net_amount": 19.64,
          "tax_percentage": 12
        }
      ]
    },
    {
      "type": "gross",
      "refund": true,
      "amount": 22.0
    },
    {
      "type": "paid",
      "refund": true,
      "amount": 22.0
    }
  ]
}
```

### header_text (Optional)

Arbitrary text data that will be displayed at the top of the receipt.

**If provided, the following are required:**
- `type` - Must be `"array"`
- `collection` - Array of strings

Example:

```json
{
  "header_text": {
    "type": "array",
    "collection": [
      "Öppettider: Mådag - Fredag 10-18 Lördag 10-15",
      "Another header text line..."
    ]
  }
}
```

### footer_text (Optional)

Arbitrary text data that will be displayed at the bottom of the receipt.

**If provided, the following are required:**
- `type` - Must be `"array"`
- `collection` - Array of strings

Example:

```json
{
  "footer_text": {
    "type": "array",
    "collection": ["Sommarerbjudande: Rabatt på lagringsmedia."]
  }
}
```

### items (Required)

An array of items sold, returned, etc. Must contain at least one item.

**All items require:**
- `type` - Item type: `sale`, `return`, `text`, or `deposit`
- `sequence_number` - Unique sequence number (1, 2, 3, etc.)

The following item types are defined:

- _sale_: Properties to handle sold product/service
- _return_: Properties to handle returned product/service
- _text_: Text only item, example: product warranty text linked to item purchased
- _deposit_: For some products, example soda bottle, you pay an amount that is refunded when you return the bottle.

Each item type will be described in more detail below. For all details se the json schema.
Generic for all items is the _sequence_number_. It starts at "1" and is incremented by one for each item added.

#### sale item

**Required fields for sale items:**
- `type` - Must be `"sale"`
- `identifiers` - At least one identifier (see below)
- `description` - Item description
- `quantity` - Object with `value` and `unit` (both required)
- `sequence_number` - Unique sequence number
- `actual_sales_unit_price` - Final unit price after discounts
- `extended_amount` - Total amount for this line item
- `extended_gross_amount` - Total amount before discounts

**Optional fields:**
- `regular_sales_unit_price`, `unit_cost_price`, `tax_percentage`, `tax_amount`, `retail_price_modifiers`, `eligible_for_frequent_shopper_points`, etc.

Example

```json
{
  "type": "sale",
  "identifiers": [
    {
      "identifier_type": "pos",
      "value": "912042"
    }
  ],
  "eligible_for_frequent_shopper_points": true,
  "description": "Kingston USB Flash Drive 8 GB",
  "quantity": {
    "value": 1,
    "entry_method": "scanned",
    "unit": "ea"
  },
  "regular_sales_unit_price": 145,
  "extended_gross_amount": 145,
  "retail_price_modifiers": [
    {
      "amount": 45
    }
  ],
  "actual_sales_unit_price": 100,
  "extended_amount": 100,
  "tax_percentage": 25,
  "sequence_number": 1
}
```

Each sale/return item must have at least one identifier.
Supported identifier types:

- _pos_: An item identifier registered in the POS.
- _gtin_: [Global Trade Item Number by GS1](https://en.wikipedia.org/wiki/Global_Trade_Item_Number)

Item description:

- _description_: Textual description of item sold.

Item quantity:

- _value_: The quantity sold
- _unit_: In what unit is the quantity given? Default is _ea_ (each), supported types, [see schema](../../../schemas/json/retail/v1.0.json).
- _entry_method_: How is the item registered? Default is _scanned_, supported methods, [see schema](../../../schemas/json/retail/v1.0.json).

Amounts:

- _unit_cost_price_: The unit cost of the item to the merchant at the time of the transaction.
- _regular_sales_unit_price_: The per-unit price for the item/service before any discounts or surcharges have been applied.
- _extended_gross_amount_: The total amount the items/service sales for excluding discounts. regular_sales_unit_price times quantity.
- _actual_sales_unit_price_: The amount a single item sold for taking into account discounts and surcharges. The amount charged the customer (extended_amount) takes into account this price times quantity.
- _extended_amount_: The actual amount this item sells for. It is the actual_sales_unit_price times the quantity taking into account any retail price modifiers.

VAT:

- _tax_percentage_: Taxation rate of given product/service
- _tax_amount_: Tax amount applied. extended_amount times tax_percentage

Discount/price modifier:

- _retail_price_modifiers_: In it's simplest form the _retail_price_modifier_ is a discount amount given. For all details, [see schema](../../../schemas/json/retail/v1.0.json).

#### return item

**Required fields for return items:**
- Same as sale items, plus `type` must be `"return"`

**Optional fields:**
- `receipt_reference` - Reference to original sale receipt (if provided, both `value` and `context` are required)

Example

```json
{
  "type": "return",
  "identifiers": [
    {
      "identifier_type": "pos",
      "value": "912042"
    }
  ],
  "description": "Kingston USB Flash Drive 8 GB",
  "quantity": {
    "value": 1,
    "entry_method": "scanned",
    "unit": "ea"
  },
  "unit_cost_price": 145,
  "extended_gross_amount": 145,
  "retail_price_modifiers": [
    {
      "amount": 45
    }
  ],
  "actual_sales_unit_price": 100,
  "extended_amount": 100,
  "tax_percentage": 25,
  "sequence_number": 1,
  "receipt_reference": {
    "value": "0123456123",
    "context": "store"
  }
}
```

A sale and return item contain the same data except for the _receipt_reference_:

- _value_: A reference to the sale receipt. Usually the _extended_number_, part of the _receipt_identifier_ described above.
- _context_: In what context is the value unique? Supported contexts: _store_, _chain_, _global_

The _value_ and _context_ makes it possible to link a sale and return receipt.
If _receipt_reference_ is missing the return receipt will be "standalone" without connection to the sale receipt.

#### deposit item

Amount to get or pay connected to other items sold/returned.

**Required fields for deposit items:**
- `type` - Must be `"deposit"`
- `amount` - The deposit amount
- `sequence_number` - Unique sequence number

**Optional fields:**
- `unit_amount`, `quantity`, `refund`, `tax_percentage`, `item_link`, `text`, `sub_deposits`

Example:

```json
{
  "type": "deposit",
  "amount": 6.0,
  "unit_amount": 2.0,
  "quantity": 3,
  "refund": false,
  "sequence_number": 4,
  "item_link": 3,
  "text": {
    "type": "array",
    "collection": ["+ Pant       3*2,00"]
  }
}
```

- _amount_: The deposit amount to pay or get.
- _unit_amount_: The deposit amount to pay or get for each unit.
- _quantity_: Number of units deposited.
- _refund_: If _true_ money goes to the customer, if _false_ customer pays amount given.
- _tax_percentage_: Taxation rate of deposit.
- _item_link_: Deposit is connected to the item(s) with _sequence_number_.
- _text_: Any textual description if applicable.

Example of a deposit refund with different tax levels on the returned material.

```json
{
  "type": "deposit",
  "description": "Pantretur",
  "quantity": 1,
  "sequence_number": 7,
  "sub_deposits": [
    {
      "amount": 3.0,
      "refund": true,
      "tax_percentage": 12.0
    },
    {
      "amount": 25.0,
      "refund": true,
      "tax_percentage": 25.0
    }
  ],
  "amount": 28.0,
  "refund": true,
  "unit_amount": 28.0
}
```

#### text only item

Use when any text is needed in the item list.

**Required fields for text items:**
- `type` - Must be `"text"`
- `text` - Object with `type` (must be `"array"`) and `collection` (array of strings)
- `sequence_number` - Unique sequence number

Example:

```json
{
  "type": "text",
  "text": {
    "type": "array",
    "collection": ["SJÄLVBETJÄNINGSKUND"]
  },
  "sequence_number": 1
}
```

### retail_price_modifiers (Optional)

Receipt-level price modifiers (discounts, surcharges). Can also be defined at the item level.

**Required fields for each modifier:**
- `amount` - The modifier amount

**Optional fields:**
- `percent`, `unit_amount`, `quantity`, `action` (default: `"subtract"`), `tax_percentage`, `item_links`, `description`

One or more _retail_price_modifiers_ can be connected to a single item as shown above. It can also be connected to a collection of items or be a _generic price modifier_. Example:

```json
{
  "retail_price_modifiers": [
    {
      "amount": 35.0,
      "percent": 10,
      "description": {
        "type": "array",
        "collection": ["10% of, todays special"]
      }
    },
    {
      "amount": 20.0,
      "action": "subtract",
      "description": {
        "type": "array",
        "collection": ["3 läsk betala för 2"]
      },
      "item_links": [1, 3, 5]
    }
  ]
}
```

The first modifier gives discount (percentage), of total receipt amount.
The second modifier gives a quantity based discount on certains products bought.

- _amount_: The total amount to subtract, add or replace dependent on action.
- _percent_: If the modifier is based on percentage.
- _unit_amount_: If modifier is applied several times (quantity) this gives the amount for each modifier.
- _quantity_: Number of times the modifier is applied.
- _action_: One of: _subtract, add, replace_.
- _tax_percentage_: If the modifier has another tax percentage than the item/service amount it affects.
- _item_links_: Modifier is connected to the item(s) with _sequence_number_ equal to the values in _item_link_.
- _description_: Any textual description if applicable.

### payments (Required)

An array of payment/tender objects. Must contain at least one payment.

**Required fields for each payment:**
- `tender` - Object with `type` field (see tender types below)
- `amount` - The payment amount

**Optional fields:**
- `amount_applied_to_bill`, `foreign_currency_amount`, `rounding`, `refund`

This section covers supported payment/tender types. All payments have following properties:

- _amount_: The amount given by the customer.
- _amount_applied_to_bill_: The amount applied to the transaction total.
- _foreign_currency_amount_: If a currency other than the receipt currency is used.
- _rounding_: If applicable on cash payments.
- _refund_: _true_ If the money goes to the customer, _false_ if the customer pays (default).

#### tender cash

Example, customer uses a 100 SEK note to pay a 55.50 SEK bill with _rounding_ and _refund_.

```json
{
  "payments": [
    {
      "tender": {
        "type": "cash"
      },
      "amount": 100.0,
      "amount_applied_to_bill": 55.5,
      "rounding": 0.5
    },
    {
      "tender": {
        "type": "cash"
      },
      "refund": true,
      "amount": 44.0
    }
  ]
}
```

#### tender-creditdebit

Payment is done using a credit/debit card.
Additional properties:

- _card_token_: If a card token is used to identify the customer. Use `"scheme": "par"` for PAR token.
- _payment_slip_: Information from the card terminal represented as an array of strings.

If possible, the follwowing [ISO 8583](https://en.wikipedia.org/wiki/ISO_8583) fields should be added to the tender:

- _bank_identification_number_: Masked card number
- _retrieval_reference_number_: Field 37
- _card_acceptor_terminal_id_: Field 41
- _merchant_identifier_: Field 42

Example, card payment.

```json
{
  "payments": [
    {
      "amount": 24.99,
      "amount_applied_to_bill": 24.99,
      "tender": {
        "type": "creditdebit",
        "card_token": {
            "value": "0bbe7c68d1b5536ee5b1ef221816817d321dc1bff61c377b383bbfbd1b4bf17c",
            "scheme": "kivra"
        },
        "payment_slip": {
          "type": "array",
          "collection": [
            "MyStore",
            "",
            "MyStore",
            "Street 49",
            "111 11 City",
            "",
            "Org. nr: 112233-4444",
            "",
            "",
            "Butiksnr: 33",
            "Termid: 13848718",
            "Kassörsnr: 1-Jan",
            "Thu 23 May 2019      11:09",
            "...",
            "...",
            "TSI: E800",
            ""
          ]
        },
        "approval_code": "123456",
        "bank_identification_number": "527500**********",
        "retrieval_reference_number": "996933866525",
        "card_acceptor_terminal_id": "13848718",
        "merchant_identifier": "8056101"
      }
    }
  ]
}
```

#### tender giftcard

Example

```json
{
  "payments": [
    {
      "tender": {
        "type": "giftcard",
        "card_number": "527500******7651",
        "expiration_date": "2018-12-31",
        "initial_balance": 1000.0,
        "current_balance": 503.0
      },
      "amount": 503.0,
      "amount_applied_to_bill": 503.0
    }
  ]
}
```

Additional properties:

- _card_number_: Gift card number.
- _date_sold_: Date when giftcard was sold.
- _date_activated_: Date when giftcard is activated.
- _expiration_date_: Date when giftcard exires.
- _initial_balance_: Gift card initial balance.
- _current_balance_: Gift card current balance.

#### tender mobile

All mobile payments uses _tender mobile_. Mobile payment provider must be given (_provider_). The only provider supported at the moment is 'swish'.

Additional properties:

- _provider_: Payment provider.
- _phone_: Customer phone number.
- _tender_details_: Information from the payment provider.

Example, swish payment:

```json
{
  "payments": [
    {
      "tender": {
        "type": "mobile",
        "phone": "+467211234567",
        "provider": "swish:pay",
        "tender_details": {
          "type": "map",
          "collection": {
            "id": "AB23D7406ECE4542A80152D909EF9F6B",
            "payeePaymentReference": "0123456789",
            "paymentReference": "6D6CD7406ECE4542A80152D909EF9F6B",
            "callbackUrl": "https://example.com/api/swishcb/paymentrequests",
            "payerAlias": "07211234567",
            "payeeAlias": "1231234567890",
            "amount": "100",
            "currency": "SEK",
            "message": "Kingston USB Flash Drive 8 GB",
            "status": "PAID",
            "dateCreated": "2015-02-19T22:01:53+01:00",
            "datePaid": "2015-02-19T22:03:53+01:00"
          }
        }
      },
      "amount_applied_to_bill": 100.0,
      "amount": 100.0
    }
  ]
}
```

#### tender coupon

Some coupons can be used as a payment, some are just a discount connected to a product/service bought.

Additional properties:

- _name_: Any textual coupon description.
- _coupon_code_: If applicable, otherwise use "".
- _coupon_value_: The value of the coupon when redeemed.

```json
{
  "payments": [
    {
      "amount": 3.0,
      "amount_applied_to_bill": 3.0,
      "tender": {
        "type": "coupon",
        "name": "LÄKEROL 3:-",
        "coupon_code": "",
        "coupon_value": 3.0
      }
    }
  ]
}
```

#### tender loyalty

Customer pays with bonus check, redeems loyalty points.

Additional properties:

- _loyalty_program_: The name of the loyalty program.
- _points_redeemed_: The number of loyalty points redeemed by the customer.
- _amount_redeemed_: The amount redeemed by the customer.

You can use _points_redeemed_ and/or _amount_redeemed_.

```json
{
    "payments": [
        {
          "tender": {
            "type": "loyalty",
            "loyalty_program": "my club",
            "points_redeemed": 6400,
            "amount_redeemed": 350.00
          },
          ...
        }
    ]
}
```

#### tender other

Use if none of the supported tender types in the schema fullfills your needs.

- _type_name_: Your name of the tender type.
- _tender_details_: Information from the payment provider.
- _barcode_: barcode representation of tender info if needed.

You can use _points_redeemed_ and/or _amount_redeemed_.

```json
{
    "payments": [
        "tender": {
          "type": "other",
          "type_name": "KLARNA",
          "tender_details": {
            "type": "array",
            "collection": [
              "Butiksnr:  8708",
              "Fakturanr: 2222 3333 4444 5555",
              "Kund Idnr: 12334454545"
            ],
            "barcode": {
              "value": "$EPAY${\"Butiknr\": \"8708\",\"Faktnr\": \"2222333344445555\"}",
              "type": "QRCode"
            }
          }
        },
        "amount": 488.00,
        "amount_applied_to_bill": 488.00
      }
    ]
}
```

### customer (Conditional)

Contains information about the customer.

**When is `customer` required?**
- Required when you need to identify the receipt recipient
- **NOT required** if using a card token for identification (see [tender creditdebit](#tender-creditdebit))
- **NOT required** for greenbin receipts (anonymous/retained receipts)

**If `customer` is provided:**
- `id` object is required with at least one identifier type

**Optional fields:**
- `contact` - Customer contact information (email, phone, address)

NOTE: The customer property is not needed if a credit/debit card token is used to identify the customer. In that case the token information is added to the [tender part](#tender-creditdebit).

Supported id types:

- _civic_registration_number_
- _email_
- _phone_
- _loyalty_

[See schema](../../../schemas/json/retail/v1.0.json) for more details.

Example:

```json
{
  "customer": {
    "id": {
        "civic_registration_number": "190002021111"
    },
    "contact": {
      "email": "your@email.com",
      "phone": "+46-111-111-1111"
    }
}
```

### customer_order (Optional)

One or more receipts can be connected via an order number/reference. This is common in the travel sector where you might get one receipt for the main booking/order and additional receipts for add-on services and/or changes.

**Fields (use one or the other):**
- `order_number` - For the main order/booking receipt
- `order_reference` - For add-on/related receipts linking to an existing order
The receipts will be connected based on:

- Order number/reference
- Receipt issuer
- Customer

Example: Receipt connected to main order/booking, using _order_number_:

```json
{
  "customer_order": {
    "order_number": "BLX4948Z"
  }
}
```

Example: Receipt connected to _add on service_ on existing order/booking, using _order_reference_:

```json
{
  "customer_order": {
    "order_reference": "BLX4948Z"
  }
}
```

### control_unit (Conditional)

**When is `control_unit` required?**
- Required when a control unit (Swedish: kontrollenhet) is connected to the POS system
- Not required if no control unit is used

**Required fields (when `control_unit` is provided):**
- `id` - Control unit identifier
- `code` - Control unit code/signature

Example:

```json
{
  "control_unit": {
    "id": "RIHTT102710007088",
    "code": "BGXOV2QOHHILXHLPHHXRAYZEKGFNC2BD;"
  }
}
```
