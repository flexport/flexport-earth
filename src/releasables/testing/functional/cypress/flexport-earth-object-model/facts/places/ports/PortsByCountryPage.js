export default class PortsByCountryPage {
    static path = 'facts/places/ports';

    getPortLink(unlocode) {
        return cy.get('#port-' + unlocode);
    }
}
