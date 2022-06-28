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

    const response = await (
        await fetch(
            oauthUrl,
            {
                method:  'POST',
                headers: headers,
                body:    body
            },
        )
    );

    return response.json();
}

export async function getFlexportApiClient() {
    const baseUrl = 'https://fpos-data-authority.dev-fpos-data-authority.nonp-dev-3.use1.eng-nonprod.flexport.internal';

    // TODO: Store access tokens for reuse.
    //       Only get new token if no existing token,
    //       or current token has expired.

    // const accessTokenResponse = await getAccessToken(
    //     baseUrl,
    //     process.env.FLEXPORT_API_CLIENT_ID,
    //     process.env.FLEXPORT_API_CLIENT_SECRET,
    // );

    return new ApiClient(
        baseUrl,
        ""  //accessTokenResponse.access_token
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

class places {
    private baseUrl:        string;
    private portsBaseUrl:   string;
    private headers:        Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl        = baseUrl;
        this.portsBaseUrl   = `${this.baseUrl}/v1/places/ports`;
        this.headers        = headers;
    }

    async getAllPortsPagedData(queryStringParameters: string): Promise<Ports> {
        let page:     PortsDataPage;
        let allPorts: Ports = { ports: [] };
        let url:      string = `${this.portsBaseUrl}?per=100&${queryStringParameters}`;

        // TODO: REMOVE THIS:
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

        do {
            //console.log('REQUESTING: ' + url);
            page = await (
                await fetch(
                    url,
                    { headers: this.headers },
                )
            ).json();

            //console.log('RECEIVED COUNT: ' + page.data.length)
            //console.log(page.data);
            allPorts.ports = allPorts.ports.concat(page.data);
            //console.log('TOTAL COUNT: ' + allPorts.ports.length)
            //console.log('NEXT PAGE: ' + page.next);

            url = `${this.baseUrl}${page.next}`
        } while (page.next);

        return allPorts;
    }

    async getSeaports(): Promise<Ports> {
        //console.log('GETTING ALL SEAPORTS');
        return await (this.getAllPortsPagedData(`types=SEAPORT`));
    }

    async getSeaportsByCca2(cca2: string): Promise<Ports> {
        //console.log('GETTING SEAPORT BY CCA2: ' + cca2);
        return await (this.getAllPortsPagedData(`types=SEAPORT&country_code=${cca2}`));
    }

    async getPortByUnlocode(unlocode: string): Promise<Ports> {
        //console.log('GETTING PORT BY UNLOCODE: ' + unlocode);
        return await (this.getAllPortsPagedData(`unlocode=${unlocode}`));
    }
}

export type PortsDataPage = {
    prev:  string,
    next:  string,
    total: number,
    data:  Port[]
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
    private baseUrl:        string;
    private vesselsBaseUrl: string;
    private headers:        Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl        = baseUrl;
        this.vesselsBaseUrl = `${this.baseUrl}/v1/vehicles/vessels`;
        this.headers        = headers;
    }

    async getAllVesselsPagedData(queryStringParameters: string = ""): Promise<Vessels> {
        let page:       VesselsDataPage;
        let allVessels: Vessels = { vessels: [] };
        let url:        string  = `${this.vesselsBaseUrl}?per=100&${queryStringParameters}`;

        // TODO: REMOVE THIS:
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

        do {
            console.log('REQUESTING: ' + url);
            page = await (
                await fetch(
                    url,
                    { headers: this.headers },
                )
            ).json();

            console.log('RECEIVED COUNT: ' + page.data.length)
            console.log(page.data);
            allVessels.vessels = allVessels.vessels.concat(page.data);
            console.log('TOTAL COUNT: ' + allVessels.vessels.length)
            console.log('NEXT PAGE: ' + page.next);

            url = `${this.baseUrl}${page.next}`
        } while (page.next);

        return allVessels;
    }

    async getVessels(): Promise<Vessels> {
        // TODO: REMOVE THIS:
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

        return await this.getAllVesselsPagedData();
    }

    async getVesselByMmsi(mmsi: number): Promise<Vessels> {
        // TODO: REMOVE THIS:
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

        return await this.getAllVesselsPagedData(`mmsi=${mmsi}`);
    }
}

export type VesselsDataPage = {
    prev:  string,
    next:  string,
    total: number,
    data:  Vessel[]
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