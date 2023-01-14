import { Suspense }               from 'react'

import Link                       from 'next/link'
import Image                      from 'next/image'

import Breadcrumbs                from 'components/breadcrumbs/breadcrumbs'

import { getFlexportApiClient }   from 'lib/data-sources/flexport/api'
import getRestCountriesApiClient  from 'lib/data-sources/restcountries.com/api'

import SatelitePort               from 'public/images/satellite-port.png'
import Styles                     from 'styles/facts/places/ports/index.module.css'

type Cca2Params = {
    params: {
        cca2: string
    }
};

type AdministrativeAreaPorts = {
  administrativeAreaCode: string,
  ports:                  AdministrativeAreaPortListItem[]
}

type AdministrativeAreaPortListItem = {
  portName: string,
  unlocode: string
}

async function getCountryInfo(cca2: string) {
    const countriesApi          = getRestCountriesApiClient();
    const flexportApi           = await getFlexportApiClient();
    const portsResponseData     = await flexportApi.places.getSeaportsByCca2(cca2);
    const countryResponseData   = await countriesApi.countries.getCountryByCountryCode(cca2);

    // Sort raw data by administrative area, port name:
    const sortedPorts = portsResponseData.ports.sort(
        function (a, b) {
            return a.address.administrative_area.localeCompare(b.address.administrative_area) ||
                a.name.localeCompare(b.name);
        }
    );

    // Transform raw data to page view model:
    const previousAdministrativeArea = null;
    const administrativeAreaPortsMap = new Map<string, AdministrativeAreaPorts>();

    for (let i = 0; i < sortedPorts.length; i++) {
      const currentPort                   = sortedPorts[i];
      let   currentPortAdministrativeArea = currentPort.address.administrative_area;

      if (previousAdministrativeArea != currentPortAdministrativeArea) {
        let currentAdministrativeAreaPorts: AdministrativeAreaPorts | undefined;

        if (administrativeAreaPortsMap.has(currentPortAdministrativeArea)) {
          currentAdministrativeAreaPorts = administrativeAreaPortsMap.get(currentPortAdministrativeArea);
        } else {
          currentAdministrativeAreaPorts = {
            administrativeAreaCode: currentPortAdministrativeArea  == '' ? 'Not Specified' : currentPortAdministrativeArea,
            ports:                  []
          };

          administrativeAreaPortsMap.set(
            currentPortAdministrativeArea,
            currentAdministrativeAreaPorts
          );
        }

        currentAdministrativeAreaPorts?.ports.push({
          portName: currentPort.name,
          unlocode: currentPort.unlocode
        });
      }
    }

    return {
        cca2:           cca2,
        countryName:    countryResponseData[0].name.common,
        statesAndPorts: Array.from(administrativeAreaPortsMap.values())
    };
}

export default async function PortsByCountryPage(params: Cca2Params) {
    const countryInfo = await getCountryInfo(params.params.cca2);

    return (
        <div>
          <Breadcrumbs
            currentPageName={countryInfo.countryName}
          />

          <h1 className={Styles.title}>{countryInfo.countryName} ports</h1>

          <div className={Styles.pageTabs}>
            <span className={Styles.selectedRegionStatePageTab}>
              By Region/State
            </span>
          </div>

          <div>
            {countryInfo.statesAndPorts.map(({ administrativeAreaCode, ports }) => (

            <div key={administrativeAreaCode} className={Styles.stateSection}>
              <div className={Styles.administrativeAreaTitle}>{administrativeAreaCode}</div>

              <ol className={`${Styles.countriesList}`}>
                {ports.map(({ portName, unlocode }) => (
                    <Link key={unlocode} prefetch={false} href={`/facts/places/port/${unlocode}`}>

                      <li id={`port-${unlocode}`} className={Styles.port}>
                        <div className={Styles.portBackground}>
                          <Image
                            src={SatelitePort}
                            alt="Satelite Port Background"
                            objectFit='cover'
                            layout='fill'
                          />
                        </div>
                        <Image
                          src={`https://assets.flexport.com/flags/svg/1/${countryInfo.cca2}.svg`}
                          alt={`${countryInfo.cca2} Flag`}
                          height={32}
                          width={32}
                        />
                        <div>
                          {portName} port
                        </div>
                      </li>
                    </Link>
                ))}
              </ol>
            </div>
            ))}
          </div>
        </div>
    )
}
