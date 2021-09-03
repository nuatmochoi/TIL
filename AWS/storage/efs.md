# AWS EFS

- 관리형 파일 스토리지
- 온프레미스의 NFS, NAS와 동일한 서비스
- 수천대의 EC2 인스턴스간 파일 시스템 공유 가능. 병렬 접근이 가능하도록 설계되어 IOPS가 파일시스템이 커짐에 따라 탄력적으로 설정됨
  - 따라서 두 개 이상의 EC2로부터 하나의 공유된 스토리지 공간이 필요할 때 EFS 채택

![EFS Architecture](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/images/efs-ec2-how-it-works-Regional.png)

- EFS 생성 시 VPC 내 가용영역의 서브넷에 Mount Target 생성
- Linux만 지원하며 Windows는 지원하지 않음 (필요하다면 Linux와 SAMBA 연동 필요)
- Direct Connect와 VPN 연결을 통해 온프레미스 NFS, NAS와 연결이 용이하다.

## Vs EBS

- EFS는 EBS와 다르게 Multi-AZ 가능
- 단일 EBS 볼륨의 최대 크기는 최대 16TB까지 될 수 있지만 EFS 볼륨 크기는 사실상 무제한이다. EFS에서 파일의 최대 크기는 47.9TB이다. EBS는 파일 크기 제한 없음.
- EBS, EFS 모두 높은 내구성을 제공하지만, 확장성에서 차이가 있음. EFS 볼륨은 워크로드 수요의 급격한 증가를 수용하기 위해 빠르며 자동으로 수행되는 Scale-up/down이 가능함.
- EFS는 S3와 비슷하게 lifecycle 관리를 통해 스토리지 클래스를 전환하여 비용을 절감할 수 있음
- EBS는 디스크 지연 시간을 최소로 할 수 있음(프로비저닝된 IOPS). EFS는 충분히 빠르지만 EBS만큼의 낮은 디스크 지연시간은 확보할 수 없음. 반면에 분산 파일 저장 시스템이기 때문에, EFS는 EBS에 비해 초당 처리량은 높을 수 있다.
- EFS 볼륨은 전사적 파일 서버, 백업 시스템, 빅 데이터 클러스터, 대규모 병렬 처리(MPP) 시스템, CDN 및 기타 대규모 사용 사례에 적합
- EBS 볼륨은 관계형 및 NoSQL 데이터베이스, ERP 시스템, 메일 서버, 쉐어포인트, 웹 서버, 디렉터리 서버, DNS 서버 또는 미들웨어에 적합 (큰 클러스터에서 실행되지 않는 워크로드로 마운트되는 볼륨이 필요 없음)

## EFS Backup 옵션

1. DataSync

   - DataSync는 온프레미스 스토리지와 Amazon EFS 파일 시스템 간의 상시 연결을 유지하여 둘 사이에서 데이터를 쉽게 이동하도록 도움.
   - DataSync는 대량의 데이터를 정기적으로 가져오기 및 내보내기, 일회성 데이터 마이그레이션 또는 데이터 복제 및 복구에 사용할 수 있음.
   - 리전간 전송에도 AWS DataSync를 사용할 수 있음

2. AWS Tranfer Family

   - SFTP, FTPS, FTP를 지원하는 완전관리형 파일 전송 서비스.
   - Amazon EFS 내부 및 외부 파일 전송을 가능하게 함.
   - AWS Transfer Family 엔드포인트는 EFS 파일 시스템과 동일한 리전에 있어야 함 (리전 간 전송 불가)

3. AWS Backup

   - Amazon EFS의 백업 정책 및 예약을 자동화하고 추적함

4. [EFS-to-EFS backup](https://aws.amazon.com/ko/solutions/implementations/efs-to-efs-backup-solution/)

   - EFS 파일의 증분 백업을 자동으로 생성

## Reference

- [AWS EFS Mount](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/accessing-fs.html)
