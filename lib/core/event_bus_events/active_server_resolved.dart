/// Fired after connect/failover once the *actual* routing server is known,
/// so the UI can sync its displayed server to the one really carrying traffic.
/// Unlike a user-initiated server change, this must NOT trigger a reconnect —
/// it only updates what is shown.
class ActiveServerResolved {
  const ActiveServerResolved({required this.serverIp});

  final String serverIp;
}
