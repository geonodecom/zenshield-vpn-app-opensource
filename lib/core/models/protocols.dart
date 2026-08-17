enum Protocols {
  auto('Automatic'),
  vless('VLESS'),
  vmess('VMess'),
  trojan('Trojan'),
  shadowsocks('Shadowsocks'),
  wireguard('WireGuard');

  const Protocols(this.displayName);
  final String displayName;
}
