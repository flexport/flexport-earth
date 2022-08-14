type Port = {
    name:           string,
    iata_code:      string,
    icao_code:      string,
    unlocode:       string,
    cbp_port_code:  string,
    address: {
        street_address:         string,
        street_address2:        string,
        locality:               string,
        administrative_area:    string,
        time_zone:              string,
        country_code:           string,
        geo_location: {
            latitude:   string,
            longitude:  string,
            altitude:   string
        },
        postal_code:        string,
        localized_address:  string
    }
}

export default Port;
