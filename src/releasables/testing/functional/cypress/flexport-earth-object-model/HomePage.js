export default class HomePage {
    getBody() {
        return cy.get('body');
    }

    getHeader() {
        return new Header();
    }

    getAllPortsLink() {
        return cy.get('#all-ports-link');
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
