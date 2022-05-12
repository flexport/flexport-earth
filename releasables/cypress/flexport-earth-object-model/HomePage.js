export default class HomePage {
    getBody() {
        return cy.get('body');
    }
    
    getHeader() {
        return new Header();
    }

    getCountriesLink() {
        return cy.get('#countries');
    }

    getFooter() {
        return new Footer();
    }
}

class Header {
    FlexportLogo = cy.get('#flexport-logo')
}

class Footer {
    BuildNumber = cy.get('#build-number-anchor');
}
