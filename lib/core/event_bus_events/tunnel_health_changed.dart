/// Fired after the post-connect health check finishes, reporting whether the
/// tunnel can actually reach the internet through its exit server. `false`
/// means the tunnel is up but every probe failed (typically the server-side
/// proxy service is down) — the UI should stop showing a plain green
/// "Connected" and warn the user instead.
class TunnelHealthChanged {
  const TunnelHealthChanged({required this.healthy});

  final bool healthy;
}
