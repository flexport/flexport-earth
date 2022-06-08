import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link';
import styles from '/styles/Home.module.css'

export async function getStaticProps() {
  const ports = await (
    await fetch(
      'https://api.nonp-dev-6.use1.eng-nonprod.flexport.internal/places/ports?types=SEAPORT',
      {
        headers: new Headers({
          'Authorization':    'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjFrUGo1ZTV0VUZaQ25OZmpJQzU0UCJ9.eyJpc3MiOiJodHRwczovL2FwaS1zdGFnaW5nLmlkZW50aXR5LWRldi5mbGV4cG9ydC5jb20vIiwic3ViIjoiSmtwZkdYOFJTVDhYbUpRMmIyQ2ptWmZHN0p6YjA4Q1JAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vYXBpLmZsZXhwb3J0LmNvbSIsImlhdCI6MTY1NDYzMzQwMiwiZXhwIjoxNjU0NzE5ODAyLCJhenAiOiJKa3BmR1g4UlNUOFhtSlEyYjJDam1aZkc3SnpiMDhDUiIsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyJ9.sA5xkz-NW1nPdXuy3Nj5NuhPNrP-FD6t5N7RaghNpoZaCL72qB03YFFb6waK11wwFitLJfqCLytLAPjijRBxqqjYTMSpGYnNaESDovAmobLOH7cqTSC4Or4y8pEBkbjglzIA9xds_RFTdTxCkOEyLXrCeO-nJad6nQD24XqFc_qwtoPOpoZ0SnmZEdg70c_xZxMPFQLpIIYWIHzTCtOKEj76meyDtRqdrLgcuuiopDJZYg3qTjr6hGnwKvZblfaJnOCEzn6hpuglO2uwWJo9TKKAO1p8V38Tk74DIMVkrvdc3ZQWnthT95gQ3r7d7hXiLgzhMH59Esc1pevVrLQmyg',
          'Flexport-Version': '1'
        })
      },
    )
  ).json();

  //const ports = {ports: [{name: "test"}]}

  console.log(ports);

  return {
    props: {
      ...ports,
    },
  };
}

type Countries = {
  ports: [{
    name: string
  }]
}

const CountriesPage: NextPage<Countries> = ({ports}) => {
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

export default CountriesPage
