/// <reference types="cypress" />

import CountryPage from '../../../../flexport-earth-object-model/facts/country/CountryPage'

describe('Country Page', () => {
  let countryPage;

  beforeEach(() => {
    cy
      .visit(Cypress.env('EARTH_WEBSITE_URL') + '/' + CountryPage.path + '/US')

    countryPage = new CountryPage();
  })

  it('Shows number of Seaports', () => {
    countryPage
      .getNumberOfSeaports().should('be.gt', 0);
  })
})
