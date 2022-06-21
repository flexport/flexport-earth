/// <reference types="cypress" />

import { gotoCountryPage } from '../../../../flexport-earth-object-model/facts/country/CountryPage'

describe('Country Page', () => {
  let countryPage;

  beforeEach(() => {
    countryPage = gotoCountryPage();
  })

  it('Shows number of Seaports', () => {
    countryPage
      .getNumberOfSeaports().should('be.gt', 0);
  })
})
