import type { NextPage } from 'next'
import Layout from '../../../components/layout'

type CountryCodeParams = {
    params: {
        cca2: string
    }
}

async function getAllCountryCodes() {
    const responseData: Countries = await (
        await fetch('https://restcountries.com/v3.1/all')
    ).json();

    return responseData.map(country => {
        return {
            params: {
                cca2: country.cca2
            }
        }
    });
}

async function getCountryData(cca2: string) {
    const json = await (
        await fetch('https://restcountries.com/v3.1/alpha/' + cca2)
    ).json();

    return json;
}

export async function getStaticPaths() {
    const paths = await getAllCountryCodes()
    return {
        paths,
        fallback: false
    }
}

export async function getStaticProps(params: CountryCodeParams) {
    const postData = await getCountryData(params.params.cca2);

    return {
      props: {
        time: new Date().toISOString(),
        ...postData[0]
      },
      revalidate: 10
    }
}

type Countries = [{
    name: {
      common: string
    },
    cca2: string
}]

type Country = {
    name: {
        common: string
    },
    cca2: string,
    time: string
}

const CountryPage: NextPage<Country> = (country) => {
  return (
    <Layout title={country.name.common} h1={country.name.common}>
        {country.time}
    </Layout>
  )
}

export default CountryPage
