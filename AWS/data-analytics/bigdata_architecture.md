# 빅데이터 아키텍처

빅데이터 아키텍처에는 다음과 같은 워크로드 유형이 포함된다.

- 미사용 빅 데이터 원본의 일괄 처리
- 사용 중인 빅 데이터의 실시간 처리
- 빅 데이터의 대화형 탐색
- 예측 분석 및 기계 학습

## 람다 아키텍처

- 일괄 처리계층 (Batch Layer) : 들어오는 모든 데이터를 원시(raw) 형식으로 저장하고, 해당 데이터에 대해 일괄 처리를 수행
  - 대용량 데이터 집계에 오랜 시간이 걸리기 떄문에, 배치를 이용해서 데이터를 미리 계산
- 빠른 레이어 (Speed Layer) : 데이터를 실시간으로 분석. 정확도는 떨어지지만 짧은 대기 시간을 제공

  - Batch Layer의 갭을 메우는 것. 데이터가 Batch의 간격에 따라 편차가 발생한다. 배치는 매일 돌리면서, 오늘의 데이터에 대한 계산값을 실시간으로 업데이트 하는 방법을 사용. 실시간 집계 테이블과 배치 테이블을 조인하여 실시간 통계를 보여주는 식

  ![Lambda Architecture](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/images/lambda.png)

## 카파 아키텍처

- 람다 아키텍처의 복잡성을 해결하기 위해 제안된 아키텍처
- 모든 데이터가 스트림 처리 시스템을 통해 단일 경로로 흐름
- 배치 레이어를 제거하고, Speed Layer에서 모든 데이터를 스트림 처리하여 서빙 레이어로 전달하는 구조

![Kappa Architecture](https://lh4.googleusercontent.com/7hZHJ21ubSdIrdHQ-9XyJueF0Askayc-i0eAZp978okhEsx4v0OGheiFaXv4SQvDXOpqbGr9AU3Srd2yt43xkXYrI3o2r6VqxtHnt4naAACQJQbRclG_bZUZJFD05fgWXuljWZ8c)

## IoT (이벤트 기반 아키텍처)

- 데이터가 경우에 따라 대기 시간이 긴 환경에서 수집되며, 수천만 혹은 수백만 개의 디바이스에서 낮은 대기 시간 환경으로 전송되어 데이터를 빠르게 수집하고 처리하는 기능이 요구됨

![IoT Architecture](https://docs.microsoft.com/ko-kr/azure/architecture/guide/architecture-styles/images/iot.png)

- 클라우드 게이트웨이 : 안정적이고 대기 시간이 짧은 메시징 시스템을 사용하여 디바이스 이벤트를 수집
- 디바이스는 클라우드 게이트웨이에 직접 이벤트를 보내거나, 필드 게이트웨이를 통해 보낼 수 있음 (필드 게이트웨이는 디바이스와 함께 배치됨)
  - 필드 게이트웨이에서 필터링, 집계, 프로토콜 변환 등 기능을 수행하여 전처리를 수행함
- 수집된 이벤트는 데이터를 스토리지 등으로 라우팅하거나 분석 등 처리를 할 수 있는 스트림 프로세서를 통과함.

## Reference

- [빅데이터 아키텍처 - Microsoft Docs](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/)
