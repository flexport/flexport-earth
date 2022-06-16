import type { NextPage } from 'next'
import Layout from '../../../../components/layout'
import { getFlexportApiClient, Vessel } from '../../../../lib/data_sources/flexport/api'
import { useRouter } from 'next/router'

type MMSIParams = {
    params: {
        mmsi: number
    }
};

type VesselPageParams = {
    vessel: Vessel,
}

export async function getStaticPaths() {
    const paths = [{params: {mmsi: "353136000"}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: MMSIParams) {
    const flexportApi   = await getFlexportApiClient();
    const responseData  = await flexportApi.vehicles.getVesselByMmsi(params.params.mmsi);
    const vessel        = responseData.vessels[0];

    return {
      props: {
        vessel: vessel
      },
      revalidate: 3600
    }
}

const VesselPage: NextPage<VesselPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={params.vessel.name} h1={params.vessel.name}>
            <ul>
                <li>MMSI: {params.vessel.mmsi}</li>
                <li>IMO: {params.vessel.imo}</li>
                <li>Registration Country Code: {params.vessel.registration_country_code}</li>
                <li>Carrier: {params.vessel.carrier.carrier_name}</li>
            </ul>
        </Layout>
    )
}

export default VesselPage;
