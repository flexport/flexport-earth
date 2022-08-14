import HttpClient   from '../../../http/HttpClient';
import DataPage     from './DataPage'

class DataPaging {
    static async getAllPagedData<DataType>(
        httpClient:             HttpClient,
        relativeUrl:            string,
        queryStringParameters:  string = ""
    ): Promise<DataType[]> {
        let page:                       DataPage<DataType>;
        let allData:                    DataType[]    = [];
        let relativeUrlWithQueryString: string        = `${relativeUrl}?${queryStringParameters}&per=100`;

        do {
            const response = await httpClient.Get(
                relativeUrlWithQueryString
            );

            page    = JSON.parse(await response.text());
            allData = allData.concat(page.data);

            relativeUrlWithQueryString = page.next;
        } while (page.next);

        return allData;
    }
}

export default DataPaging;
