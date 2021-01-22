# Stoage Migration

## AWS EBS

- EC2 인스턴스에 사용하기 위한 블록 레벨 스토리지 볼륨 제공
- 동일한 인스턴스에 여러 볼륨을 마운트할 수 있으나, 각 볼륨은 한 번에 하나의 인스턴스에만 연결
- 볼륨 타입으로 SSD, HDD
  - SSD : 일반적 용도, 낮은 대기 시간과 높은 처리량을 위한 성능이 필요하다면 선택
  - HDD : 처리량 최적화 볼륨(높은 처리량이 필요한 빅데이터나 로그 처리 등), Cold(접속은 적게하지만, 처리량에 최적화된 업무)

## AWS EFS

- 파일 시스템을 만들고, EC2 인스턴스에 파일 시스템을 마운트한 다음, EFS에서 데이터를 읽고 쓸 수 있음
- EFS를 여러 EC2에 동시에 마운트할 수 있음. 즉, 여러 서버에 대한 공유 파일 시스템을 구성 가능
- AWS에 내장된 EFS를 온프레미스 서버로 마운트 가능

## AWS Snowball

- 데이터 센터에서 네트워크에 직접 연결하고 로컬 네트워크를 활용하여 데이터를 복사할 수 있는 물리적 디바이스
- 최대 80TB, AWS KMS에 의해 데이터를 암호화
- 온프레미스 데이터 스토리지와 S3간 데이터를 가져오고 내보낼 수 있음

## AWS Snowmobile

- 이동할 데이터가 많을 때 사용
- 최대 100페타바이트의 데이터를 보관

## AWS Storage Gateway

- 온프레미스 환경에서 AWS 내의 게이트웨이 엔드포인트에 연결되는 VM 이미지르 활용
- 로컬 스토리지 리소스를 AWS 클라우드에 연결하고 스토리지 메커니즘에 가용성, 내결함성 및 확장성 추가
- 파일 기반, 볼륨 기반, 테이프 기반 옵션 제공
  - File Gateway : S3에 대한 파일 인터페이스 지원. NFS, SMB와 같은 프로토콜을 통해 S3에서 객체를 저장 및 검색 가능
  - Volume Gateway : 온프레미스 애플리케이션 서버에서 iSCSI 장치로 마운트할 수 있는 클라우드 백 스토리지 볼륨 제공
    - 캐시 볼륨 : S3에 데이터를 저장하고 자주 액세스하는 데이터 집합의 복사본을 로컬로 유지 가능
    - 저장 볼륨 : 전체 데이터 세트에 대한 짧은 지연 시간의 액세스가 필요한 경우에 사용
      - 모든 데이터는 로컬에 저장되며, 온프레미스 스토리지에서 스냅샷 생성, 로컬 볼륨 복구나 AWS 계정 내 볼륨 생서에 사용
  - Tape Gateway : 백업 데이터를 AWS에 안정적으로 보관할 수 있음

## AWS DataSync

- 하이브리드 환경으로 마이그레이션할 때, 환경 간 작업에 도움을 주는 도구
- AWS Direct Connect를 통해 온프레미스 스토리지 시스템과 AWS 스토리지 서비스 간 데이터 이동 및 복제를 단순,자동,가속화하는 데이터 전송 서비스
- NFS에서 DFS, S3로의 전송을 지원.
  - Storage Gateway와의 차이점은 DataSync는 주로 NFS 소스에서 전송하는 데 사용되며 대상은 EFS
- 온프레미스 스토리지 스스템에서 데이터를 읽거나 쓰는데 사용되는 가상 머신인 **에이전트** 사용

## AWS DMS (Database Migration Service)

- RDBMS, Data warehouse, NoSQL 등 데이터 저장소를 쉽게 마이그레이션하는 도구
- 데이터를 AWS클라우드와 온프레미스 간 마이그레이션
- 원본 데이터 저장소에 연결하여 원본 데이터를 읽은 다음, 대상 데이터 저장소에서 사용할 데이터를 형식화하고 데이터를 로드
- 마이그레이션을 모니터링할 수 있는 기능을 제공
- Oracle to Orcle, Oracle to MySql, MySql to Aurora 등 다른 DB 플랫폼간 마이그레이션을 지원
- 온프레미스 DB를 EC2 인스턴스에서 실행되는 DB로 마이그레이션도 가능
- 가동 중지 시간 없이 데이터베이스를 마이그레이션할 수 있음
- AWS DMS를 사용하려면 하나의 엔드포인트가 반드시 AWS 서비스에 있어야 함 (온프레미스 to 온프레미스는 지원 X)

