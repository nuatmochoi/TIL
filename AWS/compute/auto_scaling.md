# AWS Auto Scaling

트래픽이 증가할 때 인스턴스를 늘리는 것 외에도 트래픽이 줄어듦에 따라 줄여주는 것도 Auto Scaling에 포함

1. 특정 주기마다 로드밸런서의 네트워크 정보와 서버의 시스템 리소스 메트릭 정보들을 모니터링 서비스로 수집
2. AWS CloudWatch에서 입계값을 벗어나는 것을 감지하면 Auto Sacling 그룹으로 알람 전송 (Auto Scaling 정책 Trigger)
3. 서버 수를 늘리거나 줄이는 Auto Scaling 정책 적용
4. 지정된 서버 수만큼 프로비저닝 작업 시작됨 (프로비저닝 : 사용자의 요구에 맞게 시스템을 제공하는 것)
5. AWS ELB(Elastic Load Balancing)에서 생성한 신규 서버의 상태 확인을 위해 http 요청과 200 OK response를 통해 시작 여부 확인 가능
6. 서버 상태 완료 이후, 서버를 서비스 로드밸런서에 추가하여 기존 서버와 동일하게 클라이언트의 request를 처리함

## 적용되는 서비스

- 주기적으로 특정 시간대에 트래픽이 집중하는 서비스
- 일괄작업(batch), 주기적 분석과 같은 패턴 서비스
- 특정 기간에 급증하는 트래픽 등

## Auto Scaling 보안
- Auto Scaling 요청은 요청 메시지 및 사용자의 개인키에서 계산한 HMAC-SHA1 서명으로 서명