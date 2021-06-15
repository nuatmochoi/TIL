# OpsWorks

## OpsWorks Stacks
![OpsWorks Stacks](https://jayendrapatil.com/wp-content/uploads/2016/12/OpsWorks-Stacks.png)
- OpsWorks Stacks은 ELB, Database, 애플리케이션 서버 등 여러 계층이 포함된 스택으로 모델링
- OpsWorks for Chef Automate와 달리 Chef 서버가 필요없음
- Stacks은 EC2, RDS 인스턴스 등 AWS 리소스를 위한 컨테이너
- 인스턴스 자동 복구 지원
- 다양한 인스턴스 유형 지원
    - 24/7 인스턴스 : 수동 시작 및 중지
    - 시간 기반 인스턴스 : 예약된 시간에 실행
    - 로드 기반 인스턴스 : load metric을 기반으로 자동 시작 및 중지

### Layer
- 모든 스택에는 하나 이상의 레이어가 포함
- 모든 레이어에는 하나 이상의 인스턴스가 있어야 함
- 모든 인스턴스는 최소 한 레이어의 구성원이어야 함
- Layer는 Chef 레시피에 따라 인스턴스에 패키지 설치, 앱 배포, 스크립트 실행과 같은 작업 처리
- 커스텀 레시피와 관련 파일은 Cookbook에 패키징되어 S3 혹은 Git에 저장됨

### Recipe
- 인스턴스가 여러 Layer에 속하더라도 각 Layer에 대한 레시피를 실행

### Backend와 데이터베이스 연결
- [database 레이어를 추가하고, deploy 실행을 포함하는 레시피를 추가함](https://docs.aws.amazon.com/ko_kr/opsworks/latest/userguide/customizing-rds.html)
- 스택의 [deploy 속성을 지정하는 JSON 객체](https://docs.aws.amazon.com/ko_kr/opsworks/latest/userguide/workingcookbook-json.html#workingcookbook-json-deploy)에서 `[:deploy][:app_name][:database]` 속성을 작성 - [참고](https://docs.aws.amazon.com/ko_kr/opsworks/latest/userguide/customizing-rds-setup.html)
- 데이터베이스 연결을 위한 레시피는 각 애플리케이션당 1개씩 필요함
    - 예를 들어 기존에 Java로 작성한 서버가 있고, 추가 기능을 위해 node.js로 애플리케이션을 추가했다면, 1개의 Stack, 2개의 Layer, 1개의 사용자 지정 Recipe가 필요

## OpsWorks for Chef Automate
- Chef Automate를 호스팅하는 완전 관리형 구성 관리 서비스

## OpsWorks 배포 전략
1. All at once(한 번에 배포)
    - 오류 발생시 다운타임 발생
    - 5개의 최신 배포를 저장하므로 최대 4개의 버전으로 롤백 가능
2. 롤링 배포
    - 문제 발생시 이전 인스턴스가 트래픽 처리 가능
3. Blue-Green 배포
    ![OpsWorks Blue Green](https://jayendrapatil.com/wp-content/uploads/2019/03/OpsWorks-Blue-Green-Deployment.png)
    1. ELB를 Green 스택의 서버 Layer에 연결
    2. Green 스택의 모든 인스턴스가 ELB 상태 확인 통과하면, Route 53의 가중치 변경으로 트래픽 점진적 라우팅(Blue to Green)
    3. Green 스택이 제대로 작동하여 모든 트래픽을 처리할 수 있게 되면
    4. Blue 스택의 서버 Layer에서 ELB를 분리
    5. 문제 발생시 절차를 반대로 수행하여 Blue 스택으로 롤백

# OpsWorks Stacks Lifecycle Event

1. Setup : 시작된 인스턴스가 부팅을 완료하면 발생
2. Configure
    - 인스턴스가 온/오프라인 상태로 전환되는 경우 발생
    - EIP 주소를 인스턴스에 연결하거나 연결 해제하는 경우 발생
    - ELB를 계층에 추가하거나 분리하는 경우 발생
3. Deploy : 애플리케이션을 리포지토리에서 계층의 인스턴스로 배포하는 레시피 실행
4. Undeploy : 앱을 삭제할 때 발생. 모든 앱 버전을 제거하고 정리 작업 수행
5. Shutdown : 사용자가 OpsWorks Stacks에게 인스턴스를 종료하도록 한 이후 실제로 종료되기 전에 발생.
