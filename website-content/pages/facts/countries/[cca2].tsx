import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import styles from '/styles/Home.module.css'

type CountryCodeParams = {
    params: {
        cca2: string
    }
}

async function getAllCountryCodes() {
    const responseData: Countries = await (
        await fetch('https://restcountries.com/v3.1/all')
    ).json();

    return responseData.map(country => {
        return {
            params: {
                cca2: country.cca2
            }
        }
    });
}

async function getCountryData(cca2: string) {
    const json = await (
        await fetch('https://restcountries.com/v3.1/alpha/' + cca2)
    ).json();

    return json;
}

export async function getStaticPaths() {
    const paths = await getAllCountryCodes()
    return {
        paths,
        fallback: false
    }
}

export async function getStaticProps(params: CountryCodeParams) {
    console.log(params.params);

    const postData = await getCountryData(params.params.cca2);

    console.log(postData);

    return {
      props: {
        time: new Date().toISOString(),
        ...postData[0]
      },
      revalidate: 10
    }
}

type Countries = [{
    name: {
      common: string
    },
    cca2: string
}]

type Country = {
    name: {
        common: string
    },
    cca2: string,
    time: string
}

const CountryPage: NextPage<Country> = (country) => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: Country: {country.cca2}</title>
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
        {country.name.common}
        </h1>
        {country.time}
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

export default CountryPage
