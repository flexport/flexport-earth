import Link                       from 'next/link';
import Breadcrumbs                from 'components/breadcrumbs/breadcrumbs'

import getRestCountriesApiClient  from 'lib/data-sources/restcountries.com/api'

async function getCountries() {
  const countriesApi = getRestCountriesApiClient();
  const countries    = await countriesApi.countries.getAllCountries();

  return countries.map(country => ({
      name: ({ common: country.name.common }),
      cca2: country.cca2
    }));
}

export default async function CountriesPage() {
  const countries = await getCountries();

  return (
    <div>
      <Breadcrumbs />

      <h1>Countries</h1>

      <ol>
        {countries.sort((a, b) => a.name.common.localeCompare(b.name.common)).map(({ name, cca2 }) => (
            <li key={name.common}>
              <Link prefetch={false} href={`/facts/country/${cca2}`}>{name.common}</Link>
            </li>
          ))}
      </ol>
    </div>
  )
}
