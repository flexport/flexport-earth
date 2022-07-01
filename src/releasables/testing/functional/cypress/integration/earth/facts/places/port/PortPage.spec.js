/// <reference types="cypress" />

import { gotoHomePage }               from '../../../../../flexport-earth-object-model/HomePage'
import ListCountriesAndPortCountsPage from  '../../../../../flexport-earth-object-model/facts/places/ports/ListCountriesAndPortCountsPage'
import PortsByCountryPage             from  '../../../../../flexport-earth-object-model/facts/places/ports/PortsByCountryPage'
import PortPage                       from  '../../../../../flexport-earth-object-model/facts/places/port/PortPage'

describe('Port', () => {
  it('Can navigate to a port from the Homepage', () => {
    gotoHomePage()
      .getAllPortsLink()
        .click();

      new ListCountriesAndPortCountsPage()
        .getCountryPortsLink('US')
          .click();

      const sanDiegoPortUnLoCode = 'USSAN';

      new PortsByCountryPage()
        .getPortLink(sanDiegoPortUnLoCode)
          .click();

      new PortPage()
        .getBody()
          .contains('San Diego');
  })
})
