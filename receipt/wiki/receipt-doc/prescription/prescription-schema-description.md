# **_RFC - Kivra prescription specification_**

## Introduction
This RFC describes a proposed way to handle prescription specifications issued by pharmacies which will be sent to Kivra and will be connected to a receipt. 

The specification is based on discussions with different pharmacies, printed examples of prescription specifications and some data from the Swedish eHealth Agency.

This RFC only covers prescription specification content, not scenarios (e.g someone picks up medicals for another person (power of attorney)).

## Scope

This document focuses on the construction and content of the prescription specification. It does not describe how the specification is transferred from the issuer to the customer and how it is presented.

## Terminology

### Sender System

The system creating and delivering prescription specifications to the customer. It can be the same system which creates the receipt (POS) but does not have to.

### JSON - JavaScript Object Notation

In computing, JavaScript Object Notation, [JSON](https://www.json.org/), is an open-standard file format that uses human-readable text to transmit data objects consisting of attribute–value pairs and array data types (or any other serializable value). [(Wikipedia)](https://en.wikipedia.org/wiki/JSON)

### JSON Schema

JSON Schema is a powerful tool for validating the structure of JSON data. [(Understanding JSON Schema)](https://json-schema.org/understanding-json-schema/)

## Json

### Header

This part of the prescription specification contains the same information as the digital receipt so we have reused these properties from the Kivra digital receipt schema.  

- _business_unit_
- _cashier_
- _receipt_identifier_
- _time_of_purchase_
- _customer_

These properties are described in more detail [here](../retail/retail-schema-description.md)


### Expedition

As this part seems to differ a bit between different pharmacies we  represent this part as an array of strings in the json specification.

Examples:
```json
{
  "expedition": [
    "Inköp på expedition T02 AAN631"
  ]
}  
```

```json
{
  "expedition": [
    "Inköp på recept 154789798A",
    "Läkare Kinhult Anna-Carin",
    "Läkare Winsö Katarina"
  ]
}  
```

### Animal prescription
_animal_ identifies to whom the prescription is issued and what medicals are issued.
```json
{
  "animal": {
    "id":"Fido",
    "medications": [
      {
        "description":  "Metacam för hund och katt",
        "amount":  3050.00
      }
    ]
  }
}  
```

### Human prescription
_human_ contains properties related to high cost reimbursement.

```json
{
  "human": {
    "high_cost": {
      "previous_period": {
        "gross": 0.0,
        "net": 0.0,
        "start_date": "2014-02-14T08:00:00+02:00"
      },
      "current_period": {
        "gross": 2116.80,
        "net": 2116.80,
        "start_date": "2015-02-14T08:00:00+02:00"
      },
      "next_period": {
        "gross": 0.0,
        "net": 0.0,
        "start_date": "2016-02-14T08:00:00+02:00"
      }
    }
  }
}  
```

### Amount
_amount_without_benefit_ and _amount_to_pay_ are given on both _animal_ and _human_ specifications. _amount_with_benefit_ is added to human specifications as they are affected by high cost reimbursement. 

Animal

Human

