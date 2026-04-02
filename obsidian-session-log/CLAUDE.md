# obsidian-session-log

Claude Code plugin — 세션 종료 시 Obsidian vault에 자동으로 세션 요약 노트를 생성한다.

## 동작 방식

1. Claude Code 세션 종료 시 `SessionEnd` 훅이 `session-end.sh` 실행
2. stdin으로 `session_id`, `transcript_path`, `cwd` 수신
3. Main process가 stdin 읽고 즉시 background worker fork 후 exit 0
4. Obsidian.app 미실행 시 `open -a Obsidian --background`로 자동 실행 (최대 15초 대기)
5. Worker가 AI 요약 생성 (claude CLI, sonnet 모델) → fallback으로 jq 파싱
6. `obsidian` CLI로 vault에 노트 append/create
7. macOS toast 알림으로 결과 표시 (사용된 방식 포함)

## 노트 저장 경로

`{FOLDER_PREFIX}/{project_name}/history/{YYYY-MM-DD}.md`

- `FOLDER_PREFIX`: 사용자 설정 (`~/.claude/obsidian-session-log.conf`)
- `project_name`: `cwd`의 basename
- 같은 날 여러 세션 → 같은 파일에 append

## 설정

`~/.claude/obsidian-session-log.conf`:
```bash
FOLDER_PREFIX="20_Project"    # 필수 — Obsidian vault 내 저장 폴더 prefix
LANG_SUMMARY="ko"             # ko | en (기본: ko)
OBSIDIAN_VAULT=""              # vault 이름 (비어있으면 CLI 기본 vault)
```

- `FOLDER_PREFIX` 미설정 시 toast 에러 후 종료. 암묵적 기본값 없음.
- `LANG_SUMMARY`: AI 요약 및 fallback 템플릿 언어. `ko`(한국어) 또는 `en`(영어).
- `OBSIDIAN_VAULT`: 멀티 vault 환경에서 대상 vault 지정. 미설정 시 obsidian CLI 기본 vault 사용.

## 의존성

- **obsidian CLI**: `command -v obsidian` (필수)
- **jq**: stdin JSON 파싱 + fallback 요약 (필수)
- **claude CLI**: AI 요약 생성 (없으면 jq fallback 사용)
- **Obsidian.app**: 실행 중이어야 CLI가 동작
- **macOS**: toast 알림용 osascript

## 설계 원칙

- 하드코딩 경로 없음 — 모든 바이너리는 `command -v`로 탐색
- fallback 최소화 — obsidian CLI only (direct fs write 없음)
- 암묵적 기본값 없음 — 설정 누락 시 명시적 에러
- toast 알림에 사용 방식 표시 (obsidian append/create)
- SessionEnd 훅은 즉시 exit — 무거운 작업은 background worker
- Obsidian 미실행 시 자동 실행 (background, 최대 15초 polling 대기)
