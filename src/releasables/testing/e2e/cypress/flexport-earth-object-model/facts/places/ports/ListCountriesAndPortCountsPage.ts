export default class ListCountriesAndPortCountsPage {
    static path = 'facts/places/ports';

    getCountryPortsLink(cca2CountryCode: string) {
        return cy.get('#country-' + cca2CountryCode);
    }
}