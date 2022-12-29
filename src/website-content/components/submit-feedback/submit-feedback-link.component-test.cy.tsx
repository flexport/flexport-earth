import SubmitFeedbackLink from './submit-feedback-link';

describe('Submit Feedback Link', () => {
    it('Clicking link opens email with technical details', () => {
        // Arrange
        const feedbackLinkText = "Submit feedback!";

        cy.window().then((win) => {
            cy.stub(win, 'open').as('windowOpen')
        });

        cy.mount(
            <SubmitFeedbackLink className=''>
                {feedbackLinkText}
            </SubmitFeedbackLink>
        );

        // Act
        cy.contains(feedbackLinkText).click();

        // Assert
        cy.get('@windowOpen')
            .should(
                'be.calledWithMatch',
                /mailto:earth-feedback@flexport.com\?subject=Earth Feedback&body=.+Current Webpage: http:\/\/localhost:8080\/.+\/src\/website-content\/components\/submit-feedback\/submit-feedback-link.component-test.cy.tsx.+User Agent: Mozilla\/5.0.+Screen Size: \d+x\d+/
            );
    })

    it('Specified text appears as text in the link', () => {
        // Arrange
        const feedbackLinkText = "This text should appear in the link";

        // Act
        cy.mount(
            <SubmitFeedbackLink className=''>
                {feedbackLinkText}
            </SubmitFeedbackLink>
        );

        // Assert
        cy.contains(feedbackLinkText)
            .should('exist');
    })
})
