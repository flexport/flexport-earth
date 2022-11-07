import PortsCard from './ports-card';

describe('Ports Card', () => {
    it('renders countries and port counts', () => {
        // Arrange
        const countries = [
            { countryName: 'China',         cca2CountryCode: 'CN', portCount: 111 },
            { countryName: 'United States', cca2CountryCode: 'US', portCount: 222 },
            { countryName: 'Singapore',     cca2CountryCode: 'SG', portCount: 333 },
            { countryName: 'South Korea',   cca2CountryCode: 'KR', portCount: 4444 },
            { countryName: 'Malaysia',      cca2CountryCode: 'MY', portCount: 555 },
            { countryName: 'Japan',         cca2CountryCode: 'JP', portCount: 666 }
        ];

        const portsCardComponent =
            <PortsCard
                countries={countries}
            />;

        // Act
        cy.mount(portsCardComponent);

        // Assert
        countries.forEach((country) => {
            cy.get('body').contains(`${country.countryName} ports ( ${country.portCount} )`);
        });
    })
});
