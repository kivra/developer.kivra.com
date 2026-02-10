# POS API

## Version 1.3.18

### New

Release of retail/v1.1

## Version 1.3.17 (2025-05-15)

### Fix

- Added cardtoken as a identifier type

## Version 1.3.16 (2025-03-11)

### New

- Added prescription specification api

## Version 1.3.15 (2025-01-03)

### Fix

- Updated error responses

## Version 1.3.14 (2022-09-21)

### New

- New endpoints:
  - list chains connected to a partner
  - list stores connected to a chain.

## Version 1.3.13 (2022-06-30)

### Fix

- Fixed some small bugs and partly rewritten ingres.

## Version 1.3.12 (2020-05-05)

### Fix

- Fixed a bug where user sync incorrectly handled an user change event.

## Version 1.3.3 (2020-04-15)

### New

- Added functionality to upload icons and logos when creating/updating chains/stores

### Fix

- Fix a bug where missing receipt identifier was not handled correctly

## Version 1.1.0 (2020-02-03)

### New

- Updated error handling and error responses

### Fix

## Version 1.0.0 (2020-02-03)

### New

- added endpoint for getting GDPR information for a person (lists GDPR relevant information for all the persons receipts)
- Add an endpoint to de-register a person from expense management system `POST /expense/person/deregister`
- Add an endpoint to "unexpense" an expensed receipt `DELETE /expense/receipts/:receiptID`

### Fix

## Version 0.13.4 (2020-01-30)

### New

- add an endpoint to start authorisation process

### Fix

- update schema for ems

## Version 0.13.3 (2020-01-29)

### New

- Partner is now required to specify chainID when checking if user exists

## Version 0.12.1 (2019-12-18)

### New

- Updated to latest json schema. See schema changelog for more detail

### Fix

- Added owner_id to get store documentation

## Version 0.12.0 (2019-12-11)

### New

- Partner is now allowed to create stores using partner token
- Partner is now allowed to fetch stores using partner token
- Partner is now allowed to fetch receipts using partner token
- Updated to the RC2 schema, see json schema changelog

### Fix

- Fixed a bug where receipt couldn't be sent in with receipt identifier context "chain"

## Version 0.11.0 (2019-11-27)

### FIX

- Fixed a bug where `external_id` is called `store_id` when fetching store
- Fixed a bug where address where returned as null when fetching store

## Version 0.10 (2019-11-13)

### New

- Added endpoints to register expense management systems and to register persons for expense management systems
  - POST /dr/v1/expense/register
  - POST /dr/v1/expense/person
- Add store now supports ExternalID as store identifier
- Added get store endpoints
  - GET /dr/v1/stores
  - GET /dr/v1/stores/{storeID}

## Version 0.8 (2019-10-02)

### FIX

- Fixed a bug where fetching the receipt returned an error

## Version 0.7 (2019-10-02)

### New

- When creating a JSON receipt the schema version has to be sent in the content-type
  - application/json; profile=<https://se.digitalreceipts.net/schemas/json/retail/{Schema-Version}>
  - See documentation for available versions

## Version 0.6 (2019-09-18)

### New

- Added endpoint to update stores/chains
  - PUT /dr/v1/stores/:storeID
  - PUT /dr/v1/chains/:chainID

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

- Address is now optional when creating a new store/chain.
  - When determining if a new store/chain is being created or if it already exists we only compare VAT and Name to existing stores.

### Fix

- Fix error that occurred when a new chain/store was created without a city in the address
