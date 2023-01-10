/// <reference types="cypress" />

// NOTE:
// Tests in this fail will only work / pass when executed against
// an Earth website that is running in Azure as some of these tests
// depend on Azure infrastructure... Therefore, these tests will not work
// if you run them against your locally running Earth website.

describe('Requires Azure: Earth Website Alerts: Notify Earth Operators', () => {
  it('When a Website User encounters a HTTP 404 error', () => {
    // Arrange:
    const currentBuildNumber                          = Cypress.env('BUILD_NUMBER');
    const earthEnvironmentName                        = Cypress.env('EARTH_ENVIRONMENT_NAME');
    const earthWebsiteBaseUrl                         = Cypress.env('EARTH_WEBSITE_URL');
    const earthEnvironmentOperatorsEmailAddress       = Cypress.env('EARTH_ENV_OPS_EMAIL');
    const earthEnvironmentOperatorsGmailClientId      = Cypress.env('EARTH_ENV_OPS_GMAIL_CLIENT_ID');
    const earthEnvironmentOperatorsGmailClientSecret  = Cypress.env('EARTH_ENV_OPS_GMAIL_CLIENT_SECRET');
    const earthEnvironmentOperatorsGmailRefreshToken  = Cypress.env('EARTH_ENV_OPS_GMAIL_REFRESH_TOKEN');

    const gmailApiCredentials = {
      clientId:     earthEnvironmentOperatorsGmailClientId,
      clientSecret: earthEnvironmentOperatorsGmailClientSecret,
      refreshToken: earthEnvironmentOperatorsGmailRefreshToken
    };

    // Act:
    // Request invalid url from the website.
    // const response = await fetch(
    //   `${earthWebsiteBaseUrl}/website-alerts/test/404`
    // );

    const startTimestamp = Date.now();

    fetch(
      `https://${earthWebsiteBaseUrl}/website-alerts/test/404/build/${currentBuildNumber}`
    ).then(response => {
      assert(
        response.status == 404,
        "Expected a HTTP 404 response from the server."
      );
    });

    // Assert:
    // Verify alerts have been received in the Earth Environment Operator email.
    cy.log(`Checking for emails after ${new Date(startTimestamp)}`);

    cy
      .task("gmail:check", {
        gmailApiCredentials:  gmailApiCredentials,
        from:                 "azure-noreply@microsoft.com",
        to:                   earthEnvironmentOperatorsEmailAddress,
        subject:              `Azure: Activated Severity: 2 ${earthEnvironmentName} - Earth Website HTTP 404 Alert (${currentBuildNumber})`,
        after:                startTimestamp
      }, { timeout: 300000 })
      .then(email => {
        assert.isNotNull(email);
      });
  })
})

export {};
