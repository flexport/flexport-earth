export default class PortPage {
    static path = 'facts/places/port/';

    getBody() {
        return cy.get('body');
    }

    getTerminalLink(terminalCode: string) {
        return cy.get('#terminal-' + terminalCode);
    }
}