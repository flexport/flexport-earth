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
                <a href="facts/places/ports/CN" className={Styles.portsCardMajor}>
                    <div>China ports (260)</div>
                </a>

                <a href="facts/places/ports/US" className={Styles.portsCardMajor}>
                    <div>United States ports (64)</div>
                </a>

                <a href="facts/places/ports/SG" className={Styles.portsCardMajor}>
                    <div>Singapore ports (2)</div>
                </a>

                <a href="facts/places/ports/KR" className={Styles.portsCardMajor}>
                    <div>South Korea ports (43)</div>
                </a>

                <a href="facts/places/ports/MY" className={Styles.portsCardMajor}>
                    <div>Malaysia ports (13)</div>
                </a>

                <a href="facts/places/ports/JP" className={Styles.portsCardMajor}>
                    <div>Japan ports (383)</div>
                </a>
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
              <div className={`${Styles.portsCardMinor} ${Styles.allPorts}`}>All ports &gt;</div>
            </Link>
          </div>
        </div>
      </main>

      <Footer/>
    </div>
  )
}

export default Home
