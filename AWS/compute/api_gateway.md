# API GATEWAY

- Security
- Mediation
- Traffic Management

## 기능

1. Routing

   - 모바일과 PC 중 적절히 라우팅
   - Monolithic -> MSA 할 때 많이 사용
     - 마이그레이션 할 때 중요하게 사용
     - 마이그레이션 중 따로 뺀 api도 동작해야하기 때문

2. Quota (할당량)

3. Authentication (인증)

4. Authorization (특정 권한 가진 사람만 접근)

5. API Cache (반복 요청에 대해 API 게이트웨이의 캐시로부터 바로 반환)

6. Logging - 로그 파일이 한 곳에 모임

7. 모니터링

8. 로드 밸런서와 다른 부분? : Mediation (중재)

   - 백엔드 api가 바뀌었을 때 클라이언트의 요청을 바꿔주는 기능
   - 클라이언트가 원하지 않는 속성을 지워주는 기능
   - 각 단계별(4단계)로 원하는 조건을 수행하도록 함

9. json to xml, xml to json 가능

10. gRPC (내부에서는 빠르게, 외부에는 API Gateway를 거쳐서 필요한 형식 json 등으로)

11. API Gateway는 k8s와 통합이 시작되고 있음

    - 백엔드 서비스가 k8s 형식으로 배포될 때, 입구에서 API Gateway가 하나씩 던져주는 식으로 작동

12. HTTP API vs REST API

- HTTP API : 가격이 100만 건당 $0.90 ~ $1.00으로 싸지만, Validation, WAF, API Caching, loging 등을 지원하지 않음
- REST API : 100만 건당 $1.51 ~ $3.50, [HTTP API보다 다양한 기능을 제공](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html)

13. WebSocket API - 요청을 받고 응답하는 REST API와는 다르게 클라이언트와 백엔드 간 양방향 통신 지원

- 채팅, 알림, 실시간 대시보드에 사용됨

## API Gateway vs ALB

1. 확장성
   - API Gateway : 10000 RPS(requests per second) 가 제한
   - ALB : 제한 없음
2. 신뢰성 및 가용성
   - API Gateway : 사용자가 관리할 필요 X
   - ALB : 사용자가 region 당 2개 이상의 AZ를 지정할 필요가 있음
3. 타 서비스와 통합
   - API Gateway : Lambda 함수 이외에 DynamoDB, SQS, S3 등 HTTP 기반 서비스와 모두 통합 가능
   - ALB : [Lambda](https://aws.amazon.com/ko/about-aws/whats-new/2018/11/alb-can-now-invoke-lambda-functions-to-serve-https-requests/), EC2, ECS, Cognito
4. Routing
   - API Gateway : 경로 기반 라우팅 (클라이언트 요청 url 기반)
   - ALB : 규칙 기반 라우팅 (url 기반 + 요청자 host name, IP address, HTTP header, Request Type 등)
5. 비용
   - API Gateway : 수신한 요청에 대해서만 부과
     - HTTP API : 100만 건당 $0.90 ~ $1.00
     - REST API : 100만 건당 $1.51 ~ $3.50
     - WebSockets : 100만 건당 $0.80 ~ $1.00, 연결 분당 0.25
   - ALB : 시간당 + 리소스 사용량당
     - 시간당 $0.0225
     - LCU(로드밸런서 용량 단위) 시간당 $0.008 - [참고](https://aws.amazon.com/ko/elasticloadbalancing/pricing/)
