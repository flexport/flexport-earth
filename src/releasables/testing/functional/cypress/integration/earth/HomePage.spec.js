/// <reference types="cypress" />

import {gotoHomePage} from '../../flexport-earth-object-model/HomePage'

describe('Earth Homepage', () => {
  let homePage;

  beforeEach(() => {
    homePage = gotoHomePage();
  })

  it('Displays the Homepage', () => {
    homePage
      .getBody()
        .contains("Discover the world of supply chain");
  })

  it('Links to flexport.com', () => {
    homePage
      .getHeader()
        .getFlexportLogo()
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
})
