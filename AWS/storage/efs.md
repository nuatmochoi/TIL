# AWS EFS

- 관리형 파일 스토리지
- 온프레미스의 NFS, NAS와 동일한 서비스

![EFS Architecture](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/images/efs-ec2-how-it-works-Regional.png)

- EFS 생성 시 VPC 내 가용영역의 서브넷에 Mount Target 생성
- Linux만 지원하며 Windows는 지원하지 않음 (필요하다면 Linux와 SAMBA 연동 필요)
- Direct Connect와 VPN 연결을 통해 온프레미스 NFS, NAS와 연결이 용이하다.

## Reference

- [AWS EFS Mount](https://docs.aws.amazon.com/ko_kr/efs/latest/ug/accessing-fs.html)
