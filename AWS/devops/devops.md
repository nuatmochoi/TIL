# DevOps
- 유연함을 위한 작은 단위로 나눔 (MSA, 2 피자팀)
    - 유닛을 가능한 작게, 기능 단위가 아니라 **Sacling(확장) 단위 기반으로 분리**
    - 각각의 서비스를 별도로 운영하여, 각각 다른 라이프사이클로 돌게 함
    - 투- 피자팀 : 12~15명 정도
- 모든 것을 자동화
    - 개발, 테스팅 모두 자동화
- 애플리케이션 아키텍쳐적인 변화가 중요하다!!
- 표준 도구 사용
- 프로세스 표준화(템플릿)
- IaC

- 아마존도 초기에 모놀리스 서비스였음 (운영 파이프 라인도 1개만 있었음, 모든 개발자가 한 사이클이 지날 때까지 기다릴 수 밖에 없는)
    - 따라서 운영 파이프라인을 서비스 단위로 나누게 되었음

## DevOps 도구
- CodeCommit : 소스를 저장 관리
- CodeBuild (빌드, 테스트)
- CodeDeploy (배포)
- AWS X-Ray, AWS CloudWatch (모니터링)
- Cloud9

- 디펜던시, 패키징, 빌드 검증 (중간)
- 베타(성능), 감마(프로덕션 레디 검증), 프로덕션 (프로덕션)

### AWS 운영 책임 모델
- 서버리스 (Lambda, Fargate, S3, Aurora, DynamoDB)
- 컨테이너 (EKS, ECR, ECS)

- AWS Cloud Development Kit(CDK) : VPC 생성하는 코드가 2줄 내지, IaC로 코드로 관리할 수 있는 것
    - CloudFormation 템플릿화, DevOps가 CloudFormation으로 구현되는 것이다
    - CloudFormation의 러닝 커브를 줄여 준다.
    - Typescript, Python, Java 등 범용 프로그래밍 언어로 IaC가 가능해진다.

- 블루-그린 배포 
    - 블루 : 기존 버전
    - 그린 : 새 버전
    - 트래픽을 일정 수준 이상 전환해보고 문제 없이 작동되면 그린 환경으로 배포, 이후 블루 환경 제거

- DevOps Guru는 머신러닝 기반으로, 애플리케이션 가용성을 개선
    - 이상을 감지하고, 노이즈 제거
    - 연관관계를 몰라서 의미를 찾기 힘든 경우를 찾아줌
    - CDK 혹은 CloudFormation 단위로 적용 가능

- CI/CD 과정 중에 어떤 로직을 더할 것인가가 중요 (ex> CI/CD 과정 중에 jmeter를 통한 부하 테스트 모니터링 등)