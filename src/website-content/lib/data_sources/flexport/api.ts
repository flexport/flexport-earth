class AccessTokenRequestBody {
    client_id:     string;
    client_secret: string;
    audiance:      string;
    grant_type:    string;

    constructor(
        client_id:     string,
        client_secret: string
    )
    {
        this.client_id     = client_id;
        this.client_secret = client_secret;
        this.audiance      = 'https://api.flexport.com';
        this.grant_type    = 'client_credentials';
    }
}

type AccessTokenResponse = {
    access_token: string,
    expires_in:   number,
    token_type:   string
}

async function getAccessToken(
    apiBaseUrl:   string,
    clientId:     string,
    clientSecret: string): Promise<AccessTokenResponse>
{
    const oauthUrl = `${apiBaseUrl}/oauth/token`
    const headers  = new Headers({
        'content-type': 'application/json'
    });

    const body = JSON.stringify(new AccessTokenRequestBody(clientId, clientSecret));

    const response = await fetch(
        oauthUrl,
        {
            method:  'POST',
            headers: headers,
            body:    body
        },
    );

    return response.json();
}

export async function getFlexportApiClient() {
    const baseUrl = 'https://api.flexport.com';

    // TODO: Store access tokens for reuse.
    //       Only get new token if no existing token,
    //       or current token has expired.

    const accessTokenResponse = await getAccessToken(
        baseUrl,
        process.env.FLEXPORT_API_CLIENT_ID,
        process.env.FLEXPORT_API_CLIENT_SECRET,
    );

    return new ApiClient(
        baseUrl,
        accessTokenResponse.access_token
    );
}

export class ApiClient {
    places:   places
    vehicles: vehicles

    constructor(baseUrl: string, accessToken: string) {
        const headers = new Headers({
            'Authorization':    `Bearer ${accessToken}`,
            'Flexport-Version': '1'
        });

        this.places = new places(
            baseUrl,
            headers
        );

        this.vehicles = new vehicles(
            baseUrl,
            headers
        );
    }
}

class DataPaging {
    static async getAllPagedData<DataType>(
        headers:                Headers,
        baseUrl:                string,
        relativeUrl:            string,
        queryStringParameters:  string = ""
    ): Promise<DataType[]> {
        let page:     DataPage<DataType>;
        let allData:  DataType[]    = [];
        let url:      string        = `${baseUrl}${relativeUrl}?${queryStringParameters}&per=100`;

        do {
            const rawText = await (
                await fetch(
                    url,
                    { headers: headers },
                )
            ).text();

            page    = JSON.parse(rawText);
            allData = allData.concat(page.data);

            url = `${baseUrl}${page.next}`
        } while (page.next);

        return allData;
    }
}

class places {
    private baseUrl:                string;
    private portsRelativeBaseUrl:   string;
    private headers:                Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl                = baseUrl;
        this.portsRelativeBaseUrl   = '/places/ports';
        this.headers                = headers;
    }

    async getSeaports(): Promise<Ports> {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.headers,
                        this.baseUrl,
                        this.portsRelativeBaseUrl,
                        `types=SEAPORT`
                    )
        };

        return ports;
    }

    async getSeaportsByCca2(cca2: string): Promise<Ports> {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.headers,
                        this.baseUrl,
                        this.portsRelativeBaseUrl,
                        `types=SEAPORT&country_code=${cca2}`
                    )
        };

        return ports;
    }

    async getPortByUnlocode(unlocode: string): Promise<Ports> {
        const ports = {
            ports:  await DataPaging.getAllPagedData<Port>(
                        this.headers,
                        this.baseUrl,
                        this.portsRelativeBaseUrl,
                        `unlocode=${unlocode}`
                    )
        };

        return ports;
    }
}

export type Ports = {
    ports: Port[]
}

export type Port = {
    name:           string,
    iata_code:      string,
    icao_code:      string,
    unlocode:       string,
    cbp_port_code:  string,
    address: {
        street_address:         string,
        street_address2:        string,
        locality:               string,
        administrative_area:    string,
        time_zone:              string,
        country_code:           string,
        geo_location: {
            latitude:   string,
            longitude:  string,
            altitude:   string
        },
        postal_code:        string,
        localized_address:  string
    }
}

class vehicles {
    private baseUrl:                string;
    private vesselsRelativeBaseUrl: string;
    private headers:                Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl                = baseUrl;
        this.vesselsRelativeBaseUrl = `/vehicles/vessels`;
        this.headers                = headers;
    }

    async getVessels(): Promise<Vessels> {
        const vessels = {
            vessels:  await DataPaging.getAllPagedData<Vessel>(
                        this.headers,
                        this.baseUrl,
                        this.vesselsRelativeBaseUrl
                    )
        };

        return vessels;
    }

    async getVesselByMmsi(mmsi: number): Promise<Vessels> {
        const vessels = {
            vessels:  await DataPaging.getAllPagedData<Vessel>(
                        this.headers,
                        this.baseUrl,
                        this.vesselsRelativeBaseUrl,
                        `mmsi=${mmsi}`
                    )
        };

        return vessels;
    }
}

export type DataPage<DataType> = {
    prev:  string,
    next:  string,
    total: number,
    data:  DataType[]
}

export type Vessels = {
    vessels: Vessel[]
}

export type Vessel = {
    name:                       string,
    mmsi:                       number,
    imo:                        number,
    registration_country_code:  string,
    carrier: {
        carrier_name: string,
    }
}

export default getFlexportApiClient;