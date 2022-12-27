import SubmitFeedbackLink   from './submit-feedback-link';
import Styles               from './submit-feedback-link.module.css'

describe('Submit Feedback Link', () => {
    it('Clicking link opens email with technical details', () => {
        // Arrange
        cy.window().then((win) => {
            cy.stub(win, 'open').as('windowOpen')
        });

        cy.mount(<SubmitFeedbackLink />);

        // Act
        cy.get(`.${Styles.productFeedbackLink}`).click();

        // Assert
        cy.get('@windowOpen')
            .should(
                'be.calledWithMatch',
                /mailto:earth-feedback@flexport.com\?subject=Earth Feedback&body=.+Current Webpage: http:\/\/localhost:8080\/.+\/src\/website-content\/components\/submit-feedback\/submit-feedback-link.component-test.cy.tsx.+User Agent: Mozilla\/5.0.+Screen Size: \d+x\d+/
            );
    })
})
