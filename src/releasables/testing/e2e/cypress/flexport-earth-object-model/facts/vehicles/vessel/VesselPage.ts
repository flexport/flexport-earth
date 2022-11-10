export default class VesselPage {
    static path = 'facts/vehicles/vessel/';

    getBody() {
        return cy.get('body');
    }
}