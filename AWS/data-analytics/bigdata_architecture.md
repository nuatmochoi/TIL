# 빅데이터 아키텍처

## 람다 아키텍처

- 일괄 처리계층 (Batch Layer) : 들어오는 모든 데이터를 원시(raw) 형식으로 저장하고, 해당 데이터에 대해 일괄 처리를 수행
  - 대용량 데이터 집계에 오랜 시간이 걸리기 떄문에, 배치를 이용해서 데이터를 미리 계산
- 빠른 레이어 (Speed Layer) : 데이터를 실시간으로 분석. 정확도는 떨어지지만 짧은 대기 시간을 제공

  - Batch Layer의 갭을 메우는 것. 데이터가 Batch의 간격에 따라 편차가 발생한다. 배치는 매일 돌리면서, 오늘의 데이터에 대한 계산값을 실시간으로 업데이트 하는 방법을 사용. 실시간 집계 테이블과 배치 테이블을 조인하여 실시간 통계를 보여주는 식

  ![Lambda Architecture](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/images/lambda.png)

## Reference

- [빅데이터 아키텍처 - Microsoft Docs](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/)
