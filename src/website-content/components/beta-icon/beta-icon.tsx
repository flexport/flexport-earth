import Styles       from './beta-icon.module.css'

import Image        from 'next/image'

import IconX        from 'public/images/icon-X.svg'
import Arrow        from 'public/images/icon-arrow-right-blue.svg'

const BetaIcon = ({className = ''}) => {
    function showPopup() {
        var elements     = document.getElementsByClassName(`${Styles.betaIconPopup}`);
        var popupElement = elements[0];

        popupElement.classList.remove(Styles.betaIconPopupInactive);
    }

    function hidePopup() {
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
            <div className={`${Styles.betaIconPopup} ${Styles.betaIconPopupInactive}`}>
                <div className={Styles.betaIconPopupTitleBar}>
                    <p className={Styles.betaIconPopupTitle}>
                        Beta mode
                    </p>
                    <Image
                        className = {Styles.betaIconPopupCloseButton}
                        src       = {IconX}
                        alt       = 'Close Button'
                        width     = {14.44}
                        onClick   = {hidePopup}
                    />
                </div>
                <p className={Styles.betaIconPopupDescription}>
                    The site is in beta. Please help us improve it by reporting any bugs or issues you find.
                </p>
                <a className={Styles.betaIconPopupSubmitFeedbackLink}>
                    Submit feedback
                    &nbsp;
                    <Image
                        src       = {Arrow}
                        alt       = 'Right Pointing Blue Arrow'
                        width     = {12}
                    />
                </a>
            </div>
        </span>
    );
}

export default BetaIcon;
