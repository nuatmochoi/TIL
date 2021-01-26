# Route 53

## DNS
- `naver.com`과 같은 문자열 주소를 `192.168.0.1`과 같은 IPv4로의 주소 변환이 필요하고, 이를 DNS 서비스라 부름
- DNS서버에는 도메인 주소와 IP주소가 서로 맵핑된다.
- 하나의 행을 레코드라고 부르며, 저장되는 타입에 따라, A 레코드와 CNAME으로 구분

## Record 
- A 레코드 : 도메인 주소와 서버의 IP 주소를직접 맵핑 (`naver.com` - `192.168.0.1`)
    - 한 번의 요청으로 바로 IP 주소를 알 수 있음
    - IP 주소가 자주 바뀌는 경우 번거로움
- CNAME : 도메인 주소를 또 다른 도메인 주소로 맵핑 (`post.blog.co.kr` - `postapi.blog.co.kr`)
    - IP 주소가 자주 바뀌어도 유연하게 대응 가능
    - 실제 IP 주소를 얻을 때까지 여러 번 DNS 정보를 요청하며, 성능 저하의 가능성 존재

## Route 53 이 정상적인 레코드를 선택하는 방식
1. 라우팅 정책과 레코드에 대해 지정한 값을 기반으로 선택
2. Route 53이 레코드가 정상이라 확인한 경우
    - 상태 확인이 연결된 비별칭 레코드
    - Evaluate Target Health (대상 상태 평가)가 예로 설정된 별칭 레코드 
3. 레코드가 정상인 경우 IP주소와 같이 해당되는 값으로 쿼리에 응답 / 레코드가 비정상인 경우 다른 레코드 선택하고 정상 레코드를 찾을 때까지 반복