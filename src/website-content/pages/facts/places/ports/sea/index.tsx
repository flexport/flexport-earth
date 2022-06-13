import type { NextPage } from 'next'
import getApiClient from '../../../../../lib/data_sources/flexport/api'
import Layout from '../../../../../components/layout'

export async function getStaticProps() {
  const flexportApi = await getApiClient();
  const ports = await flexportApi.places.getSeaports()

  return {
    props: {
      time: new Date().toISOString(),
      ...ports,
    },
    revalidate: 60
  };
}

type Ports = {
  time: string,
  ports: [{
    name: string
  }]
}

const SeaportsPage: NextPage<Ports> = ({ports, time}) => {
  return (
    <Layout title='Seaports' h1='Seaports'>

        { time }

        <ol>
          {ports.map(({ name }) => (
              <li key={name}>
                {name}
              </li>
            ))}
        </ol>
    </Layout>
  )
}

export default SeaportsPage
