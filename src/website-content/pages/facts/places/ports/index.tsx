import type { NextPage } from 'next'
import { getFlexportApiClient } from '../../../../lib/data-sources/flexport/api'
import Layout from '../../../../components/layout'
import Link from 'next/link';
import Styles from '../../../../styles/facts/places/ports/index.module.css'
import Image from 'next/image'
import getRestCountriesApiClient from '../../../../lib/data-sources/restcountries.com/api'
import Breadcrumbs from '../../../../components/breadcrumbs/breadcrumbs'

type CountryInfo = {
  countryName:      string,
  cca2CountryCode:  string,
  portCount:        number
}

export async function getStaticProps() {
  const countriesApi = getRestCountriesApiClient();
  const countries    = await countriesApi.countries.getAllCountriesAsMap();
  const flexportApi  = await getFlexportApiClient();
  const seaports     = await flexportApi.places.getSeaports()

  let countryMap = new Map<string, CountryInfo>();

  for (let i = 0; i < seaports.ports.length; i++) {
    let port          = seaports.ports[i];
    let countryPorts  = countryMap.get(port.address.country_code);

    if (!countryPorts) {
      const cca2CountryCode = port.address.country_code;
      let country           = countries.get(cca2CountryCode)

      if (!country) {
        throw `Country not found for country code '${cca2CountryCode}'.`
      }

      countryPorts = {
        countryName:      country.name.common,
        cca2CountryCode:  cca2CountryCode,
        portCount:        0
      };

      countryMap.set(
        cca2CountryCode,
        countryPorts
      );
    }

    countryPorts.portCount++;
  }

  const countriesSortedByPortCount = Array.from(
    countryMap.values()).sort((a, b) => b.portCount - a.portCount
  );

  return {
    props: {
      time:  new Date().toISOString(),
      ports: countriesSortedByPortCount
    },
    revalidate: 3600
  };
}

type Ports = {
  time:  string,
  ports: CountryInfo[]
}

const PortsPage: NextPage<Ports> = ({ports, time}) => {
  return (
    <Layout title='Ports' selectMajorLink='ports'>
        <Breadcrumbs />

        <h1 className={Styles.title}>Ports</h1>

        <div className={Styles.pageTabs}>
          <span className={Styles.selectedQuantityPageTab}>
            By quantity
          </span>
          <span className={Styles.countryPageTab}>
            <Link href='/facts/places/ports/by-country'>By country</Link>
          </span>
        </div>

        <ol className={Styles.countriesList}>
          {ports.map(({ countryName, cca2CountryCode, portCount }) => (
            <Link prefetch={false} key={cca2CountryCode} href={`/facts/places/ports/${cca2CountryCode}`}>
              <li id={`country-${cca2CountryCode}`} className={Styles.port}>
                <Image
                  src={`https://assets.flexport.com/flags/svg/1/${cca2CountryCode}.svg`}
                  alt={`${cca2CountryCode} Flag`}
                  height={32}
                  width={32}
                />
                <div id={`country-${cca2CountryCode}`}>
                  {countryName} ports ( {portCount} )
                </div>
              </li>
            </Link>
          ))}
        </ol>
        <br/>
        Data last refreshed @ { time }
        <br/><br/>
    </Layout>
  )
}

export default PortsPage
