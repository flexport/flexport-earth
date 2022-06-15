import type { NextPage } from 'next'
import { getFlexportApiClient, Port } from '../../../../lib/data_sources/flexport/api'
import Layout from '../../../../components/layout'
import Link from 'next/link';

export async function getStaticProps() {
  const flexportApi = await getFlexportApiClient();
  const seaports    = await flexportApi.places.getSeaports()

  return {
    props: {
      time: new Date().toISOString(),
      ports: seaports.ports.map(port => ({ name: port.name, unlocode: port.unlocode }))
    },
    revalidate: 3600
  };
}

type Ports = {
  time: string,
  ports: [{
    name:     string,
    unlocode: string
  }]
}

const PortsPage: NextPage<Ports> = ({ports, time}) => {
  return (
    <Layout title='Ports' h1='Ports'>
        <ol>
          {ports.map(({ name, unlocode }) => (
              <li key={name}>
                <Link prefetch={false} href={`/facts/places/port/${unlocode}`}>{name}</Link>
              </li>
            ))}
        </ol>
        <br/>
        Data refreshed @ { time }
    </Layout>
  )
}

export default PortsPage