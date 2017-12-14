---
title: Kivra Integration Reference

language_tabs:
  - shell: cURL

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>

includes:
  - tenantusers
  - paciolipayments

search: true
---

# Introduction

Welcome to the Kivra Integration Reference! Get familiar with the Kivra Integraion products and explore their features:

# The service
Kivra is a secure digital mailbox tied to your social security number or VAT-number to which you receive documents from companies, organizations and government agencies that are connected to Kivra. With Kivra you can receive, manage and archive your content wherever you are and on every platform as long as you have an internet connection.

Over one billion window envelopes are sent every year in Sweden alone, so by choosing to use Kivra you contribute to a reduced carbon footprint!

Kivra acts as a digital postman between Sender and Recipients which is also reflected in the allocation of responsibilities. Concretely, this means that the Sender is responsible for the design and content whereas Recipients are responsible for reading and processing the received content.

# Tenant Users

## Get accepting users

```shell
curl "http://api.kivra.com/v1/tenant/${TENANT_KEY}/users" \
    -H "Authorization: token ${API_TOKEN}"
```


> The above command returns JSON structured like this:

```json
[
  {"key": "some_key", "ssn": "some_ssn"},
  {"key": "another_key", "ssn": "another_ssn"}
]
```

This endpoint retrieves all users that accepts the tenant as a sender.

### HTTP Request

`GET http://api.kivra.com/v1/tenant/${TENANT_KEY}/users`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
reject | false | If set to true, the result will contain all users that rejects the tenant
ssn | null | If set, the result will include only the user with the ssn provided. An empty response indicates that the user doesn't exist in Kivra or that the tenant isn't accepted as a sender.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>
