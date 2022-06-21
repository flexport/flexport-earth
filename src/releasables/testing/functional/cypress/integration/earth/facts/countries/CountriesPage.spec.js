/// <reference types="cypress" />

import { gotoCountriesPage } from '../../../../flexport-earth-object-model/facts/countries/CountriesPage'

describe('Countries Page', () => {
  let countriesPage;

  beforeEach(() => {
    countriesPage = gotoCountriesPage();
  })

  it('Lists Countries', () => {
    countriesPage
      .getBody()
        .contains('United States');
  })
})
