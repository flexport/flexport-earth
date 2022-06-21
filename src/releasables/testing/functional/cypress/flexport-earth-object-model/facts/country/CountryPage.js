import {getBaseUrl} from '../../Base'

export function gotoCountryPage() {
    cy
        .visit(getBaseUrl() + '/' + CountryPage.path + '/US');

    return new CountryPage();
}

class CountryPage {
    static path = 'facts/country';

    getNumberOfSeaports() {
        return cy.get('#number-of-seaports').invoke('text').then(parseFloat);
    }
}