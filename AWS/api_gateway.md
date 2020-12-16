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
