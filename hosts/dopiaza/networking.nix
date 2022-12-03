{ lib, ... }:

{
  networking = {
    dhcpcd.enable = false;

    defaultGateway = "64.225.96.1";
    defaultGateway6 = "2a03:b0c0:3:d0::1";

    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "64.225.97.72"; prefixLength = 20; }
          { address = "10.19.0.6"; prefixLength = 16; }
        ];

        ipv6.addresses = [
          { address = "2a03:b0c0:3:d0::cdf:f001"; prefixLength = 64; }
          { address = "fe80::f853:8dff:fe6c:e64a"; prefixLength = 64; }
        ];

        ipv4.routes = [{ address = "64.225.96.1"; prefixLength = 32; }];

        ipv6.routes = [{ address = "2a03:b0c0:3:d0::1"; prefixLength = 128; }];
      };
    };

    nameservers = [
      "9.9.9.9"
      "1.1.1.1"
    ];
  };

  services.udev.extraRules = ''
    ATTR{address}=="fa:53:8d:6c:e6:4a", NAME="eth0"
    ATTR{address}=="ae:37:11:de:df:37", NAME="eth1"
  '';
}
