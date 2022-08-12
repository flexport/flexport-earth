import FlexportOAuthClient      from './security/flexport-oauth-client'

import places                   from './facts/places/places'
import vehicles                 from './facts/vehicles/vehicles'
import HttpClient               from '../../http/HttpClient'

// This is the factory function that the rest of the codebase
// should use to get an instance of the FlexportApiClient.
export async function getFlexportApiClient() {
    const baseUrl = 'https://api.flexport.com';

    // Step 1: Get an authenticated HttpClient that can be used for API calls.

    const oAuthClient = new FlexportOAuthClient(
        baseUrl,
        process.env.FLEXPORT_API_CLIENT_ID,
        process.env.FLEXPORT_API_CLIENT_SECRET
    );

    // TODO: EARTH-107: Store access tokens for reuse.
    //       Only get new token if no existing token,
    //       or current token has expired.

    const response = await oAuthClient.getAccessToken();

    return new FlexportApiV1Client(
        baseUrl,
        response.access_token
    );
}

export class FlexportApiV1Client {
    places:   places
    vehicles: vehicles

    constructor(baseUrl: string, accessToken: string) {
        const headers = new Headers({
            'Authorization':    `Bearer ${accessToken}`,
            'Flexport-Version': '1'
        });

        const httpClient = new HttpClient(
            baseUrl,
            headers
        );

        this.places = new places(
            httpClient
        );

        this.vehicles = new vehicles(
            httpClient
        );
    }
}

export default getFlexportApiClient;
