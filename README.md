# battlemage-os &nbsp; [![bluebuild build badge](https://github.com/draugr196/battlemage-os/actions/workflows/build.yml/badge.svg)](https://github.com/draugr196/battlemage-os/actions/workflows/build.yml)

## Installation ISO
Premade installation ISO can be downloaded here 

Base: https://drive.proton.me/urls/0GN7TBGGXR#aAUSyZWfQiE2

Webtop: https://drive.proton.me/urls/T2EJKMQD5R#uV3kAJFOZazo

Nvidia: https://drive.proton.me/urls/JQDEFFW5MG#NJ5AvbmCZWgn

Nvidia Webtop: https://drive.proton.me/urls/8XW7CCPTP0#jvX55yGJSpsQ


## Building an ISO

New ISO builds are uploaded only after major changes You can generate your own ISO with the instructions available [here](https://blue-build.org/how-to/generate-iso/#_top).

NOTE: This tool is being depreciated and will not be available for builds based on Fedora 45. Options for generating ISOs in the future are being explored.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/draugr196/battlemage
```
