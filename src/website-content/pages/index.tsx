import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link'
import Styles from '../styles/HomePage.module.css'
import Footer from '../components/footer'

const Home: NextPage = () => {
  return (
    <div className={Styles.container}>
      <Head>
        <title>Flexport Earth</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={Styles.main}>
        <div className={Styles.mainContent}>
          <Image
            src="/images/flexport-logo.svg"
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
            <Link href='facts/places/ports'>
              <div className={Styles.portsLink}>
                <Image
                  src="/images/icon-port.svg"
                  alt="Port Icon"
                  height={26}
                  width={26}
                />

                <span className={Styles.portsSectionTitle}>Ports</span>

                <span className={Styles.rightChevron}>
                  <Image
                    src="/images/right-chevron.svg"
                    alt="Right Chevron"
                    height={14}
                    width={14}
                  />
                </span>
              </div>
            </Link>

            <div className={Styles.portCountries}>
              <Link href='facts/places/ports/CN'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-china.png"
                    alt="China flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;China ports ( 260 )
                </div>
              </Link>

              <Link href='facts/places/ports/US'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-usa.png"
                    alt="United States flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;United States ports ( 64 )
                </div>
              </Link>

              <Link href='facts/places/ports/SG'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-singapore.png"
                    alt="Singapore flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;Singapore ports ( 2 )
                </div>
              </Link>

              <Link href='facts/places/ports/KR'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-south-korea.png"
                    alt="South Korea flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;South Korea ports ( 43 )
                </div>
              </Link>

              <Link href='facts/places/ports/MY'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-malaysia.png"
                    alt="Malaysia flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;Malaysia ports ( 13 )
                </div>
              </Link>

              <Link href='facts/places/ports/JP'>
                <div className={Styles.portCountry}>
                  <Image
                    src="/images/flag-japan.png"
                    alt="Japan flag"
                    height={16}
                    width={16}
                  />

                  &nbsp;&nbsp;Japan ports ( 383 )
                </div>
              </Link>
            </div>
          </div>

          <div className={Styles.vesselsAndContainersSection}>
            <div className={Styles.vesselsSection}>
              <Image
                src="/images/icon-vessel.svg"
                alt="Vessel Icon"
                height={26}
                width={26}
              />

              &nbsp;&nbsp;&nbsp;Vessels&nbsp;&nbsp;&nbsp;

              <Image
                src="/images/right-chevron.svg"
                alt="Right Chevron"
                height={14}
                width={14}
              />
            </div>

            <div className={Styles.containersSection}>
              <Image
                src="/images/icon-containers.svg"
                alt="Containers Icon"
                height={26}
                width={26}
              />

              &nbsp;&nbsp;&nbsp;Containers&nbsp;&nbsp;&nbsp;

              <Image
                src="/images/right-chevron.svg"
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
