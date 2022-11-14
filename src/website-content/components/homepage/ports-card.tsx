import Image                        from 'next/image'
import Link                         from 'next/link'

import Styles from                  './ports-card.module.css'

import PortIcon                     from 'public/images/icon-port.svg'
import RightChevron                 from 'public/images/right-chevron.svg'

export type PortsCardCountryInfo = {
    countryName:      string,
    cca2CountryCode:  string,
    portCount:        number
}

const PortsCard = ({countries}: {countries: PortsCardCountryInfo[]}) => {

    return (
    <div className={Styles.portsSection}>
        <a id="all-ports-link" href='facts/places/ports'>
            <div className={Styles.portsLink}>
            <Image
                src={PortIcon}
                alt="Port Icon"
                height={26}
                width={26}
            />

            <span className={Styles.portsSectionTitle}>Ports</span>

            <span className={Styles.rightChevron}>
                <Image
                src={RightChevron}
                alt="Right Chevron"
                height={14}
                width={14}
                />
            </span>
            </div>
        </a>

        <div className={Styles.portCountries}>
            {
                countries.map(({ countryName, cca2CountryCode,portCount }) => (
                    <Link key={cca2CountryCode} href={`facts/places/ports/${cca2CountryCode}`}>
                        <div className={Styles.portCountry}>
                            <Image
                                src={`https://assets.flexport.com/flags/svg/1/${cca2CountryCode}.svg`}
                                alt={`${countryName} flag`}
                                height={16}
                                width={16}
                            />

                            <span className={Styles.portCountryText}>{countryName} ports ( {portCount} )</span>
                        </div>
                    </Link>
                ))
            }
        </div>
    </div>
  );
}

export default PortsCard;