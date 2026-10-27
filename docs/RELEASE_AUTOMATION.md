# Release automation

The workflow is manual only: **Actions -> release (approval gated) -> Run workflow**.

- `dry-run` rebuilds the distributed `Mod/` folder and calculates the next semantic release. It creates no tag, GitHub release, or Steam upload.
- `publish` waits for the `steam-production` environment approval, then creates the GitHub release and uploads the existing Workshop item `3806133311`.

`steam-production` needs `STEAM_USERNAME` and `STEAM_CONFIG_VDF`. Generate the latter with SteamCMD after Steam Guard, encode it as a single base64 line, and keep it only as a GitHub environment secret. Do not use the desktop Steam client's much larger configuration file.

The workflow only accepts `main`; it does not build or publish a feature branch.
