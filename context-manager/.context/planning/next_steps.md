# Next Steps

## 즉시 필요한 작업

### 1. 실제 환경 테스트 (우선순위: 높음)

현재 스크립트 `--help`만 테스트됨. 실제 프로젝트에서 전체 워크플로우 테스트 필요.

```bash
# 테스트 순서
cd /path/to/test/project

# 1. 초기화 테스트
/context:init

# 2. 상태 확인
/context:status

# 3. 업데이트 테스트
/context:update --category planning --file test.md --summary "Test content"

# 4. 검색 테스트
/context:search test planning
```

### 2. qmd 통합 테스트 (우선순위: 높음)

qmd가 설치된 환경에서 시맨틱 검색 테스트 필요.

```bash
# qmd 설치
pip install qmd

# 컬렉션 설정
python scripts/qmd_setup.py --context-dir .context

# 시맨틱 검색 테스트
python scripts/find_context.py --context-dir .context --keywords "authentication" --prefer-semantic --json
```

### 3. Hook 테스트 (우선순위: 중간)

수동 설치 후 hooks가 제대로 동작하는지 확인.

```bash
# Hook 설치 (hooks/README.md 참조)
mkdir -p ~/.claude/hooks/stop
cp hooks/stop/*.sh ~/.claude/hooks/stop/
chmod +x ~/.claude/hooks/stop/*.sh

# settings.json 설정 후 Claude Code 세션 종료 시 동작 확인
```

---

## 개선 사항

### 단기 (다음 버전)

- [ ] **에러 핸들링 개선**: 스크립트에서 더 친절한 에러 메시지
- [ ] **로깅 추가**: 디버깅을 위한 verbose 모드
- [ ] **검색 결과 캐싱**: 동일 쿼리 반복 시 성능 향상

### 중기

- [ ] **컨텐츠 기반 검색**: 파일명/카테고리뿐 아니라 문서 내용도 키워드 검색
- [ ] **자동 카테고리 추천**: 문서 내용 분석해서 적절한 카테고리 제안
- [ ] **중복 감지**: 유사한 내용의 문서가 있으면 경고

### 장기

- [ ] **웹 UI**: .context/ 디렉토리 시각화 및 편집
- [ ] **팀 동기화**: 여러 사람이 공유하는 컨텍스트 관리
- [ ] **버전 비교**: 문서 변경 이력 시각화

---

## 알려진 이슈

### 1. qmd 컬렉션 이름 하드코딩

현재 `context`로 고정되어 있음. 프로젝트별 다른 이름 사용 시 문제.

**해결 방안**: 환경변수 또는 설정 파일로 컬렉션 이름 지정

### 2. 상대 경로 의존성

스크립트가 플러그인 디렉토리 기준 상대 경로 사용.
`--plugin-dir` 외의 설치 방식에서 경로 문제 가능.

**해결 방안**: `$PLUGIN_DIR` 환경변수 또는 절대 경로 감지 로직

### 3. Windows 호환성

Bash 스크립트 hooks가 Windows에서 동작 안 함.

**해결 방안**: PowerShell 버전 hooks 추가 또는 Python으로 대체

---

## 참고: 관련 파일

| 작업 | 수정할 파일 |
|------|-------------|
| 검색 알고리즘 | `scripts/find_context.py` |
| 업데이트 로직 | `scripts/update_context.py` |
| qmd 설정 | `scripts/qmd_setup.py` |
| 명령어 동작 | `commands/*.md` |
| 스킬 워크플로우 | `skills/context-manager/SKILL.md` |
| 플러그인 메타데이터 | `.claude-plugin/plugin.json` |

---

## 질문/결정 필요 사항

1. **배포 방식**: GitHub 릴리즈? npm 패키지? 플러그인 마켓플레이스?
2. **버전 관리**: SemVer 사용? 언제 1.1.0으로?
3. **문서 언어**: 현재 영어/한국어 혼용. 통일 필요?
