import Footer from './footer';
import Styles from './footer.module.css'

describe('Footer', () => {
    it('Product feedback includes technical details', () => {
        // Arrange
        const footerComponent = <Footer />;

        // Act
        cy.mount(footerComponent);

        // Assert
        const link = cy.get(`.${Styles.productFeedbackLink}`);
    })
})