# Anti-Pattern For AWS Storage


## S3
정적이고 탄력성, 내구성, 가용성을 요하는 데이터 저장에는 이점이 있다.

하지만 다음과 같은 솔루션에서는 최적화되지 않음.
- File System 
- 쿼리를 사용하는 구조화된 데이터 : 객체 검색에 비적합
- 빠르게 바뀌는 데이터 : EBS, RDS, DynamoDB 가 적합
- 백업 및 아카이빙 스토리지 : Glacier가 적합
- 동적 웹사이트 호스팅 : EC2가 적합

## Glacier
다음과 같은 솔루션에서 최적화되지 않음
- 빠르게 바뀌는 데이터
- 실시간 접근 : 조회 job은 3~5시간 걸림. S3가 더 적합

## EBS
하나의 EC2 인스턴스의 lifecycle을 넘어서 유지해야 하는 정보가 있는 경우에 적합

하지만 다음과 같은 솔루션에서 최적화되지 않음.
- 임시 스토리지 : EC2 local storage, SQS, ElastiCache가 적합
- 고내구성 스토리지 : S3, Glacier가 적합. 
- 정적 데이터 웹 컨텐츠 : 데이터가 자주 바뀌지 않는다면 S3가 비용효율적 & 확장성

## EC2 local storage
임시 데이터 내구성을 위해 복제하는 데이터에 적합

하지만 다음과 같은 솔루션에서 최적화되지 않음.
- Persistent storage : EBS, S3가 적합
- 관계형 데이터베이스 스토리지 
- 공유 스토리지 : S3, EBS가 적합
- 스냅샷 : EBS가 적합

## AWS Import/Export
인터넷을 통해 로드하는 데에 오래 걸리는 작업에 적합

인터넷을 통해 전송하는 데에 일주일 미만으로 걸린다면 비적합

## AWS Storage Gateway 
데이터베이스 스토리지에 비적합

## Amazon CloudFront
static & dynamic 전달에 적합

하지만 다음과 같은 솔루션에서 최적화되지 않음
- 프로그래밍적인 캐시 무효화(cache invalidation) : AWS는 객체 버저닝을 권장한다.
- 잦지 않은 데이터 요청 : 잦게 요청되지 않는 데이터에 대한 edge에서의 origin fetch 비용을 줄여야 한다.

## Amazon SQS
다음과 같은 솔루션에서 최적화되지 않음
- Binary or Large message : SQS 메시지는 텍스트이고, 64KB가 최대. 더 큰 메시지 저장에는 S3, RDS가 적합하며, 해당 데이터의 pointer를 SQS에 저장하는 것이 적합.
- 장기 저장 : 메시지 데이터는 최대 14일 동안 저장 가능. S3가 장기 저장에 적합.
- 빠른 메시지 큐잉 : DynomoDB가 적합
- 짧은 작업 : EC2에서 메시지 큐잉 시스템 구성이 적합 

## RDS
다음과 같은 솔루션에서 최적화되지 않음
- 인덱스 및 쿼리 포커싱 데이터 : DynamoDB가 적합
- 많은 BLOB (audio, video, image 등) : S3가 적합
- 자동 확장 : DynamoDB가 적합
- 다른 데이터베이스 플랫폼 : IBM DB2, Informix, Sybase 등은 EC2 내 데이터베이스로 배포가 적합
- 완전한 제어 : 데이터베이스 서버에 완전한 OS 수준 제어(root, admin login 등)가 필요하다면, EC2 내 데이터베이스로 배포가 적합

## DynamoDB
다음과 같은 솔루션에서 최적화되지 않음
- 조인 및 복잡합 트랜잭션 : RDS, EC2 내 데이터베이스가 적합
- BLOB 데이터 : S3가 적합
- I/O 비율이 낮은 큰 데이터 : S3가 적합

## ElastiCache
- Persistent 데이터 : 빠르게 접근가능하면서도 내구성 있는 서비스가 필요하다면 DynamoDB가 적합

## RedShift
- OLTP 워크로드 : RDS가 적합
- BLOB 데이터 : S3가 적합

## Reference
- [https://d1.awsstatic.com/whitepapers/Storage/aws-storage-options.pdf](https://d1.awsstatic.com/whitepapers/Storage/aws-storage-options.pdf)
