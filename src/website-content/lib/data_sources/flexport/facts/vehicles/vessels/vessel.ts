type Vessel = {
    name:                       string,
    mmsi:                       number,
    imo:                        number,
    registration_country_code:  string,
    carrier: {
        carrier_name: string,
    }
}

export default Vessel;
