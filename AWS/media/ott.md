# OTT

## 순서

미디어 파일 - s3 - lambda - aws elemental MediaConvert - s3 - cloudfront - client

## HLS(HTTP 라이브 스트리밍)

- HLS는 비디오 파일을 다운로드할 수 있는 HTTP 파일 조각으로 나누고 HTTP 프로토콜을 이용해 전송
- 클라이언트는 이러한 HTTP 파일을 로드한 후 비디오로 재생
- 모든 인터넷 장치가 HTTP를 지원하기 떄문에 간단하게 실행 가능
- HLS 스트리밍은 재생에 지장을 주지 않고 네트워크 상태에 따라 비디오 품질을 높이거나 낮출 수 있다.

- 미디어 파일을 한 번에 모두 보내는 대신 한 번에 조금씩 지속적으로 사용자 장치에 보냄

1. 서버

- 인코딩 : 비디오 포맷 재설정 -> 모든 장치가 데이터를 인식하도록
- 조각화 : 비디오는 몇 초 길이(10초 정도)의 세그먼트로 쪼개짐
  - 세그먼트로 나누고, 세그먼트의 인덱스 파일(m3u8)을 만들어 세그먼트의 순서를 기록
  - HLS는 480p, 720p, 1080p 등 다양한 품질로 여러 세트 세그먼트 복제

2. 배포

- 일반적으로 CDN을 사용하여 여러 지역으로 배포. 스트리밍을 캐시하여 클라이언트에 더 신속히 전송 가능

3. 클라이언트

- 인덱스 파일(m3u8)을 참조하여 비디오를 순서대로 조합하고 필요에 따라 품질을 높이거나 낮춤

## 스트리밍

- MediaLive : 실시간 스트리밍 영상을 가공
- MediaPackage : 영상 저장
