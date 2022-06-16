/// <reference types="cypress" />

import HomePage      from '../../flexport-earth-object-model/HomePage'
import AllPortsPage from '../../flexport-earth-object-model/facts/places/ports/AllPortsPage'
import PortPage from '../../flexport-earth-object-model/facts/places/port/PortPage'

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

  it('Can navigate to a port', () => {
    homePage
      .getAllPortsLink()
        .click();

    cy
      .url()
      .should('contain', AllPortsPage.path)

    let allPortsPage = new AllPortsPage();

    allPortsPage
      .getPortLink('USSAN')
        .click();

    cy
      .url()
      .should('contain', PortPage.path)
  })
})
