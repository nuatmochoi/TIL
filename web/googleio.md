# Web
Google I/O 2021에서 기조연설을 보고 새롭게 출시되는 웹 관련 기능을 정리했습니다.

- [Day1 Keynote](https://youtu.be/0UiaD059eqM)
## WebApp
- Badging API : 앱 아이콘을 꾸며서 재참여 유도(숫자)
- declarative link capturing : 적절한 링크를 클릭하면 웹앱이 자동으로 실행되도록 함
- 크롬 웹앱 설치 UI 개선
- Multi Screen window placement api : 웹앱이 연결된 모든 디스플레이를 검색하고 해당 화면에 창이 배치되는 위치 제어 (화상 회의에서 유용)
- File System Access API : 웹앱이 사용자 로컬 파일 시스템을 읽고 사용
- File Handling API : 사용자가 파일 브라우저에서 웹앱의 파일을 열 수 있도록 함 (개발중, 2021년 말 출시)

## Google Map
- 기울기 및 회전 & WebGLOverlayView (베타 출시) : 지도 3차원 조작 (with three.js)
    - `onAdd()` : 오버레이 인스턴스 생성 때 호출
    - `onContextRestored()` : 렌더링 컨텍스트가 사용가능할 때 호출됨
    - `onDraw()` : 지도 렌더링

## Web Performance 
- WebAssembly : SIMD 프로세서 커맨드에 대한 지원을 V8에서 구현하여 성능 향상 (ex> Google Meet)
- Intensive timer throttling : 브라우저 탭이 5분 이상 백그라운드 -> 탭에서 JS 코드를 실행하는 빈도 낮춤 
    - `content-visibility` (in CSS): 디스플레이에 표시되지 않을 때 콘텐츠 렌더링 생략 (사이트 속도 향상)
- BFCache (in Android) : 웹페이지에서 벗어난 후 일부 페이지를 메모리에 로드 -> 사용자가 뒤,앞으로 이동할 때 페이지 즉시 표시
    - 곧 Chrome 데스크톱 플랫폼에 출시
- Prerendering : 사용자가 링크 클릭 전 에,모든 리소스 로드하고, DOM 렌더링까지 완료
    - 올해 말에 prerendering을 테스팅할 수 있는 렌더링 API 출시 예정
- Cross-device OTPs : Android에서 OTP를 받고, 노트북 등 다른 기기의 Chrome 브라우저로 자동 전송
