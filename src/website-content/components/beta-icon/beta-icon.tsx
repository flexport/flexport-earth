import Styles       from './beta-icon.module.css'

import Image        from 'next/image'

import IconX        from 'public/images/icon-X.svg'

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
                    <div className={Styles.betaIconPopupTitle}>
                        Beta mode
                    </div>
                    <Image
                        className = {Styles.betaIconPopupCloseButton}
                        src       = {IconX}
                        alt       = 'Close Button'
                        width     = {14.44}
                        onClick   = {hidePopup}
                    />
                </div>
                <div className={Styles.betaIconPopupDescription}>
                    The site is in beta. Please help us improve it by reporting any bugs or issues you find.
                </div>
                <a>Submit feedback &#8594;</a>
            </div>
        </span>
    );
}

export default BetaIcon;
