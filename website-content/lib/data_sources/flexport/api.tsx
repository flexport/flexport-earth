export function getApiClient() {
    const baseUrl = 'https://api.flexport.com';

    return new ApiClient(
        baseUrl,
        process.env.FLEXPORT_API_ACCESSTOKEN
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

    async getSeaports() {
        return await (
            await fetch(
                `${this.baseUrl}?types=SEAPORT`,
                { headers: this.headers },
            )
        ).json();
    }
}

export default getApiClient;