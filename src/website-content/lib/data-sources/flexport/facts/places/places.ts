import HttpClient from '../../../../http/HttpClient';
import DataPaging from '../../paging/DataPaging';

import Port  from './ports/port'
import Ports from './ports/ports'

class places {
    private portsRelativeBaseUrl:   string;
    private httpClient:             HttpClient;

    constructor(
        authenticatedHttpClient:    HttpClient)
    {
        this.portsRelativeBaseUrl   = '/places/ports';
        this.httpClient             = authenticatedHttpClient;
    }

    async getSeaports(): Promise<Ports> {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.httpClient,
                        this.portsRelativeBaseUrl,
                        `types=SEAPORT`
                    )
        };

        return ports;
    }

    async getSeaportsByCca2(
        cca2: string): Promise<Ports>
    {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.httpClient,
                        this.portsRelativeBaseUrl,
                        `types=SEAPORT&country_code=${cca2}`
                    )
        };

        return ports;
    }

    async getPortByUnlocode(
        unlocode: string): Promise<Ports>
    {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.httpClient,
                        this.portsRelativeBaseUrl,
                        `types=SEAPORT&unlocode=${unlocode}`
                    )
        };

        return ports;
    }
}

export default places;
