class HttpClient {
    baseUrl;
    headers;

    constructor(
        baseUrl:    string,
        headers:    Headers = new Headers())
    {
        this.baseUrl = baseUrl;
        this.headers = headers;
    }

    async Get(
        relativeUrlWithQueryString: string)
    {
        return fetch(
            `${this.baseUrl}${relativeUrlWithQueryString}`,
            { headers: this.headers }
        );
    }

    async PostJson(
        relativeUrl:    string,
        postPayload:    object)
    {
        this.headers.set(
            'content-type',
            'application/json'
        );

        const body = JSON.stringify(postPayload);

        return fetch(
            `${this.baseUrl}${relativeUrl}`,
            {
                method:  'POST',
                headers: this.headers,
                body:    body
            },
        );
    }
}

export default HttpClient;
