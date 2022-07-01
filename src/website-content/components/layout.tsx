import React, { ReactNode } from 'react';
import Head from 'next/head';
import styles from '/styles/Layout.module.css'
import Image from 'next/image'
import Footer from './footer'
import Link from 'next/link';

type Props = {
  children:         ReactNode;
  title?:           string;
  selectMajorLink?: string;
};

const Layout = ({
    children,
    title,
    selectMajorLink
  }: Props) => (
    <>
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: {title}</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header className={styles.pageHeader}>
        <div className={styles.pageHeaderContent}>
          <div className={styles.pageWikiTitle}>
              <a id="flexport-logo" href="https://www.flexport.com">
                <Image
                  src="/images/flexport-logo.svg"
                  alt="Flexport Logo"
                  height={36}
                  width={106}
                />
              </a>
              <span id="wiki-title-vertical-line" className={styles.wikiTitleVerticalLine} />
              <span id="wiki-subtitle" className={styles.wikiSubTitle}>Wiki</span>
          </div>
          <div className={styles.majorLinks}>
            <Link href='/facts/places/ports'>
              <div className={selectMajorLink == 'ports' ? styles.selectedMajorLink : ""}>
                Ports
              </div>
            </Link>
            <Link href='/facts/vehicles/vessels'>
              <div className={selectMajorLink == 'vessels' ? styles.selectedMajorLink : ""}>
                Vessels
              </div>
            </Link>
            <Link href=''>
              <div className={selectMajorLink == 'containers' ? styles.selectedMajorLink : ""}>
                Containers
              </div>
            </Link>
          </div>
        </div>
      </header>

      <main className={styles.main}>

        {children}

      </main>

      <Footer/>
    </div>
  </>
);

export default Layout;
