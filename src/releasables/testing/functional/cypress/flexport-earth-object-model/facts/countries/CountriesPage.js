export default class CountriesPage {
    static path = 'facts/countries';

    getBody() {
        return cy.get('body');
    }
}