# RDS

- 장애 조치 시에, Amazon RDS는 DB 인스턴스의 CNAME가 예비 복제본을 가리키도록 변경. 이 예비 복제본이 새로운 기본 복제본이 된다. 일반적으로 1~2분 내에 완료되는 조치.
- RDS에서는 샤딩을 완전하게 지원되지 않기 때문에 읽기 전용 복제본을 사용해야 한다.
- 프로비저닝된 IOPS 스토리지 : OLAP(온라인 트랜잭션 처리) 워크로드에 최적화되어 있음.
- 암호화를 위해 KMS나 Oracle TDE 옵션을 지원하고 있음.

## 볼륨 유형
1. 범용 SSD
    - gp3, gp2
    - 버스트시 1TB당 3000 IOPS
2. 프로비저닝된 IOPS SSD
    - io1, io2
3. 처리량 최적화 HDD
    - st1
4. Cold HDD
    - sc1

## I/O Credit
- 범용 SSD 스토리지에서 기본 성능 이상이 필요할 때 대용량 I/O를 버스트하는 데 사용할 수 있는 가용 대용폭 (1GB 당 3IOPS 할당됨) 
[참고](https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/UserGuide/CHAP_Storage.html#Concepts.Storage.GeneralSSD)

## RDS Proxy
- RDS의 완전 관리형 고가용성 데이터베이스 프록시
- DB 연결을 폴링하고 공유하여 확장성 개선
- 장애조치 시간을 66%까지 줄이고 장애 조치 중 애플리케이션 연결 보존하여 가용성 향상
- DB에 IAM을 적용하고 Secrets manger에 자격 증명을 안전하게 저장
- Use cases
    - 예측할 수 없는 워크로드
    - DB 연결을 자주 열고 닫는 경우
    - 연결을 유휴 상태로 유지
    - 일시적 오류로 가용성 필요할 때

## RDS Event Notification
- DB 인스턴스, DB 보안그룹, DB 파라미터 그룹, DB 스냅샷 등의 이벤트가 발생했을 때 Amazon SNS를 사용하여 알림 메시지를 받을 수 있음
- [`describe-events`](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-events.html)을 통해 RDS 리소스의 이벤트를 검색 가능 (최대 14일)
    - 더 오랜 기간 보관해야한다면 [CloudWatch 이벤트에 Amazon RDS 이벤트를 전송](https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/UserGuide/rds-cloud-watch-events.html#rds-cloudwatch-events.sending-to-cloudwatch-events)해야함
