import type { NextPage } from 'next'
import Layout from '../../../components/layout'
import Country from '../../../lib/data_sources/restcountries.com/country'
import getApiClient from '../../../lib/data_sources/restcountries.com/api'

type CountryCodeParams = {
    params: {
        cca2: string
    }
};

type Countries = Country[];

const countriesApi = getApiClient();

async function getAllCountryCodes() {
    const responseData: Countries = await countriesApi.countries.getAllCountries();

    return responseData.map(country => {
        return {
            params: {
                cca2: country.cca2
            }
        }
    });
}

export async function getStaticPaths() {
    const paths = await getAllCountryCodes()
    return {
        paths,
        fallback: false
    }
}

export async function getStaticProps(params: CountryCodeParams) {
    const countries = await countriesApi.countries.getCountryByCountryCode(params.params.cca2);

    return {
      props: {
        ...countries[0]
      },
      revalidate: 10
    }
}

const CountryPage: NextPage<Country> = (country) => {
  return (
    <Layout title={country.name.common} h1={country.name.common}>
        {new Date().toISOString()}
    </Layout>
  )
}

export default CountryPage;
