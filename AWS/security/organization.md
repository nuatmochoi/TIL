# AWS Organizations

- 여러 AWS 계정을 생성하고 중앙에서 관리하도록 통합
  ![Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/images/BasicOrganization.png)

## 용어 정리

- 루트 : 모든 계정에 대한 상위 컨테이너. 정책을 루트에 지정하면, 정책이 모든 OU와 계정에 적용
- OU (조직단위) : OU에 정책을 연결하면, 하위에 연결된 OU와 leaf까지 정책이 반영됨
- SCP : SCP는 Organization, OU, 계정에 대한 최대 권한을 지정

## SCP (서비스 제어 정책)

- 조직의 루트에서는 SCP를 연결하지 않는것이 좋고, 프로덕션 OU에 연결하는 것을 권장

## Access 알림

- CloudWatch Events, CloudTrail와 같이 사용하여 관리자가 지정한 작업이 발생할 때 이벤트 발생시킬 수 있음
- CloudWatch Event Rule을 구성하여, SNS와 연결 가능
- AWS Config의 다중 계정, 다중 지역 데이터 집계를 통해 여러 AWS 계정에 대해 규정 준수 모니터링 가능

## AWS RAM

- AWS Resource Access Manager (RAM)을 사용하여 지정된 AWS 리소스를 다른 계정과 공유할 수 있다. AWS Organization 에서 이러한 `신뢰할 수 있는 액세스`를 활설화 하려면 AWS RAM CLI에서 `enable-sharing-with-aws-organizations` 커맨드를 사용한다.
