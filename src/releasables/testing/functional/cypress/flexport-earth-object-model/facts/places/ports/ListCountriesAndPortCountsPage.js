export default class ListCountriesAndPortCountsPage {
    static path = 'facts/places/ports';

    getCountryPortsLink(cca2CountryCode) {
        return cy.get('#country-' + cca2CountryCode);
    }
}