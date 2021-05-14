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

## Reference

- [빅데이터 아키텍처 - Microsoft Docs](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/)
