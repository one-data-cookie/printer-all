# printer-all — ARM64 macOS CUPS Drivers for 89 Printers

Native Apple Silicon CUPS raster filters for printers that have no official macOS ARM64 driver. No Ghostscript, no Rosetta — uses macOS's built-in `cgpdftoraster`.

```
PDF → cgpdftoraster (macOS built-in) → rastertoXXX (our filter) → printer
```

## Supported Printers

9 format families covering 89 printer models.

### XQX — `rastertoxqx`

HP LaserJet P1005, P1006, P1007, P1008

### ZjStream — `rastertozjs`

HP LaserJet 1000, 1005, 1018, 1020, 1022, 1022n, 1022nw, M1005 MFP, M1120 MFP, M1319 MFP, P2014, P2014n, P2035, P2035n, Pro M1212nf MFP, Pro P1102, Pro P1102w, Pro P1566, Pro P1606dn · Minolta 2200 DL, 2300 DL, 2430 DL

### ZJS (HP 2600n) — `rastertohp`

HP Color LaserJet 1600, 2600n, CP1215

### HiPerC — `rastertohiperc`

Oki C110, C301dn, C310dn, C3100, C3200, C3300, C3400, C3530 MFP, C5100, C511dn, C5200, C5500, C5600, C5650, C5800, C810

### QPDL — `rastertoqpdl`

Samsung CLP-300, CLP-310, CLP-315, CLP-325, CLP-365, CLP-600, CLP-610, CLP-620, CLX-2160, CLX-3160, CLX-3175, CLX-3185 · Xerox Phaser 6110

### LAVAFLOW — `rastertolava`

Konica Minolta magicolor 1600W, 1680MF, 1690MF, 2430 DL, 2480 MF, 2490 MF, 2530 DL, 4690MF · Minolta Color PageWorks Pro L · Olivetti d-Color P160W · Xerox Phaser 6115MFP, 6121MFP · Oki C110

### HBPL2 — `rastertohbpl2`

Dell 1355, C1765 · Epson AcuLaser M1400, CX17NF · Fuji Xerox DocuPrint CM205, CM215, M215, P205 · Xerox WorkCentre 3045, 6015

### OAKT — `rastertooak`

HP Color LaserJet 1500 · Kyocera KM-1635, KM-2035

### SLX — `rastertoslx`

Lexmark C500

## Installation

### Prerequisites

- macOS 14+ on Apple Silicon (arm64)
- Xcode Command Line Tools: `xcode-select --install`

### Quick Install

```bash
sudo ./install.sh
```

This compiles all 9 filters, installs them to `/usr/libexec/cups/filter/`, copies PPDs and firmware, then restarts CUPS.

### Manual Build

```bash
make          # build all 9 filters
make tools    # build arm2hpdl and xqxdecode utilities
make clean
```

Individual filters:

```bash
make rastertozjs
make rastertohiperc
# etc.
```

### After Installation

1. Connect your printer via USB
2. Add it in **System Settings > Printers & Scanners**
3. Select the matching PPD as the driver

### Firmware Printers

Some HP LaserJets have no onboard firmware and require upload every power cycle:

| Firmware file | Printers |
|---|---|
| `sihp1000.dl` | LaserJet 1000 |
| `sihp1005.dl` | LaserJet 1005 |
| `sihp1018.dl` | LaserJet 1018 |
| `sihp1020.dl` | LaserJet 1020, 1022 series |
| `sihpP1005.dl` | LaserJet P1005, P1006, P1007, P1008 |
| `sihpP1006.dl` | LaserJet P1006 (alternate) |
| `sihpP1505.dl` | LaserJet P1505 series |

Upload firmware after the printer powers on:

```bash
lp -oraw /usr/local/share/foo2zjs/firmware/sihpP1005.dl
```

## Files

| Path | Purpose |
|------|---------|
| `rastertoXXX.c` | CUPS raster filters (9 files, one per format family) |
| `foo2zjs/jbig.c` | JBIG compression library |
| `foo2zjs/*.h` | Format definitions (xqx.h, zjs.h, hiperc.h, qpdl.h, hbpl.h, oak.h, slx.h) |
| `foo2zjs/*.img` | Firmware images for HP LaserJets |
| `foo2zjs/*.icm` | ICC color profiles for color printers |
| `PPD/` | Printer description files (89 files) |
| `install.sh` | Automated installer |
| `Makefile` | Build system |

## License

GNU General Public License v2 or later. See [LICENSE](LICENSE).

Based on the [foo2zjs](http://foo2zjs.rkkda.com/) project by Rick Richardson (GPL v2+). Firmware images are copyright HP.
