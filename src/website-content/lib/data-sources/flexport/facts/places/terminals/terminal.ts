type Terminal = {
    terminal_ref: {
        id:             string,
        link:           string,
        ref_type:       string
    },
    name:               string,
    terminal_code:      string,
    unlocode:           string,
    firms_code:         string,
    address: {
        street_address:         string,
        street_address2:        string,
        locality:               string,
        administrative_area:    string,
        time_zone:              string,
        country_code:           string,
        geo_location: {
            latitude:           number,
            longitude:          number,
            altitude:           number
        },
        postal_code:            string,
        localized_address:      string
    }
}

export default Terminal;
