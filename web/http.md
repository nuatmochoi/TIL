# HTTP 프로토콜

HTTP 프로토콜은 **stateless 프로토콜**이다. stateless란 다시 말해, 각각의 데이터 요청이 독립적으로 관리가 되는 것이고, 세션 등을 서버가 따로 관리하지 않는 것을 의미한다. 연결을 끊는 순간 클라이언트와 서버의 통신이 끊기며, 상태 정보를 유지하지 않는다.

- 장점 : 불특정 다수를 대상으로 하는 서비스에 적합
- 단점 : client가 로그인을 하더라도 로그 정보를 유지할 수 없다. 따라서 서버는 세션 정보를 cookie를 이용하여 관리한다.

HTTP 프로토콜은 TCP/IP 통신 위에서 동작하며 80번 포트를 사용한다.

![How HTTP works](https://lh3.googleusercontent.com/proxy/4u8mMVuUqh9TXBibsv5tSEMPManW6GihgYdSF6UfwMWvgHCK6UpVcrn_O4TZoi9d4JH6ymQI149p8WmKruPo7-gxQoYo_pWA65VLGV2YozAymSpdYN4jWw7ut2JhCpxuSnv23o3tGXoOWL75MSWaU_qKEQCmpdrgNus)

HTTP 프로토콜은 Request를 보내고 Response를 받는 식으로 동작한다. 즉 Client-Server 형식이다.

HTTP를 통해 전달되는 자료는 `http://` 로 시작하는 **URL**로 조회가 가능하다.

#### HTTP 요청 메소드

- GET: URL가 가진 정보를 조회를 요청
- POST: 클라이언트에서 서버로 entity를 제출함. 때에 따라서 create, update, delete도 가능.
- PUT: 내용 갱신. 전체 자원을 업데이트 할 때 사용한다.
- DELETE: 리소스를 삭제

- PATCH: 리소스의 부분을 수정하는 데 사용.
- HEAD: 헤더 정보만 요청. response body를 반환하지 않음. 자원의 존재 유무만 확인할 때 사용
- OPTIONS: 서버 옵션을 확인하기 위한 요청. CORS에서 사용

#### HTTP 상태 코드

- 2XX : 성공
  - **200** : 오류없이 전송 성공
- 3XX : 리다이렉션
  - **304** : 클라이언트의 캐시에 문서가 저장되었고, 선택적인 요청에 의해 수행됨
- 4XX : 클라이언트 에러
  - 400 : 요청 실패. 문법상 오류가 있어 서버가 요청을 이해하지 못함
  - **401** : 권한 없음. 인증이 필요함.
  - 403 : 금지 (접근 거부 or SSL 등)
  - **404** : 문서를 찾을 수 없음. 서버가 요청한 리소스를 찾지 못함.
  - 405 : 메서드 허용 안됨
- 5XX : 서버 에러
  - **500** : 서버 내부 오류. 서버가 요청을 수행할 수 없음.
  - **503** : 외부 서비스가 멈췄거나, 이용할 수 없는 서비스 (일시적)

#### HTTP 요청 메세지 형식

_Request Header + Empty Line + Request Body_

- Header

  - **요청 메소드 + 요청 URI + HTTP Protocol 버전**
  - _GET /background.png HTTP/1.0_
  - Header 정보 (날짜, 웹서버 이름 및 버전, 콘텐츠 타입 및 길이, 캐시 제어 방식, keep-alive 설정 등)
    - _keep-alive란 지정된 시간동안 연결을 끊지 않고 요청을 계속해서 보내는 방식. TCP는 3 way-hanshake 방식으로 연결을 확인하는데, 매 데이터 요청마다 연결을 맺고 끊으면 비효율적이기 때문에 필요한 방식_

- Empty Line

  - 요청에 대한 모든 meta-content가 전송되었음을 알림

- Body
  - POST와 PUT만 존재하는 부분
  - 요청과 관련된 내용
    - POST는 이 Body 안에 entity를 넘기고, GET은 url로 요청하는 정보를 넘긴다

#### HTTP 응답 메세지 형식

_Response Header + Empty Line + Response Body_

- Header

  - **HTTP Protocol 버전 + 응답 상태코드 + 응답 메세지**
  - _HTTP/1.1 404 Not Found._

- Empty Line

  - 요청에 대한 모든 meta-content가 전송되었음을 알림

- Body
  - 실제 응답 리소스 데이터
