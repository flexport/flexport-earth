import Image        from 'next/image'

import Styles               from './beta-icon.module.css'

import IconX                from 'public/images/icon-X.svg'
import Arrow                from 'public/images/icon-arrow-right-blue.svg'

import SubmitFeedbackLink   from 'components/submit-feedback/submit-feedback-link'

const BetaIcon = ({className = '', popupClassName = '', pointerClassName = ''}) => {
    function showPopup() {
        // Show the popup pointer
        var elements        = document.getElementsByClassName(`${Styles.betaIconPopupPointer}`);
        var pointerElement  = elements[0];

        pointerElement.classList.remove(Styles.betaIconPopupInactive);

        // Show the popup box
        elements            = document.getElementsByClassName(`${Styles.betaIconPopup}`);
        var popupElement    = elements[0];

        popupElement.classList.remove(Styles.betaIconPopupInactive);
    }

    function hidePopup() {
         // Hide the popup pointer
         var elements     = document.getElementsByClassName(`${Styles.betaIconPopupPointer}`);
         var popupElement = elements[0];

         popupElement.classList.add(Styles.betaIconPopupInactive);

        // Hide the popup box
        var elements     = document.getElementsByClassName(`${Styles.betaIconPopup}`);
        var popupElement = elements[0];

        popupElement.classList.add(Styles.betaIconPopupInactive);
    }

    return (
        <span className={Styles.betaIconContainer}>
            <span
                className   = {`${Styles.betaIcon} ${className}`}
                onClick     = {showPopup}
            >
                <span className={Styles.betaIconText}>
                    Beta
                </span>
            </span>
            <span className={`${Styles.betaIconPopupPointer} ${Styles.betaIconPopupInactive} ${pointerClassName}`}></span>
            <div className={`${Styles.betaIconPopup} ${Styles.betaIconPopupInactive} ${popupClassName}`}>
                <div className={Styles.betaIconPopupTitleBar}>
                    <p className={Styles.betaIconPopupTitle}>
                        Beta mode
                    </p>
                    <Image
                        className = {Styles.betaIconPopupCloseButton}
                        src       = {IconX}
                        alt       = 'Close Button'
                        width     = {12}
                        onClick   = {hidePopup}
                    />
                </div>
                <p className={Styles.betaIconPopupDescription}>
                    The site is in beta. Please help us improve it by reporting any bugs or issues you find.
                </p>

                <SubmitFeedbackLink className={Styles.betaIconPopupSubmitFeedbackLink}>
                    Submit feedback
                    <Image
                        src     = {Arrow}
                        alt     = 'Right Pointing Blue Arrow'
                        width   = {12}
                    />
                </SubmitFeedbackLink>
            </div>
        </span>
    );
}

export default BetaIcon;
