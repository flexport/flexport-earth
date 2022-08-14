import DataPaging   from '../../paging/DataPaging';
import HttpClient   from '../../../../http/HttpClient';

import Vessels      from './vessels/vessels'
import Vessel       from './vessels/vessel'

class vehicles {
    private vesselsRelativeBaseUrl: string;
    private httpClient:             HttpClient;

    constructor(
        authenticatedHttpClient:      HttpClient)
    {
        this.vesselsRelativeBaseUrl = `/vehicles/vessels`;
        this.httpClient             = authenticatedHttpClient;
    }

    async getVessels(): Promise<Vessels> {
        const vessels = {
            vessels:  await DataPaging.getAllPagedData<Vessel>(
                        this.httpClient,
                        this.vesselsRelativeBaseUrl
                    )
        };

        return vessels;
    }

    async getVesselByMmsi(
        mmsi: number): Promise<Vessels>
    {
        const vessels = {
            vessels:  await DataPaging.getAllPagedData<Vessel>(
                        this.httpClient,
                        this.vesselsRelativeBaseUrl,
                        `mmsi=${mmsi}`
                    )
        };

        return vessels;
    }
}

export default vehicles;
