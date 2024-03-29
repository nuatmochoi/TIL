# Amazon SQS vs Amazon SNS

## Amazon SNS 
- Pub Sub(출판-구독) 모델 : 게시자가 SNS로 메시지를 보낼 때 구독자에게 Push됨 (Push 방식)
- 개별 메시지를 보내거나 대량의 메시지를 다수의 수신자에게 보낼 때 사용
- 이메일, SMS, HTTP 엔드포인트 및 SQS와 같은 엔드포인트를 지원함
- 메시지를 가져오는 동시에 메시지 삭제. 사용 가능한 수신자가 없을 경우 메시지 손실 (메시지 전달이 보장되지 않음)
- 수신자마다 다른 방식으로 메시지 처리 가능

## Amazon SQS
- 분산 큐잉 시스템 : 메시지가 수신자에게 푸시되지 않고, 수신자가 메세지를 수신하기 위해 SQS를 Polling 해야함 (Pull 방식)
- 동시에 여러 수신자가 메시지를 받는 것이 아님. SNS와는 달리 폴링 방식으로, SQS에서의 메시지 전달에는 약간의 latency 존재
- 애플리케이션 분리 및 병렬 비동기 처리에 사용됨
    - 트래픽이 많이 몰리는 상황에서, 누락되는 요청을 안정적으로 받아내기 위해 특정 서비스 앞에 붙여 사용
- 수신자가 available하지 않을 경우 메시지가 최대 14일(기본값 : 4일) 동안 SQS내에 저장 (메시지 전달이 보장)
- 모든 수신자가 동일한 방식으로 메시지를 처리해야 함
- 표준 대기열
    - API 작업별 초당 무제한 호출 수 지원
    - 각 메시지 최소 1회 전달 보장
        - 2회 이상 동일한 메시지가 전달될 수도 있음.
        - 가용성을 위해 메시지를 여러 서버에 저장하고, 서버가 사용될 수 없는 경우 메시지가 삭제되지 않고, 다시 메시지를 수신할 수 있도록 설계되어 있기 때문
    - 정확한 순서 보장 X
- FIFO 대기열
    - API 작업별 초당 최대 3000개 트랜잭션 지원(초당 300번의 처리 * Batch 10회 처리)
    - 모든 메시지를 정확히 1회 처리 보장
    - 정확한 순서 보장
- DLQ (데드레터큐) : 메시지 전송 실패를 처리할 때 사용. 해당 대기열을 따로 생성해야 사용 가능

### SQS visibility timeout
- 소비자가 큐에서 메시지를 받아서 처리할 때, SQS는 자동으로 메시지를 삭제하지 않는다.
- 메시지를 받은 즉시에는 여전히 큐에 남아있다. 다른 소비자가 메시지를 받는 것을 막기 위해, SQS에서는 visibility timeout 설정을 제공하고 있다. 기본 visibility timeout값은 30초 이다. 최소는 0초, 최대는 12시간까지 설정할 수 있다. 
    - visibility timeout 시간을 변경하려면 `ChangeMessageVisibility` api를 호출하여 변경할 수 있다.
- `DeleteMessage` api로 지정된 큐에서 지정된 메시지를 삭제할 수 있다. Visibility timeout 설정으로 인해 다른 소비자가 메시지를 잠근 경우에도 큐에서 메시지를 삭제할 수 있다.

## SNS with SQS
### SNS 단일 사용 시 문제점
1. 메시지를 받는 수신자가 연결을 막았을 수 있음
2. 대량의 메시지로 엔드포인트가 죽을 수도 있음
3. http 엔드포인트 혹은 SMS로 보낼 때 메시지 전송 실패로 메시지가 도착하지 못하고 모두 삭제될 수 있음

- SNS와 SQS를 결합하면 원하는 속도로 메시지를 받을 수 있음!
- 클라이언트가 오프라인 상태가 되거나, 네트워크 및 호스트 장애에도 메시징에 문제가 없음 (메시지 전송을 보장)

## Amazon MQ
- 온프레미스 환경에서 사용하던 코드를 클라우드로 그대로 옮기고 싶거나, MQTT, STOMP 등 다양한 프로토콜 지원이 필요한 경우
