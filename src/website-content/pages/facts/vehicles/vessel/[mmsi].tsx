import type { NextPage } from 'next'
import Layout from '../../../../components/layout/layout'
import { getFlexportApiClient } from '../../../../lib/data-sources/flexport/api'
import { useRouter } from 'next/router'
import Styles from './mmsi.module.css'
import Image from 'next/image'
import Breadcrumbs from '../../../../components/breadcrumbs/breadcrumbs'
import Vessel from '../../../../lib/data-sources/flexport/facts/vehicles/vessels/vessel'
import VesselDetailHeaderBackground from '../../../../public/images/vessel-detail-header-background.png'

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
        <Layout title={params.vessel.name} selectMajorLink='vessels'>
            <Breadcrumbs
                currentPageName={params.vessel.name}
            />

            <div className={Styles.vesselDetailHeader}>
                <div className={Styles.VesselDetailHeaderBackgroundContainer}>
                    <Image
                        src={VesselDetailHeaderBackground}
                        alt="Vessel Header Background"
                        objectFit='cover'
                        layout='fill'
                    />
                </div>
                <div className={Styles.vesselDetailTitle}>
                    <Image
                        src={`https://assets.flexport.com/flags/svg/1/${params.vessel.registration_country_code}.svg`}
                        alt={`${params.vessel.registration_country_code} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{params.vessel.name}</h1>
                </div>
            </div>

            <div className={Styles.vesselDetail}>
                <div className={Styles.vesselDetailLeft}>
                    <div className={Styles.vesselDetailSubTitle}>About this vessel</div>

                    <div className={Styles.vesselDetailSectionTitle}>
                        General
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <div className={Styles.vesselDetailFieldName}>
                            Vessel name
                        </div>
                        <div className={Styles.vesselDetailFieldValue}>
                            {params.vessel.name}
                        </div>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            Flag state
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {params.vessel.registration_country_code}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            Carrier
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {params.vessel.carrier.carrier_name}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            IMO number
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {params.vessel.imo}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            MMSI number
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {params.vessel.mmsi}
                        </span>
                    </div>
                </div>

                <div className={Styles.vesselDetailRight}>
                    <div className={Styles.pageDetailLearnMore}>
                        <div className={Styles.vesselDetailSectionTitle}>
                            Learn more about Flexport
                        </div>
                        <div className={Styles.vesselDetailField}>
                            <span className={Styles.vesselDetailFieldName}>
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

export default VesselPage;
