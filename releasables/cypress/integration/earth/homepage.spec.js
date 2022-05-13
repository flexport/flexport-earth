/// <reference types="cypress" />

import HomePage      from '../../flexport-earth-object-model/HomePage'
import CountriesPage from '../../flexport-earth-object-model/facts/countries/CountriesPage'

describe('Earth Homepage', () => {
  let homePage;

  beforeEach(() => {
    cy
      .visit(Cypress.env('EARTH_WEBSITE_URL'))

    homePage = new HomePage();
  })

  it('Displays the Homepage', () => {
    homePage
      .getBody()
        .contains("Discover the world of supply chain");
  })

  it('Links to flexport.com', () => {
    homePage
      .getHeader()
        .FlexportLogo
          .click();

    cy
      .url()
      .should('eq', 'https://www.flexport.com/');
  })

  it('Shows correct build number', () => {
    homePage
      .getFooter()
        .BuildNumber.then($els => {
          // get Window reference from element
          const win = $els[0].ownerDocument.defaultView
          // use getComputedStyle to read the pseudo selector
          const before = win.getComputedStyle($els[0], 'before')
          // read the value of the `content` CSS property
          const contentValue = before.getPropertyValue('content')
          // the returned value will have double quotes around it, but this is correct
          expect(contentValue).to.eq('"' + Cypress.env('BUILD_NUMBER') + '"')
        })
  })

  it('Links to Countries', () => {
    homePage
      .getCountriesLink()
        .click();

    cy
      .url()
      .should('contain', CountriesPage.path)
  })
})
