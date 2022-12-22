import Styles from './styles.module.css'

const BetaIcon = ({className = ''}) => {
    return (
        <span className={`${Styles.betaIcon} ${className}`}>
            <span className={Styles.betaIconText}>
                Beta
            </span>

            <div className={Styles.betaIconPopup}>
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
