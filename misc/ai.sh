#!/bin/bash

# Variant of the unofficial Bash strict mode.
set -uo pipefail
IFS=$'\n\t'
trap 'RC=$? ; echo "$0: Error on line "$LINENO": $BASH_COMMAND" ; exit $RC' ERR
[[ -n "${DEBUG+unset}" ]] && set -x

# Anthropic Claude.
brew install --quiet --cask --no-quarantine claude
open -a Claude
dockutil --add '/Applications/Claude.app' --replacing 'Claude' --after 'ChatGPT' &>/dev/null

# Claude Code is my preferred AI assistant (now OpenCode, if not for Anthropic subscription restrictions).
# Bootstrap via Homebrew, then migrate to built-in auto-updating.
if ! readlink -f "$(command -v claude)" | grep -q "^$HOME/.local/share/claude/versions/"; then
    brew install --quiet claude-code
    claude install latest
    brew uninstall claude-code
fi

# A couple dependencies that Claude Code will use if available.
brew install --quiet ugrep # faster version of `grep`, w/ a TUI, lots more options, and better defaults for code
brew install --quiet bfs   # breadth-first version of `find`

# OpenAI [ChatGPT](https://chat.openai.com/) desktop app.
# WARNING: This requires MacOS Sonoma (14.0) or newer on Apple Silicon.
# NOTE: Includes DALL-E (generative images).
if [[ $(arch) == 'arm64' ]]; then
    brew install --quiet --cask chatgpt
    open -a ChatGPT
    dockutil --add '/Applications/ChatGPT.app' --replacing 'ChatGPT' --after 'Zed' &>/dev/null
else
    echo -n "$(tput setaf 1)ChatGPT desktop app is only available on Apple Silicon "
    echo "Macs running MacOS Sonoma (14.0) or newer. Skipping installation.$(tput sgr0)"
fi

# OpenAI Codex CLI.
brew install codex-cli

# [OpenCode](https://opencode.com/) and its dependencies.
brew install --quiet oven-sh/bun/bun
brew install --quiet opencode

# GitHub Copilot CLI. We also have the VS Code extension.
brew install copilot-cli copilot-language-server

# Google Gemini.
brew install gemini-cli

# Google Workspace CLI. Access Gmail, Calendar, Drive, Docs, Sheets, etc.
# Great for automating tasks via AI agents.
brew install googleworkspace-cli

# Ollama. Allows running various LLMs on your local hardware.
brew install --quiet --cask ollama
# OPTIONAL (probably want some OLLAMA_* env varaibles): brew services restart ollama
# OPTIONAL: brew install --quiet --cask llamabarn  # menu bar app for running local LLMs

# Pull local models for agentic coding workflows.
# Models are inert on disk (~100GB total); only loaded models consume RAM.
ollama pull gemma4:31b      # Google Gemma 4 31B dense — deep reasoning
ollama pull gemma4:26b      # Google Gemma 4 26B MoE (4B active) — fast daily driver
ollama pull gemma4:e4b      # Google Gemma 4 E4B — tiny/instant for quick tasks
ollama pull devstral        # Mistral Devstral 24B — agentic SWE, 68% SWE-bench
ollama pull qwen3-coder     # Alibaba Qwen3-Coder 80B MoE (3B active) — agentic coding
ollama pull qwen3.6         # Alibaba Qwen3.6 35B — agentic coding

ollama pull glm-4.7-flash   # Zhipu GLM-4.7 Flash 30B MoE (3B active) — strong tool calling

# TODO: Kimi K2.6 — #1 open-source LiveBench Coding, needs 128+ GB RAM
# TODO: MiniMax M3 — near Opus-level SWE-bench, needs 128+ GB RAM
# TODO: Stable Diffusion (generative images)
# TODO: Midjourney (generative images)
# TODO: Microsoft Copilot?
# TODO: Meta Llama?

# Mistral Vibe
brew install --quiet mistral-vibe

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
