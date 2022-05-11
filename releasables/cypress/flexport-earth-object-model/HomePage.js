export default class HomePage {
    getHeader() {
        return new Header();
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
