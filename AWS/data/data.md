## AWS Managed Services
- 변경 요청, 모니터링, 패치 관리, 보안, 백업 서비스
- Amazon Elasticsearch Service
- Amazon Redshift
- Amazon EMR

## Serverless Analytics Services
- 운영이 없고, SQL, Script 등에만 집중
- Amazon Athena : 서버 운영 없이 SQL 기반으로 분석
    - 분석할 데이터를 S3에 Json, csv, parquet 등 포맷으로 넣으면, S3 데이터로 테이블 생성하여 SQL 분석 가능
        - Data Source로는 S3만 가능. 
        - DynamoDB는 불가. DDB 사용하려면 lambda -> kinesis firehose -> S3 -> Athena 순서로 구성해야 함.
    - User Defined function (UDF) 지원 (SQL 뿐만으로 부족한 부분 해결)
    - 1Tb -> $5.75 (비용 절감을 위해 parquet으로 변환)
- AWS Glue : 데이터 카탈로그를 관리하거나 spark 경험에서 ETL 작업하려면 선택
    - 데이터 카탈로그 생성 (데이터의 테이블 정보) -> Athena, EMR, Redshift Spectrum 등 다양한 분석 툴에서 분석 -> QuickSight로 시각화하여 대시보드 생성 가능
    - Glue Job을 통해서 스크립트로 ETL 작업
    - AWS Glue DataBrew : S3, RDS, 데이터 카탈로그의 데이터를 연결하여, 데이터의 정교화를 도와줌 (필드에 대한 통계 정보, 상관 관계)
- Amazon QuickSight
- 서버리스한 데이터 레이크(S3) 활용

- 데이터 저장은 S3에 하면 된다.

- 조그만 데이터로도 Athena, QuickSight로 데이터 분석 가능

## 완전 관리형 데이터베이스
- 고객은 스키마 설계, 쿼리 작성, 쿼리 최적화에만 신경
- AWS에서 백업, 복구, 보안, 스케일링, 모니터링 등 모두 지원
- MySQL, PostgreSQL, MariaDB 등 오픈소스DB 지원
    - 상용 DB보다 성능, 가용성 안 좋다 
    - 이를 해결하기 위해 **Amazon Aurora**
        - MySQL PostgreSQL 오픈소스와 호환
            - MySQL의 5배, PostgreSQL의 3배 쓰루풋 
            - 고가용성 보장
        - 1/10 비용으로 상용 데이터베이스 수준의 성능 & 가용성 제공
        - Aurora Serverless
            - 데이터베이스를 shutdown 시켜놓았을 때 EC2에 대한 과금 X
            - 자동으로 용량 조절
            - 초당 지불 (최소 1분)
            - 자주 사용하지 않거나, 주기적인 워크로드에 적합
            - HTTP 기반 API 제공

### Aurora Multi-Masters
기존 aurora는 클러스터 내 읽기/쓰기가 가능한 마스터 노드는 1개만 구성하였고, 최대 15개의 읽기 복제본만 구성(읽기 성능만 확장)할 수 있었다.
Multi-Masters의 출시로 이제는 읽기/쓰기가 모두 가능한 마스터 노드르 2개 이상 구성할 수 있게 되어, 읽기/쓰기 성능 모두 확장 가능하게 되었다. (2019년에 정식버전으로 병합)
- 마스터 노드 1개가 장애가 발생하더라도 다른 마스터노드가 쓰기 작업을 할 수 있게 되었다.
- 샤딩 없이 쓰기 성능을 확장 가능
    - 샤딩 : 최대 성능의 데이터베이스 타입을 사용 중인데 성능이 부족하게 된다면, 같은 스키마를 가진 데이터를 다수의 db에 분산하여 저장하는 방법
따라서 고가용성과 성능을 보장하게 되었고, 비용을 절감할 수 있게 되었다.

## AWS DB 종류
- 관계형 : RDS, Aurora (ACID)
- Key-value : DynamoDB (높은 처리량, 낮은 지연)
    - Aurora와는 달리 서버리스
    - 아이템(항목) (== RDB의 row)
    - Attributes (속성) (== RDB의 column)
        - 모든 아이템들이 동일한 속성을 가지지 않아도 된다
        - 테이블이 생성된 이후에도 원하는 아이템에 대해서 속성을 추가할 수 있다.
    - 파티션키 지정 (데이터 분산이 잘 되도록)
    - 조회를 빠르게하기 위해 소트키를 옵션으로 지정
    
- Document : DocumentDB
- In-memory : ElastiCache (마이크로 초단위 레이턴시, 애플리케이션에서 바로 접근 가능한 캐시 구조)
- Graph : Neptune
- Time-series : Timestream (시계열 데이터)
- Ledger : QLDB (블록체인)
- Wide column : Keyspaces (아파치 카산드라 호환)

