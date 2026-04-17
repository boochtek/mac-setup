#!/bin/bash

# Install [ChatGPT](https://chat.openai.com/) desktop app.
# WARNING: This requires MacOS Sonoma (14.0) or newer on Apple Silicon.
# NOTE: Includes DALL-E (generative images).
if [[ $(arch) == 'arm64' ]]; then
    brew install --quiet --cask chatgpt
fi

# NOTE: GitHub Copilot is also installed through VS Code.
brew install --quiet --cask copilot-cli

# Anthropic Claude
brew install --quiet --cask claude

# Claude Code
brew install --quiet claude-code

# OpenAI Codex
brew install --quiet --cask codex

# Mistral Vibe
brew install --quiet mistral-vibe

# Ollama — local LLM runner (uses MLX on Apple Silicon for ~2x speed).
brew install --quiet --cask ollama

# Pull local models for agentic coding workflows.
# Models are inert on disk (~100GB total); only loaded models consume RAM.
ollama pull gemma4          # Google Gemma 4 31B dense — deep reasoning
ollama pull gemma4:26b      # Google Gemma 4 26B MoE (4B active) — fast daily driver
ollama pull gemma4:e4b      # Google Gemma 4 E4B — tiny/instant for quick tasks
ollama pull devstral        # Mistral Devstral 24B — agentic SWE, 68% SWE-bench
ollama pull qwen3-coder     # Alibaba Qwen3-Coder 80B MoE (3B active) — agentic coding
ollama pull glm-4.7-flash   # Zhipu GLM-4.7 Flash 30B MoE (3B active) — strong tool calling

# TODO: Kimi K2.5 — #1 open-source LiveBench Coding, needs 128+ GB RAM
# TODO: MiniMax M2.5/M2.7 — near Opus-level SWE-bench, needs 128+ GB RAM
# TODO: Meta Llama
# TODO: Stable Diffusion (generative images)
# TODO: Midjourney (generative images)
# TODO: Microsoft Copilot



# Whisper Assistant for VS Code uses a local Whisper AI.
# Use Command+M or click Whisper in the VS Code bottom bar to start/stop recording.
# UGH: Then you have to paste!

### Extensions for editors.
code --install-extension anthropic.claude-code


### Extensions for browsers.


### MCP Servers.
brew install --quiet mcptools
brew install --quiet playwright-mcp
brew install --quiet slack-mcp-server
brew install --quiet chrome-devtools-mcp


# Install [OpenCode](https://opencode.com/) and its dependencies.
brew install --quiet oven-sh/bun/bun
brew install --quiet opencode
