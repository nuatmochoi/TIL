## AWS Site-to-Site VPN

- AWS 서비스와 IDC를 잇는 VPN
- Site-to-Site VPN은 IPsec VPN 연결을 지원
- 다음 네 가지 요소가 포함됨
  1. 가상 프라이빗 게이트웨이
     ![Virtual Private GW](https://docs.aws.amazon.com/ko_kr/vpn/latest/s2svpn/images/vpn-how-it-works-vgw.png)
  2. 전송 게이트웨이(Transit Gateway)
     ![Transit Gateway](https://docs.aws.amazon.com/ko_kr/vpn/latest/s2svpn/images/vpn-how-it-works-tgw.png)
  3. 고객 게이트웨이 디바이스
  4. 고객 게이트웨이

## AWS Client VPN

- AWS와 사용자(클라이언트)를 연결하는 VPN
- 로컬 및 모바일 디바이스에서 OpenVPN기반 VPN Client 애플리케이션을 사용하여 VPN 세션을 설정함. VPN 세션 설정 이후 VPC 내 리소스에 접근 가능
  ![Client VPN](https://docs.aws.amazon.com/ko_kr/vpn/latest/clientvpn-admin/images/architecture.png)
