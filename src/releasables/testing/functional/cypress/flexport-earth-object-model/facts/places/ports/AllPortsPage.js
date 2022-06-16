export default class AllPortsPage {
    static path = 'facts/places/ports';

    getPortLink(unlocode) {
        return cy.get('#port-' + unlocode);
    }
}