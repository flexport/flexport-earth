import Image                      from 'next/image'
import Link                       from 'next/link';

import Breadcrumbs                from 'components/breadcrumbs/breadcrumbs'

import getRestCountriesApiClient  from 'lib/data-sources/restcountries.com/api'
import { getFlexportApiClient }   from 'lib/data-sources/flexport/api'

import Styles                     from 'styles/facts/places/ports/index.module.css'
import SatelitePort               from 'public/images/satellite-port.png'

type CountryInfo = {
  countryName:      string,
  cca2CountryCode:  string,
  portCount:        number
}

async function getPorts() {
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
    countryMap.values()).sort((a, b) => a.countryName.localeCompare(b.countryName)
  );

  return {
      time:  new Date().toISOString(),
      ports: countriesSortedByPortCount
    };
}

export default async function PortsPage() {
  const ports = await getPorts();

  return (
    <div>
        <Breadcrumbs />

        <h1 className={Styles.title}>Ports</h1>

        <div className={Styles.pageTabs}>
          <span className={Styles.quantityPageTab}>
            <Link href='/facts/places/ports'>
              By quantity
            </Link>
          </span>
          <span className={Styles.selectedCountryPageTab}>
            By country
          </span>
        </div>

        <ol className={Styles.countriesList}>
          {ports.ports.map(({ countryName, cca2CountryCode, portCount }) => (
            <Link prefetch={false} key={cca2CountryCode} href={`/facts/places/ports/${cca2CountryCode}`}>
              <li className={Styles.port}>
              <div className={Styles.portBackground}>
                  <Image
                    src={SatelitePort}
                    alt="Satelite Port Background"
                    objectFit='cover'
                    layout='fill'
                  />
                </div>
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
        Data last refreshed @ { ports.time }
        <br/><br/>
    </div>
  )
}
