# AWS IAM

- console 기반 작업 -> Script 기반 -> 프로비저닝 엔진 (CloudFornmation, Terraform) -> DOM (CDK)
  - 어떤 방식을 사용하든 API로 이루어진다.
- AWS에서 API 인증

  - AWS 자격 증명 = Access Key + 비밀 KEY (HMAC) (+ 임시는 Session Token)
  - 요청 내용과 비교하면 서명값 확인 -> 타임 스탬프 확인 -> 권한 판단 -> 허용 여부 판단

- 데이터, 어플리케이션 (클라우드 위의 보안)은 고객이 보안을 책임 (데이터 + **IAM**)

- IAM : AWS 전체의 권한 통제 시스템 (Identity and Access Management)

  - Identity : AWS로 요청할 수 있는 보안 주체(principal)을 만들어줌
  - Access Management : 누가 어떤 리소스에 대해 어떠 일을 할 수 있는 권한을 가지는지 정의

- Access Advisor를 통해 일정 기간동안 접근하지 않은 서비스에 대해 검사 가능 -> 이후 권한 회수할 것이 권장됨

## Identity

- Root User 는 보안상 취약(권한 조정할 수 없는 슈퍼 유저), 따라서 IAM User, Role을 사용해야 함
  - IAM 사용자 : 로그인할 수 있는 보안 주체로 사용되기도 함 (장기 Credential을 이용해 서비스에 접근하는 보안 주체)
  - IAM Role
    - IAM 사용자가 장기 Credential 사용하기 때문에, 자격증명이 영구지속되기 때문에 서버 안에서 사용하든지, 하드코딩하기에는 위험
    - Role은 자동으로 로테이션 되는 임시 Credential 사용 (키값에 더해 일정 시간이 지나면 만료되는 Token 존재)
    - API적인 접근 / 외부 사용자(외부에 존재하는 보안주체)를 SAML, OpenIDC을 이용해 Role과 연계

## Access Management

- AWS에서의 인가
- 디폴트가 Deny, 명시적 allow < 명시적 deny
- AND 조건으로 권한 인가

- Effect : allow or deny
- action : 어떤 행위를?
- Resource : 어떤 객체에 대해?
- Condition : 어떤 조건에서?

```json
{
	"Effect": "Allow",
	"Action": "dynamodb:GetItem",
	"Resource": ["arn:aws:dynamodb:us-east-2:1111222233333:table/MyTable"],
	"Condition": {
		"IpAddress": {
			"aws:SourceIp": "1.1.1.1"
		}
	}
}
```

## IAM 정책 종류

- Identity-based : IAM User, Role (요청하는 보안 주체에게 연결)
- Resource-based : 자원에 할당 (요청을 받는 리소스에 연결) (Principal이라는 보안주체 속성이 추가)
- Permission Boundary : 권한의 최대치 규정
- SCP : 멀티 어카운트
- Session, ACL, Endpoint

- 동일 어카운트 환경에서 Identity, Resource 충돌 -> 합집합 (한쪽에만 allow 라면, 다른 쪽도 요청 허용)
- 크로스 어카운트 환경에서는 교집합 (한쪽에만 allow 라면, 다른 쪽은 요청 거부)

### AWS Managed Policies

- AdministratorAccess : 특정 IAM User에게 전체 액세스 권한을 부여함
- PowerUserAccess : AWS IAM & AWS Organizations를 제외한 모든 리소스에 대한 작업 허용

## AWS 계정 활동 모니터링 및 감사

- AWS CloudTrail : 모든 API 활동 기록을 확인 가능, 문제가 발생했을 때 트러블 슈팅하기 위함
- AWS IAM Access analyzer : 외부 엔티티와 공유되는 리소스를 식별
- Amazon GuardDuty : CloudTrail, DNS로그, VPC Flow로그를 기반으로 해킹시도나 보안 위협을 탐지
- AWS Security Hub : 다양한 AWS 보안 서비스를 통합하여 보여주는 통합 대시보드 서비스

## ABAC

- Role기반(RBAC)의 문제점 : 역할이 많거나 서비스 확장
  - ABAC : 태그를 이용하여 접근 제어
    - ARN 기반 정적 권한관리가 아닌, 보안 주체의 태그와 리소스의 태그를 비교하여, 동적 권한관리

## Policy

- IAM 신뢰 정책 : 대상이 역할을 하도록 (ex: EC2 인스턴스가 EC2 역할을 하도록)
  - arn key값을 명시함으로써 가능
- IAM 권한 정책 : 역할을 부여 (ex: EC2 ROLE이 S3 객체에 액세스하도록 권한 부여)
