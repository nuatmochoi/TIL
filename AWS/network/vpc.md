# VPC

- `enableDnsHostnames` 
    - PC에서 시작된 인스턴스가 퍼블릭 DNS 호스트 이름을 가져오는지 여부
    - `true`인 경우 VPC의 인스턴스는 퍼블릭 DNS 호스트 이름을 갖지만, `enableDnsSupport`가 `true`인 경우에만 가능
- `enableDnsSupport`
    - VPC에 대해 DNS 확인이 지원되는지 여부
    - `false`이면 퍼블릭 DNS 호스트 이름을 IP주소로 확인하는 DNS 서버가 활성화되지 않음
    - `true`이면 Amazon 제공 DNS 서버에 대한 쿼리와 예약된 IP주소에 대한 쿼리가 성공

## VPC Peering 
![VPC Peering](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/VPC-Peering-On-Premise-1.png)
- 프라이빗 IPv4 또는 IPv6 주소를 사용하여 두 VPC 간 트래픽을 라우팅하기 위한 VPC 간의 네트워킹 연결
- 온프레임과 연결시 모든 VPC에 VPN Connection을 해주어야 하는 번거로움
- VPC 당 최대 VPC Peering 가능 개수 : 125개
- 대역폭 제한 없음
    - 대역폭 제한이 문제가 된다면 VPC Peering 사용

## Transit Gateway
![Transit Gateway](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/TGW-On-Premise-1.png)
- VPC와 온프레미스 네트워크를 단일 게이트웨이에 연결할 수 있도록 해주는 서비스
- 여러 VPC를 한번에 연결할 수 있게 함 + VPN Connection의 개수도 줄어듦
- 대역폭 제한 : 50 Gbps
- Transit Gateway당 VPC 최대 연결 개수 : 5000개
    - VPC 1개당 125개가 넘는 VPC Peering이 필요하다면, Transit Gateway 사용  
    - 단순한 구조이지만, VPC Peering 보다 많은 비용 청구

## Reference
- [VPC Peering과 Transit Gateway 어떻게 다를까](https://dev.classmethod.jp/articles/different-from-vpc-peering-and-transit-gateway/)