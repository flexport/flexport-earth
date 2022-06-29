import React, { ReactNode } from 'react';
import Styles from '../styles/Footer.module.css'
import Image from 'next/image'

const Footer = () => (
      <footer className={Styles.footer}>
        <div className={Styles.footerContent}>
            <div className={Styles.footerMainContentSection}>
                <div className={Styles.topPorts}>
                    <div className={Styles.footerTopTitle}>TOP PORTS</div>
                    <ol className={Styles.footerTopList}>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                        <li>Ports name here</li>
                    </ol>
                </div>
                <div className={Styles.topVessels}>
                    <div className={Styles.footerTopTitle}>TOP VESSELS</div>
                    <ol className={Styles.footerTopList}>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                        <li>Vessel name here</li>
                    </ol>
                </div>
                <div className={Styles.glossaryAndInfo}>
                    <div className={Styles.footerGlossary}>
                        <div className={Styles.footerGlossaryLeft}>
                            <div className={Styles.footerGlossaryTitle}>Glossary &gt;</div>
                            <div className={Styles.footerGlossaryDescription}>Boost Your Supply Chain Terminology</div>
                        </div>
                        <div className={Styles.footerGlossaryRight}>
                            <Image
                                src="/images/icon-supply-chain-book.png"
                                alt="Supply Chain Book"
                                height={170}
                                width={199}
                            />
                        </div>
                    </div>
                    <div className={Styles.footerInfo}>
                        <div className={Styles.footerInfoTitle}>Interested in tech stack behind this website?</div>
                        <div className={Styles.footerInfoDescription}>Read our public API documentation , or check out Github repository</div>
                    </div>
                </div>
            </div>

            <hr className={Styles.footerContentHr}/>

            <div className={Styles.footerLowerSection}>
                <span className={Styles.footerLowerLeftSection}>
                    <Image className={Styles.footerContentFlexportLogo} layout="raw" src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90}/>
                    <div className={Styles.footerContentTagLine}>We&apos;re making global trade easy for everyone.</div>
                </span>
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

export default Footer;
