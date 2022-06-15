import type { NextPage } from 'next'
import Layout from '../../../../components/layout'
import { getFlexportApiClient, Port } from '../../../../lib/data_sources/flexport/api'
import { useRouter } from 'next/router'

type UNLoCodeParams = {
    params: {
        unlocode: string
    }
};

type PortPageParams = {
    port: Port,
}

export async function getStaticPaths() {
    const paths = [{params: {unlocode: 'ARAFA'}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: UNLoCodeParams) {
    const flexportApi   = await getFlexportApiClient();
    const responseData  = await flexportApi.places.getPortByUnlocode(params.params.unlocode);
    const port          = responseData.ports[0];

    console.log(port);

    return {
      props: {
        port: port
      },
      revalidate: 900
    }
}

const CountryPage: NextPage<PortPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={params.port.name} h1={params.port.name}>

        </Layout>
    )
}

export default CountryPage;
