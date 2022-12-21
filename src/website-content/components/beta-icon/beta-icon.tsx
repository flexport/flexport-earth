import Styles from './styles.module.css'

const BetaIcon = ({className = ''}) => {
    return (
        <span className={`${Styles.betaIcon} ${className}`}>
            <span className={Styles.betaIconText}>
                Beta
            </span>
        </span>
    );
}

export default BetaIcon;
