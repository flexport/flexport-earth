import Breadcrumbs                  from 'components/breadcrumbs/breadcrumbs'

import getRestCountriesApiClient    from 'lib/data-sources/restcountries.com/api'
import getFlexportApiClient         from 'lib/data-sources/flexport/api'

type CountryCodeParams = {
    params: {
        cca2: string
    }
};

const countriesApi = getRestCountriesApiClient();

export async function generateStaticParams() {
    const paths = [{cca2: 'US'}];

    return paths;
}

async function getCountryInfo(params: CountryCodeParams) {
    const flexportApi     = await getFlexportApiClient();
    const countries       = await countriesApi.countries.getCountryByCountryCode(params.params.cca2);
    const country         = countries[0];
    const countrySeaports = await flexportApi.places.getSeaportsByCca2(params.params.cca2);

    return {
        country:      country,
        seaportCount: countrySeaports.ports.length
    };
}

export default async function CountryPage(params: CountryCodeParams) {
    const countryInfo = await getCountryInfo(params);

    return (
        <div>
            <Breadcrumbs currentPageName={countryInfo.country.name.common} />

            <h1>{countryInfo.country.name.common}</h1>

            <div>Number of Seaports: <span id="number-of-seaports">{countryInfo.seaportCount}</span></div>
        </div>
    )
}
