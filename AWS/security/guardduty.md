# Amazon GuardDuty

- AWS 서비스 상에서 악의적 활동 또는 무단 동작을 지속적으로 모니터링하는 위협 탐지 서비스 - Detect까지가 GuardDuty의 역할
- 활성화 시에 CloudTrail, VPC Flow Logs, DNS Log를 직접 분석하여 위협요소를 탐지한 결과를 표시함
- [2020년 6월에 Amazon GuardDuty S3 Protection 기능이 추가됨](https://aws.amazon.com/ko/blogs/aws/new-using-amazon-guardduty-to-protect-your-s3-buckets/)
  - GaurdDuty를 활성화시켰더라도 해당 기능을 쓰려면 추가적으로 Enable 시켜줘야 한다.
- 보안 사고에 대해 즉각 통보 및 대응을 도와주는 서비스로 활성화가 일반적으로 추천되는 서비스

## Findings

- Findings의 업데이트 주기는 default는 6시간인데, 빠른 통보를 위해 15분(minimum)으로 설정하는 것이 추천됨
- Findings의 등급은 Low, Medium, High로 나눠짐

## Reference

- [Deep Dive on Amazon GuardDuty](https://youtu.be/o2YaIsps5LY)
