+++
title = "Sid Assistant"
description = "Smart Intent Dispatcher — a local-first Home Assistant conversation agent that makes voice control fast for device commands and smart for everything else."
weight = 4

[extra]
hook = "Smart Intent Dispatcher — a local-first Home Assistant conversation agent. Fast for device commands, smart for everything else."
repo = "kcalvelli/sid-assistant"
language = "Python"
status = "active"
stack = "Python · Home Assistant · OpenAI-compatible"
+++

## What it does

Every existing HA conversation agent (OpenAI, Anthropic, Ollama, etc.) sends **all** voice commands to the LLM — including simple "turn on the kitchen lights." That means every light switch takes 10–30 seconds while the LLM reasons about tool calls. Home Assistant handles those commands locally in milliseconds.

SID tries Home Assistant's built-in intent system **first**. If it matches a device command (lights, switches, covers, scenes), the action executes instantly. Then SID forwards the context to the LLM so it can acknowledge what happened, in character — your pirate assistant says "Aye, lights are on!" without having been the one to turn them on.

If the local intent system doesn't match (questions, conversations, complex requests), SID falls through to the LLM with the full request and the current entity states.

**Result:** "Turn on the lights" completes in ~1 second instead of 10–30 seconds.

## Compatibility

Works with any OpenAI-compatible `/v1/chat/completions` endpoint: OpenAI, Anthropic (via proxy), Ollama, LM Studio, OpenRouter, vLLM, etc.

## Install

Via HACS:

1. Open HACS → three dots → **Custom repositories**
2. Add `kcalvelli/sid-assistant` as an **Integration**
3. Search for "SID Assistant," install, restart HA

Then: **Settings → Integrations → Add Integration → SID Assistant**, enter your endpoint URL, bearer token, and model name. Set SID as the conversation agent under **Voice Assistants**, and **disable** "Prefer handling commands locally" — SID handles that logic itself.
