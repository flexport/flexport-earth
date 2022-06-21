/// <reference types="cypress" />

import { gotoHomePage } from '../../../../../flexport-earth-object-model/HomePage'
import AllPortsPage from     '../../../../../flexport-earth-object-model/facts/places/ports/AllPortsPage'
import PortPage from         '../../../../../flexport-earth-object-model/facts/places/port/PortPage'

describe('Port', () => {
  it('Can navigate to a port from the Homepage', () => {
    let homePage = gotoHomePage();

    homePage
      .getAllPortsLink()
        .click();

      cy
        .url()
        .should('contain', AllPortsPage.path)

      let allPortsPage = new AllPortsPage();

      const sanDiegoPortUnLoCode = 'USSAN';

      allPortsPage
        .getPortLink(sanDiegoPortUnLoCode)
          .click();

      cy
        .url()
        .should('contain', PortPage.path)
  })
})
