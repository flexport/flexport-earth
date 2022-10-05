import type { NextPage } from 'next'
import Layout from '../../../../components/layout/layout'
import { getFlexportApiClient } from '../../../../lib/data-sources/flexport/api'
import { useRouter } from 'next/router'
import Image from 'next/image'
import Styles from '../../../../styles/facts/places/port/unlocode.module.css'
import Breadcrumbs from '../../../../components/breadcrumbs/breadcrumbs'
import Terminal from '../../../../lib/data-sources/flexport/facts/places/terminals/terminal'
import PortSateliteBackground from '../../../../public/images/port-satelite-background.png'

type TerminalCodeParams = {
    params: {
        terminalCode: string
    }
};

type TerminalDetailPageViewModel = {
    general: {
        terminalName:   string,
        country:        string,
        regionCity:     string,
        address:        string,
        unlocode:       string,
        firmsCode:      string,
        terminalCode:   string
    },
    location: {
        latitude:       number,
        longitude:      number
    }
}

export async function getStaticPaths() {

    // getStaticPaths executes at BUILD TIME.

    // Instead of getting and building all ports at BUILD TIME (which would take a long time)
    // we're just building one here for sake of verifying the functionality works at BUILD TIME.
    // All the other ports will be generated at RUN TIME on-demand.

    // USPCV-CTT == CT2 Terminal.
    // Nothing special about this terminal.
    const testTerminalCode = 'USPCV-CTT';

    const paths = [{params: {terminalCode: testTerminalCode}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: TerminalCodeParams) {
    const flexportApi           = await getFlexportApiClient();
    const responseData          = await flexportApi.places.getTerminalByTerminalCode(params.params.terminalCode);
    const flexportApiTerminal   = responseData.terminals[0];

    const terminalDetailPageViewModel: TerminalDetailPageViewModel = {
        general: {
            terminalName:   flexportApiTerminal.name,
            country:        flexportApiTerminal.address.country_code,
            regionCity:     `${flexportApiTerminal.address.administrative_area}/${flexportApiTerminal.address.locality}`,
            address:        flexportApiTerminal.address.street_address,
            terminalCode:   flexportApiTerminal.terminal_code,
            unlocode:       flexportApiTerminal.unlocode,
            firmsCode:      flexportApiTerminal.firms_code
        },
        location: {
            latitude:   flexportApiTerminal.address.geo_location.latitude,
            longitude:  flexportApiTerminal.address.geo_location.longitude
        }
    }

    const cachePageDurationSeconds = 86400;

    return {
      props: {
        ...terminalDetailPageViewModel
      },
      revalidate: cachePageDurationSeconds
    }
}

const PortDetailPage: NextPage<TerminalDetailPageViewModel> = (port) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title={port.general.terminalName} selectMajorLink='terminals'>
            <Breadcrumbs />

            <div className={Styles.portDetailHeader}>
                <div className={Styles.PortSateliteBackgroundContainer}>
                    <Image
                        src={PortSateliteBackground}
                        alt="Satelite image of a Port"
                        objectFit='cover'
                        layout='fill'
                    />
                </div>
                <div className={Styles.portDetailTitle}>
                    <Image
                        src={`https://assets.flexport.com/flags/svg/1/${port.general.country}.svg`}
                        alt={`${port.general.country} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{port.general.terminalName} terminal</h1>
                </div>
            </div>

            <div className={Styles.portDetail}>
                <div className={Styles.portDetailLeft}>
                    <div className={Styles.portDetailSubTitle}>About this terminal</div>

                    <div className={Styles.portDetailSectionTitle}>
                        General
                    </div>

                    <div className={Styles.portDetailField}>
                        <div className={Styles.portDetailFieldName}>
                            Port name
                        </div>
                        <div className={Styles.portDetailFieldValue}>
                            {port.general.terminalName}
                        </div>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Country
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.country}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Region/City
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.regionCity}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Address
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.address }
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Firms Code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.firmsCode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            UNLoCode
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.unlocode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Terminal code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.terminalCode}
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
                                {port.location.latitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                Longitude
                            </span>
                            <span className={Styles.portDetailFieldValue}>
                                {port.location.longitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                <a
                                    target='_blank'
                                    rel='noreferrer'
                                    href={`https://www.google.com/maps/search/?api=1&query=${port.location.latitude},${port.location.longitude}`}>
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
            <div className={Styles.portDetailSectionSpacer}></div>
        </Layout>
    )
}

export default PortDetailPage;
