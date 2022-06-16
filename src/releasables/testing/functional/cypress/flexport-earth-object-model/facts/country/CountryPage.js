export default class CountriesPage {
    static path = 'facts/country';

    getNumberOfSeaports() {
        return cy.get('#number-of-seaports').invoke('text').then(parseFloat);
    }
}