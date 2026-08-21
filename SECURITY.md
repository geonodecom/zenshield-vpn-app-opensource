# Security Policy

## Reporting a vulnerability

If you find a security vulnerability in ZenShield VPN, please **do not**
open a public GitHub issue.

Instead, report it privately by emailing **security@zenshield.com** with:

- A description of the vulnerability and its potential impact.
- Steps to reproduce it (proof-of-concept code/screenshots welcome).
- The affected platform(s) (Android, iOS, macOS, Windows) and app version.

We aim to acknowledge reports within 5 business days and to keep you
updated as we investigate and fix the issue. Once a fix is released, we'll
credit reporters who wish to be credited.

## Scope

This policy covers the Flutter/Dart application code in this repository.
It does **not** cover:

- The upstream [sing-box](https://github.com/SagerNet/sing-box) VPN core —
  report issues there to that project directly.
- Third-party dependencies listed in `pubspec.yaml` — report issues to
  their respective maintainers, though we'd still appreciate a heads-up if
  it affects ZenShield users.

## Supported versions

As an actively developed open-source project, only the latest release on
the `main` branch receives security fixes.
