import Styles from './styles.module.css'

const BetaIcon = ({className = ''}) => {
    function showPopup(){
        var elements     = document.getElementsByClassName(`${Styles.betaIconPopup}`);
        var popupElement = elements[0];

        popupElement.classList.remove(Styles.betaIconPopupInactive);
    }

    return (
        <span className={Styles.betaIconContainer}>
            <span className={`${Styles.betaIcon} ${className}`} onMouseEnter={showPopup}>
                <span className={Styles.betaIconText}>
                    Beta
                </span>
            </span>
            <div className={`${Styles.betaIconPopup} ${Styles.betaIconPopupInactive}`}>
                <div className={Styles.betaIconPopupTitle}>Beta mode</div>
                <div className={Styles.betaIconPopupDescription}>
                    The site is in beta. Please help us improve it by reporting any bugs or issues you find.
                </div>
                <a>Submit feedback &#8594;</a>
            </div>
        </span>
    );
}

export default BetaIcon;
