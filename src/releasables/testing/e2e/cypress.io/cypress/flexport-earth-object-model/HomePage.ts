import {getBaseUrl} from './Base'

export function gotoHomePage() {
    cy.visit(getBaseUrl());

    return new HomePage();
}

export class HomePage {
    getBody() {
        return cy.get('body');
    }

    getHeader() {
        return new Header();
    }

    getAllPortsLink() {
        return cy.get('#all-ports-link');
    }

    getAllVesselsLink() {
        return cy.get('#all-vessels-link');
    }

    getFooter() {
        return new Footer();
    }
}

class Header {
    getFlexportLogo() {
        return cy.get('#flexport-logo');
    }
}

class Footer {
    BuildNumber = cy.get('#build-number-anchor');
}
