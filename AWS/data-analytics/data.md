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
  - [쿼리 성능 향상 팁](https://aws.amazon.com/ko/blogs/korea/top-10-performance-tuning-tips-for-amazon-athena/)
    - [파티셔닝](https://docs.aws.amazon.com/athena/latest/ug/partitions.html)
    - 파일 압축 및 분할 (`Apache Parquet`, `ORC` 불가능하면 `Bzip2`, `Gzip`)
    - 파일 크기 최적화 (파일이 너무 작지는 않은가, EMR에서 S3DistCP 유틸을 통해 작은 파일을 큰 오브젝트로 결합 가능)
    - 그래도 느리면 Hadoop, Hive를 앞단에 두어야 함
- AWS Glue : 데이터 카탈로그를 관리하거나 spark 경험에서 ETL 작업하려면 선택
  - 데이터 카탈로그 생성 (데이터의 테이블 정보) -> Athena, EMR, Redshift Spectrum 등 다양한 분석 툴에서 분석 -> QuickSight로 시각화하여 대시보드 생성 가능
  - Glue Job을 통해서 스크립트로 ETL 작업
  - AWS Glue DataBrew : S3, RDS, 데이터 카탈로그의 데이터를 연결하여, 데이터의 정교화를 도와줌 (필드에 대한 통계 정보, 상관 관계). csv 파일로 일괄적으로 데이터 형식을 변경하는 등의 처리가 가능
- Amazon QuickSight

  - 서버리스한 데이터 레이크(S3) 활용

  - 데이터 저장은 S3에 하면 된다.

  - 조그만 데이터로도 Athena, QuickSight로 데이터 분석 가능
