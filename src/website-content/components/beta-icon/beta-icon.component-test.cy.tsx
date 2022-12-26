import BetaIcon from './beta-icon';
import Styles   from './beta-icon.module.css'

const betaIconCssSelector                   = `.${Styles.betaIcon}`;
const betaIconPopupCssSelector              = `.${Styles.betaIconPopup}`;
const betaIconPopupCloseButtonCssSelector   = `.${Styles.betaIconPopupCloseButton}`;

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

    it.only('popup is shown on mouse click', () => {
        // Arrange
        cy.mount(<BetaIcon />);

        // Act
        cy
            .get(betaIconCssSelector)
            .click();

        // Assert
        cy
            .get(betaIconPopupCssSelector)
            .should('be.visible');
    })

    it.only('popup is closed on close button click', () => {
        // Arrange
        cy.mount(<BetaIcon />);

        cy
            .get(betaIconCssSelector)
            .click();

        // Act
        cy
            .get(betaIconPopupCloseButtonCssSelector)
            .click();

        // Assert
        cy
            .get(betaIconPopupCssSelector)
            .should('not.be.visible');
    })
})
