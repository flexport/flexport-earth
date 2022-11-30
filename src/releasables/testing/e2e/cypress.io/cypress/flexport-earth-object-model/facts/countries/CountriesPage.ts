import {getBaseUrl} from '../../Base'

export function gotoCountriesPage() {
    cy
      .visit(getBaseUrl() + '/' + CountriesPage.path);

    return new CountriesPage();
}

export class CountriesPage {
    static path = 'facts/countries';

    getBody() {
        return cy.get('body');
    }
}