import {getBaseUrl} from '../../Base'

export function gotoCountryPage(cca2: string) {
    cy
        .visit(getBaseUrl() + '/' + CountryPage.path + '/' + cca2);

    return new CountryPage();
}

export class CountryPage {
    static path = 'facts/country';

    getNumberOfSeaports() {
        return cy.get('#number-of-seaports').invoke('text').then(parseFloat);
    }
}