# AWS Config
- IAM Role과는 달리 사용자가 특정 작업을 하는 것을 허용/제한하지 않음
- Config Rule과 일치하는지 **평가**만 수행
- Config Rule은 Lambda와 연동하여 트리거로 작동할 수 있음

## 리소스 대상
- API Gateway / Lambda
- CloudFront / ELB
- CloudWatch / CloudTrail / X-Ray
- DynamoDB / Redshift / RDS
- EC2 / EBS / VPC / Auto Scaling / EB / Network Firewall
- ES
- S3 버킷 속성/ S3
- SNS, SQS
- IAM / ACM / KMS / Secrets Manager / Shield / System Manager / WAF
- CloudFormation / CodeBuild / CodePipeline / Service Catalog

## 기능
1. 리소스 관리 
- 리소스가 생성, 수정, 삭제될 때마다 알림을 받을 수 있게 설정

2. 감사, 보안 및 규정 준수
- 기업 및 팀의 내부 정책을 준수했는지 리소스 구성 기록(history)을 확인할 수 있음 

3. 의존 관계 리소스 관리
- 연결된 관계의 리소스를 보고, 한 리소스가 변경되었을 때 영향을 확인
- 문제된 리소스의 마지막으로 성공한 구성을 확인

4. 보안
- IAM User, Group, Role에 할당된 정책 확인
- 특정 시점에 사용자에게 부여된 권한 여부 확인 (ex> 사용자 A에게 2020년 8월 15일에 VPC 설정을 수정할 권한이 있었는지)
- 특정 시점의 EC2 보안 그룹 구성(인바운드 포트)
