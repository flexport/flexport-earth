/// <reference types="cypress" />

import { gotoHomePage }               from  'flexport-earth-object-model/HomePage'
import ListCountriesAndPortCountsPage from  'flexport-earth-object-model/facts/places/ports/ListCountriesAndPortCountsPage'
import PortsByCountryPage             from  'flexport-earth-object-model/facts/places/ports/PortsByCountryPage'
import PortPage                       from  'flexport-earth-object-model/facts/places/port/PortPage'

// TODO: EARTH-257: REFACTOR:
//       Refactor test data into a central/reusable location.

const CountryCodeUnitedStates     = 'US';
const PortCanaveralName           = 'Port Canaveral';
const PortCanaveralUnLoCode       = 'USPCV';
const TerminalCanaveralChiwanName = 'CHIWAN CONTAINER TERMINAL (CCT)'

const ValidCountryCode  = CountryCodeUnitedStates;
const ValidCountryName  = PortCanaveralName;
const ValidPortUnloCode = PortCanaveralUnLoCode;

describe('Port', () => {
  it('Can navigate to a Valid Port from the Homepage', () => {
    gotoHomePage()
      .getAllPortsLink()
        .click();

      new ListCountriesAndPortCountsPage()
        .getCountryPortsLink(ValidCountryCode)
          .click();

      new PortsByCountryPage()
        .getPortLink(ValidPortUnloCode)
          .click();

      new PortPage()
        .getBody()
          .contains(ValidCountryName);
  })

  it('Can view Terminals for a Valid Port', () => {
    // Step 1: Go to Homepage
    gotoHomePage()
      .getAllPortsLink()
        .click();

    // TODO: EARTH-257: REFACTOR:
    //       Refactor test page models to return subsequent models
    //       instead of tests having to new them up.

    // Step 2: Navigate to a Port that has Terminals
    new ListCountriesAndPortCountsPage()
    .getCountryPortsLink(ValidCountryCode)
      .click();

    new PortsByCountryPage()
      .getPortLink(ValidPortUnloCode)
        .click();

    new PortPage()
      .getBody()
        .contains(ValidCountryName);

    // Step 3: Validate that the Ports Terminals Appear as expected
    new PortPage()
      .getBody()
        .contains(TerminalCanaveralChiwanName);
  })
})
