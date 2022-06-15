import type { NextPage } from 'next'
import Link from 'next/link';
import Layout from '../../../components/layout'
import Country from '../../../lib/data_sources/restcountries.com/country'
import getRestCountriesApiClient from '../../../lib/data_sources/restcountries.com/api'

export async function getStaticProps() {
  const countriesApi = getRestCountriesApiClient();
  const countries    = await countriesApi.countries.getAllCountries();

  return {
    props: {
      countries: countries.map(country => ({
        name: ({ common: country.name.common }),
        cca2: country.cca2
      }))
    },
  };
}

type Countries = {
  countries: Country[]
}

const CountriesPage: NextPage<Countries> = ({countries}) => {
  return (
    <Layout title='Countries' h1='Countries'>
        <ol>
          {countries.sort((a, b) => a.name.common.localeCompare(b.name.common)).map(({ name, cca2 }) => (
              <li key={name.common}>
                <Link href={`/facts/countries/${cca2}`}>{name.common}</Link>
              </li>
            ))}
        </ol>
    </Layout>
  )
}

export default CountriesPage;
