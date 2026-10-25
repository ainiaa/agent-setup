#!/usr/bin/env bash
# 一键部署：skill 共享库 + 个人规则，适用于 macOS / Linux
# 用法：clone 本仓库后运行 ./setup.sh（可重复运行，幂等）
set -euo pipefail

echo "==> 1/3 安装 skill 到共享库 ~/.agents/skills（各 agent 自动共用）"
command -v npx >/dev/null || { echo "需要 Node.js (npx)"; exit 1; }
while IFS= read -r line; do
  line="${line%%#*}"                      # 去掉行内注释
  [[ -z "${line// /}" ]] && continue      # 跳过空行和 TODO 占位行会被 npx 报错，跳过含 TODO 的行
  [[ "$line" == *TODO* ]] && { echo "  跳过（TODO 未填）: $line"; continue; }
  echo "  npx skills add $line"
  npx -y skills add $line || echo "  安装失败，跳过: $line"
done < "$(dirname "$0")/skills.list"

echo "==> 2/3 部署个人规则（真身 ~/.agents/AGENTS.md，软链给各家）"
mkdir -p ~/.agents ~/.claude ~/.codex
cp "$(dirname "$0")/AGENTS.md" ~/.agents/AGENTS.md
ln -sfn ~/.agents/AGENTS.md ~/.claude/RULES.md
ln -sfn ~/.agents/AGENTS.md ~/.codex/RULES.md

echo "==> 3/3 给 CLAUDE.md / AGENTS.md 挂上引用（不动工具生成的内容）"
# 只追加一行 @引用；RTK / CodeGraph 等工具自己管理的段落保持原样
touch ~/.claude/CLAUDE.md ~/.codex/AGENTS.md
grep -q '@RULES.md' ~/.claude/CLAUDE.md || printf '\n@RULES.md\n' >> ~/.claude/CLAUDE.md
grep -q "@$HOME/.codex/RULES.md" ~/.codex/AGENTS.md || printf '\n@%s/.codex/RULES.md\n' "$HOME" >> ~/.codex/AGENTS.md

echo "完成。skill 三家共用（claude/codex/zcode），规则单点维护于 ~/.agents/AGENTS.md"
