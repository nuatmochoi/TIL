# AWS Auto Scaling

트래픽이 증가할 때 인스턴스를 늘리는 것 외에도 트래픽이 줄어듦에 따라 줄여주는 것도 Auto Scaling에 포함

1. 특정 주기마다 로드밸런서의 네트워크 정보와 서버의 시스템 리소스 메트릭 정보들을 모니터링 서비스로 수집
2. AWS CloudWatch에서 입계값을 벗어나는 것을 감지하면 Auto Scaling 그룹으로 알람 전송 (Auto Scaling 정책 Trigger)
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

## 수명 주기 후크
![ASG Lifecycle Hook](https://docs.aws.amazon.com/ko_kr/autoscaling/ec2/userguide/images/lifecycle_hooks.png)
1. ASG가 인스턴스를 시작
2. `Pending:Wait` (대기) 상태인 인스턴스를 시작한 다음 사용자 지정 작업 수행
    - 기본 1시간을 대기 상태로 유지하고, 이후 작업을 완료하거나 timeout되면 `Pending:Proceed` 상태로 변환
3. 인스턴스가 `InService` 상태로 들어가고 health check가 시작됨. ELB는 인스턴스를 등록하고 상태 확인 시작
4. ASG가 인스턴스를 종료하기 시작. ELB는 인스턴스를 등록 취소
5. 인스턴스가 `Terminating:Wait` 상태가 되고, 사용자 지정 작업 수행
    - 기본 1시간을 대기 상태로 유지하고, 이후 작업을 완료하거나 timeout되면 `Terminating:Proceed` 상태로 변환
