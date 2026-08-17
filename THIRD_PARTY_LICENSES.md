# Third-Party Licenses

This app bundles the following third-party components in its native builds:

## sing-box

- Project: https://github.com/SagerNet/sing-box
- License: GNU General Public License v3.0 (GPL-3.0)
- Full license text: https://www.gnu.org/licenses/gpl-3.0.txt
- Usage in this app:
  - Android: official sing-box "libbox" Go mobile bindings, compiled natively (`android/app/src/main/kotlin/.../bg/BoxService.kt`, `VPNService.kt`)
  - iOS/macOS: prebuilt sing-box core, bundled as `ios/ZenshieldBox.xcframework` / `macos/zenshieldBox.xcframework`, run inside a Network Extension (`Tunnel/SingBox/ExtensionProvider.swift`)
  - Windows: `singbox-tunnel.exe`, run as an external process/service, driven via FFI + a local TCP socket

sing-box is not modified source-for-source in this repository; it is bundled as a compiled binary/library. Its GPL-3.0 license text is reproduced above by reference — see the upstream project for source code.
