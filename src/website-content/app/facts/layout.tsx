import Image                from 'next/image'
import Link                 from 'next/link';

import Styles               from './layout.module.css'

import Footer               from 'components/footer/footer'
import BetaIcon             from 'components/beta-icon/beta-icon';

import FlexportLogo         from 'public/images/flexport-logo.svg'

type Props = {
  children:         React.ReactNode;
  title?:           string;
  selectMajorLink?: string;
};

const Layout = ({
    children,
    selectMajorLink
  }: Props) => (
    <>
    <div className={Styles.container}>
      <header className={Styles.pageHeader}>
        <div className={Styles.pageHeaderContent}>
          <div className={Styles.pageWikiTitle}>
              <a href="https://www.flexport.com">
                <Image
                  src={FlexportLogo}
                  alt="Flexport Logo"
                  height={36}
                  width={106}
                />
              </a>

              <span id="wiki-title-vertical-line" className={Styles.wikiTitleVerticalLine} />

              <span id="wiki-subtitle" className={Styles.wikiSubTitle}>
                <Link href="/">Wiki</Link>
              </span>
          </div>

          <BetaIcon
            className         = {Styles.betaIcon}
            popupClassName    = {Styles.betaIconPopup}
            pointerClassName  = {Styles.betaIconPopupPointer}
          />

          <div className={Styles.majorLinks}>
            <Link href='/facts/places/ports'>
              <div className={selectMajorLink == 'ports' ? Styles.selectedMajorLink : ""}>
                Ports
              </div>
            </Link>
            <Link href='/facts/vehicles/vessels'>
              <div className={selectMajorLink == 'vessels' ? Styles.selectedMajorLink : ""}>
                Vessels
              </div>
            </Link>
            <Link href=''>
              <div className={selectMajorLink == 'containers' ? Styles.selectedMajorLink : ""}>
                Containers
              </div>
            </Link>
          </div>
        </div>
      </header>

      <main className={Styles.main}>

        {children}

      </main>

      <Footer/>
    </div>
  </>
);

export default Layout;
