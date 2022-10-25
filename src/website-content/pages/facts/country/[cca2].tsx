import type { NextPage } from 'next'
import Layout from '../../../components/layout/layout'
import Country from '../../../lib/data-sources/restcountries.com/country'
import getRestCountriesApiClient from '../../../lib/data-sources/restcountries.com/api'
import getFlexportApiClient from '../../../lib/data-sources/flexport/api'
import { useRouter } from 'next/router'
import Breadcrumbs from '../../../components/breadcrumbs/breadcrumbs'

type CountryCodeParams = {
    params: {
        cca2: string
    }
};

type Countries = Country[];

type CountryPageParams = {
    country:      Country,
    seaportCount: number
}

const countriesApi = getRestCountriesApiClient();

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
    const paths = [{params: {cca2: 'US'}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: CountryCodeParams) {
    const flexportApi     = await getFlexportApiClient();
    const countries       = await countriesApi.countries.getCountryByCountryCode(params.params.cca2);
    const country         = countries[0];
    const countrySeaports = await flexportApi.places.getSeaportsByCca2(params.params.cca2);

    return {
      props: {
        country:      country,
        seaportCount: countrySeaports.ports.length
      },
      revalidate: 3600
    }
}

const CountryPage: NextPage<CountryPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={params.country.name.common}>
            <Breadcrumbs />

            <h1>{params.country.name.common}</h1>

            <div>Number of Seaports: <span id="number-of-seaports">{params.seaportCount}</span></div>
        </Layout>
    )
}

export default CountryPage;
