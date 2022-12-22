import BetaIcon from './beta-icon';
import Styles   from './styles.module.css'

const betaIconCssSelector       = `.${Styles.betaIcon}`;
const betaIconPopupCssSelector  = `.${Styles.betaIconPopup}`;

describe('Beta Icon', () => {
    it.only('popup is hidden on load', () => {
        // Arrange
        // Act
        cy.mount(<BetaIcon />);

        // Assert
        cy
            .get(betaIconPopupCssSelector)
            .should('not.be.visible');
    })

    it.only('popup is shown on mouse hover', () => {
        // Arrange
        cy.mount(<BetaIcon />);

        // Act
        cy
            .get(betaIconCssSelector)
            .realHover();

        // Assert
        cy
            .get(betaIconPopupCssSelector)
            .should('be.visible');
    })
})
