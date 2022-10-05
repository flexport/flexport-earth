/// <reference types="cypress" />

import { gotoHomePage }               from '../../../../../flexport-earth-object-model/HomePage'
import ListCountriesAndPortCountsPage from  '../../../../../flexport-earth-object-model/facts/places/ports/ListCountriesAndPortCountsPage'
import PortsByCountryPage             from  '../../../../../flexport-earth-object-model/facts/places/ports/PortsByCountryPage'
import PortPage                       from  '../../../../../flexport-earth-object-model/facts/places/port/PortPage'

// TODO: EARTH-257: REFACTOR:
//       Refactor test data into a central/reusable location.

const CountryCodeUnitedStates                   = 'US';
const PortCanaveralName                         = 'Port Canaveral';
const PortCanaveralUnLoCode                     = 'USPCV';
const TerminalCanaveralCT2TerminalName          = 'CT2 Terminal'
const TerminalCanaveralCT2TerminalTerminalCode  = 'USPCV-CTT'

const ValidCountryCode  = CountryCodeUnitedStates;
const ValidCountryName  = PortCanaveralName;
const ValidPortUnloCode = PortCanaveralUnLoCode;
const ValidTerminalName = TerminalCanaveralCT2TerminalName;
const ValidTerminalCode = TerminalCanaveralCT2TerminalTerminalCode;

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
            .contains(ValidTerminalName);

    new PortPage()
        .getTerminalLink(ValidTerminalCode)
            .click();
  })
})
