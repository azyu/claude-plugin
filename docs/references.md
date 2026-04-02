# Project References

## Project Overview

Claude Code 플러그인 마켓플레이스. AI 코딩 에이전트의 생산성을 높이는 9개 플러그인을 제공하며, 스킬 검색, 플랜 리뷰, 컨텍스트 관리, 프롬프트 엔지니어링, Obsidian 연동 등의 기능을 포함한다. 대상 사용자는 Claude Code, Codex CLI, Gemini CLI 등 AI 코딩 도구 사용자.

## Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Plugin System | Markdown (SKILL.md, commands/*.md) | Claude Code 네이티브 플러그인 포맷, 빌드 불필요 |
| Hook Scripts | Bash (sh) | 크로스 플랫폼 셸 호환, 경량 |
| Utility Scripts | Python 3 | context-manager의 시맨틱 검색, qmd 인덱싱 |
| Obsidian Integration | notesmd-cli, Obsidian REST API | 3개 Obsidian 플러그인에서 사용 |
| Version Control | Git | 마켓플레이스 배포 및 협업 |

## Architecture Decisions

### ADR-1: Markdown 기반 플러그인 시스템

- **Status:** Accepted
- **Context:** Claude Code 플러그인은 코드 빌드 없이 마크다운만으로 정의 가능
- **Decision:** 모든 플러그인을 순수 마크다운 + 셸 스크립트로 구현
- **Consequences:** 빌드 파이프라인 불필요, 빠른 이터레이션. 복잡한 로직은 외부 스크립트로 위임

### ADR-2: 마켓플레이스 패턴

- **Status:** Accepted
- **Context:** 여러 플러그인을 하나의 레포에서 관리할 구조 필요
- **Decision:** `marketplace.json` → 개별 `plugin.json` → `SKILL.md/commands/hooks` 계층 구조
- **Consequences:** 플러그인 간 독립성 유지, 개별 설치 가능, 중앙 레지스트리로 검색 용이

### ADR-3: Obsidian 연동 분리

- **Status:** Accepted
- **Context:** Obsidian 기능이 plan-sync, report-sync, session-log 3가지로 분화
- **Decision:** 각각 독립 플러그인으로 분리 (hook 타이밍이 다름: PostToolUse, Stop, SessionEnd)
- **Consequences:** 사용자가 필요한 것만 선택 설치 가능, 각 플러그인이 단일 책임

## Plugins Inventory

| Plugin | Version | Type | Key Feature |
|--------|---------|------|-------------|
| skill-finder | 1.0.0 | Skill | AI 스킬 검색 및 설치 |
| context-manager | 1.0.0 | Skill + Command + Hook | 시맨틱 컨텍스트 관리 |
| update-claude | 1.0.0 | Skill + Command | 실수로부터 학습 → CLAUDE.md 업데이트 |
| prompt-engineer | 1.0.0 | Skill + Command | CRAFT 프레임워크 프롬프트 최적화 |
| obsidian-plan-sync | 1.0.0 | Hook | Plan Mode 종료 시 Obsidian 저장 |
| obsidian-report-sync | 1.0.0 | Hook | 세션 리포트 Obsidian 저장 |
| obsidian-session-log | 1.0.0 | Hook | 세션 요약 Obsidian 로그 |

## Key References

- Claude Code Plugin Documentation (공식 문서)
- Obsidian REST API / notesmd-cli
- OpenAI Codex CLI
- sickn33/antigravity-awesome-skills (238+ skills)
- nextlevelbuilder/ui-ux-pro-max-skill
- skills.sh (Community marketplace)

## Open Questions

- 없음 (성숙한 프로젝트)
