import type { NextPage } from 'next'
import { getFlexportApiClient, Vessel } from '../../../../lib/data_sources/flexport/api'
import Layout from '../../../../components/layout'
import Link from 'next/link';
import Styles from '../../../../styles/facts/vehicles/vessels/index.module.css'
import Image from 'next/image'
import Breadcrumbs from '../../../../components/breadcrumbs'

function truncate(
  stringToTruncate: string,
  maxLength:        number)
{
  if (stringToTruncate.length > maxLength) {
    stringToTruncate = stringToTruncate.substring(0, maxLength - 3);
    stringToTruncate += '...';
  }

  return stringToTruncate;
}

export async function getStaticProps() {
  const flexportApi   = await getFlexportApiClient();
  const responseData  = await flexportApi.vehicles.getVessels()

  return {
    props: {
      time:     new Date().toISOString(),
      vessels:  responseData.vessels.map(vessel => ({
                  name:         vessel.name,
                  mmsi:         vessel.mmsi,
                  cca2:         vessel.registration_country_code,
                  carrierName:  truncate(vessel.carrier.carrier_name, 15)
                }))
    },
    revalidate: 3600
  };
}

type Vessels = {
  time: string,
  vessels: [{
    name:         string,
    mmsi:         number,
    cca2:         string,
    carrierName:  string
  }]
}

const VesselsPage: NextPage<Vessels> = ({vessels, time}) => {
  return (
    <Layout title='Vessels' selectMajorLink='vessels'>
      <Breadcrumbs />

      <h1 className={Styles.allVesselsTitle}>All Vessels</h1>

      <ol className={Styles.vesselsList}>
        {vessels.map(({ name, mmsi, cca2, carrierName }) => (
            <li key={name} className={Styles.vessel}>
                <Link prefetch={false} href={`/facts/vehicles/vessel/${mmsi}`}>
                  <div id={`vessel-${mmsi}`} className={Styles.vesselLink}>
                    <div className={Styles.vesselThumbnail}>
                      <Image
                        src={'/images/thumbnail-container-ship.png'}
                        alt="Container Ship Thumbnail"
                        width={132}
                        height={92}
                      />
                    </div>
                    <div className={Styles.vesselInfo}>
                      <div className={Styles.vesselTitle}>
                        <Image
                          src={`https://assets.flexport.com/flags/svg/1/${cca2}.svg`}
                          alt={`${cca2} Flag`}
                          height={24}
                          width={24}
                        />
                        &nbsp;&nbsp;&nbsp;
                        {name}
                      </div>
                      <div className={Styles.vesselDetail}>
                        <div className={Styles.vesselListField}>
                          <div className={Styles.vesselListFieldName}>
                            Carrier
                          </div>
                          <div className={Styles.vesselListFieldValue}>
                            {carrierName}
                          </div>
                        </div>

                        <div className={Styles.vesselListField}>
                          <div className={Styles.vesselListFieldName}>
                            Country
                          </div>
                          <div className={Styles.vesselListFieldValue}>
                            {cca2}
                          </div>
                        </div>

                        <div className={Styles.vesselListField}>
                          <div className={Styles.vesselListFieldName}>
                            MMSI
                          </div>
                          <div className={Styles.vesselListFieldValue}>
                            {mmsi}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </Link>
            </li>
          ))}
      </ol>

      <div className={Styles.clear} />

      Data refreshed @ { time }

      <br/><br/>

    </Layout>
  )
}

export default VesselsPage
