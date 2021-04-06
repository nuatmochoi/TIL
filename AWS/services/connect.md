# Amazon Connect

- 인터넷 연결만 되면 관리자, 상담원이 어디서나 이용 가능
- 하드웨어, 공간, 전화 인프라가 필요 없음
- 시스템 증설, 축소가 자동 (탄력적 - auto scaling)
- 싱글 채널 콜센터가 아닌 멀티 채널 콜센터(채팅, 전화, 웹 문의)로의 확장이 용이
- 녹취는 stereo로 녹음 (한쪽은 상담원 / 한쪽은 고객)

## 기존 오프라인 콜센터와의 비교

- 콜센터 구축이 수개월 정도 걸린다 -> _Connect는 이것을 수분만에 가능하도록 해줌_
- 1년차에 구매 - 3년차에 업그래이드 - 5년차에 갱신
  - 인프라 노후화
  - 업그레이드 비용
  - 추가 설치 비용
- 통화 내용을 단순히 저장하는 것뿐 -> _Connect는 텍스트로 인식하고, 콜을 언제 누가 받았고 어떻게 대응했는지 알 수 있다._
- 기존에는 IVR(Interactive Voice Response System), Recording 설계, 관리가 힘듦. -> _Connect는 고객 흐름을 커스텀하기 쉽고, 녹취가 용이_
- TTS로 음성을 구축한 다음, 실제 런칭하면 전문 성우로 대체하는데, 이후에 변경이 쉽지 않다 -> _Connect는 Polly를 통해 쉽게 변경할 수 있다._
- 상담원이 통화를 하지 않더라도, 통화 관련 약정이 필요하기 때문에 가격이 부담 -> _Connect는 통화를 할때만 과금_

## 비용

1. 분당 사용료
2. 번호 사용료
3. 통화료 (지역마다 다르며, 대한민국 수신이라면 분당 $0.0251)
4. 3번까지가 Connect를 사용하는 당사자가 내는 비용, 고객에 대해서는 따로 명시되어 있지 않지만, 모든 통화 요금을 내는 것으로 이해된다.

## 과정

- 현재 서울 리전에서 서비스하고 있지 않기 때문에, 아웃바운드 콜을 한국으로 연결하기 위해서는 support case를 열고 whitelist에 KR을 추가해달라는 요청을 해야한다.
- 기본적으로 소프트폰이고, 프로토콜은 WebRTC 사용
- https://github.com/aws/connect-rtc-js (softphone 개발)
- https://github.com/aws/amazon-connect-streams (웹으로 자체 커스텀)

1. agent가 웹 브라우저를 이용해 Amazon Connect 애플리케이션에 액세스
2. agent는 WebRTC를 통해 브라우저에서 Amazon Connect에 대한 음성 연결을 설정. signaling 통신은 TLS로 암호화, 오디오는 SRTP를 통해 암호화
3. PTSN(기존 전화 통신망)에 대한 연결은 통신 사업자와 Amazon Connect 간 private network 연결로 이루어짐. 공유 네트워크 사용 시 singnaling 통신은 TLS로 암호화, 오디오는 SRTP를 통해 암호화
4. 통화 녹음은 Amazon Connect에 액세스 권한이 부여된 Amazon S3 버킷에 저장
5. Amazon S3 서버 측 암호화는 고개 소유의 KMS 키를 사용해 통화 녹음을 암호화

## 타 AWS 서비스와의 연계

- Polly : 한국어를 활용한 콜센터 시나리오 구축이 가능하다.
  - AI TTS : 문맥에 따라 달라지는 발음
  - SSML을 통해 세부적인 조정이 가능
  - 생성한 polly 음성을 다운로드 받아, 프롬프트로 연결 가능 (connect IVR 상에서 직접 TTS도 가능)
- S3 : 녹취 / 상담 이력, call 레포트
  - KMS 기반으로 암호화된 상태로 저장됨
  - Connect 인스턴스를 생성할 때 자동으로 S3 버킷을 생성하고, Connect에 저장/관리/암호화/읽기/쓰기 권한을 부여함
  - 6개월 지난 녹취 기록은 Glacier로 이관하든지, 저장을 위해 라이프사이클 관리가 용이
- Lambda
  1. Contact Flow 상에서 [AWS Lambda 함수 호출] 블럭 뒤에 [연락처 속성 설정] 블럭을 연결하는 순서로 설정
  2. [연락처 속성 설정] 블럭에서 대상 유형을 `사용자 정의`로, 대상 속성을 원하는 문자열 값으로, 그리고 속성 유형을 `외부`로 하고, 속성 값을 `Lambda return object의 key값`으로 지정
  3. 프롬프트 재생에서 $.Attribute.[속성 값] 으로 해당 값에 접근 가능
- VPN, Direct Connect : 온프레미스의 고객 정보 연결을 위함
- Connect <-> Lex(Poly) -> Transcribe (realtime) -> Comprehand (감정분석) -> Analytics (Athena, Kinesis, Glue, Quicksight)

## 프리티어

- 서비스를 사용하는 첫 12개월 동안 무료 사용
  - 매월 90분의 Amazon Connect 사용료
  - 해당 AWS 리전의 DID(Direct Inward Dial) 번호 사용료
  - 매월 30분의 시내 수신/발신 DID 통화료
