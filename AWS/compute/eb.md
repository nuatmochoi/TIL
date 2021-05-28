# Elastic Beanstalk

- 애플리케이션 버전 업데이트시 인플레이스 업데이트를 수행하기 때문에 다운타임 발생할 수 있다. 이를 회피하기 위해 블루/그린 배포를 수행하여야 한다.
- 새 버전 배포 이후, Swap environment URLs 옵션을 통하여, 이전 버전과 새 버전의 CNAME을 교환시키며, 트래픽도 리디렉션된다.
- 이전 DNS 레코드가 만료될 때까지 이전 환경을 종료하여서는 안됨.

## 구성
- Application = Environments + versions + configurations

## 아키텍처
![EB Architecture](https://jayendrapatil.com/wp-content/uploads/2016/12/Elastic-Beanstalk-Environment-Tiers.png)
- EB Environment에는 환경 계층, 플랫폼 및 환경 유형이 필요
    - 환경 계층 : EB가 애플리케이션을 지원하기 위해 리소스를 프로비저닝하는지 여부 결정
        - 웹 환경 계층 : 웹 프로그램이 웹 요청을 처리하는 환경 계층
            - ELB, Auto Scaling Group, 한 개 이상 ec2 포함
        - 작업자 환경 계층 : 백그라운드를 실행하는 환경 계층
            - ASG, 하나 이상의 ec2 및 iam 역할 포함
            - SQS를 생성하고 프로비저닝
            - 작업자 환경 계층이 시작되면 언어 지원 파일과 ec2에 데몬을 설치
            - 데몬은 SQS -> 해당 계층에서 실행중인 App으로 데이터 전송

## EB 배포 전략
- 최소/최대 1개의 인스턴스를 유지하기 위한 단일 인스턴스 및 Auto Scaling이 있는 단일 인스턴스 환경 지원
- Auto Scaling및 로드 밸린싱을 사용하는 환경 지원

## EB 배포 방법
![EB 배포 방법](https://jayendrapatil.com/wp-content/uploads/2018/04/Elastic-Beanstalk-Deployment-Methods.png)

1. All at once
- 모든 인스턴스에서 동시에 배포

2. 롤링 배포
- 롤링 배포 중 인스턴스의 일부는 이전 버전의 애플리케이션으로 요청을 처리하고, 완료된 배치의 인스턴스는 새 버전으로 요청 처리

3. Rolling with additional batch
- 배포 프로세스 중 전체 용량을 보장
- 인스턴스가 서비스에서 제외되기 전에 새 인스턴스 배치를 시작

4. Immutable
- All at once와 롤링 배포가 기존 인스턴스를 업데이트하는 것에 반해
- Immutable Update는 항상 새 인스턴스에 배포됨
- 환경에서 두번째 ASG을 시작하여, 새 버전은 새 인스턴스가 상태확인을 통과할 때까지 이전 버전과 함께 트래픽 처리

5. Blue/Green
- swap environment url을 통해 지원
- 새 버전이 새 환경에 배포된 다음 두 환경의 CNAME을 교체
