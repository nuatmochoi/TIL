# 빅데이터 아키텍처

## 람다 아키텍처

- 일괄 처리계층 (Batch Layer) : 들어오는 모든 데이터를 원시 형식으로 저장하고, 해당 데이터에 대해 일괄 처리를 수행
- 빠른 레이어 (Speed Layer) : 데이터를 실시간으로 분석. 정확도는 떨어지지만 짧은 대기 시간을 제공
  ![Lambda Architecture](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/images/lambda.png)
