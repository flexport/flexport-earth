import Image        from 'next/image'

import Styles       from './submit-feedback-link.module.css'
import Arrow        from 'public/images/icon-arrow-right-blue.svg'

const SubmitFeedbackLink = ({className = ''}) => {
    const openUserFeedbackEmail = () => {
        const currentWebPage    = window.location.href;
        const userAgent         = window.navigator.userAgent;
        const screenSize        = window.screen.width + 'x' + window.screen.height;

        const userFeedbackEmailBody = `



------------------------------------------------------
Technical Details:
-Current Webpage: ${currentWebPage}
-User Agent: ${userAgent}
-Screen Size: ${screenSize}`;

        const emailTo   = 'earth-feedback@flexport.com';
        const emailSub  = 'Earth Feedback';
        const emailBody = userFeedbackEmailBody.replace(/[\r\n]/gm, '%0D%0A');

        window.open("mailto:"+emailTo+'?subject='+emailSub+'&body='+emailBody);
    }

    return (
        <a
            className   = {`${Styles.productFeedbackLink} ${className}`}
            onClick     = {() => openUserFeedbackEmail()}
        >
            Submit feedback
            &nbsp;
            <Image
                src     = {Arrow}
                alt     = 'Right Pointing Blue Arrow'
                width   = {12}
            />
        </a>
    );
}

export default SubmitFeedbackLink;
