# AWS EFS

- 관리형 파일 스토리지
- 온프레미스의 NFS, NAS와 동일한 서비스
- EBS와 다르게 Multi-AZ 가능
- 수천대의 EC2 인스턴스간 파일 시스템 공유 가능. 병렬 접근이 가능하도록 설계되어 IOPS가 파일시스템이 커짐에 따라 탄력적으로 설정됨
  - 따라서 두 개 이상의 EC2로부터 하나의 공유된 스토리지 공간이 필요할 때 EFS 채택

![EFS Architecture](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/images/efs-ec2-how-it-works-Regional.png)

- EFS 생성 시 VPC 내 가용영역의 서브넷에 Mount Target 생성
- Linux만 지원하며 Windows는 지원하지 않음 (필요하다면 Linux와 SAMBA 연동 필요)
- Direct Connect와 VPN 연결을 통해 온프레미스 NFS, NAS와 연결이 용이하다.

## Reference

- [AWS EFS Mount](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/accessing-fs.html)
