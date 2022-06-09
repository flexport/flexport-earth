import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link';
import styles from '/styles/Home.module.css'
import FlexportApiClient from '../../../../../lib/data_sources/flexport/api'

export async function getStaticProps() {
  const flexportApi = FlexportApiClient();
  const ports = await flexportApi.places.getSeaports()

  console.log(ports);

  return {
    props: {
      time: new Date().toISOString(),
      ...ports,
    },
    revalidate: 60
  };
}

type Ports = {
  time: string,
  ports: [{
    name: string
  }]
}

const SeaportsPage: NextPage<Ports> = ({ports, time}) => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: Seaports</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header className={styles.pageHeader}>
            <div className={styles.pageWikiTitle}>
                <a id="flexport-logo" href="https://www.flexport.com"><Image src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90} /></a>
                <span id="wiki-title-vertical-line" className={styles.wikiTitleVerticalLine}></span>
                <span id="wiki-subtitle" className={styles.wikiSubTitle}>Wiki</span><br/>
            </div>
      </header>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Seaports
        </h1>

        { time }

        <ol>
          {ports.map(({ name }) => (
              <li key={name}>
                {name}
              </li>
            ))}
        </ol>
      </main>

      <footer className={styles.footer}>
        <div className={styles.footerContent}>
            <hr className={styles.footerContentHr}/>

            <div>
                <Image className={styles.footerContentFlexportLogo} layout="raw" src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90}/>
                <span className={styles.footerContentTagLine}>We&apos;re making global trade easy for everyone.</span>
            </div>

            <a href="javascript:alert('Build URL not specified.');" className={styles.buildNumber}>
                <div id="build-number-anchor"></div>
            </a>
        </div>
      </footer>
    </div>
  )
}

export default SeaportsPage
