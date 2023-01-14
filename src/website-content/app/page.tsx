import Homepage                   from 'components/homepage/homepage'

import getRestCountriesApiClient  from 'lib/data-sources/restcountries.com/api'
import { getFlexportApiClient }   from 'lib/data-sources/flexport/api'

type CountryInfo = {
  countryName:      string,
  cca2CountryCode:  string,
  portCount:        number
}

async function getCountryPorts(
  cca2CountryPortsToHighlight: string[])
{
  const countriesApi = getRestCountriesApiClient();
  const countries    = await countriesApi.countries.getAllCountriesAsMap();

  const flexportApi  = await getFlexportApiClient();

  console.log();
  console.log('getCountryPorts');
  console.log();

  let countryMap: CountryInfo[] = [];

  for (let i = 0; i < cca2CountryPortsToHighlight.length; i++) {
    let cca2CountryCode = cca2CountryPortsToHighlight[i];

    console.log();
    console.log(`Processing ${cca2CountryCode}`);
    console.log();

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

  return countryMap;
}

type HomepageViewModel = {
  countryPortsToHighlight: CountryInfo[]
}

export default async function HomePage () {
  const cca2CountryPortsToHighlight = [
    'CN',
    'US',
    'SG',
    'KR',
    'MY',
    'JP'
  ];

  const countryPortsToHighlight = await getCountryPorts(
    cca2CountryPortsToHighlight
  );

  return (
    <Homepage
      countryPortsToHighlight={countryPortsToHighlight}
    />
  )
}
