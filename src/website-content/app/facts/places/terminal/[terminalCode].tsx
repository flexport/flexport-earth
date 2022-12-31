import { useRouter }        from 'next/router'
import Image                from 'next/image'

import Breadcrumbs              from 'components/breadcrumbs/breadcrumbs'

import { getFlexportApiClient } from 'lib/data-sources/flexport/api'

import Styles                   from './terminalCode.module.css'
import PortSateliteBackground   from 'public/images/port-satelite-background.png'

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

async function getTerminal(params: TerminalCodeParams) {
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

    return terminalDetailPageViewModel;
}

export default async function PortDetailPage(params: TerminalCodeParams) {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <div>Loading...</div>
        )
    }

    const terminal = await getTerminal(params);

    return (
        <div>
            <Breadcrumbs
                currentPageName={terminal.general.terminalName}
                doNotLinkList={['Terminal']}
            />

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
                        src={`https://assets.flexport.com/flags/svg/1/${terminal.general.country}.svg`}
                        alt={`${terminal.general.country} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{terminal.general.terminalName} terminal</h1>
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
                            {terminal.general.terminalName}
                        </div>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Country
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.country}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Region/City
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.regionCity}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Address
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.address }
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Firms Code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.firmsCode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            UNLoCode
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.unlocode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            Terminal code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {terminal.general.terminalCode}
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
                                {terminal.location.latitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                Longitude
                            </span>
                            <span className={Styles.portDetailFieldValue}>
                                {terminal.location.longitude}
                            </span>
                        </div>

                        <div className={Styles.portDetailField}>
                            <span className={Styles.portDetailFieldName}>
                                <a
                                    target='_blank'
                                    rel='noreferrer'
                                    href={`https://www.google.com/maps/search/?api=1&query=${terminal.location.latitude},${terminal.location.longitude}`}>
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
        </div>
    )
}
