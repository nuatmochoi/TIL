# Storage Migration

## 온프레미스 환경에서 스토리지 종류

### IDC Storage 
- 블록 스토리지 
  - 하나의 서버가 하나의 volume을 mount해서 사용
  - LUN(Logical Unit Number)이 연결되어 애플리케이션이 해당 볼륨을 마운트해서 읽고 쓸 수 있음
- 파일 스토리지
  - NAS(Network Attched Storage)
  - 여러 서버가 하나의 보륨을 동시에 공유해 사용
- 오브젝트 스토리지
  - HTTP 프로토콜로 데이터에 접근

### Cloud Storage
- 블록 스토리지 -> Amazon EBS
- 파일 스토리지 -> Amazon EFS, Amazon FSx
- 오브젝트 스토리지 -> Amazon S3

### 데이터 마이그레이션이 어려운 이유
- 용량에 따라 걸리는 시간이 수주가 걸릴 수도
- 동기화를 위해 서비스 다운 타임이 필요할 수도
- 어떤 마이그레이션 서비스가 빠른지 고민이 됨

## 데이터 전송을 위한 5가지 고려사항
1. 어떤 데이터를 어느 스토리지로 이관?
2. 한번만 전송? 지속적 동기화?
3. 단방향? 양방향?
  - IDC to Cloud 한 번이면 되는지, 다시 Cloud to IDC를 해야 하는지
4. 데이터량 및 가능한 전송시간?
5. 네트워크 대역폭 제한은?
  - 네트워크 한계 == 최저 속도 == 네트워크 구간의 병목이 나는 구간의 속도를 알아야 함

![Network bandwidth with data](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/network-bandwidth-and-capcity-640x349.png)
- AWS Direct Connect는 1Gbps와 10Gbps를 제공
- 10PB의 경우 124일이 걸리기 때문에 네트워크로는 거의 불가능
- 따라서 10PB와 같은 대용량 데이터는 AWS Snowball 오프라인 전송 서비스 권고
  - 처음에만 Snowball로 이관하고, 증분 데이터는 네트워크로 넘기는 혼합 이관 방식도 사용됨

## AWS Migration 서비스
![AWS Migration Service](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/aws-migration-service.png)

## 데이터 마이그레이션 서비스
![Data Migration Service](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/aws-migration-service-icons-640x167.png)

### AWS Transfer for SFTP
![AWS Transfer for SFTP](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/AWS-transfer-for-SFTP-workflow-960x473.png)
- Amazon S3로 SFTP를 통해 직접 파일을 송수신할 수 있도록 지원 (타켓이 S3에 저장된다는 특징)
- 완전관리형

### AWS DataSync
![AWS DataSync](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/AWS-dataSync-workflow.png)
- S3와 EFS에 데이터를 전송할 수 있는 데이터 동기화 서비스
- 네트워크를 통해 서 데이터 정송
- 데이터 동기화 기능
  - 클라우드 데이터를 통해 온프레미스의 데이터가 파손되었을 시에 복구 가능

### AWS Storage Gateway
- 온프레미스 백업, 스토리지 파일 공유, 애플리케이션이 클라우드에 낮은 지연시간으로 접근

### AWS Snowball Edge
- 오프라인 전송으로 별도의 하드웨어 장비를 가지고 IDC에서 데이터를 저장한 후, 차를 통해 운반하고 AWS Center에서 데이터를 바로 S3로 옮겨주는 서비스

#### AWS Snowball 종류
- Snowball : 데이터에 대한 저장 장치만 제공
- Snowball Edge : 저장 장치 + EC2 Instance 내장
- Snowball Mobile : 수백테라 이상의 데이터를 컨테이너를 통해 이동

한국에서는 Snowball Edge가 주로 사용됨

#### AWS Snowball Edge Compute or Stroage Optimized
- 42TB 또는 100TB 스토리지 용량
- 종단 데이터 암호화 (유출되거나 훔쳐가더라도 데이터를 볼 수 없음)
- 8.5G 중력 보호
- 비와 먼지 방지
- AWS Greengrass 지원을 통해 IoT 연결도 지원
- Edge Compute를 위한 Computing을 Snowball 자체에서 지원
- GPU 또한 Optional하게 지원

## 스토리지 전송 서비스 비교
| | DataSync | Transfer for STFP | Snowball Edge | Storage Gateway |
|-|-|-|-|-|
|전송 스토리지 | S3, EFS, FSx | S3 | S3 | S3,EBS, Backup |
|방향성 | 양방향 | 양방향 | 단방향 | 양방향 |
|데이터 용량 | S3 무제한, EFS 페타단위 | S3 무제한 | 하드웨어 전송 | S3 무제한, EBS 16TB |
|전송속도 | 네트워크 의존 | 네트워크 의존 | 하드웨어 전송 | 네트워크 의존 |

- S3의 경우 어떤 서비스든 가능
- EFS, FSx의 경우 DataSync가 편리
- EBS로 보낼 경우 Storage Gateway가 편리
- 대용량 데이터의 경우 Snowball Edge (수십 테라~수십 페타)

## 대량 데이터 전송 사례 (롯데 통합 온라인몰 LotteON)
- 제품 이미지 약 1억 4천만 개, 17TB, 대부분 200K 이하의 작은 파일
- Direct Connect를 사용하고 있었음에도, 데이터 전송에 Direct Connect를 사용하면 너무 많은 대역폭을 점유하기 때문에 문제가 있어 사용하지 못하고, Snowball Edge 채택

### AWS Snowball Edge 절차 및 소요 시간
![AWS Snowball Edge Process](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/AWS-Snowball-Edge-process.png)
1. AWS Console로 신청 (1~3일 소요)
2. IDC로 Snowball Edge가 오게 되고 연결 (1~2일 소요)
3. 데이터 복제 (소요 시간은 파일 전송 속도-데이터량,파일 갯수에 따름) (가장 오래 걸림)
4. AWS Console로 반납 신청 후 수거 (1~2일 소요)
5. S3 버킷으로 전송 (1~N일 소요)

- 5번 과정이 3번 과정만큼 오래 걸리는 작업

### 1차 결과
전송 속도가 6.4MB/s로 2천만 개에 5일이 걸렸음, 전체 소요 시간이 70일 예상
- 하나하나의 파일마다 S3, Snowball로 가는 Connection을 가지게 되고, 맺고 끊고 하는 시간이 문제가 되었음
- 따라서 개선 사항은 다음과 같았음
  - 커넥션 타임 줄이기
  - Tar 뭉치기
  - 메모리에 뭉치도록

## 2차 시도
- Tar 파일 정상적으로 압축
- 메타데이터가 기록되지 않는 문제 
- IDC에서 압축하고 메타데이터 태그를 붙이고 Snowball Edge로 전송

### 2차 결과
전송 시간이 169.1 MB/s로 7배의 시간을 줄여 2주 내에 데이터 전송 완료


## Reference
- [AWS 스토리지 마이그레이션 서비스 및 대규모 데이터 전송 사례](https://dev.classmethod.jp/articles/summit-online-korea-storage-migration/)
