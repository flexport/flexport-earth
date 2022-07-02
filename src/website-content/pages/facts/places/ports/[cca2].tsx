import type { NextPage } from 'next'
import Layout from '../../../../components/layout'
import { getFlexportApiClient, Port, Ports } from '../../../../lib/data_sources/flexport/api'
import { useRouter } from 'next/router'
import Link from 'next/link'
import Image from 'next/image'
import Styles from '../../../../styles/facts/places/ports/index.module.css'
import getRestCountriesApiClient from '../../../../lib/data_sources/restcountries.com/api'

type Cca2Params = {
    params: {
        cca2: string
    }
};

type PortsByCountryPageParams = {
    cca2:           string,
    countryName:    string,
    ports:          Port[],
}

export async function getStaticPaths() {
    const paths = [{params: {cca2: 'US'}}];

    return {
        paths,
        fallback: true
    }
}

export async function getStaticProps(params: Cca2Params) {
    const countriesApi          = getRestCountriesApiClient();
    const flexportApi           = await getFlexportApiClient();
    const portsResponseData     = await flexportApi.places.getSeaportsByCca2(params.params.cca2);
    const countryResponseData   = await countriesApi.countries.getCountryByCountryCode(params.params.cca2);

    console.log('portsResponseData:');
    console.log(portsResponseData);
    console.log('');

    // Sort by administrative area, port name.
    const sortedPorts = portsResponseData.ports.sort(
        function (a, b) {
            return a.address.administrative_area.localeCompare(b.address.administrative_area) ||
                a.name.localeCompare(b.name);
        }
    );

    console.log('sortedPorts:');
    console.log(sortedPorts);
    console.log('');

    return {
      props: {
        cca2:           params.params.cca2,
        countryName:    countryResponseData[0].name.common,
        ports:          sortedPorts
      },
      revalidate: 3600
    }
}

const PortsByCountryPage: NextPage<PortsByCountryPageParams> = (params) => {
    const router = useRouter();

    if (router.isFallback) {
        return (
            <Layout>Loading...</Layout>
        )
    }

    return (
        <Layout title='Ports' selectMajorLink='ports'>
        <div className={Styles.breadcrumbs}>
          <Link href='/'>Wiki</Link>&nbsp;&nbsp;&nbsp;
          <Image
            src="/images/right-chevron.svg"
            alt="Right Chevron"
            height={10}
            width={10}
          />
          &nbsp;&nbsp;&nbsp;<Link href='/facts/places/ports'>Ports</Link>&nbsp;&nbsp;&nbsp;
          <Image
            src="/images/right-chevron.svg"
            alt="Right Chevron"
            height={10}
            width={10}
          />
          &nbsp;&nbsp;&nbsp;{params.cca2} Ports
        </div>

        <h1 className={Styles.title}>{params.countryName} ports</h1>

        <div className={Styles.pageTabs}>
          <span className={Styles.selectedRegionStatePageTab}>
            By Region/State
          </span>
        </div>

        <ol className={Styles.countriesList}>
          {params.ports.map(({ name, unlocode }) => (
            <Link prefetch={false} key={unlocode} href={`/facts/places/port/${unlocode}`}>
              <li id={`port-${unlocode}`} className={Styles.port}>
                <Image
                  src={`https://assets.flexport.com/flags/svg/1/${params.cca2}.svg`}
                  alt={`${params.cca2} Flag`}
                  height={32}
                  width={32}
                />
                <div>
                  {name} port
                </div>
              </li>
            </Link>
          ))}
        </ol>
        <div className={Styles.clear}></div>
        Data last refreshed @ { new Date().toISOString() }
        <br/><br/>
    </Layout>
    )
}

export default PortsByCountryPage;
