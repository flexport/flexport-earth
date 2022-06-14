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

export async function getApiClient() {
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
    places: places

    constructor(baseUrl: string, accessToken: string) {
        const headers = new Headers({
            'Authorization':    `Bearer ${accessToken}`,
            'Flexport-Version': '1'
        });

        this.places = new places(
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
}

export type Ports = {
    ports: Port[]
}

export type Port = {
    name: string
}

export default getApiClient;