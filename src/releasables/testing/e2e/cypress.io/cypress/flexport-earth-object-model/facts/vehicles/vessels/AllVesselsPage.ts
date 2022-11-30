export default class AllPortsPage {
    static path = 'facts/vehicles/vessels';

    getVesselLink(mmsi: string) {
        return cy.get('#vessel-' + mmsi);
    }
}