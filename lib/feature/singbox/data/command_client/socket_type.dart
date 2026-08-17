sealed class SocketType {
  const SocketType();
}

class UnixSocketType extends SocketType {
  const UnixSocketType({
    required this.path,
  });

  final String path;
}

class TcpSocketType extends SocketType {
  const TcpSocketType({
    required this.host,
    required this.port,
  });

  final String host;
  final int port;
}
