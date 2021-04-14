# *_Example receipts_*
This document links to a number of example receipts and contains a short description of each receipt provided. The receipts are classified based on type (sale, return), payment method used, discounts, customer identification, etc. For details see description for each receipt.

## Sale receipts

### [Sale receipt one](example-receipts/min-sale-receipt-cash-payment.json)
Contains the basic elements of a sales receipt.

#### Characteristics
* **type**: sale
* **receipt identifier**: sequence number and extended number with barcode
* **items**: one
* **payment**: cash
* **customer identifier**: phone number
* **discount**: simple discount amount
* **others**: control unit information

### [Sale receipt two](example-receipts/min-sale-receipt-cash-payment-rpm.json)
Contains the basic elements of a sales receipt with volume based retail price modifier, deposit and bonus.

#### Characteristics
* **type**: sale
* **receipt identifier**: sequence number and extended number with barcode
* **items**: three
* **payment**: cash
* **customer identifier**: phone number
* **customer loyalty**: loyalty based discounts, loyalty information
* **discount**: volume discount and deposit
* **others**: control unit information

### [Sale receipt three](example-receipts/sale-receipt-card-payment.json)
Contains the basic elements of a sales receipt with credit/debit card payment.

#### Characteristics
* **type**: sale
* **receipt identifier**: sequence number and extended number with barcode
* **items**: two
* **payment**: debit/credit card (payment slip included)
* **customer identifier**: civic registration number
* **discount**: simple amount discount
* **others**: control unit information

## Return receipts
Return receipts are based on the same content as sale receipts. Instead of sale items they have return items and a reference to the sale receipt if possible. The sale receipt reference must be given a context, e.g. is the reference unique on store, chain or global level.

### [Return receipt one](example-receipts/min-return-receipt-cash-payment.json)
Contains the basic elements of a return receipt including *local* reference to a sales receipt.

#### Characteristics
* **type**: return
* **receipt identifier**: sequence number
* **items**: one
* **refund**: cash
* **customer identifier**: phone number
* **discount**: simple discount amount
* **sale receipt reference**: store
* **others**: control unit information

### [Return receipt two](example-receipts/min-return-receipt-cash-payment-sha.json)
Contains the basic elements of a return receipt including a *global* reference to a sales receipt.

#### Characteristics
* **type**: return
* **receipt identifier**: sequence number
* **items**: one
* **refund**: cash
* **customer identifier**: phone number
* **discount**: simple discount amount
* **sale receipt reference**: global
* **others**: control unit information
