/// <reference types="cypress" />

import { gotoHomePage }               from  'flexport-earth-object-model/HomePage'
import ListCountriesAndPortCountsPage from  'flexport-earth-object-model/facts/places/ports/ListCountriesAndPortCountsPage'
import PortsByCountryPage             from  'flexport-earth-object-model/facts/places/ports/PortsByCountryPage'
import PortPage                       from  'flexport-earth-object-model/facts/places/port/PortPage'

import { TestData }                   from  'integration/earth/TestData';

describe('Terminal Detail Page', () => {
  it('Can view Terminal Details for a Valid Terminal', () => {
    // Step 1: Go to Homepage
    gotoHomePage()
      .getAllPortsLink()
        .click();

    // TODO: EARTH-257: REFACTOR:
    //       Refactor test page models to return subsequent models
    //       instead of tests having to new them up.

    // TODO: EARTH-257: REFACTOR:
    //       Simplify the flow, don't need to go through Port List page, use footer.

    // Step 2: Navigate to a Port that has Terminals
    new ListCountriesAndPortCountsPage()
        .getCountryPortsLink(TestData.Countries.ValidCountryCode)
            .click();

    new PortsByCountryPage()
      .getPortLink(TestData.Ports.ValidPortUnloCode)
        .click();

    // Step 3: Validate that the Ports Terminals Appear as expected
    new PortPage()
        .getBody()
            .contains(TestData.Terminals.ValidTerminalName);

    new PortPage()
        .getTerminalLink(TestData.Terminals.ValidTerminalCode)
            .click();
  })
})
