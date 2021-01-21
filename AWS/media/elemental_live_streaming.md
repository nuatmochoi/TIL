# AWS Elemental Live Streaming (MediaLive & MediaPackage)

## Live Streaming 필수 요소

1. 미디어 입력
   - 시청하기에 적절하게 쪼개져 있지 않고, 고해상도일 수 있다.
2. 변환 & 저장
   - MediaLive : 고해상도의 입력신호를 적합한 화질로 변환
     - HTTP Live Streaming 이라는 프로토콜로 변환되게 됨
   - MediaStore : 저장
     - 심플한 Live Workload에 적합
     - S3와 같은 storage이지만, Cache Layer를 통해 쓰기, 읽기 지연을 최소화
   - MediaPackage : 저장
     - DRM
     - Live Streaming -> DASH + HLS + MSS (여러 디바이스에서 재생 가능)
3. 전송
   - CloudFront : 실시간 데이터를 안정적이고 좀 더 빠르게 클라이언트가 재생할 수 있게 함
4. 재생 & 소비

## MediaPackage

- MediaLive의 목적지로 존재하기 때문에 가장 먼저 생성
- Input A, B의 주소로 프로세싱된 스트림을 보내게 됨
- 사용자가 재생할 수 있는 엔드포인트(HLS, CMAF, DASH)는 직접 생성해줘야 함
- Packager Settings
  - 영상을 몇 초 단위로 쪼갤지, 재생 목록에는 몇 초 단위를 유지할지

## MediaLive

- 채널 먼저 생성하지 않고, 입력(Input A, B)을 먼저 생성
  - Event 기반, Time 기반으로 입력을 switing하는 기능이 제공 (일정 Tab)
  - 특정 시간에는 특정 인풋으로 스트림, 다른 시간에는 다른 인풋으로 맵핑 가능
- Input Type
  - RTP : UDP 기반, 전용망(Direct Connect, MediaConnect)
  - RTMP : TCP 기반, Public망
    - Push : 영상을 밀어넣거나 (OBS - 웹캡 to RTMP)
    - Pull : 미디어 서버에서 가져오거나
  - HLS, MP4 : S3의 입력 소스를 기반으로, VOD를 라이브 신호처럼 송출할 때 사용 (VOD to Live)
  - MediaConnect : 리전간 스트리밍 전송 서비스
- 채널 생성
  - 템플릿 : 해상도, 비트레이트, 프레임레이트가 사전설정된 템플릿
  - 이중화(인풋 2개, 출력 2개) : 가용성 보장하기 위해
  - 코덱 (압축) : 아래로 갈수록 압축률 높다 (압축률 높을수록 CPU자원이 많이 사용되므로 비쌈)
  - ABR (Adaptive Bit Rate): 플레이어의 네트워크 bandwidth에 따라 자동으로 해상도가 변환되는 기능 (ex> 유튜브 auto 해상도 - 쪼개진 영상 시간이 지났을 때)
  - 파이프라인 == input
- m3u8
  - 사파리에서는 바로 재생
  - 크롬에서는 HLS 확장 프로그램 설치
