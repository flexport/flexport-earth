import Styles               from './footer.module.css'

import Image                from 'next/image'
import Link                 from 'next/link'

import IconSupplyChainBook  from 'public/images/icon-supply-chain-book.png'
import FlexportLogo         from 'public/images/flexport-logo.svg'

import React                from 'react'

import SubmitFeedbackLink   from 'components/submit-feedback/submit-feedback-link'

const Footer = () => {
    return (
      <footer className={Styles.footer}>
        <div className={Styles.footerContent}>
            <div className={Styles.footerMainContentSection}>
                <div className={Styles.topPorts}>
                    <div className={Styles.footerTopTitle}>TOP PORTS</div>
                    <ol className={Styles.footerTopList}>
                        <li><Link href='/facts/places/port/USPCV'>Port Canaveral</Link></li>
                        <li><Link href='/facts/places/port/USPEF'>Port Everglades</Link></li>
                        <li><Link href='/facts/places/port/USFOC'>Port Fourchon</Link></li>
                        <li><Link href='/facts/places/port/USHOU'>Port of Houston</Link></li>
                        <li><Link href='/facts/places/port/USLGB'>Port of Long Beach</Link></li>
                        <li><Link href='/facts/places/port/USLAX'>Port of Los Angeles</Link></li>
                        <li><Link href='/facts/places/port/USMIA'>Port of Miami</Link></li>
                        <li><Link href='/facts/places/port/USSEA'>Port of Seattle</Link></li>
                        <li><Link href='/facts/places/port/USSCK'>Port of Stockton</Link></li>
                    </ol>
                </div>
                <div className={Styles.topVessels}>
                    <div className={Styles.footerTopTitle}>TOP VESSELS</div>
                    <ol className={Styles.footerTopList}>
                        <li><Link href='/facts/vehicles/vessel/353136000'>Ever Given</Link></li>
                        <li><Link href='/facts/vehicles/vessel/352986146'>Ever Ace</Link></li>
                        <li><Link href='/facts/vehicles/vessel/371308000'>Ever Goods</Link></li>
                        <li><Link href='/facts/vehicles/vessel/636019234'>Ever Glory</Link></li>
                        <li><Link href='/facts/vehicles/vessel/351297000'>HMM Algeciras</Link></li>
                        <li><Link href='/facts/vehicles/vessel/219836000'>Madrid Maersk</Link></li>
                        <li><Link href='/facts/vehicles/vessel/372003000'>MSC Gülsün</Link></li>
                        <li><Link href='/facts/vehicles/vessel/477333500'>OOCL Hong Kong</Link></li>
                    </ol>
                </div>
                <div className={Styles.glossaryAndInfo}>
                    <a className={Styles.footerGlossaryLink} href='https://www.flexport.com/glossary' target="_blank" rel="noreferrer">
                        <div className={Styles.footerGlossary}>
                            <div className={Styles.footerGlossaryLeft}>
                                <div className={Styles.footerGlossaryTitle}>Glossary &gt;</div>
                                <div className={Styles.footerGlossaryDescription}>Boost Your Supply Chain Terminology</div>
                            </div>
                            <div className={Styles.footerGlossaryRight}>
                                <Image
                                    src={IconSupplyChainBook}
                                    alt="Supply Chain Book"
                                    height={170}
                                    width={199}
                                />
                            </div>
                        </div>
                    </a>

                    <div className={Styles.footerInfo}>
                        <div className={Styles.footerInfoTitle}>
                            Interested in tech stack behind this website?
                        </div>
                        <div className={Styles.footerInfoDescription}>
                            Read our public <a href="https://apidocs.flexport.com" target="_blank" rel="noreferrer">API documentation</a>, or check our <a href="https://github.com/flexport/flexport-earth" target="_blank" rel="noreferrer">Github repository</a>
                        </div>

                        <div className={Styles.footerInfoTitle}>
                            Product feedback
                        </div>
                        <div className={Styles.footerInfoDescription}>
                            Let us know how we can improve your experience. Tell us about a problem you&apos;d like to report or feedback that you have about your experience by<br/><SubmitFeedbackLink className={Styles.productFeedbackLink}>submitting feedback</SubmitFeedbackLink>.
                        </div>
                    </div>
                </div>
            </div>

            <hr className={Styles.footerContentHr}/>

            <div className={Styles.footerLowerSection}>
                <a className={Styles.footerLowerLeftSection} id="flexport-logo" href="https://www.flexport.com">
                    <div>
                        <Image
                            className={Styles.footerContentFlexportLogo}
                            layout="raw"
                            src={FlexportLogo}
                            alt="Flexport Logo"
                            height={20}
                            width={90}
                        />
                        <div className={Styles.footerContentTagLine}>We&apos;re making global trade easy for everyone.</div>
                    </div>
                </a>
                <div className={Styles.footerLowerRightSection}>
                    <a href="javascript:alert('Build URL not specified.');" className={Styles.buildNumber}>
                        <div id="build-number-anchor"></div>
                    </a>
                    <div className={Styles.footerCopyright}>
                        Copyright © 2022 Flexport, Inc.
                    </div>
                </div>
            </div>
        </div>
      </footer>
    );
}
export default Footer;
