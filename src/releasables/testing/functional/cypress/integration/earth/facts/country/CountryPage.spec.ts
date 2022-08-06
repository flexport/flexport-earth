/// <reference types="cypress" />

import { gotoCountryPage, CountryPage } from '../../../../flexport-earth-object-model/facts/country/CountryPage'

describe('Country Page', () => {
  let countryPage: CountryPage;

  beforeEach(() => {
    countryPage = gotoCountryPage('US');
  })

  it('Shows number of Seaports', () => {
    countryPage
      .getNumberOfSeaports().should('be.gt', 0);
  })
})
