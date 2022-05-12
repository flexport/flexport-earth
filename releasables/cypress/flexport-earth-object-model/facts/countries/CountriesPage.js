export default class CountriesPage {
    static path = 'facts/countries/index.html';

    getBody() {
        return cy.get('body');
    }
}