/// <reference types="cypress" />

import {gotoHomePage} from '../../../../../flexport-earth-object-model/HomePage'
import AllVesselsPage from '../../../../../flexport-earth-object-model/facts/vehicles/vessels/AllVesselsPage'
import VesselPage from     '../../../../../flexport-earth-object-model/facts/vehicles/vessel/VesselPage'

describe('Vessel', () => {
  it('Can navigate to a vessel from the Homepage', () => {
    let homePage = gotoHomePage();

    homePage
      .getAllVesselsLink()
        .click();

    cy
      .url()
      .should('contain', AllVesselsPage.path);

    let allVesselsPage = new AllVesselsPage();

    const everGivenVesselMmsi = '353136000';

    allVesselsPage
      .getVesselLink(everGivenVesselMmsi)
        .click();

    cy
      .url()
      .should('contain', VesselPage.path)
  })
})
