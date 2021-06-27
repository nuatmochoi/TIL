# EC2

- 최신 인스턴스일수록 일반적으로 가성비가 좋은 것은 맞지만, 용도에 특화된 인스턴스들이 있기 때문에 무조건적으로 모든 스펙이 우월한 것은 아님.

## RI(예약 인스턴스)

- 연단위 계약

## EC2 Instance Types

1. 범용 (Mac, T4g, T3, T3a, T2, M6g, M5, M5a, M5n, M5zn, M4, A1)
   - 균형 있는 컴퓨팅, 메모리, 네트워킹 리소스 제공 / 웹 서버 및 코드 저장소에 적합
   - M -> 리소스의 균형적 사용
   - T -> 성능 순간 확장 가능 (burstable performance : 임계값 이상이면 credit 소진하고 0이 되면 성능 freeze / 임계값 미만이면 credit 오름)
2. 컴퓨팅 최적화 (C6g, C6gn, C5, C5a, C5n, C4)
   - 고성능 프로세서를 사용하는 애플리케이션
   - 배치 처리워크로드, 미디어 트랜스코딩, 고성능 웹 서버, HPC, 과학적 모델링, 전용 게임 서버, 광고 서버 엔진, 기계 학습 추론 등
3. 메모리 최적화 (R6g, R5, R5a, R5b, R5n, R4, X1e, X1, 대용량메모리, z1d)
   - 메모리 집약적 애플리케이션, 인메모리
4. 가속화된 컴퓨팅 (P4, P3, P2, Inf1, G4dn, G4ad, G3, F1)
   - GPU 기반 컴퓨팅을 통해 부동 소수점 수 계산, 그래픽 처리, 데이터 패턴 일치 등에 유리
   - 기계학습 훈련/추론 및 고성능 컴퓨팅에 적합
5. 스토리지 최적화 (I3, I3en, D2, D3, D3en, H1)
   - 매우 큰 데이터 셋에 대해 많은 순차적 읽기 및 쓰기 액세스를 요하는 워크로드
   - 짧은 지연 시간, 수만 단위의 무작위 IOPS를 지원
   - I -> SSD 기반
   - D -> HDD 기반

## EC2 타입 및 용량 변경

- 앞단에 LB가 존재하고, LB 뒷단에 복수의 인스턴스로 연결되어 있기 때문에, LB의 target group에서 변경이 필요한 인스턴스를 제거하여, 요청 트래픽을 받지 않게 한 다음, 이 상태에서 중지-스펙 변경-재가동-타겟그룹 연결을 수행한다.

## EC2용 분산형 배치 그룹

분산된 환경의 컴퓨팅 노드로 인해 HPC 클러스터의 성능이 떨어질 수 있다. 분산형 배치 그룹을 통해 노드 간 통신에 latency가 짧은 네트워크 성능을 얻을 수 있다.

1. 클러스터 : 가용영역 내에서 인스턴스를 가깝게 압축
2. 파티션 : 인스턴스를 논리적 파티션에 분산하여, 다른 파티션의 인스턴스와 하드웨어를 공유하지 않게 함. Hadoop, Cassandra, Kafka 등의 워크로드에 필요.
3. 분산(Spread) : 소규모의 인스턴스 그룹을 다른 하드웨어로 분산하여 관련된 오류를 줄임
   - 일반적으로 아키텍처의 기존 네트워크 성능이 떨어짐
4. EFA (Elastic Fabric Adapter) : OS bypass networking 메커니즘을 통해 인스턴스간 저지연, low-jitter(불안정성) 채널을 제공
5. Amazon FSx for Lustre : HPC 등 속도가 중요한 워크로드에 Lustre를 적용. ms 초 미안의 지연시간, 최대 수백 Gbps의 처리량 및 최대 수백만 IOPS를 제공.

배치 그룹 변경은 인스턴스가 중지된 상태에서 변경이 가능함.

## EC2Rescue

- EC2 Linux & Windows Server 인스턴스의 문제를 진단
  - 인스턴스 연결 문제
  - OS 부팅 문제
  - 운영체제 로그 확인
- Systems Manager Automation 및 AWSSupport-ExecuteEC2Rescue를 통해 자동으로 실행 가능

## Troubleshooting

### 시작하지 않은 EC2가 실행되는 이유

1. 타 서비스에 의해 시작
   - CloudFormation : 스택에 EC2가 포함될 수 있음
   - EB : EC2 + AutoScaling가 포함됨
   - OpsWorks : OpsWorks 스택의 쿡북에 EC2가 포함될 수 있음
   - EMR : EC2 인스턴스 그룹인 클러스터&노드가 시작됨
2. 권한을 가진 타 사용자가 인스턴스 시작
   - CloudTrail 사용하여 `RunInstances` API를 호출한 인스턴스를 찾을 수 있음
   - 사용자에 대한 관리는 IAM으로 제어

### 종료했는데 EC2가 다시 시작되는 이유

1. Auto Scaling 그룹 설정에 의해서 재시작
   - 인스턴스 ID 확인하고, Auto Scaling 그룹에서 활동기록 -> 인스턴스 ID 일치하는 것 찾기
2. EB 환경에 Auto Scaling이 포함되었을 수 있음

### EC2 인스턴스를 찾을 수 없는 이유

1. 다른 리전으로 설정
2. 다른 사용자가 종료
3. 다른 계정에서 실행 중
4. Auto Scaling, EB, ELB, Lambda 등에 의해 인스턴스가 종료
5. 인스턴스가 스팟 인스턴스로 시작 + 스팟 가격이 입찰 가격을 초과

### EC2를 다른 서브넷, AZ, VPC로 이동하려면?