## AWS SSC (Storage Schema Conversion)

- 기존 데이터베이스를 가져와서 해당 스키마를 다른 엔진으로 변환 (이기종 엔진간 변환)

## Amazon Aurora (Serverless)

- 데이터베이스가 애플리케이션 요구에 따라 자동으로 시작, 종료 및 용량 확장, 축소가 되는 Auto Scaling Solution
- DB 인스턴스 클래스 크기를 지정하지 않고, 데이터베이스 엔드포인트를 생성 (대신, 최대 및 최소 용량을 설정함)
- 연결을 자동으로 관리. 요청을 처리한 준비가 된(warm) 리소스 pool을 사용

## AWS Direct Connect

- 개방형 인터넷을 사용하는 경우, VPN 연결로 네트워크 연결
- 개방형 인터넷을 쓰지 않는 경우, AWS Direct Connect 사용
  - 네트워크 경로에 퍼블릭 인터넷이 없어도 AWS 클라우드에 대한 가상 인터페이스를 직접 생성 가능
  - Direct Connect 링크를 통해 VPN 터널을 설정하여, 온프레미스 리소스에서 AWS의 리소스로 안전하게 통신 터널을 만듦
  - 부드러운 데이터 전송, 마이그레이션 컷오버(새 버전 오픈) 및 지속적 복제 가능

## 배포 전략

1. 레드-블랙

- 원래 환경과 새로운 환경 모두 실행 중
- 마이그레이션된 프로그램에 문제가 발생하면 원래 환경으로 돌림
- 트래픽 이동 후에 문제가 발생하면, 애플리케이션이 다운되어 사용자에게 부정적인 영향

2. 블루-그린

- 설치, 테스트 및 실행 중인 두 환경 모두 설정이 동일
- 즉석으로 컷오버하는 것이 아니라 적은 양의 트래픽(5~10%)만 이동
- 레드-블랙은 문제가 널리 퍼지지 않아 사용자에게 영향이 적다.
- 대신에 각 엔드포인트로 이동하는 트래픽 양을 제어할 수 있는 DNS 서비스(Route 53)을 사용해야 한다.

## AWS CloudFormation

- CloudFormation 엔진을 통해 인프라를 생성, 구성 및 업데이트할 수 있는 템플릿 기능
- 테스트 환경을 신속하게 가동할 수 있기 때문에 마이그레이션에 유용

## AWS Systems Manager

- 실행 중인 서버에 대한 경로를 제공하여 명령과 업데이트를 예약할 수 있다.
- 서버에 직접 연결하지 않고도 명령을 실행할 수 있기 떄문에 시간과 노력이 절약
- AWS 뿐만 아니라 온프레미스 서버로 시스템을 관리 가능(SSM 에이전트 == AWS 시스템 관리자 에이전트 사용)

## TSO Logic

- AWS 내에 존재하는 솔루션으로, 기존 리소스를 검색하여 컴퓨팅, 스토리지, DB 등 영역에서 실행중인 대상을식별하는 데에 도움을 줌
- 애플리케이션에 대한 총 소유 비용(TCO)를 평가할 수 있고, 예측 분석을 통해 클라우드의 워크로드(마이그레이션)에 적합한 것을 결정 가능

## CloudEndure

- 물리적, 가상 및 클라우드 기반 인프라에서 AWS로의 **대규모 마이그레이션**을 단순화, 촉진 및 자동화한다.
- 스냅샷을 만들거나 디스크에 데이터를 기록하지 않으므로 성능에 거의 영향을 주지 않음
- 수천대의 시스템에서 동시에 데이터를 복제할 수 있으며, 각 머신을 병렬으로 작동시킴
- 전체 마이그레이션 라이프사이클을 관리하며, 컷오버 준비 상태를 확인할 수 있음