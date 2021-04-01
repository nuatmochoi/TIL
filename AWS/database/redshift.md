# RedShift
- RedShift는 완전관리형 petabyte 규모의 데이터웨어하우스 서비스
- OLAP 유형의 DB
- 현재 단일 AZ 배포만 지원
- RedShift는 읽기 전용 복제본이 없음

## 구성
1. 클러스터 : Leader node + Compute nodes(1개 이상)
    - 클러스터를 프로비저닝할 때 하나의 DB를 생성하며, 데이터 로드 및 쿼리에 이용됨
2. RedShift 노드
    - Leader node 
        - client application으로부터 쿼리를 받음(리더 노드하고만 직접 상호작용)
        - 구문을 분석하여 복합 쿼리 결과를 얻기 위한 쿼리 실행계획을 작성
        - 실행 계획에 따라 코드를 컴파일하여 컴퓨팅 노드로 배포한 후 데이터 구간을 컴퓨팅 노드로 할당 & 결과 집계
        - 결과를 client application으로 반환
    - Compute node
        - 쿼리 실행계획을 실행
        - 쿼리 처리를 위해  leader node로 데이터 전송
    - 노드 유형
        - DS (고밀도 스토리지) : 대용량 데이터 워크로드 최적화 / HDD
        - DC (고밀도 컴퓨팅) : 성능 집약적 워크로드 최적화 / SSD
3. 매개 변수 그룹 (parameter group) : WLM (워크로드 관리)
    - 기본 WLM 구성 : 최대 5개 쿼리를 동시 실행하는 queue 
    - 더 많은 쿼리 처리를 위해 큐를 추가 가능

## 모니터링
- Enhanced VPC Routing (향상된 VPC 라우팅)
    - VPC를 통해 클러스터와 데이터 저장소 간 모든 COPY & UNLOAD 트래픽 관리
    - VPC 흐름 로그를 이용해 COPY & UNLOAD 트래픽 모니터링
    - 비활성화 상태라면, 인터넷을 통해 트래픽 라우팅
- 감사 로깅 
    - RedShift 클러스터의 연결, 쿼리, 사용자 활동에 대한 정보 모니터링
    - 로그는 S3 버킷에 저장됨
