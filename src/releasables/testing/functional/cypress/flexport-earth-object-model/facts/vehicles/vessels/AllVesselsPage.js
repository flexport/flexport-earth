export default class AllPortsPage {
    static path = 'facts/vehicles/vessels';

    getVesselLink(mmsi) {
        return cy.get('#vessel-' + mmsi);
    }
}