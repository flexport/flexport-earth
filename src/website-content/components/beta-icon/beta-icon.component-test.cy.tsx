import BetaIcon from './beta-icon';
import Styles   from './styles.module.css'

describe('Beta Icon', () => {
    it('popup is hidden on load', () => {
        // Arrange
        const betaIconPopupCssSelector = `.${Styles.betaIconPopup}`;

        // Act
        cy.mount(<BetaIcon />);

        // Assert
        cy
            .get(betaIconPopupCssSelector)
            .should('not.be.visible');
    })
})
