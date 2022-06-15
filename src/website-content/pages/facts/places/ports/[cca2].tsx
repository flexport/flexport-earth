import type { NextPage } from 'next'
import Layout from '../../../../components/layout'
import { getFlexportApiClient, Port, Ports } from '../../../../lib/data_sources/flexport/api'
import { useRouter } from 'next/router'
import Link from 'next/link'

type Cca2Params = {
    params: {
        cca2: string
    }
};

type PortsByCountryPageParams = {
    cca2:  string,
    ports: Ports,
}

export async function getStaticPaths() {
    const paths = [{params: {cca2: 'US'}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: Cca2Params) {
    const flexportApi   = await getFlexportApiClient();
    const responseData  = await flexportApi.places.getSeaportsByCca2(params.params.cca2);

    return {
      props: {
        cca2:   params.params.cca2,
        ports:  responseData
      },
      revalidate: 3600
    }
}

const CountryPage: NextPage<PortsByCountryPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={`${params.cca2} Ports`} h1={`${params.cca2} Ports`}>
            <ol>
                {params.ports.ports.map(({ name, unlocode }) => (
                <li key={name}>
                    <Link prefetch={false} href={`/facts/places/port/${unlocode}`}>{name}</Link>
                </li>
                ))}
            </ol>
        </Layout>
    )
}

export default CountryPage;
