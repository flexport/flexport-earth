import HttpClient from '../../../http/HttpClient';
import AccessTokenRequestBody   from './access-token-request-body'
import AccessTokenResponse      from './access-token-response'

class FlexportOAuthClient {
    httpClient:   HttpClient
    clientId:     string;
    clientSecret: string;

    constructor(
        apiBaseUrl:   string,
        clientId:     string,
        clientSecret: string)
    {
        this.httpClient     = new HttpClient(apiBaseUrl);
        this.clientId       = clientId;
        this.clientSecret   = clientSecret;
    }

    async getAccessToken(): Promise<AccessTokenResponse>
    {
        const oauthRelativePath = '/oauth/token';

        const postPayload = new AccessTokenRequestBody(
            this.clientId,
            this.clientSecret
        );

        const response = await this.httpClient.PostJson(
            oauthRelativePath,
            postPayload
        );

        return response.json();
    }
}

export default FlexportOAuthClient;
