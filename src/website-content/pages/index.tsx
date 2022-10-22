import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link'
import Styles from '../styles/HomePage.module.css'
import Footer from '../components/footer/footer'
import FlexportLogo from '../public/images/flexport-logo.svg'
import PortIcon from '../public/images/icon-port.svg'
import RightChevron from '../public/images/right-chevron.svg'
import VesselIcon from '../public/images/icon-vessel.svg'
import ContainersIcon from '../public/images/icon-containers.svg'
import Background from '../public/images/boat-background.png'

// export async function getStaticProps() {
//   const cachePageDurationSeconds = 86400;

//   return {
//     props: {    },
//     revalidate: cachePageDurationSeconds,
//   }
// }

const Home: NextPage = () => {
  return (
    <div className={Styles.container}>
      <Head>
        <title>Flexport Earth</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={Styles.main}>
        <div className={Styles.mainBackgroundContainer}>
          <Image
            src={Background}
            alt="Boat Background"
            objectFit='cover'
            layout='fill'
            className={Styles.mainBackground}
          />
        </div>
        <div className={Styles.mainContent}>
          <Image
            src={FlexportLogo}
            alt="Flexport Logo"
            height={30}
            width={110}
          />

          <span className={Styles.wikiTitleVerticalLine}></span>

          <span className={Styles.wikiSubTitle}>Wiki</span>

          <div className={Styles.tagLine}>
            Discover the world of supply chain
          </div>

          <div className={Styles.portsSection}>
            <a id="all-ports-link" href='facts/places/ports'>
              <div className={Styles.portsLink}>
                <Image
                  src={PortIcon}
                  alt="Port Icon"
                  height={26}
                  width={26}
                />

                <span className={Styles.portsSectionTitle}>Ports</span>

                <span className={Styles.rightChevron}>
                  <Image
                    src={RightChevron}
                    alt="Right Chevron"
                    height={14}
                    width={14}
                  />
                </span>
              </div>
            </a>

            <div className={Styles.portCountries}>
              <Link href='facts/places/ports/CN'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/CN.svg"
                    alt="China flag"
                    height={16}
                    width={16}
                  />

                  <span className={Styles.portCountryText}>China ports ( 260 )</span>
                </div>
              </Link>

              <Link href='facts/places/ports/US'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/US.svg"
                    alt="United States flag"
                    height={16}
                    width={16}
                  />

                  <span className={Styles.portCountryText}>United States ports ( 64 )</span>
                </div>
              </Link>

              <Link href='facts/places/ports/SG'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/SG.svg"
                    alt="Singapore flag"
                    height={16}
                    width={16}
                  />

                  <span className={Styles.portCountryText}>Singapore ports ( 2 )</span>
                </div>
              </Link>

              <Link href='facts/places/ports/KR'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/KR.svg"
                    alt="South Korea flag"
                    height={16}
                    width={16}
                  />

                  <span className={Styles.portCountryText}>South Korea ports ( 43 )</span>
                </div>
              </Link>

              <Link href='facts/places/ports/MY'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/MY.svg"
                    alt="Malaysia flag"
                    height={16}
                    width={16}
                  />

                  <span className={Styles.portCountryText}>Malaysia ports ( 13 )</span>
                </div>
              </Link>

              <Link href='facts/places/ports/JP'>
                <div className={Styles.portCountry}>
                  <Image
                    src="https://assets.flexport.com/flags/svg/1/JP.svg"
                    alt="Japan flag"
                    height={16}
                    width={16}
                  />

                  Japan ports ( 383 )
                </div>
              </Link>
            </div>
          </div>

          <div className={Styles.vesselsAndContainersSection}>
            <a id="all-vessels-link" href='facts/vehicles/vessels'>
              <div className={Styles.vesselsSection}>
                <Image
                  src={VesselIcon}
                  alt="Vessel Icon"
                  height={26}
                  width={26}
                />

                <span className={Styles.vesselsSectionTitle}>Vessels</span>

                <Image
                  src={RightChevron}
                  alt="Right Chevron"
                  height={14}
                  width={14}
                />
              </div>
            </a>

            <div className={Styles.containersSection}>
              <Image
                src={ContainersIcon}
                alt="Containers Icon"
                height={26}
                width={26}
              />

            <span className={Styles.containersSectionTitle}>Containers</span>

              <Image
                src={RightChevron}
                alt="Right Chevron"
                height={14}
                width={14}
              />
            </div>
          </div>
        </div>
      </main>

      <Footer/>
    </div>
  )
}

export default Home
