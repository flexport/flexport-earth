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
    const paths = [{params: {unlocode: 'USLAX'}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: UNLoCodeParams) {
    const flexportApi   = await getFlexportApiClient();
    const responseData  = await flexportApi.places.getPortByUnlocode(params.params.unlocode);
    const port          = responseData.ports[0];

    return {
      props: {
        port: port
      },
      revalidate: 3600
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
            <ul>
                <li>
                    Address:
                    <ul>
                        <li>Street Address: {params.port.address.street_address}</li>
                        <li>Street Address 2: {params.port.address.street_address2}</li>
                        <li>Locality: {params.port.address.locality}</li>
                        <li>Administrative Area: {params.port.address.administrative_area}</li>
                        <li>Time Zone: {params.port.address.time_zone}</li>
                        <li>Country Code: {params.port.address.country_code}</li>
                        <li>Postal Code: {params.port.address.postal_code}</li>
                        <li>Localized Address: {params.port.address.localized_address}</li>
                        <li>
                            Geo Location:
                            <ul>
                                <li>Latitude: {params.port.address.geo_location.latitude}</li>
                                <li>Longitude: {params.port.address.geo_location.longitude}</li>
                                <li>Altitude: {params.port.address.geo_location.altitude}</li>
                            </ul>
                        </li>
                    </ul>
                </li>
                <li>unlocode: {params.port.unlocode}</li>
                <li>IATA Code: {params.port.iata_code}</li>
                <li>CBP Port Code: {params.port.cbp_port_code}</li>
                <li>ICAO Code: {params.port.icao_code}</li>
            </ul>
        </Layout>
    )
}

export default CountryPage;
