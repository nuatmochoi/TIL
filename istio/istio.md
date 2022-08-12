## MSA 구조의 문제
- 각각 서비스에 중복 인증처리 
- 서비스를 거쳐서 오는 로그(tracing)
- 모든 서비스가 모든 로그를 받는 것도 말이 안됨
- 모니터링

## API Gateway
- 위 문제를 해결하기 위해 API Gateway 방식이 나왔으나
- API Gateway 자체에 대한 무거움 / 인프라 복잡도
- k8s에서는 네임스페이스별로 기능/책임을 위임하는데, 어울리지 않고
- API Gateway 레이어 자체에 장애가 났을 때, 전체 서비스 장애로 이어짐

## MSA 장애 상황을 가정한다면
- Centry에만 에러가 찍히고, 트레이싱이 어려움 (개발자 측면)
- 인프라 측면
    - 덤프 찍기가 어렵다 (프레임워크, 네트워크 설정이 다 다름)
    - 구간별로 특정하기가 어렵다 (infra, k8s iptables, services 지나쳐 오면서)
    - ..어디가 원인이지?
- 공통적으로 통일된 네트워킹 정책으로 공통적인 모니터링 정책이 들어가야 원인을 찾기 쉬움

## proxy sidecar pattern
- 모든 inbound/outbound traffic이 해당 proxy를 통해서 처리가 되기 때문에 
- proxy에 대한 관리만 잘하면 일관된 네트워크 정책, 일관된 메트릭
- proxy끼리만 통신하기 때문에, proxy 간 config 관리만 잘되면 각 서비스에 대한 헬스체크가 용이

## Istio
- control plane = istiod
- data plane = istio-proxy (envoy)
    - service mash (map) 구성 가능

## Envoy Proxy

