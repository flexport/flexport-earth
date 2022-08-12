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
}

export default HttpClient;
