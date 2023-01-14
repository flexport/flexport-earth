import Image    from 'next/image'

import Styles from './homepage.module.css'
import Footer from '../footer/footer'

import FlexportLogo     from 'public/images/flexport-logo.svg'
import RightChevron     from 'public/images/right-chevron.svg'
import VesselIcon       from 'public/images/icon-vessel.svg'
import ContainersIcon   from 'public/images/icon-containers.svg'
import Background       from 'public/images/boat-background-optimized.webp'

import PortCard         from './ports-card'
import BetaIcon         from 'components/beta-icon/beta-icon';

type CountryInfo = {
  countryName:      string,
  cca2CountryCode:  string,
  portCount:        number
}

const Homepage = (
    {countryPortsToHighlight}: {countryPortsToHighlight: CountryInfo[]}
) => {
    return (
        <div className={Styles.container}>
            <main className={Styles.main}>
                <div className={Styles.mainBackgroundContainer}>
                    <Image
                        src         = {Background}
                        alt         = "Boat Background"
                        className   = {Styles.mainBackground}
                        priority    = {true}
                    />
                </div>
                <div className={Styles.mainContent}>
                    <Image
                        src     = {FlexportLogo}
                        alt     = "Flexport Logo"
                        height  = {30}
                        width   = {110}
                    />

                    <span className={Styles.wikiTitleVerticalLine}></span>

                    <span className={Styles.wikiSubTitle}>
                        Wiki
                    </span>

                    <BetaIcon
                        className           = {Styles.betaIcon}
                        popupClassName      = {Styles.betaIconPopup}
                        pointerClassName    = {Styles.betaIconPopupPointer}
                    />

                    <div className={Styles.tagLine}>
                        Discover the world of supply chain
                    </div>

                    <PortCard
                        countries={countryPortsToHighlight}
                    />

                    <div className={Styles.vesselsAndContainersSection}>
                        <a id="all-vessels-link" href='facts/vehicles/vessels'>
                        <div className={Styles.vesselsSection}>
                            <Image
                                src     = {VesselIcon}
                                alt     = "Vessel Icon"
                                height  = {26}
                                width   = {26}
                            />

                            <span className={Styles.vesselsSectionTitle}>
                                Vessels
                            </span>

                            <Image
                                src     = {RightChevron}
                                alt     = "Right Chevron"
                                height  = {14}
                                width   = {14}
                            />
                        </div>
                        </a>

                        <div className={Styles.containersSection}>
                            <Image
                                src     = {ContainersIcon}
                                alt     = "Containers Icon"
                                height  = {26}
                                width   = {26}
                            />

                            <span className={Styles.containersSectionTitle}>
                                Containers
                            </span>

                            <Image
                                src     = {RightChevron}
                                alt     = "Right Chevron"
                                height  = {14}
                                width   = {14}
                            />
                        </div>
                    </div>
                </div>
            </main>

            <Footer/>
        </div>
    );
}

export default Homepage;
