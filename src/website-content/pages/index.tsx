import type { NextPage } from 'next'

import Homepage                   from '../components/homepage/homepage'

import getRestCountriesApiClient  from '../lib/data-sources/restcountries.com/api'
import { getFlexportApiClient }   from '../lib/data-sources/flexport/api'

type CountryInfo = {
  countryName:      string,
  cca2CountryCode:  string,
  portCount:        number
}

export async function getServerSideProps() {
  const countriesApi = getRestCountriesApiClient();
  const flexportApi  = await getFlexportApiClient();
  const countries    = await countriesApi.countries.getAllCountriesAsMap();

  const cca2CountryPortsToHighlight = [
    'CN',
    'US',
    'SG',
    'KR',
    'MY',
    'JP'
  ]

  let countryMap: CountryInfo[] = [];

  for (let i = 0; i < cca2CountryPortsToHighlight.length; i++) {
    let cca2CountryCode = cca2CountryPortsToHighlight[i];

    const ports = (await flexportApi.places.getSeaportsByCca2(cca2CountryCode)).ports;

    let country = countries.get(cca2CountryCode)

    if (!country) {
      throw `Country not found for country code '${cca2CountryCode}'.`
    }

    const countryPorts: CountryInfo = {
      countryName:      country.name.common,
      cca2CountryCode:  cca2CountryCode,
      portCount:        ports.length
    };

      countryMap.push(
        countryPorts
      );
  }

  return {
    props: {
      countryPortsToHighlight: countryMap
    }
  };
}

type HomepageViewModel = {
  countryPortsToHighlight: CountryInfo[]
}

const Home: NextPage<HomepageViewModel> = ({ countryPortsToHighlight}) => {
  return (
    <Homepage
      countryPortsToHighlight={countryPortsToHighlight}
    />
  )
}

export default Home
