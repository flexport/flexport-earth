import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import styles from '/styles/Home.module.css'

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Flexport Earth: Countries</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header className={styles.pageHeader}>
            <div className={styles.pageWikiTitle}>
                <a id="flexport-logo" href="https://www.flexport.com"><Image src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90} /></a>
                <span id="wiki-title-vertical-line" className={styles.wikiTitleVerticalLine}></span>
                <span id="wiki-subtitle" className={styles.wikiSubTitle}>Wiki</span><br/>
            </div>     
      </header>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Countries
        </h1>

        <ol>
          <li>Afghanistan</li>
          <li>Åland Islands</li>
          <li>Albania</li>
          <li>Algeria</li>
          <li>American Samoa</li>
          <li>Andorra</li>
          <li>Angola</li>
          <li>Anguilla</li>
          <li>Antarctica</li>
          <li>Antigua and Barbuda</li>
          <li>Argentina</li>
          <li>Armenia</li>
          <li>Aruba</li>
          <li>Australia</li>
          <li>Austria</li>
          <li>Azerbaijan</li>
          <li>Bahamas (the)</li>
          <li>Bahrain</li>
          <li>Bangladesh</li>
          <li>Barbados</li>
          <li>Belarus</li>
          <li>Belgium</li>
          <li>Belize</li>
          <li>Benin</li>
          <li>Bermuda</li>
          <li>Bhutan</li>
          <li>Bolivia (Plurinational State of)</li>
          <li>Bonaire, Sint Eustatius and Saba</li>
          <li>Bosnia and Herzegovina</li>
          <li>Botswana</li>
          <li>Bouvet Island</li>
          <li>Brazil</li>
          <li>British Indian Ocean Territory (the)</li>
          <li>Brunei Darussalam</li>
          <li>Bulgaria</li>
          <li>Burkina Faso</li>
          <li>Burundi</li>
          <li>Cabo Verde</li>
          <li>Cambodia</li>
          <li>Cameroon</li>
          <li>Canada</li>
          <li>Cayman Islands (the)</li>
          <li>Central African Republic (the)</li>
          <li>Chad</li>
          <li>Chile</li>
          <li>China</li>
          <li>Christmas Island</li>
          <li>Cocos (Keeling) Islands (the)</li>
          <li>Colombia</li>
          <li>Comoros (the)</li>
          <li>Congo (the Democratic Republic of the)</li>
          <li>Congo (the)</li>
          <li>Cook Islands (the)</li>
          <li>Costa Rica</li>
          <li>Croatia</li>
          <li>Cuba</li>
          <li>Curaçao</li>
          <li>Cyprus</li>
          <li>Czechia</li>
          <li>Côte d&apos;Ivoire</li>
          <li>Denmark</li>
          <li>Djibouti</li>
          <li>Dominica</li>
          <li>Dominican Republic (the)</li>
          <li>Ecuador</li>
          <li>Egypt</li>
          <li>El Salvador</li>
          <li>Equatorial Guinea</li>
          <li>Eritrea</li>
          <li>Estonia</li>
          <li>Eswatini</li>
          <li>Ethiopia</li>
          <li>Falkland Islands (the) [Malvinas]</li>
          <li>Faroe Islands (the)</li>
          <li>Fiji</li>
          <li>Finland</li>
          <li>France</li>
          <li>French Guiana</li>
          <li>French Polynesia</li>
          <li>French Southern Territories (the)</li>
          <li>Gabon</li>
          <li>Gambia (the)</li>
          <li>Georgia</li>
          <li>Germany</li>
          <li>Ghana</li>
          <li>Gibraltar</li>
          <li>Greece</li>
          <li>Greenland</li>
          <li>Grenada</li>
          <li>Guadeloupe</li>
          <li>Guam</li>
          <li>Guatemala</li>
          <li>Guernsey</li>
          <li>Guinea</li>
          <li>Guinea-Bissau</li>
          <li>Guyana</li>
          <li>Haiti</li>
          <li>Heard Island and McDonald Islands</li>
          <li>Holy See (the)</li>
          <li>Honduras</li>
          <li>Hong Kong</li>
          <li>Hungary</li>
          <li>Iceland</li>
          <li>India</li>
          <li>Indonesia</li>
          <li>Iran (Islamic Republic of)</li>
          <li>Iraq</li>
          <li>Ireland</li>
          <li>Isle of Man</li>
          <li>Israel</li>
          <li>Italy</li>
          <li>Jamaica</li>
          <li>Japan</li>
          <li>Jersey</li>
          <li>Jordan</li>
          <li>Kazakhstan</li>
          <li>Kenya</li>
          <li>Kiribati</li>
          <li>Korea (the Democratic People&apos;s Republic of)</li>
          <li>Korea (the Republic of)</li>
          <li>Kuwait</li>
          <li>Kyrgyzstan</li>
          <li>Lao People&apos;s Democratic Republic (the)</li>
          <li>Latvia</li>
          <li>Lebanon</li>
          <li>Lesotho</li>
          <li>Liberia</li>
          <li>Libya</li>
          <li>Liechtenstein</li>
          <li>Lithuania</li>
          <li>Luxembourg</li>
          <li>Macao</li>
          <li>Madagascar</li>
          <li>Malawi</li>
          <li>Malaysia</li>
          <li>Maldives</li>
          <li>Mali</li>
          <li>Malta</li>
          <li>Marshall Islands (the)</li>
          <li>Martinique</li>
          <li>Mauritania</li>
          <li>Mauritius</li>
          <li>Mayotte</li>
          <li>Mexico</li>
          <li>Micronesia (Federated States of)</li>
          <li>Moldova (the Republic of)</li>
          <li>Monaco</li>
          <li>Mongolia</li>
          <li>Montenegro</li>
          <li>Montserrat</li>
          <li>Morocco</li>
          <li>Mozambique</li>
          <li>Myanmar</li>
          <li>Namibia</li>
          <li>Nauru</li>
          <li>Nepal</li>
          <li>Netherlands (the)</li>
          <li>New Caledonia</li>
          <li>New Zealand</li>
          <li>Nicaragua</li>
          <li>Niger (the)</li>
          <li>Nigeria</li>
          <li>Niue</li>
          <li>Norfolk Island</li>
          <li>Northern Mariana Islands (the)</li>
          <li>Norway</li>
          <li>Oman</li>
          <li>Pakistan</li>
          <li>Palau</li>
          <li>Palestine, State of</li>
          <li>Panama</li>
          <li>Papua New Guinea</li>
          <li>Paraguay</li>
          <li>Peru</li>
          <li>Philippines (the)</li>
          <li>Pitcairn</li>
          <li>Poland</li>
          <li>Portugal</li>
          <li>Puerto Rico</li>
          <li>Qatar</li>
          <li>Republic of North Macedonia</li>
          <li>Romania</li>
          <li>Russian Federation (the)</li>
          <li>Rwanda</li>
          <li>Réunion</li>
          <li>Saint Barthélemy</li>
          <li>Saint Helena, Ascension and Tristan da Cunha</li>
          <li>Saint Kitts and Nevis</li>
          <li>Saint Lucia</li>
          <li>Saint Martin (French part)</li>
          <li>Saint Pierre and Miquelon</li>
          <li>Saint Vincent and the Grenadines</li>
          <li>Samoa</li>
          <li>San Marino</li>
          <li>Sao Tome and Principe</li>
          <li>Saudi Arabia</li>
          <li>Senegal</li>
          <li>Serbia</li>
          <li>Seychelles</li>
          <li>Sierra Leone</li>
          <li>Singapore</li>
          <li>Sint Maarten (Dutch part)</li>
          <li>Slovakia</li>
          <li>Slovenia</li>
          <li>Solomon Islands</li>
          <li>Somalia</li>
          <li>South Africa</li>
          <li>South Georgia and the South Sandwich Islands</li>
          <li>South Sudan</li>
          <li>Spain</li>
          <li>Sri Lanka</li>
          <li>Sudan (the)</li>
          <li>Suriname</li>
          <li>Svalbard and Jan Mayen</li>
          <li>Sweden</li>
          <li>Switzerland</li>
          <li>Syrian Arab Republic</li>
          <li>Taiwan (Province of China)</li>
          <li>Tajikistan</li>
          <li>Tanzania, United Republic of</li>
          <li>Thailand</li>
          <li>Timor-Leste</li>
          <li>Togo</li>
          <li>Tokelau</li>
          <li>Tonga</li>
          <li>Trinidad and Tobago</li>
          <li>Tunisia</li>
          <li>Turkey</li>
          <li>Turkmenistan</li>
          <li>Turks and Caicos Islands (the)</li>
          <li>Tuvalu</li>
          <li>Uganda</li>
          <li>Ukraine</li>
          <li>United Arab Emirates (the)</li>
          <li>United Kingdom of Great Britain and Northern Ireland (the)</li>
          <li>United States Minor Outlying Islands (the)</li>
          <li>United States of America (the)</li>
          <li>Uruguay</li>
          <li>Uzbekistan</li>
          <li>Vanuatu</li>
          <li>Venezuela (Bolivarian Republic of)</li>
          <li>Viet Nam</li>
          <li>Virgin Islands (British)</li>
          <li>Virgin Islands (U.S.)</li>
          <li>Wallis and Futuna</li>
          <li>Western Sahara</li>
          <li>Yemen</li>
          <li>Zambia</li>
          <li>Zimbabwe</li>
        </ol>
      </main>

      <footer className={styles.footer}>
        <div className={styles.footerContent}>
            <hr className={styles.footerContentHr}/>
            
            <div>
                <Image className={styles.footerContentFlexportLogo} layout="raw" src="/images/flexport-logo.svg" alt="Flexport Logo" height={20} width={90}/>
                <span className={styles.footerContentTagLine}>We&apos;re making global trade easy for everyone.</span>
            </div>
            
            <a href="https://dev.azure.com/flexport-earth/Earth/_build/results?buildId={BUILDID}" className={styles.buildNumber}>
                <div id="build-number-anchor"></div>
            </a>
        </div>
      </footer>
    </div>
  )
}

export default Home
