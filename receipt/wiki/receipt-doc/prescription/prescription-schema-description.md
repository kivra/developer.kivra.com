# **_Kivra prescription specification explained_**

## Introduction
This document describes the different parts of Kivras prescription specification format. A prescription specification is issued by pharmacies and will be connected to a receipt in Kivra. 

The specification is based on discussions with different pharmacies and data from the Swedish eHealth Agency.

## Scope

This document focuses on the construction and content of the prescription specification. It does not cover:
- How the specification is transferred from the issuer to the customer.
- How it is presented in the Kivra app/web.
- Scenarios (e.g someone picks up medicals for another person (power of attorney))  

## Terminology

### POS

Point Of Sale (POS) is any system that creates a receipt. In this document POS is also used for the system creating and delivering prescription specifications to the customer.  In reality it could be a separate system.

### JSON - JavaScript Object Notation

In computing, JavaScript Object Notation, [JSON](https://www.json.org/), is an open-standard file format that uses human-readable text to transmit data objects consisting of attribute–value pairs and array data types (or any other serializable value). [(Wikipedia)](https://en.wikipedia.org/wiki/JSON)

### JSON Schema

JSON Schema is a powerful tool for validating the structure of JSON data. [(Understanding JSON Schema)](https://json-schema.org/understanding-json-schema/)

## Prescription specification - json

### Header

This part of the prescription specification contains the same information as the digital receipt so we have reused these properties from the Kivra digital receipt schema.  

- _business_unit_
- _cashier_
- _receipt_identifier_
- _time_of_purchase_
- _customer_

These properties are described in more detail [here](../retail/retail-schema-description.md)


### Expedition

As this part seems to differ a bit between different pharmacies we represent this part as an array of strings in the json specification. The “details” section is what is going to be visible to the user. The “id” is for internal use and exchange with other systems.

Examples:
```json
{
    "expedition": {
    "id": "T02 AAN631",
    "details": ["Inköp på expedition T02 AAN631"]
  }
}  
```

```json
{
   "expedition": {
    "id": "154789798A",
    "details": [
      "Inköp på recept 154789798A",
      "Läkare Kinhult Anna-Carin",
      "Läkare Winsö Katarina"
    ]
  }
}  
```

### Human or animal prescription
A prescription can be issued to an _animal_ or _human_. The data needed differs slightly based on the target.
#### Animal prescription
_animal_ has one property
- _id_: identifies the animal to whom the prescription is issued.
```json
{
  "animal": {
    "id":"Fido"
  }
}  
```

#### Medication list
The medication list is can be used on both animal and human prescriptions. This an animal example.
- _medications_:  a list of medications issued and cost.
```json
{
    "medications": [
      {
        "description":  "Metacam för hund och katt",
        "amount":  3050.00
      }
    ]
}  
```
#### Human prescription
_human_ has properties related to high cost reimbursement. These are given in three periods:
- _previous_period_
- _current_period_
- _next_period_

It can also contain 
- _amount_left_to_reimbursement_
which is not mandatory.

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
      },
      "amount_left_to_reimbursement": {
        "gross": 100.00,
        "net": 100.00
      }      
    }
  }
}  
```

### Amounts
The following amounts must be given on both _animal_ and _human_:
- _amount_without_benefit_ 
- _amount_to_pay_

_human_ has two additional amounts:
- _amount_with_benefit_
- _amount_paid_by_benefit_
as they are affected by high cost reimbursement. These amounts are usually the same but will differ in cases where insurances are involved.

Examples
_animal_
```json
{
  "amount_without_benefit": 3050.00,
  "amount_to_pay": 3050.00
}  
```


_human_
```json
{
  "amount_with_benefit": 58.27,
  "amount_without_benefit": 5.38,
  "amount_paid_by_benefit": 58.27,  
  "amount_to_pay": 5.38
}  
```
