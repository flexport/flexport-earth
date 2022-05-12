/// <reference types="cypress" />

import CountriesPage from '../../../../flexport-earth-object-model/facts/countries/index'

describe('Countries Page', () => {
  let countriesPage;

  beforeEach(() => {
    cy
      .visit(Cypress.env('EARTH_WEBSITE_URL') + '/' + CountriesPage.path)

    countriesPage = new CountriesPage();
  })

  it('Lists Countries', () => {
    countriesPage
      .getBody()
        .contains('United States of America');
  })
})
