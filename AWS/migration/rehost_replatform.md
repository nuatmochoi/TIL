# Rehosting & Replatforming

## Scaling

- Horizontal Scaling (scaling out)
  - 자원을 추가하고 이를 통해 분배할 때
  - 원래 자원에 대한 정지 시간이 발생하지 않음
  - 로드가 증가함에 따라 더 많은 리소스를 추가하고 로드를 분산
  - 로드가 줄어들면 다시 원래 숫자로 돌릴 수 있음
- Vertical Scaling (scaling up)
  - 동일한 논리적 리소스를 유지하지만 해당 리소스를 효율적으로 사용
  - 리소스가 더 많은 작업량을 처리하도록, 메모리, 스토리지, 컴퓨팅 파워 등의 항목을 추가
  - 하나의 논리적 리소스이기 때문에 여러 개의 요청을 분배할 필요가 없음
  - 약간의 정지시간 발생
  - 규모가 확장되지 않을 수 있음

## High Availability

- 단일 구성 요소나 노드 장애로 시스템 실패를 피함

- 여러 엔드포인트 혹은 노드에 트래픽과 요청을 분배(Load Balancing)
- 확장성 (수평, 수직 확장)
- 환경을 모니터링 (비정상적인 작업 탐지 및 복구)

## Migrating DB

- DB Migration
  - 크기
  - 스키마
  - 테이블 유형
  - 엔진 관련 제한 사항

## AWS Server Migration Services (SMS)

- AWS 클라우드 환경으로 가상 리소스를 쉽게 전송할 수 있음
- Agent 없는 서비스로, 최대 수천 개의 온프레미스 작업량을 AWS로 쉽고 빠르게 마이그레이션할 수 있음
- VMware vSphere, Microsoft Hyper-V, Azure 가상 머신을 AWS로 마이그레이션하는 데만 사용 가능
- 서버 VM을 Amazon Machine Images(AMI)로 복제하여 EC2에 배포할 수 있음
- AWS로 서버 VM을 전달하려면 Connecter가 필요함
- 마이그레이션 모니터링은 CloudWatch를 통해 가능하며, 로깅 및 품질 검사는 CloudTrail을 통해 가능
- VM Import/Export를 통해 기존 환경에서 AWS로 Virtual Machine Image를 쉽게 가져올 수 있음

## AWS Migration Hub

- 애플리케이션의 전체 마이그레이션 상태를 한눈에 파악하고 적합한 마이그레이션 도구를 선택
- 개별 애플리케이션의 마이그레이션 진행 사항 파악 (모니터링)
- 검색 혹은 마이그레이션을 시작한 이후, Migration Hub에서 환경 탐색 가능
- 마이그레이션이 완료되면, Migration Hub는 EC2 인스턴스르 만들거나 실행하는 AMI에 대한 링크 제공
- AWS Database Migration Service(DMS)에서 마이그레이션한 DB의 경우, 검색 필터로 사용 가능한 엔드포인트 ID 제공

## AWS Application Discovery Service (ADS)

- 온프레미스 서버에 대한 사용 및 구성 데이터를 수집하여 AWS 클라우드로의 마이그레이션을 계획할 수 있음
- 온프레미스 서버 검색 및 데이터 수집에서 **에이전트 없는 검색 / 에이전트 기반 검색** 둘다 지원함
  - 에이전트 없는 검색
    - VMware vCenter에서 작동
    - AWS Agentless Discovery Virtual Appliance를 배치하여 수행
    - 검색 커넥터 구성 -> vCenter와 연결된 가상장치 호스트 식별 -> 서버 구성 정보(서버 호스트 이름, IP, Mac주소 등) 수집, VMs에 대한 metrics 수집
      - Replatform 방식 마이그레이션에 유용
    - 검색 커넥터는 VMs의 내부를 볼 수 없기 때문에, 실행 중인 프로세스나 네트워크 연결을 파악할 수 없음
      - 이 정보가 필요하다면 에이전트 기반 접근 방식을 사용해야 함
  - 에이전트 기반 검색
    - 각 VMs에 AWS Application Discovery Agent를 배치하여 수행
    - 에이전트가 정적 구성 데이터, 시계열 시스템 성능 정보, 인바운드 아웃바운드 네트워크 연결, 실행 중 프로세스 등 수집
    - Application Discovery Service는 AWS Migration Hub와 통합
    - 수집한 모든 데이터는 Amazon Athena 및 Amazon QuickSight와 같은 도구를 사용하여 분석
