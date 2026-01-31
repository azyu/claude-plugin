# Context Manager Plugin - Development Context

이 디렉토리는 context-manager 플러그인 개발에 대한 컨텍스트 정보를 담고 있습니다.
다른 에이전트가 작업을 이어받을 때 참고하세요.

## 빠른 요약

**프로젝트**: context-manager Claude Code 플러그인
**상태**: v1.0.0 초기 구현 완료 (2025-02-01)
**원본**: `~/.claude/skills/context-manager/` 스킬에서 플러그인으로 변환

## 디렉토리 구조

```
.context/
├── README.md                      # 이 파일 (전체 개요)
├── planning/
│   ├── implementation_history.md  # 작업 히스토리
│   └── next_steps.md              # 다음 작업 방향
└── architecture/
    └── design_decisions.md        # 설계 결정사항
```

## 핵심 문서

| 문서 | 내용 |
|------|------|
| [Implementation History](planning/implementation_history.md) | 어떤 작업이 완료되었는지 |
| [Design Decisions](architecture/design_decisions.md) | 왜 이렇게 구현했는지 |
| [Next Steps](planning/next_steps.md) | 다음에 할 작업 |

## 플러그인 구조 요약

```
context-manager/
├── .claude-plugin/plugin.json    # 플러그인 메타데이터
├── commands/                      # 4개 명령어 (/context:*)
├── skills/context-manager/        # AI 에이전트 스킬
├── scripts/                       # Python 스크립트 (3개)
├── hooks/                         # 선택적 hooks
├── references/                    # 베스트 프랙티스
├── README.md                      # 사용자용 문서
└── INSTALL.md                     # 설치 가이드
```

## 테스트 방법

```bash
# 로컬 테스트
claude --plugin-dir /Volumes/EXTSSD/code/personal/claude-plugin/context-manager

# 명령어 확인
/context:init
/context:search <query>
/context:update --category <cat> --file <name> --summary "<text>"
/context:status
```

## 관련 파일 위치

- 마켓플레이스: `/Volumes/EXTSSD/code/personal/claude-plugin/.claude-plugin/marketplace.json`
- 원본 스킬: `~/.claude/skills/context-manager/`
- 원본 hooks: `~/.claude/hooks/stop/`
