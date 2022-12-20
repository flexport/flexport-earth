import Footer from './footer';
import Styles from './footer.module.css'

describe('Footer', () => {
    it('Product feedback includes technical details', () => {
        // Arrange
        const footerComponent = <Footer />;

        cy.window().then((win) => {
            cy.stub(win, 'open').as('windowOpen')
        });

        cy.mount(footerComponent);

        // Act
        cy.get(`.${Styles.productFeedbackLink}`)
            .click();

        // Assert
        cy.get('@windowOpen')
            .should(
                'be.calledWithMatch',
                /mailto:earth-feedback@flexport.com\?subject=Earth Feedback&body=.+Current Webpage: http:\/\/localhost:8080\/.+\/src\/website-content\/components\/footer\/footer.component-test.cy.tsx.+User Agent: Mozilla\/5.0.+Screen Size: 1792x1120/
            );
    })
})