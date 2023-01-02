import Image                    from 'next/image'
import Link                     from 'next/link';

import Breadcrumbs              from 'components/breadcrumbs/breadcrumbs'

import { getFlexportApiClient } from 'lib/data-sources/flexport/api'
import PortSateliteBackground   from 'public/images/port-satelite-background.png'

import Styles                   from './unlocode.module.css'

type UNLoCodeParams = {
    params: {
        unlocode: string
    }
};

type TerminalViewModel = {
    terminalCode: string,
    terminalName: string
}

type PortDetailPageViewModel = {
    general: {
        portName:       string,
        country:        string,
        regionCity:     string,
        address:        string,
        cbpPortCode:    string,
        unlocode:       string,
        iataCode:       string,
        icaoCode:       string
    },
    location: {
        latitude:       string,
        longitude:      string
    }
    terminals: TerminalViewModel[]
}

export async function getStaticPaths() {

    // getStaticPaths executes at BUILD TIME.

    // Instead of getting and building all ports at BUILD TIME (which would take a long time)
    // we're just building one here for sake of verifying the functionality works at BUILD TIME.
    // All the other ports will be generated at RUN TIME on-demand.

    // USPCV == Port Canaveral.
    // Nothing special about this port, it was chosen simply because it's a popular port.
    const testPortUnlocode = 'USPCV';

    const paths = [{params: {unlocode: testPortUnlocode}}];

    return {
        paths,
        fallback: true
    }
}

async function getPort(params: UNLoCodeParams) {
    const flexportApi       = await getFlexportApiClient();

    const responseDataPort      = await flexportApi.places.getPortByUnlocode(params.params.unlocode);
    const responseDataTerminals = await flexportApi.places.getTerminalsByUnlocode(params.params.unlocode);

    const flexportApiPort       = responseDataPort.ports[0];
    const flexportApiTerminals  = responseDataTerminals.terminals;

    const portDetailPageViewModel: PortDetailPageViewModel = {
        general: {
            portName:   flexportApiPort.name,
            country:    flexportApiPort.address.country_code,
            regionCity: `${flexportApiPort.address.administrative_area}/${flexportApiPort.address.locality}`,
            address:    flexportApiPort.address.street_address,
            cbpPortCode:flexportApiPort.cbp_port_code,
            unlocode:   flexportApiPort.unlocode,
            iataCode:   flexportApiPort.iata_code,
            icaoCode:   flexportApiPort.icao_code
        },
        terminals:      flexportApiTerminals.map((terminal) => { return {
                            terminalCode: terminal.terminal_code,
                            terminalName: terminal.name
                        } } ),
        location: {
            latitude:   flexportApiPort.address.geo_location.latitude,
            longitude:  flexportApiPort.address.geo_location.longitude
        }
    }

    const cachePageDurationSeconds = 86400;

    return portDetailPageViewModel;
}

export default async function PortDetailPage(params: UNLoCodeParams) {
    const port = await getPort(params);

    return (
        <div>
            <Breadcrumbs
                currentPageName={port.general.portName}
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
                        src={`https://assets.flexport.com/flags/svg/1/${port.general.country}.svg`}
                        alt={`${port.general.country} Flag`}
                        height={32}
                        width={32}
                    />

                    <h1>{port.general.portName} port</h1>
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
                            {port.general.portName}
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
                            CBP Port code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.cbpPortCode}
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
                            IATA code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.iataCode}
                        </span>
                    </div>

                    <div className={Styles.portDetailField}>
                        <span className={Styles.portDetailFieldName}>
                            ICAO code
                        </span>
                        <span className={Styles.portDetailFieldValue}>
                            {port.general.icaoCode}
                        </span>
                    </div>

                    {port.terminals.map(({ terminalName, terminalCode }) => (
                        <div key={terminalName}>
                            <div className={Styles.portDetailSectionSpacer}></div>

                            <Link
                                prefetch={false}
                                key={terminalCode}
                                id={`terminal-${terminalCode}`}
                                className={Styles.portDetailSectionTitle}
                                href={`/facts/places/terminal/${terminalCode}`}
                            >
                                Terminal: {terminalName}
                            </Link>
                        </div>
                    ))}
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
        </div>
    )
}
