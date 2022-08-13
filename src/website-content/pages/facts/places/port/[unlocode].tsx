import type { NextPage } from 'next'
import Layout from '../../../../components/layout'
import { getFlexportApiClient } from '../../../../lib/data-sources/flexport/api'
import { useRouter } from 'next/router'
import Image from 'next/image'
import Styles from '../../../../styles/facts/places/port/unlocode.module.css'
import Breadcrumbs from '../../../../components/breadcrumbs/breadcrumbs'
import Port from '../../../../lib/data-sources/flexport/facts/places/ports/port'

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

const PortDetailPage: NextPage<PortPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={params.port.name} selectMajorLink='ports'>
            <Breadcrumbs />

            <div className={Styles.portDetailHeader}>
                <div className={Styles.portDetailTitle}>
                    <Image
                        src={`https://assets.flexport.com/flags/svg/1/${params.port.address.country_code}.svg`}
                        alt={`${params.port.address.country_code} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{params.port.name} port</h1>
                </div>
            </div>

            <div className={Styles.portDetail}>
                <div className={Styles.portDetailLeft}>
                    <div className={Styles.portDetailSubTitle}>About this port</div>

                    <div className={Styles.portDetailSectionTitle}>
                        General
                    </div>

                    <div className={Styles.portDetailField}>
                        <div className={Styles.portDetailFieldName}>
                            Port name
                        </div>
                        <div className={Styles.portDetailFieldValue}>
                            {params.port.name}
                        </div>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Country
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.address.country_code}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Region/City
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.address.administrative_area}/{params.port.address.locality}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Address
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.address.street_address }
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            CBP Port code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.cbp_port_code}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            UNLoCode
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.unlocode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            IATA code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.iata_code}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            ICAO code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {params.port.icao_code}
                        </span>
                    </div>
                </div>

                <div className={Styles.portDetailRight}>
                    <div className={Styles.portDetailLocation}>
                        <div className={Styles.portDetailSectionTitle}>
                            Location
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                Latitude
                            </span>
                            <span className={Styles.portDetailFieldValue}>
                                {params.port.address.geo_location.latitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                Longitude
                            </span>
                            <span className={Styles.portDetailFieldValue}>
                                {params.port.address.geo_location.longitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                <a
                                    target='_blank'
                                    rel='noreferrer'
                                    href={`https://www.google.com/maps/search/?api=1&query=${params.port.address.geo_location.latitude},${params.port.address.geo_location.longitude}`}>
                                        View on map
                                </a>
                            </span>
                        </div>
                    </div>

                    <div className={Styles.pageDetailLearnMore}>
                        <div className={Styles.portDetailSectionTitle}>
                            Learn more about Flexport
                        </div>
                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                <a
                                    target='_blank'
                                    rel='noreferrer'
                                    href='https://www.flexport.com'>
                                        Visit website
                                </a>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </Layout>
    )
}

export default PortDetailPage;
