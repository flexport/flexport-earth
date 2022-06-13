import React, { ReactNode } from 'react';
import Head from 'next/head';
import styles from '/styles/Home.module.css'
import Image from 'next/image'

type Props = {
  children: ReactNode;
  title?:   string;
  h1?:      string;
};

const Layout = ({
    children,
    title = 'TypeScript Next.js Stripe Example',
    h1
  }: Props) => (
    <>
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: {title}</title>
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
        <h1 className={styles.title}>{h1}</h1>

        {children}

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
  </>
);

export default Layout;
