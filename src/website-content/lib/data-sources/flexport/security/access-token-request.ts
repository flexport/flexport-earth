class AccessTokenRequest {
    client_id:     string;
    client_secret: string;
    audiance:      string;
    grant_type:    string;

    constructor(
        client_id:     string,
        client_secret: string)
    {
        this.client_id     = client_id;
        this.client_secret = client_secret;
        this.audiance      = 'https://api.flexport.com';
        this.grant_type    = 'client_credentials';
    }
}

export default AccessTokenRequest;
