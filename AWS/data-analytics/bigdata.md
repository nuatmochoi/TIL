# Big Data

## 하둡
- 분산 컴퓨팅을 통해 대용량 데이터 집합을 처리하는 프레임워크

## Amazon EMR
- 관리형 클러스터 플랫폼
- 하둡, Spark, Presto 등 실행 가능
- 몇 분 안에 클러스터 시작, 실행 중 크기 조정 Auto Scaling 가능
- 노드에 이상이 생겼을 때 빠르게 교체 해줌
- 저장소로는 HDFS, S3 둘 다 가능
- S3, HDFS, DDB, Redshift, Glacier, RDS, Kinesis 등 데이터 스토어 연동 가능

## Hive
- 데이터 웨어하우징 아키텍쳐
- MapReduce 및 HDFS 사용
- HQL 제공 (비정형화 -> 정형화 데이터로 맵핑 가능)
- DB, Table, Partition, Bucket
    - Partition : 쿼리에 이용하기 쉽게 디렉터리ㄹ르 나눔
    - Table
        - 내부 : HDFS 저장소에 저장, 수명주기가 Hive와 동일
        - 외부 : Hive 외부에 저장, 테이블 삭제 시 데이터 삭제되지 않음
        - Hive Metastore : Hive 외부의 값을 내부로 맵핑하기 위한 개념

## Hive를 이용한 로그 처리
1. S3에 시계열 prefix로 데이터 저장되어 있음
2. Hive에서 외부 테이블로 S3를 맵핑 
3. 특정 기간에 대한 데이터로 temp 내부 table 생성
    - 임시 테이블에 insert 를 통해 데이터 추출
3. 여러 temp table을 조인해서 join table을 외부 테이블로 저장
    - 외부 테이블 생성 이후, Insert overwrite로 테이블 조인
4. 최종적으로 S3로 테이블 맵핑

## Apache Spark
- 가장 최신의 빅데이터 분석 서비스
- 인메모리(램)을 최대한 활용하여 기존 MapReduce보다 최대 10배 빠름
- DataFrames : r, pandas에서 활용 가능한 데이터 형식
- Spark SQL : Hive MetaStore 테이블 정의를 그대로 가져오거나, Avro, Parquet, ORC, Json, JDBC 등 데이터 원본과 호환
- 여러 데이터 소스를 조인하여 복합 처리하는 데 유용

## AWS Glue
- Apache Spark를 기반으로 구현된 서버리스 ETL 서비스
- RDS, DDB 데이터 등 쉽게 연결 가능
