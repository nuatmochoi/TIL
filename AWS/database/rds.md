# RDS

- 장애 조치 시에, Amazon RDS는 DB 인스턴스의 CNAME가 예비 복제본을 가리키도록 변경. 이 예비 복제본이 새로운 기본 복제본이 된다. 일반적으로 1~2분 내에 완료되는 조치.
- RDS에서는 샤딩을 완전하게 지원되지 않기 때문에 읽기 전용 복제본을 사용해야 한다.
- 프로비저닝된 IOPS 스토리지 : OLAP(온라인 트랜잭션 처리) 워크로드에 최적화되어 있음.

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
