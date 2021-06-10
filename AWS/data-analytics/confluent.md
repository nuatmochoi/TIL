## Kafka & Confluent

- kafka : 데이터를 전송해주는 메시징 플랫폼. 동시에 데이터를 실시간으로 처리하는 플랫폼

  - 분산 트랜잭션 로그로 구성된 확장 가능한 Pub/Sub 메시지 큐에 저장 기능이 포함된 것.

- 카프카만 가지고는 데이터 유통만 가능.
- 각종 애플리케이션을 붙이기 위한 커넥터, proxy, 실시간 테이블 처리을 위한 ksqlDB 등을 지원하는 Confluent
- Confluent는 Apache Kafka에 대한 commit의 80% 이상을 담당

## Confluent

- Confluent는 Kafka의 창시자가 설립
- 설치형 서비스 및 SaaS 서비스 제공
- 실시간 모니터링 툴 제공

## 마이크로서비스

- 대표적인 것이 넷플릭스 아키텍처: 각 서비스간 연결이 중요하지만, 많아질수록 복잡해짐
  ![Neflix](https://gblobscdn.gitbook.com/assets%2F-LcsheX9TIMwoBSNygvE%2F-LjpfQhvrhmEPWA-DTYW%2F-LjphIHMTTcPNLMu9jwf%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-07-15%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%209.56.51.png?alt=media&token=94a25c1c-8bc1-407a-97c6-8bfdd5edb4e4)
- 이벤트 기반 마이크로서비스에서 중요한 것이 event bus인데, confluent가 해당 역할을 함