- 기존 인스턴스를 옮길 수는 없다.
- AMI를 생성하여 인스턴스를 수동으로 마이그레이션하고 EIP를 인스턴스로 재할당
  - AMI 생성 시간을 줄이기 위해 EBS 스냅샷 생성
  - 도메인 보안 식별자(SID) 충돌할 수 있다. Sysprep을 통해 EC2 Windows 인스턴스에서 SID 등 고유 정보 제거

### IGW를 사용해 EC2를 인터넷에 연결이 되지 않는 이유

1. 사전 조건 충족 체크
   - 서브넷과 연결된 라우팅 테이블에 `0.0.0.0/0`(IGW 기본 경로)가 포함
   - ENI와 연결된 보안 그룹에 `0.0.0.0/0`에 대한 아웃바운드 인터넷 트래픽을 허용
   - 서브넷과 연결된 ACL에 인터넷에 대한 인/아웃바운드 규칙 모두 허용
2. 퍼블릭 IP 주소가 있는지 확인
   - EIP 할당 및 연결
   - 서브넷에서 Ipv4 주소 지정 속성 활성화
3. 방화벽이 액세스 차단하는지 체크
   - ping, curl을 사용해 액세스되는지 테스트
   - 방화벽이 HTTP or HTTPS 트래픽 허용하는지 확인

### EC2 CPU 크레딧 잔고가 감소한 이유

- 인스턴스를 중지하면 모든 크레딧이 손실
- 다시 시작하면 0 + 시작 크레딧

### Lambda를 통해 EC2를 정기적으로 중지하고 시작하려면?

1. ec2를 start, stop하는 정책을 생성하고, IAM 역할 생성. Lambda 함수에 연결
2. python을 예시로, boto3를 import하고 리전 설정. 특정 인스턴스 ID값을 중지/시작하도록 코드 구성
3. Lambda를 트리거하는 CloudWacth Event Rule 생성 (cron 표현식)

### EC2 상태 변경시 이메일 알림

1. SNS 콘솔에서 [주제 생성] -> [구독 생성] : [이메일]
2. CloudWatch 이벤트 생성
   - [이벤트 패턴] : [EC2 Instance State-change Notification]
   - [대상] : [SNS 주제]

### AMI를 다른 계정과 비공개로 공유

- AMI를 공유할 다른 계정의 ID를 알고 있으면 공유 가능
- 다른 리전의 AMI를 공유하려면 교차계정 AMI 복사를 사용해야 함

### EC2 Instance store를 EBS에 복사하려면?

1. 새 EBS를 생성한 다음, 데이터 마이그레이션 진행 (Linux에서는 `rsync`, Windows는 `robocopy`)
2. S3를 통해 개별 파일 백업

### 한 리전에서 AMI를 생성하고 다른 리전에 복사하려면?

1. EC2 인스턴스의 AMI 생성
2. AMI 복사를 통해 다른 리전으로 복사

### AWS CLI로서비스 할당량 증가 요청 확인&요청&관리?

- AWS CLI의 `aws service-quotas` 커맨드 사용
- `--region` 파라미터로 원하는 리전으로 변경
- 서비스 코드 확인
  - `list-services`로 해당 리전의 서비스 코드 목록 확인
  - `list-service-quota`로 특정 서비스 및 리전에 대해 사용 가능한 할당량 코드 확인
- 서비스 할당량 증가 요청
  - `get-service-quota`로 현재 적용된 할당량 값 확인 (with `--service-code`, `--quota-code`)
  - `request-service-qoata-increase`로 할당량 증가 요청 (with `--service-code`, `--quota-code`)
- 서비스 할당량 증가 요청 확인
  - `get-requested-service-quota-change`로 보류 중 요청 상태 확인 (with `--request-id`)
    - `CASE_CLOSED`, `APPROVED`, `DENIED` 상태일 시 요청 세부 정보 확인 가능
- 요청 추적
  - `list-requested-service-quota-change-history` : 모든 서비스 및 모든 할당량 코드
  - `list-requested-service-quota-change-history-by-quota` : 특정 할당량 코드에 대해

### 전용 호스트 <-> 공유 테넌시

- 전용 호스트 : 고객 전용, 버스트 가능 인스턴스 제공 X
- 공유 테넌시 : 타 계정과 물리적 하드웨어 공유
- 공유 테넌시 to 전용 호스트
  1. 기존 공유 테넌시 EC2의 AMI 생성
  2. AWS Console, AWS CLI, Powershell(AWS tool)을 통해 전용 호스트 할당
  3. AMI를 전용 호스트에 시작
- 전용 호스트 to 공유 테넌시
  1. 기존 전용 호스트 EC2의 AMI 생성
  2. AMI에서 EC2 시작 -> [인스턴스 구성 세부 정보] -> [테넌시] -> [공유] -> [공유된 하드웨어 인스턴스로 실행 선택]

### EC2에서 포트 25(SMTP)를 통해 이메일이 안보내지면?

- [이메일 전송 제한 제거 요청]으로 Support Case를 연다.
- [사용 사례 설명]에 사용 사례 + 원치 않는 이메일을 보내는데 연루되지 않는 계획 + 리전 을 작성한다.
- 아웃바운드 이메일을 보내는데 사용되는 EIP와 EIP 연결에 필요한 역방향 DNS(rDNS) 레코드를 제공
  - 스팸 필터리에 걸리지 않도록
  - DNS A 레코드를 사용해 EIP에 연결

### 요청한 인스턴스가 AZ에서 지원되지 않는 이유?

- 일부 가용영역은 특정 인스턴스를 지원하지 않음
- 해당 유형을 지원하는 AZ를 찾거나
- 가용영역 지정 않고 요청 제출하면 EC2가 해당 유형을 지원하는 AZ 선택
