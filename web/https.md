# HTTPS

- HTTP의 보안버전이다. 웹사이트 사용자가 인터넷을 통해 신용카드 번호, 은행 정보 및 로그인 자격 증명과 같은 중요한
  데이터를 안전하게 전송할 수 있다.
- 암호화, 인증, 무결성을 보장한다.

## TLS
- 인터넷을 통한 통신에서 보안을 확보하기 위해 송수신자가 서로 신뢰할 수 있는 자임을 확인함과 동시에, 통신 내용이 제3자에 의해 도청되는 것 방지

![TLS Handshake](https://images.ctfassets.net/slt3lc6tev37/3wZIhjRIjfVSmCbVqkBKzb/4a7aa34324108c725dc25fc9e7c4ea4a/tls-ssl-handshake.png)

1. 클라이언트가 서버에 연결
2. 서버가 TLS 인증서를 제공
3. 클라이언트가 서버 인증서를 확인
4. 클라이언트와 서버가 TLS 연결을 통해 정보 교환
