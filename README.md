# battlemage-os &nbsp; [![bluebuild build badge](https://github.com/draugr196/battlemage-os/actions/workflows/build.yml/badge.svg)](https://github.com/draugr196/battlemage-os/actions/workflows/build.yml)

## Installation ISO
Premade installation ISO can be downloaded here 

Base: https://drive.proton.me/urls/R359K2P5YW#qfVj7Bn16YlV

Webtop: https://drive.proton.me/urls/MWMWX7GKA8#AyzzitjuMM2C

Nvidia: https://drive.proton.me/urls/K1VH2SA95G#mlBess8U05Nq

Nvidia Webtop: https://drive.proton.me/urls/FA64K8157C#hYDC30qzn7ym


## Building an ISO

New ISO builds are uploaded only after major changes You can generate your own ISO with the instructions available [here](https://blue-build.org/how-to/generate-iso/#_top).

NOTE: This tool is being depreciated and will not be available for builds based on Fedora 45. Options for generating ISOs in the future are being explored.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/draugr196/battlemage
```
