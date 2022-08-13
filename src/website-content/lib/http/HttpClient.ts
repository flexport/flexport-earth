class HttpClient {
    baseUrl;
    headers;

    constructor(
        baseUrl:    string,
        headers?:   Headers)
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
        const headers = new Headers({
            'content-type': 'application/json'
        });

        const body = JSON.stringify(postPayload);

        const response = await fetch(
            `${this.baseUrl}${relativeUrl}`,
            {
                method:  'POST',
                headers: headers,
                body:    body
            },
        );

        return response;
    }
}

export default HttpClient;
