{ ... }:
let
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    wg-quick.interfaces.wg0 = {
      address = [ "10.69.70.71/32" ];
      privateKeyFile = "/certs/wg/private.key";

      peers = [{
        publicKey = "bPfJDdgBXlY4w3ACs68zOMMhLUbbzktCKnLOFHqbxl4=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "31.171.153.66:51820";
        persistentKeepalive = 25;
      }];
    };

    nat = {
      enable = true;
      externalInterface = "wg0";
      internalInterfaces = [ "enp2s0" ];
    };

    firewall = {
      extraCommands = ''
        # Create a new routing table for forwarded traffic
        echo "200 vpn" >> /etc/iproute2/rt_tables

        # Mark packets from other hosts
        iptables -t mangle -A PREROUTING -i enp2s0 ! -s 192.168.1.113 -j MARK --set-mark 0x1

        # Route marked packets through WireGuard
        ip rule add fwmark 0x1 table vpn
        ip route add default dev wg0 table vpn

        # Allow forwarding
        iptables -A FORWARD -i enp2s0 -o wg0 -j ACCEPT
        iptables -A FORWARD -i wg0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

        # NAT only forwarded traffic
        iptables -t nat -A POSTROUTING -o wg0 ! -s 192.168.1.113 -j MASQUERADE
      '';

      extraStopCommands = ''
        ip rule del fwmark 0x1 table vpn 2>/dev/null || true
        ip route flush table vpn 2>/dev/null || true
      '';
    };
  };
}
