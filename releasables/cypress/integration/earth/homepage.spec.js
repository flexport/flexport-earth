/// <reference types="cypress" />

import HomePage from '../../flexport-earth-object-model/HomePage'

describe('Earth Homepage', () => {
  beforeEach(() => {
    cy.visit(Cypress.env('EARTH_WEBSITE_URL'))
  })

  it('Displays the Homepage', () => {
    cy.get('h1').should('contain', "Welcome to Earth");
  })

  it('Links to flexport.com', () => {
    new HomePage().getHeader().FlexportLogo.click();

    cy
      .url()
      .should('eq', 'https://www.flexport.com/');
  })

  it('Shows correct build number', () => {
    new HomePage().getFooter().BuildNumber
    .then($els => {
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
})
