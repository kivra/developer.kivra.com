# Client API

## Version 1.3.13 (2025-01-03)

## Fix

 - Updated error responses

## Version 1.3.12 (2020-05-05)

## New

- Added support for html rendering of return receipts.
- Sending receipts to users that have been blocked (offboarded, rejected) is now allowed for 1 day after blocking.
- Added "include" query parameter when listing chains for person.
  - GET /api/v1/persons/{personID}/chains"

## Fix

- Fixed a bug where a discount field was missing in the rendered html receipt.
- Fixed a bug where identifiers starting with n or t were incorrectly saved in database.
- Fixed a bug where user sync incorrectly handled an user change event.

## Version 1.3.4 (2020-04-30)

## New

- Added a new query parameter for list of chains `include=XXX` to list; activated chains that a person has
  receipts from; activated chains that a person and receipts from and all rejected chains; and all chains

## Removed

- Removed the `all` query parameter

## Version 1.3.3 (2020-04-15)

### New

- Added a flag to the list chains endpoint indicating if the chain is rejected or not
- Added a query parameter "all" to list chains endpoint determining if only chains with receipts should be listed or not
  - ?all=true, ?all=false
- Make sure that a soft deleted receipt can not be fetched if the expiration date has passed

## Version 1.3.1 (2020-04-07)

### New

- Added gift receipt endpoints
  - PUT `/api/v1/persons/:personID/gifted/receipts/:receiptID/claim`
  - GET `/api/v1/gifted/receipts/:receiptID`

### Fix

- Added `all` query parameter to `GET /api/v1/persons/:personID/chains` endpoint to allow fetching all chains
  for a person, not just chains where a user has receipts. The parameter defaults to `false`

## Version 1.3.0 (2020-03-30)

### New

- Added `is_rejected` flag to the response of get chains list for person endpoint
  - GET /api/v1/persons/:personID/chains

## Version 1.2.1 (2020-03-11)

### New

- Added `DELETE /api/v1/persons/:personID/receipts/:receiptID` endpoint

### Fix

- Added `days` query parameter to `DELETE /api/v1/persons/:personID` endpoint

## Version 1.0.0 (2020-02-03)

### New

- Added optional query parameter pdf417encoding to create barcode endpoint that controls the encoding level of PDF417 barcodes
  - GET /api/v1/barcode/:type/:value
  - Values between 1 and 8, default value is 3

## Version 0.13.4 (2020-01-29)

### New

- Added endpoint `POST /api/v1/persons/:personID/identifiers` to add identifier on a person
- Added endpoint `PUT /api/v1/persons/:personID/identifiers/:identifierID` to update identifier on a person
- Added endpoint `DELETE /api/v1/persons/:personID/identifiers/:identifierID` to delete identifier on a person

### Fix

- Move `/api/v1/persons/:personID/expense` to `/api/v1/persons/:personID/receipts/:receiptID/expense`
- Update schema to `POST /api/v1/persons/`
- Update schema for `GET /api/v1/persons/:personID`

## Version 0.13.1 (2020-01-22)

### New

- Add chain_id to response when fetching single receipt

### Fix

- PDF417 barcode encoding decresed to 4 for easier scanning
- Fixed a bug where receipt id was incorrectly generated from purchase date
- Fixed a bug where sending in no customer information in receipt was handled incorrectly

## Version 0.13.0 (2020-01-16)

### New

- Barcode can now be scaled to any size
- Added refund flag to list view
- IconURL is now returned as null if missing in expense endpoints

### Fix

- Fix bug where type was missing in subtotal
- Fix bug where extended_discount_amount was missing from the receipt

## Version 0.12.1 (2019-12-18)

### New

- Updated to latest json schema. See schema changelog for more detail

## Version 0.12.0 (2019-12-11)

### Fix

- Fixed a bug where refund flags dissappeared from RC2 receipts
- Fixed a bug where 500 was returned when search result was empty

## Version 0.11.0 (2019-11-27)

### New

- Added a global endpoint for fetching all expense management sustems
  - /api/v1/expense
- Added `icon_url` to list of expense management systems
- Updated default schema returned from "/api/v1/persons/{personID}/receipts/{receiptID}" to RC2. Schema can be changed using the accept header
  - Accept: application/json;profile=https://se.digitalreceipts.net/schemas/json/retail/v1.0-RC1
  - Accept: application/json;profile=https://se.digitalreceipts.net/schemas/json/retail/v1.0-RC2

## Version 0.10 (2019-11-13)

### New

- Expensing an already expensed receipt now returns with 409 (Conflict)
- Notification is now sent out when a gift receipt is created
- Receipt list now contains a new field `is_expensed`

### Fix

- Fixed a bug where icon URL was not returned

## Version 0.9 (2019-10-30)

### New

- Added gift receipt endpoint
  - PUT /api/v1/persons/:personID/receipts/:receiptID/gift
  - No notification is sent when a gift receipt is created
- Updated receipt list and single receipt responses to match new return requirements
  - /api/v1/persons/:personID/receipts/:receiptID
  - /api/v1/persons/:personID/receipts
  - /api/v1/persons/:personID/chains/:chainID/receipts

## Version 0.8 (2019-10-16)

### New

- Added better support for user management
  - Created person now accepts creating users ans ONBOARDED/OFFBOARDED
  - Added a new user offboard endpoint
  - Added a new user onboard endpoint
  - Deleting a user now permanetnly deletes the user and all its receipts
- Added new expense endpoints
  - Get a list of expense managment systems
  - Expense a receipt using expense management system

### Fix

- Fixed a bug where total number of chains reported was incorrect

## Version 0.7 (2019-10-02)

### New

- Added new endpoint that returns all chains with support for paging and search based on chain name
  - /api/v1/chains

### Fix

- Now able to search by store name

## Version 0.6 (2019-09-18)

### New

- Added search functionality to receipt list endpoints to search based on either store name or item description.
- Barcode generation now generates barcodes with fixed aspect ratio if only height or width is given. Added support for custom colors and aspect ratio through query parameters.
- Resource id's are now reresented as URL.
  - store_icon_id -> store_icon_url
  - icon_id -> icon_url
  - logo_id -> logo_url

### Fix

- Fixed issue where icon_url and logo_url where returned as an empty string instead of null

## Version 0.5 (2019-09-04)

### New

- Error response now contains an optional "error_detail" field. This field is only present if additional information needs to be given.

  ```json
  {
    "error_code": "10000",
    "error_message": "Example error",
    "error_detail": ["Extra detail related to the error"]
  }
  ```

- Added support for fetching soft deleted receipts. New boolean flag ("deleted") has been added to the response indicating if the receipt is deleted or not.
- Added endpoint to restore receipt flow for a chain if it had previously been rejected
  - PUT "/api/v1/persons/{personID}/chains/{chainID}/restore"
- Added search functionality when fetching list of receipts, the api has the following limitations

  - Only works with "/api/v1/persons/{personID}/receipts"
  - Does not return receipts correctly sorted
  - Returned results do not include related receipts

  ```
      /api/v1/persons/:personID/receipts?Limit=20&Offset=0&q=receipt.business_unit.name%3ADRP%20Store%202
  ```

### Fix

- Added minimum and maximum size restrictions to barcode generation (0, 4096].
- Return BadRequest instead of InternalServerError when trying to restore a receipt that hasn't been deleted.
- When trying to reject a chain that has already been rejected we now return 409 (Conflict).
