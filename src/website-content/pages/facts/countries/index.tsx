import type { NextPage } from 'next'
import Link from 'next/link';
import Layout from '../../../components/layout'

export async function getStaticProps() {
  const countries = await (await fetch('https://restcountries.com/v3.1/all')).json();

  return {
    props: {
      countries,
    },
  };
}

type Countries = {
  countries: [{
    name: {
      common: string
    },
    cca2: string
  }]
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

export default CountriesPage
