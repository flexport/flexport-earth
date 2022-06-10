import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link';
import styles from '/styles/Home.module.css'

export async function getStaticProps() {
  //const countries = await (await fetch('https://restcountries.com/v3.1/all')).json();

  const countries =
  [
    {
      name: {
        common: "United States"
      },
      cca2: "US"
    }
  ];

  return {
    props: {
      countries,
    },
  };
}

type Countries = {
  countries: [{
    name: {
      common: string
    },
    cca2: string
  }]
}

const CountriesPage: NextPage<Countries> = ({countries}) => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: Countries</title>
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
          Countries
        </h1>

        <ol>
          {countries.sort((a, b) => a.name.common.localeCompare(b.name.common)).map(({ name, cca2 }) => (
              <li key={name.common}>
                <Link href={`/facts/countries/${cca2}`}>{name.common}</Link>
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

export default CountriesPage
