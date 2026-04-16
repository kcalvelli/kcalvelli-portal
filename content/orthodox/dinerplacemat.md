+++
title = "Diner Placemat"
description = "A nostalgic, diner-placemat-style business directory for the Orthodox Christian community."
weight = 2

[extra]
hook = "A nostalgic, diner-placemat-style business directory for the Orthodox Christian community."
repo = "kcalvelli/dinerplacemat"
language = "JavaScript"
status = "early"
stack = "Cloudflare Pages · D1 · R2 · vanilla JS"
+++

## What it does

DinerPlacemat.com is a community business directory that looks and behaves like an actual diner placemat — cream backgrounds, red checkerboard borders, retro pastel cards, with puzzles and games interspersed between listings. Orthodox Christian businesses submit their information through an intake form; after manual admin approval, they appear on the main page as colorful "advertising cards."

The design is the point. A searchable database with a Cloudflare-backed admin panel dressed up as a 1950s diner placemat. Responsive — 4-column desktop, 2-column tablet, 1-column mobile. Vanilla HTML/CSS/JS, no build step.

## Features

- Searchable directory by name, type, parish, or location
- Randomly-generated game cards: mazes, Orthodox-themed word searches, tic-tac-toe
- Admin panel with manual approval workflow
- 6-month listing expiration with extension support
- R2-backed logo storage

## Stack

Frontend: vanilla HTML/CSS/JS, no framework. Backend: Cloudflare Pages Functions for the API, D1 (SQLite) for listings and admin users, R2 bucket for public logo storage.
