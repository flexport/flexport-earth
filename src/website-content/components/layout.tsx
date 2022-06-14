import React, { ReactNode } from 'react';
import Head from 'next/head';
import styles from '/styles/Layout.module.css'
import Image from 'next/image'
import Footer from './footer'

type Props = {
  children: ReactNode;
  title?:   string;
  h1?:      string;
};

const Layout = ({
    children,
    title,
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

      <Footer/>
    </div>
  </>
);

export default Layout;
