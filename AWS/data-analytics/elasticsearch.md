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

## Reference
- https://www.elastic.co/kr/blog/how-many-shards-should-i-have-in-my-elasticsearch-cluster
