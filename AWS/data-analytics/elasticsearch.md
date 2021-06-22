# 엘라스틱서치

- 엘라스틱서치는 검색 엔진인 Apache Lucene으로 구현한 RESTful API 기반의 검색 엔진
- 엘라스틱서치 내에 저장된 데이터를 Index라고 부르며, 각 인덱스는 한 개 이상의 샤드로 구성되어 있음
- 샤드는 Lucene 인덱스를 뜻하며, Lucene 인덱스는 엘라스틱서치 클러스터 내에서 인덱싱 및 데이터 조회를 위한 독립적인 검색엔진이다.

- 데이터를 샤드에 입력할 때, 엘라스틱서치는 주기적으로 디스크에 immuatable한 Lucene segment 형태로 저장하며, 이 작업 이후에 조회가 가능.
  - 이 작업을 리프레쉬(**Refresh**)라고 부름
  - 샤드는 한 개 이상의 segment로 구성
    ![엘라스틱서치](https://images.contentstack.io/v3/assets/bltefdd0b53724fa2ce/bltfdb49c37fde7d294/5c3066de93d9791a70cd7433/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2018-04-26_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_9.16.10.png)
- segment 개수가 많아지면, 주기적으로 더 큰 segment로 병합된다. (**Merge**)
  - 모든 segment는 immutable하기 때문에, 병합되는 segment가 삭제되기 이전에, 새로운 segment를 생성.
  - 따라서 디스크 사용량에 변화가 생김. 병합 작업은 디스크 I/O 등 리소스에 민감하다.

## 단점

- 분산처리를 통해 실시간으로 처리하는 것으로 보이지만, 내부적으로 commit, flush 등의 작업을 거치므로 실시간은 아니다.
- 트랜잭션, Rollback을 지원하지 않음 (클러스터의 성능을 위해)
- 데이터의 업데이트를 지원하지 않음. 업데이트 명령이 오면 기존 문서를 삭제하고 새로운 문서 사용
  - 대신에 Immutable이라는 장점이 있다.
  - Segment가 Immutable한 이유는 캐싱 때문이다. Lucene은 읽기 속도를 높이기 위해 OS의 파일시스템 캐싱에 의존하고 있음. 빠른 액세스를 위해 hot segment를 메모리에 상주하게 유지시키는 식으로 작동한다. [참고](https://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html#_give_less_than_half_your_memory_to_lucene)

## 성능 향상 팁
- 샤드는 여러 노드에 잘 분포되도록
- Node 추가는 가장 트래픽이 적은 시간에 진행
  - 샤드 재분배로 인한 성능 저하
- 너무 많은 샤드 수라면 10~50GiB로 유지
- refresh interval을 60초 이상으로 늘리고(기본:1초), 다량의 인덱싱이 필요하면 복제본 수를 0으로 변경

## 인덱스 상태관리
- 7일이 지난 인덱스에 대해 Hot 스토리지인 UltraWam 스토리지로 변경
- 90일이 지나면 인덱스 삭제

## Composite Aggregation
- ElasticSearch는 한 번에 검색할 수 있는 건수(max_result_window)에 상한이 있음. 기본적으로 10000개 이상의 결과를 얻을 수 없음. 이를 해결해주는 것이 Composite Aggregation
- Composite Aggregation는 여러 집계 결과(Bucket)을 취급하는 기능이며, 집계 결과를 스크롤함으로써 위 요구사항을 해결함

## Reference

- https://www.elastic.co/kr/blog/how-many-shards-should-i-have-in-my-elasticsearch-cluster
