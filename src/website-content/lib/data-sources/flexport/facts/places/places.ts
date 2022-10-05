import HttpClient from '../../../../http/HttpClient';
import DataPaging from '../../paging/DataPaging';

import Port  from './ports/port'
import Ports from './ports/ports'

import Terminal  from './terminals/terminal'
import Terminals from './terminals/terminals'

class places {
    private portsRelativeBaseUrl:       string;
    private terminalsRelativeBaseUrl:   string;

    private httpClient:             HttpClient;

    constructor(
        authenticatedHttpClient:    HttpClient)
    {
        this.portsRelativeBaseUrl       = '/places/ports';
        this.terminalsRelativeBaseUrl   = '/places/terminals'

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

    async getTerminalsByUnlocode(
        unlocode: string): Promise<Terminals>
    {
        const terminals = {
            terminals:  await DataPaging.getAllPagedData<Terminal>(
                        this.httpClient,
                        this.terminalsRelativeBaseUrl,
                        `unlocode=${unlocode}`
                    )
        };

        return terminals;
    }

    async getTerminalByTerminalCode(
        terminalCode: string): Promise<Terminals>
    {
        const terminals = {
            terminals:  await DataPaging.getAllPagedData<Terminal>(
                        this.httpClient,
                        this.terminalsRelativeBaseUrl,
                        `terminal_code=${terminalCode}`
                    )
        };

        return terminals;
    }
}

export default places;
