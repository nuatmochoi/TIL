## Ngrinder
- 에이전트 : 머신 개수
- 에이전트별 가상사용자 : 에이전트당 몇명의 동시접속을 할것인지
	- 프로세스 / 스레드 —> grinder 공식문서는 스레드 사용을 권장
    - ramp-up : 동시 접속 사용자를 만들 때, 순차적으로 늘려가는 것 (프로세스를 사용하기 때문에 프로세스 숫자를 높여야함)
    - 스크립트 편집을 통해 —> 부하테스트 중 다른 로직 추가 가능
- 테스트 기간(몇분동안) or 횟수(스레드 당 몇번의 테스트)  
	- 에이전트 * 가상사용자 수 * 테스트 횟수 = 전체 테스트 횟수
- ramp-up 수 : 주기마다 몇개씩 프로세스 추가할 것인지
- 프로세스 ramp-up 주기 —> ms (ex> 2000ms : 2초 주기로 프로세스 추가 생성)
- tps 그래프를 통해 얼마나 많은 요청을 받을수있는지 확인 가능
- tps(초당처리량) : grinder가 초당 부하를 얼마나 보낼 수 있고, 수용할 수 있는지 (높을 수록 좋음)
- 평균테스트시간(MTT) : 커넥션을 했을 떄 얼마나 빨리 서버가 받는가 (낮을 수록 좋음)
- 로직 개선을 통해 퍼포먼스 개선되었는지 확인 : 똑같은환경 똑같은 조건으로 부하 생성 : 복제 후 생성 (ngrinder가 제공하는 기능)
- [DB 부하 테스트 (jdbc이용)](https://github.com/naver/ngrinder/wiki/Using-nGrinder-to-perform-DB-load-test)

## Apache JMeter
- 스레드 그룹 : 몇번 접속할 것인지 (Number of Thread)
	- loop count : 스레드 각각이 loop당 loop count 수만큼 접속 
	- 스레드 그룹 안에서 여러 개의 Request 만들 수 있음
- 웹 이면 HTTP Request로 요청
	- View Results Tree : 각각의 access의 결과와 서버 리턴값을 확인 가능
	- Summary Report
        - avg, min, max
        - error
        - throughput : 초당 접속 (높을 수록 좋음) 
            - error 가 발생하면 높아지기 때문에 같이 살피는 것이 중요
- JDBC Connection Configuration을 통해 DB load test 가능
