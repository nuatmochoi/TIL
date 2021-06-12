## Kafka & Confluent

- kafka : 데이터를 전송해주는 메시징 플랫폼. 동시에 데이터를 실시간으로 처리하는 플랫폼

  - 분산 트랜잭션 로그로 구성된 확장 가능한 Pub/Sub 메시지 큐에 저장 기능이 포함된 것.

- pub/sub 데이터 모델
  ![kafka](https://engineering.linecorp.com/wp-content/uploads/2019/10/1kafka2.jpg)

  - producer : kafka에 데이터를 입력하는 클라이언트
  - broker cluster : topic이라고 불리는 데이터 관리 유닛을 임의 개수만큼 호스팅하는 클러스터
    - producer는 그 중 하나의 topic만을 대상으로 데이터 입력
  - consumer : kafka에서 데이터를 가져오는 클라이언트
    - 데이터를 가져올 topic을 지정한 후 해당 topic에서 데이터를 가져옴
    - 하나의 topic에 여러 개의 consumer가 각각 다른 목적으로 존재
    - topic에 입력된 데이터는 여러 consumer가 서로 다른 처리를 위해 여러 번 가져올 수 있음

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
  ![event bus msa](https://docs.microsoft.com/ko-kr/dotnet/architecture/microservices/multi-container-microservice-net-applications/media/integration-event-based-microservice-communications/event-driven-communication.png)
