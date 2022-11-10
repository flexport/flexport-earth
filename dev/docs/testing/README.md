# Testing

We currently support 2 kinds of automated testing:

1. UI Component Testing
2. End to End Testing

We use [Cypress.io](https://www.cypress.io) as the testing tool in both cases.

## UI Component Testing

We're following the [Cypress.io recommendations](https://docs.cypress.io/guides/core-concepts/testing-types#What-is-Component-Testing) on testing UI components in isolation.

These tests run automatically at build-time after a successful build of the NextJS website to quickly verify the behavior of the UI components without needing a full environment.

You can consider these to be UI unit tests.

### Guidance

Keep your component tests next to the code that they test.

See the [Breadcrumbs UI Component](/src/website-content/components/breadcrumbs) as an example:

```
/src/website-content/components/breadcrumbs/
- ...
- breadcrumbs.component-test.cy.tsx
- breadcrumbs.tsx
- ...
```

## End to End Testing

Unlike UI Component Tests, which run in isolation often with mocked dependencies, the [End to End tests](https://docs.cypress.io/guides/core-concepts/testing-types#What-is-E2E-Testing) rely on a live fully functional website.

These tests drive a web browser and use the website features just like a real user would.

Our E2E tests are hosted in a separate location from the website source code.

You can find them under `./src/releasables/testing/e2e`

Also unlike the UI Component Tests, as you can see, the E2E tests are "releasable". They accompany a release through the CI/CD deployment pipelines as they can be used post-deploymen to any environment to verify the website actually works.

They could also be used separate from deployments to be periodically executed against an environment, such as Production, as a way to monitor application health in an on-going basis.

You can execute the E2E tests against your local website via:

`./dev RunE2ETests`

Note: This requires having the website running locally in another console via:

`./dev StartWebsiteLocallyDevMode`

or

`./dev StartWebsiteLocallyProdMode`

## Manual Testing

### Call the Ports Flexport API

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
