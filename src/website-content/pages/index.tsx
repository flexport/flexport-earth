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

      <header className={Styles.header}>
        <div id="wiki-title" className={Styles.wikiTitle}>
          <a id="flexport-logo" href="https://www.flexport.com">
            <Image src="/images/flexport-logo.svg" alt="Flexport Logo" height={30} width={110} />
          </a>
          <span id="wiki-title-vertical-line" className={Styles.wikiTitleVerticalLine}></span>
          <span id="wiki-subtitle" className={Styles.wikiSubTitle}>Wiki</span>
          <div className={Styles.tagLine}>Discover the world of supply chain</div>
        </div>
      </header>

      <main className={Styles.main}>
        <div className={Styles.portsSection}>
          <h2 className={Styles.sectionHeading}>Ports &gt;</h2>

          <div className={Styles.portsList}>
            <div className={Styles.portsLarge}>
              <div className={Styles.grid}>
                <Link href="facts/places/ports/CN">
                    <div className={Styles.portsCardMajor}>China ports (260)</div>
                </Link>

                <Link href="facts/places/ports/US">
                    <div className={Styles.portsCardMajor}>United States ports (64)</div>
                </Link>

                <Link href="facts/places/ports/SG">
                    <div className={Styles.portsCardMajor}>Singapore ports (2)</div>
                </Link>

                <Link href="facts/places/ports/KR">
                    <div className={Styles.portsCardMajor}>South Korea ports (43)</div>
                </Link>

                <Link href="facts/places/ports/MY">
                    <div className={Styles.portsCardMajor}>Malaysia ports (13)</div>
                </Link>

                <Link href="facts/places/ports/JP">
                    <div className={Styles.portsCardMajor}>Japan ports (383)</div>
                </Link>
              </div>
            </div>
          </div>

          <div className={Styles.portsSmall}>
            <a href="">
                <div className={Styles.portsCardMinor}>Country name ports (123)</div>
            </a>

            <a href="">
              <div className={Styles.portsCardMinor}>Country name ports (123)</div>
            </a>

            <a href="">
              <div className={Styles.portsCardMinor}>Country name ports (123)</div>
            </a>

            <a href="">
              <div className={Styles.portsCardMinor}>Country name ports (123)</div>
            </a>

            <Link href="/facts/places/ports">
              <div id="all-ports-link" className={`${Styles.portsCardMinor} ${Styles.allPorts}`}>All ports &gt;</div>
            </Link>
          </div>
        </div>
      </main>

      <div className={Styles.vesselsSection}>
        <h2 className={Styles.sectionHeading}>Vessels &gt;</h2>

          <Link href="/facts/vehicles/vessels">
            <div id="all-vessels-link" className={`${Styles.vesselsCardMinor} ${Styles.allVessels}`}>All Vessels &gt;</div>
          </Link>
      </div>

      <Footer/>
    </div>
  )
}

export default Home
