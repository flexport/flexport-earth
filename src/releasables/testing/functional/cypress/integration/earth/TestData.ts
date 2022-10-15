class Countries {
    public CountryCodeUnitedStates = 'US';
    public CountryNameUnitedStates = 'United States';

    public ValidCountryCode = this.CountryCodeUnitedStates;
    public ValidCountryName = this.CountryNameUnitedStates;
}

class Ports {
    public PortCanaveralName        = 'Port Canaveral';
    public PortCanaveralUnlocode    = 'USPCV';

    public ValidCountryName  = this.PortCanaveralName;
    public ValidPortUnloCode = this.PortCanaveralUnlocode;
}

class Terminals {
    public TerminalCanaveralCT2TerminalName         = 'CT2 Terminal'
    public TerminalCanaveralCT2TerminalTerminalCode = 'USPCV-CTT'

    public ValidTerminalName = this.TerminalCanaveralCT2TerminalName;
    public ValidTerminalCode = this.TerminalCanaveralCT2TerminalTerminalCode;

}

export class TestData {
    public static Countries: Countries = new Countries();
    public static Ports:     Ports     = new Ports();
    public static Terminals: Terminals = new Terminals();
}
