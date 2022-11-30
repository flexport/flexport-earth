export default class PortsByCountryPage {
    static path = 'facts/places/ports';

    getPortLink(unlocode: string) {
        return cy.get('#port-' + unlocode);
    }
}
