import Homepage from './homepage';
import Styles from   './ports-card.module.css'

describe('Homepage', () => {
    it('show Ports Card', () => {
        // Arrange
        const countryPortsToHighlight = [
            { countryName: 'China', cca2CountryCode: 'CN', portCount: 111 }
        ];

        const portsCardComponent =
            <Homepage
                countryPortsToHighlight={countryPortsToHighlight}
            />;

        // Act
        cy.mount(portsCardComponent);

        // Assert
        cy.get(`.${Styles.portsSection}`).contains(`China ports ( 111 )`);
    })
});
