/// <reference types="cypress" />

import { gotoCountriesPage, CountriesPage } from 'flexport-earth-object-model/facts/countries/CountriesPage'

describe('Countries Page', () => {
  let countriesPage: CountriesPage;

  beforeEach(() => {
    countriesPage = gotoCountriesPage();
  })

  it('Lists Countries', () => {
    countriesPage
      .getBody()
        .contains('United States');
  })
})
