## 기술 스택
- UIKit: iOS UI 구성에 사용.
- Code-Base: 스토리보드 대신 코드로 UI 구현.
- Snapkit: AutoLayout을 코드로 간결하게 작성.
- Alamofire: 네트워크 요청 및 데이터 처리.
- Moya: RESTful API 네트워크 계층 관리
- SwiftLint: 코드 스타일 검사 도구.
- SPM: 패키지 의존성 관리.

## 브랜치 컨벤션
- 브랜치 전략: GitHub Flow
- main: 배포 가능한 상태의 코드를 유지.
- feature/기능명: 각 기능 개발 시 main에서 분기.
- Pull Request를 통해 main 브랜치에 병합.
- 병합 후 feature/기능명 브랜치 삭제

## 코드 컨벤션
### 네이밍 규칙
- 클래스/구조체: PascalCase
- 변수/함수: camelCase
- 파일 이름: 클래스/구조체 이름과 동일.
- 참고 자료: [swift-style-guide](https://github.com/StyleShare/swift-style-guide)

### 코드 스타일
- SwiftLint를 적용하여 코드 일관성 유지.
- 불필요한 force unwrapping 금지(! 사용 최소화).
- 최대 줄 길이: 100자 초과 금지.
- self는 클로저 내부에서만 사용.

### 주석 작성

- 주요 로직에 대해 주석 작성.
- 함수, 변수, 클래스에는 /// 를 사용하여 역할 설명.  
→ 팀원들이 모두 이해할 수 있도록
- MARK 주석은 역할 구분시 사용.
- //  : 개인적으로 남겨야 할 코멘트 작성할때 사용.

## 커밋 컨벤션
- 커밋 메시지 형식: [타입]: 작업 내용  
ex) feat: add login screen
- 하나의 티켓에는 하나의 커밋만  
→ 🔗 우린 Git-flow를 사용하고 있어요
### 타입:
- feat: 새로운 기능
- fix: 버그 수정
- refactor: 코드 개선
- style: 스타일 변경 (기능 변화 없음)
- test: 테스트 추가
- docs: 문서 추가/수정

## 이슈 컨벤션
### 이슈 네이밍
- feat: 기능 개발
- bug: 버그 수정
- docs: 문서 작업
- duplicate: PR 중복
- refactor: 코드 리팩토링
### 이슈 템플릿
- 작업 내용
- 예상 소요 시간
- 작업 완료 조건

## PR 컨벤션
- PR 제목: [타입]: 작업 내용  
ex) [feat]: 로그인 화면 구현
### PR 템플릿
1.	작업 내용 요약
2.	테스트 결과
3.	관련 이슈 링크
### Merge 조건
- 리뷰어 지정: 최소 1명 코드 리뷰 필요.

## 프로젝트 초기 세팅 방법
1. $ git clone
2.	SwiftLint 설치 및 설정.