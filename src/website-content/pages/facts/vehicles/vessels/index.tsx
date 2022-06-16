import type { NextPage } from 'next'
import { getFlexportApiClient, Vessel } from '../../../../lib/data_sources/flexport/api'
import Layout from '../../../../components/layout'
import Link from 'next/link';
import Styles from '../../../../styles/facts/vehicles/vessels/index.module.css'

export async function getStaticProps() {
  const flexportApi   = await getFlexportApiClient();
  const responseData  = await flexportApi.vehicles.getVessels()

  return {
    props: {
      time: new Date().toISOString(),
      vessels: responseData.vessels.map(vessel => ({ name: vessel.name, mmsi: vessel.mmsi }))
    },
    revalidate: 3600
  };
}

type Vessels = {
  time: string,
  vessels: [{
    name: string,
    mmsi: number
  }]
}

const VesselsPage: NextPage<Vessels> = ({vessels, time}) => {
  return (
    <Layout title='Vessels' h1='Vessels'>
        <ol>
          {vessels.map(({ name, mmsi }) => (
              <li key={name} className={Styles.vessel}>
                <Link prefetch={false} href={`/facts/vehicles/vessel/${mmsi}`}><div id={`port-${mmsi}`}>{name}</div></Link>
              </li>
            ))}
        </ol>
        <br/>
        Data refreshed @ { time }
    </Layout>
  )
}

export default VesselsPage
