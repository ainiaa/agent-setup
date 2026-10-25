# agent-setup

我的个人 AI Agent 环境一键部署：**skill 共享库 + 个人规则**。适用于 Claude Code / Codex / ZCode 等多个 agent。

## 一键安装

```bash
git clone https://github.com/<你的用户名>/agent-setup.git
cd agent-setup && ./setup.sh
```

## 包含什么

| 文件 | 作用 |
|---|---|
| `AGENTS.md` | 个人规则真身（语言/风格/工作流偏好），部署到 `~/.agents/AGENTS.md` |
| `skills.list` | skill 安装清单，统一装进共享库 `~/.agents/skills/` |
| `setup.sh` | 幂等部署脚本：装 skill + 部署规则 + 挂引用 |

## 架构

```
~/.agents/                  ← 单点真身
├── AGENTS.md               ← 个人规则（~/.claude/RULES.md 和 ~/.codex/RULES.md 软链至此）
└── skills/                 ← 共享 skill 库（claude/codex 各自目录软链至此，zcode 原生直读）
```

- 更新规则：改本仓库 `AGENTS.md` → 各机器重跑 `./setup.sh`
- 更新 skill：改 `skills.list` → 重跑
- 工具自动生成的内容（RTK、CodeGraph 等）留在各机器本地，由各自工具管理，本脚本不覆盖

## License

MIT
