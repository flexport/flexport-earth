import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header className={styles.header}>
            <div id="wiki-title" className={styles.wikiTitle}>
                <a id="flexport-logo" href="https://www.flexport.com"><Image src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90} /></a>
                <span id="wiki-title-vertical-line" className={styles.wikiTitleVerticalLine}></span>
                <span id="wiki-subtitle" className={styles.wikiSubTitle}>Wiki</span><br/>
            </div>
            <div className={styles.wikiSearch}>
                <span>Discover the world of supply chain</span><br/>
                <input type="text"  value="<Not implemented>"/>
            </div>            
        </header>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to Flexport Earth
        </h1>

        <p className={styles.description}>
          Explore the facts of global trade by clicking into the links below.
        </p>

        <div className={styles.grid}>
          <a href="facts/countries" id="countries" className={styles.card}>
            <h2>Countries</h2>
            <p>View data for country legal entities.</p>
          </a>

          <a href="" className={styles.card}>
            <h2>Sea Ports</h2>
            <p>View data about ocean ports.</p>
          </a>

          <a
            href=""
            className={styles.card}
          >
            <h2>Vessels</h2>
            <p>View data about ocean vessels.</p>
          </a>

          <a
            href=""
            className={styles.card}
          >
            <h2>Containers</h2>
            <p>
              View data about containers.
            </p>
          </a>
        </div>
      </main>

      <footer className={styles.footer}>
        <a href="https://dev.azure.com/flexport-earth/Earth/_build/results?buildId={BUILDID}" id="build-number">
            <div id="build-number-anchor"></div>
        </a>
      </footer>
    </div>
  )
}

export default Home
