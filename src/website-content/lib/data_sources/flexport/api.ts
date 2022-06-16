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

class places {
    private baseUrl: string;
    private headers: Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl = `${baseUrl}/places/ports`;
        this.headers = headers;
    }

    async getSeaports(): Promise<Ports> {
        return await (
            await fetch(
                `${this.baseUrl}?types=SEAPORT`,
                { headers: this.headers },
            )
        ).json();
    }

    async getSeaportsByCca2(cca2: string): Promise<Ports> {
        return await (
            await fetch(
                `${this.baseUrl}?types=SEAPORT&country_code=${cca2}`,
                { headers: this.headers },
            )
        ).json();
    }

    async getPortByUnlocode(unlocode: string): Promise<Ports> {
        return await (
            await fetch(
                `${this.baseUrl}?unlocode=${unlocode}`,
                { headers: this.headers },
            )
        ).json();
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
    cbp_port_code:  string
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
    private baseUrl: string;
    private headers: Headers;

    constructor(baseUrl: string, headers: Headers) {
        this.baseUrl = `${baseUrl}/vehicles/vessels`;
        this.headers = headers;
    }

    async getVessels(): Promise<Vessels> {
        return await (
            await fetch(
                this.baseUrl,
                { headers: this.headers },
            )
        ).json();
    }

    async getVesselByMmsi(mmsi: number): Promise<Vessels> {
        const json = await (
            await fetch(
                `${this.baseUrl}?mmsi=${mmsi}`,
                { headers: this.headers },
            )
        ).json();

        console.log(json);

        return json;
    }
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