import Country from './country'

export function getRestCountriesApiClient() {
    const baseUrl = 'https://restcountries.com/v3.1';

    return new ApiClient(
        baseUrl
    );
}

export class ApiClient {
    countries: countries

    constructor(baseUrl: string) {
        this.countries = new countries(
            baseUrl
        );
    }
}

class countries {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    async getAllCountries(): Promise<Country[]> {
        return await (
            await fetch(`${this.baseUrl}/all`)
        ).json();
    }

    async getAllCountriesAsMap(): Promise<Map<string, Country>> {
        const countries = await this.getAllCountries();

        return new Map(
            countries.map(
                country => [country.cca2, country]
            )
        );
    }

    async getCountryByCountryCode(countryCode: string): Promise<Country[]> {
        return await (
            await fetch(`${this.baseUrl}/alpha/${countryCode}`)
        ).json();
    }
}

export default getRestCountriesApiClient;
