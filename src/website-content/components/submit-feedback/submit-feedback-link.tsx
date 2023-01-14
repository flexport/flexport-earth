'use client';

import { ReactNode } from 'react'

const SubmitFeedbackLink = (
    {
        children,
        className = ''
    } : {
        children:  ReactNode,
        className: string
    }) => {
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
            className   = {`${className}`}
            onClick     = {() => openUserFeedbackEmail()}
        >
            {children}
        </a>
    );
}

export default SubmitFeedbackLink;
