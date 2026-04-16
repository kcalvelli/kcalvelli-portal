# Orthoterm

A command-line tool for fetching Orthodox Christian calendar data and generating iCal files.

**Repository:** [kcalvelli/orthoterm](https://github.com/kcalvelli/orthoterm) · **Language:** Rust

## What it does

Orthoterm pulls daily saints, readings, troparia, kontakia, fasting guidelines, and feast days from [Holy Trinity Orthodox Church](https://holytrinityorthodox.com/calendar/), caches the data locally under XDG base directories, and optionally generates iCal files for import into any calendar client.

Supports both Gregorian and Julian calendar dates. The fetcher is a good neighbor: request delays, retry with exponential backoff, and aggressive local caching to minimize upstream load.

## Run it

```bash
orthoterm          # current year's calendar data
orthoterm 2025     # specific year
orthoterm -i 2025  # generate iCal for a year
```

Built in Rust for fast startup and cross-distro binary distribution.
