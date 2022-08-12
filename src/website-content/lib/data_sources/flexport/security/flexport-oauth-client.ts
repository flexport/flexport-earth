import AccessTokenRequestBody   from './access-token-request-body'
import AccessTokenResponse      from './access-token-response'

class FlexportOAuthClient {
    apiBaseUrl:   string;
    clientId:     string;
    clientSecret: string;

    constructor(
        apiBaseUrl:   string,
        clientId:     string,
        clientSecret: string)
    {
        this.apiBaseUrl     = apiBaseUrl;
        this.clientId       = clientId;
        this.clientSecret   = clientSecret;
    }

    async getAccessToken(): Promise<AccessTokenResponse>
    {
        const oauthUrl = `${this.apiBaseUrl}/oauth/token`
        const headers  = new Headers({
            'content-type': 'application/json'
        });

        const body = JSON.stringify(
            new AccessTokenRequestBody(
                this.clientId,
                this.clientSecret
            )
        );

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
}

export default FlexportOAuthClient;
