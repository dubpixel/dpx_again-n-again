# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [0.1.0] - 2026-11-02

### Added
- `AgainNAgain.app` droplet: drop any installed app on it to generate a `<Name>Again.app` launcher in `~/Applications` that opens a new instance (`open -n`) every launch
- `src/make-again.sh` generator (also usable from the command line): version-aware launchers (`sort -V`), `--exact`, `--out`, borrows the target's icon, refuses to wrap its own launchers
- `build.sh` (droplet, zip, dmg, ad-hoc re-sign) and `install.sh` (local build, no quarantine)
- Forked from [dpx_tr_again](https://github.com/dubpixel/dpx_tr_again), generalizing its Tessera-Remote-only launcher
