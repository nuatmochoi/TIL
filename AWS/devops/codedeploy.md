# CodeDeploy

## AppSpec 
- AppSpec은 CodeDeploy가 배포를 관리하기 위해 사용하는 형식 파일 (JSON or YAML)

## 파일 구조
1. AppSpec 파일구조 for ECS
```yml
version: 0.0
resources: 
  ecs-service-specifications
hooks: 
  deployment-lifecycle-event-mappings
```

2. AppSpec 파일구조 for Lambda
```yml
version: 0.0
resources: 
  lambda-function-specifications
hooks: 
  deployment-lifecycle-event-mappings
```

## AppSpec 'hooks' 
그림에서 스크립팅이 불가능한 이벤트는 회색으로 표시됨

1. AppSpec 'hooks' for ECS

<img src="https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/images/lifecycle-event-order-ecs.png" width=200>

- `BeforeInstall`
- `AfterInstall`
- `AfterAllowTestTraffic`
- `BeforeAllowTraffic`
- `AfterAllowTraffic`

2. AppSpec 'hooks' for Lambda

<img src="https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/images/lifecycle-event-order-lambda.png" width=200>

- `BeforeAllowTraffic` : 배포된 Lambda 버전으로 트래픽 전환 전 작업 실행
- `AfterAllowTraffic` : 배포된 Lambda 버전으로 전환 후 작업 실행
