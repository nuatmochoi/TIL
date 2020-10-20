# TDD

SW캡스톤디자인 과목 수강 중 라이엇게임즈 유석문 개발이사님의 Test Driven Development 특강을 듣고 TDD의 중요성을 깨달아 내용을 정리하게 되었습니다.

## 테스트가 필요한 이유

- 빠르게 데모를 통해서 보여주고 빠르게 확인하는 작업이 중요하다.
- 개발할 때 제대로 동작하는지 확인하는 과정이 필요
- 유닛테스트를 왜 해야하는가 - 버그를 코드를 작성한 시점에 발견하면 가장 좋음
- 프로젝트에 포함된 사람이 많고 비용도 많이 들기 때문에, 오류를 빠른 단계에서 잡아내면 나중에 찾지 않아도 된다.

## 테스트의 종류

- TDD(프로그래머의 테스트) - 유닛테스트와 통합 테스트 (유닛코드를 모아서 통합테스트를 진행한다)
- ATDD (Acceptance test) - 고객의 테스트, TDD가 모여서 하나의 ATDD를 구성하게 되는 것

## Java Unit Test

- 새로 도입하는 프로젝트라면 JUnit 5를 쓰는 게 유리
- 현업에서는 레거시인 JUnit 4를 많이 사용
- `@Test` 어노테이션과 `assertEquals`를 통해 테스트 (맞는지 틀린지 확인 - 수행했을 때 결과가 첫 번째, 두 번째 값은 비교값 -> 같으면 True, 다르면 False)

### 어노테이션 종류

- `@Test(expected = Exception.class)` : 실제 예외가 발생하는지 체크
- `@Test(timeout = 1000)` : async 체크 – 타임아웃 체크 등 : 정상적 실패인지 버그인지 – 실제로 문제가 되는 버그라면 놓치게 되는 경우를 해결하기 위함
- `@Test @Ignore` : 무시하는 테스트
  - 테스트 하나하나가 spec. 스펙에 맞게 프로덕션 코드를 작성하는 것. 개발하다보면 스펙이 바뀌는 경우도 있는데, 이럴 때 사용
  - 고치는 중간에 테스트를 스펙에 맞게 바꿔야되는데, 이걸 ignore 처리하고 두어버리면 좋지 않은 테스트. 스펙으로도 동작 못하고 테스트로도 동작 못하는 것
  - 테스트와 스펙의 싱크를 맞추어야되는데, 임시로 해결하기 위해서 ignore을 쓰는 것은 좋지 않은 것
- `BeforeClass` / `@AfterClass` : Class 의 시작 전후에 실행되는 test code
- `@Before` / `@After` – testcase 단위
  - 어노테이션은 메소드 안에 코드 여러 개가 들어와도 된다. test는 실행 순서를 보장하지 않기 때문에 하나씩만 만드는 것을 추천함
- `assertTrue()` : 트루값이면 패스
- `assertFalse()` : False 가 오면 패스
  - 앞에서 실패가 발생하면 뒤에 것이 실행이 되지 않는다.
  - 테스트메소드의 네이밍을 잘 설명해놓으면 반복적으로 사용 가능
  - `assertTrue(“성공원인”, true);` 혹은 `assertTrue(“실패원인”, false);` 과 같이 실패원인을 명시할 수 있음
- `assertSame()`/ `assertNotSame()`
- `assertNull()` / `assertNotNull()`

## TDD 개발 순서

1. 처음에는 failing unit test 작성 (프로덕션 코드 생성 직전 – 달성할 구현목표인 test를 만들어놓고)
2. 해당 테스트가 성공하는 프로덕션 코드 작성
3. 프로덕션 코드의 품질 높임(리팩토링) - 원래 기능을 망치지않게 – 테스트가 깨지지 않게

- 유닛테스트가 없는 기존 코드의 리팩토링을 해야하는 경우 – 전체 유닛 테스트를 만들 수 없기 떄문에, 부분만을 커버하는 작은 단위의 유닛 테스트 생성 (현업에서 많이 활용되는 방법이다)

## 기타사항

- 소스와 테스트는 다른 디렉토리에 둔다 : 배포 패키지가 커지는 경우 방지
- 어떻게 동작해야하는지 Unit Test 코드를 잘 설계해놓으면 코드를 굳이 설명할 필요가 없을 수도 있다.