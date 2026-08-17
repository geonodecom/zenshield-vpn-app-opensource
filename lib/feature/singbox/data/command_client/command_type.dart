enum CommandType {
  log(0),
  status(1),
  vpnState(2),
  ping(3);

  const CommandType(this.value);
  final int value;
}
