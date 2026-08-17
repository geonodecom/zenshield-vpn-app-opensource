/// Fired when the user picks "Auto select" in the server list, giving up any
/// manually pinned country so the tunnel is free to route through the best
/// server across all countries again.
class AutoSelectRequested {
  const AutoSelectRequested();
}
