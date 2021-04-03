# AWS Systems Manager (SSM)

SSM 서비스 내 관리형 인스턴스에 EC2 인스턴스가 포함되면 다음과 같은 작업이 가능 (`AmazonSSMManagedInstanceCore` 정책을 연결함으로써 쉽게 관리형 인스턴스로 등록 가능 - 기존에 연결하지 않고 나중에 추가되었다면 SSM Agent를 재시작해주어야 함)

1. Session Manager
   - EC2에 pem key 없이 SSH 접속할 수 있도록 해줌
   - Bastion Host를 통하여 AWS VPC의 Private Subnet에 접근하는 방법도 있지만, 이는 `Bastion Host 인스턴스 생성` + `X.509(RSA) Key Pair 관리` + `22번 (SSH)포트 허용을 위한 보안 그룹 생성`을 해야하는 불편함이 있다.
   - SSM는 HTTPS 프로토콜을 사용하며, 인증에 AWS Credentials을 사용
2. Run Commnad
   - 사전 정의된 명령을 작업하도록 시킴
3. Patch Manager

   - 인스턴스의 패치 상태를 일일이 확인하지 않고
   - **주기적으로** 패치 상태를 확인하고 패치를 적용해주는 것을 Run Command에 의해 실행됨
   - 패치 매니저를 사용하려면 `AmazonSSMPatchAssociation` 정책을 추가로 연결해주어야 함

4. Parameter Store
   - 암호, 데이터베이스 문자열, AMI ID, 라이선스 코드 등을 파라미터 값으로 저장

`AmazonSSMManagedInstanceCore` 정책 연결 이후, 다음 커맨드로 EC2 인스턴스에 연결 가능

```sh
aws ssm start-session --target <EC2 인스턴스 ID>
```

## SSM Maintenance Windows (SSM 유지 관리 기간)

- 운영체제 패지, 드라이버 업데이트, 소프트웨어 및 패치 설치 등 작업 일정을 정의할 수 있음.
- 일정, 최대 기간, 실행되어야 하는 인스턴스 집합 (대상 집합), 작업 집합
- 실행되지 않는 날짜를 지정 가능

## Reference

- [AWS 관리형 인스턴스를 사용해야만 하는 이유 - OpsNow Tech Blog](https://blog.opsnow.com/23)
- [AWS SSM으로 EC2 인스턴스에 접근하기 (SSH 대체)](https://musma.github.io/2019/11/29/about-aws-ssm.html)
