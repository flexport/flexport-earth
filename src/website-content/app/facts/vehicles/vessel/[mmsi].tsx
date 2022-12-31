import Image                from 'next/image'
import { useRouter }        from 'next/router'

import Breadcrumbs                  from 'components/breadcrumbs/breadcrumbs'

import { getFlexportApiClient }     from 'lib/data-sources/flexport/api'

import Styles                       from './mmsi.module.css'
import VesselDetailHeaderBackground from 'public/images/vessel-detail-header-background.png'

type MMSIParams = {
    params: {
        mmsi: number
    }
};

export async function getStaticPaths() {
    const paths = [{params: {mmsi: "353136000"}}];

    return {
        paths,
        fallback: true
    }
}

async function getVessel(params: MMSIParams) {
    const flexportApi   = await getFlexportApiClient();
    const responseData  = await flexportApi.vehicles.getVesselByMmsi(params.params.mmsi);
    const vessel        = responseData.vessels[0];

    return vessel;
}

export default async function VesselPage(params: MMSIParams) {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <div>Loading...</div>
        )
    }

    const vessel = await getVessel(params);

    return (
        <div>
            <Breadcrumbs
                currentPageName={vessel.name}
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
                        src={`https://assets.flexport.com/flags/svg/1/${vessel.registration_country_code}.svg`}
                        alt={`${vessel.registration_country_code} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{vessel.name}</h1>
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
                            {vessel.name}
                        </div>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            Flag state
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {vessel.registration_country_code}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            Carrier
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {vessel.carrier.carrier_name}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            IMO number
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {vessel.imo}
                        </span>
                    </div>

                    <div className={Styles.vesselDetailField}>
                        <span className={Styles.vesselDetailFieldName}>
                            MMSI number
                        </span>
                        <span className={Styles.vesselDetailFieldValue}>
                            {vessel.mmsi}
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
        </div>
    )
}
