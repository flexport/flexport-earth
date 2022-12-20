import Footer from './footer';
import Styles from './footer.module.css'

describe('Footer', () => {
    it('Product feedback includes technical details', () => {
        // Arrange
        const footerComponent = <Footer />;

        cy.window().then((win) => {
            cy.stub(win, 'open').as('windowOpen')
        });

        // Act
        cy.mount(footerComponent);

        // Assert
        cy.get(`.${Styles.productFeedbackLink}`)
            .click();

        cy.get('@windowOpen')
            .should(
                'be.calledWith',
                'mailto:earth-feedback@flexport.com?subject=Earth Feedback&body=%0D%0A%0D%0A%0D%0A%0D%0A------------------------------------------------------%0D%0ATechnical Details:%0D%0A-Current Webpage: http://localhost:8080/__cypress/iframes//Users/matthewthomas/git/flexport-earth/src/website-content/components/footer/footer.component-test.cy.tsx%0D%0A-User Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/12.0.2 Chrome/106.0.5249.51 Electron/21.0.0 Safari/537.36%0D%0A-Screen Size: 1792x1120'
            );
    })
})