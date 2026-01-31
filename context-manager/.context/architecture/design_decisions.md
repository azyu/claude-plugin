# Design Decisions

## 핵심 설계 결정

### 1. qmd 통합 전략: Graceful Degradation

**결정**: qmd를 선택적 의존성으로 처리, 없으면 키워드 검색으로 폴백

**이유**:
- qmd가 모든 환경에 설치되어 있지 않음
- 기본 기능(키워드 검색)은 의존성 없이 동작해야 함
- 사용자가 qmd 설치 시 자동으로 시맨틱 검색으로 업그레이드

**구현**:
```python
# scripts/find_context.py
if args.prefer_semantic and args.keywords:
    results = QmdIntegration.search(query=query, top_k=args.max_results)
    if results:
        search_method = 'semantic'

if results is None:
    # Fallback to keyword search
    finder = ContextFinder(args.context_dir)
    results = finder.find_relevant_contexts(...)
```

**대안 고려**:
- qmd 필수 의존성 → 설치 장벽 높아짐
- 별도 시맨틱 검색 구현 → 복잡도 증가, 유지보수 어려움

---

### 2. Hooks 처리: 수동 설치 가이드

**결정**: Hooks는 자동 설치하지 않고 README 문서로 가이드 제공

**이유**:
- `~/.claude/settings.json`은 사용자 제어 영역
- 플러그인이 사용자 설정 파일 자동 수정은 보안상 부적절
- Claude Code 플러그인 시스템의 제한사항

**구현**:
- `hooks/README.md`에 상세한 설치 가이드 제공
- 복사할 스크립트와 settings.json 예시 포함

**대안 고려**:
- 자동 설치 스크립트 → 보안 우려, 권한 문제
- Hooks 기능 제외 → 사용자 편의성 감소

---

### 3. Python 스크립트 포함 방식

**결정**: 플러그인에 Python 스크립트 직접 포함, 표준 라이브러리만 사용

**이유**:
- Python 3는 대부분 환경에 기본 설치됨
- 외부 pip 의존성 없으면 설치 단계 불필요
- 스크립트가 플러그인과 함께 버전 관리됨

**구현**:
- `argparse`, `json`, `pathlib`, `subprocess` 등 표준 라이브러리만 사용
- shebang (`#!/usr/bin/env python3`)으로 이식성 확보

**대안 고려**:
- Bash 스크립트만 사용 → 복잡한 로직 구현 어려움
- Node.js 스크립트 → Node.js가 없는 환경 존재
- pip 의존성 허용 → 설치 복잡도 증가

---

### 4. 명령어 네이밍: `/context:*` 네임스페이스

**결정**: 모든 명령어를 `context:` 네임스페이스 아래에 배치

**이유**:
- 다른 플러그인과의 충돌 방지
- 관련 명령어 그룹화로 발견성 향상
- Tab 자동완성 시 관련 명령어 함께 표시

**구현**:
```
/context:init
/context:search
/context:update
/context:status
```

**대안 고려**:
- `/ctx-*` → 약어로 타이핑 편하지만 직관성 감소
- `/init-context` → 일관성 없는 네이밍

---

### 5. 스킬과 명령어 분리

**결정**: AI 스킬(SKILL.md)과 사용자 명령어(commands/*.md) 분리 유지

**이유**:
- 스킬: AI 에이전트가 자동으로 활성화, 워크플로우 정의
- 명령어: 사용자가 명시적으로 호출, 특정 작업 수행
- 각각의 용도와 트리거 방식이 다름

**구현**:
- `skills/context-manager/SKILL.md`: 작업 시작 시 컨텍스트 로드 워크플로우
- `commands/*.md`: 개별 작업(init, search, update, status)

---

## 파일 구조 결정

### scripts/ 위치

**결정**: 플러그인 루트에 `scripts/` 배치 (스킬 내부가 아님)

**이유**:
- 명령어에서도 스크립트 참조 필요
- 공통 유틸리티로서의 역할
- 경로 관리 단순화

---

## 향후 변경 시 고려사항

1. **qmd API 변경**: `QmdIntegration` 클래스만 수정하면 됨
2. **새 명령어 추가**: `commands/` 디렉토리에 새 .md 파일 추가
3. **검색 알고리즘 개선**: `ContextFinder` 클래스의 scoring 로직 수정
4. **새 카테고리 추가**: `COMMON_CATEGORIES` 리스트와 `TASK_CATEGORIES` 매핑 업데이트
