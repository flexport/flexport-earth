# Testing

## Unit Testing

We use Cypress.io for unit testing frontend code.

### Guidance

Keep your unit tests next to the code that they test.

See the [Breadcrumbs UI Component](/src/website-content/components/breadcrumbs) as an example:

```
/src/website-content/components/breadcrumbs/
- ...
- breadcrumbs.tsx
- breadcrumbs.unit-test.cy.ts
- ...
```

## Manual Testing

### Call the Ports Flexort API

```
~/git/flexport-earth> ./dev/tools/flexport-api/get-ports.ps1 | ConvertTo-Json

{
  "next": "/places/ports?types=SEAPORT&cursor=MjA=&per=20",
  "total": 4444,
  "data": [
    {
      "port_ref": "@{id=62858d43585d96428aa6c709; link=https://api.flexport.com/places/ports/62858d43585d96428aa6c709; ref_type=Port}",
      "name": "ARRECIFE DE LANZAROTE",
    ...
}
```
