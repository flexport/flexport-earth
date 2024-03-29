import type { NextPage }  from 'next'
import Image              from 'next/image'
import Link               from 'next/link';

import Layout                   from 'components/layout/layout'
import Breadcrumbs              from 'components/breadcrumbs/breadcrumbs'

import { getFlexportApiClient } from 'lib/data-sources/flexport/api'

import Styles                   from 'styles/facts/vehicles/vessels/index.module.css'
import ShipThumbnail            from 'public/images/thumbnail-container-ship.png'

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

  const maxCarrierNameLength = 15;

  return {
    props: {
      time:     new Date().toISOString(),
      vessels:  responseData.vessels.map(vessel => ({
                  name:         vessel.name,
                  mmsi:         vessel.mmsi,
                  cca2:         vessel.registration_country_code,
                  carrierName:  truncate(
                                  vessel.carrier?.carrier_name ?? '', // TODO: EARTH-288: Unit test.
                                  maxCarrierNameLength
                                )
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
                        src={ShipThumbnail}
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

      {vessels.length} vessels refreshed @ { time }

      <br/><br/>

    </Layout>
  )
}

export default VesselsPage
