# Nginx

## Nginx Context

![nginx context](https://clouddocs.f5.com/training/community/nginx/html/_images/confcontexts.png)

1. Events : Nginx가 일반 수준에서 연결을 처리하는 방법에 대한 전역 옵션
2. HTTP : Nginx를 reverse proxy로 사용하는 목적
   - HTTP
   - Server
   - Location
3. Stream : TCP/UDP 로드 밸런싱을 위한 옵션이며, 인스턴스간 클러스터링 구성에 사용됨

- Stream context는 L4이기 때문에 웹 방화벽을 올리지 않음
- HTTP context Full context에 적용을 하게 되면 하위의 모든 context에 적용이 됨
  - Server context에 적용을 하게 되면 해당 Server에만 적용이 되게 됨

## Nginx Logging

1. Nginx error log
   - `/var/log/nginx/error.log`
   - 로그 레벨 정의
2. Nginx access log
   - `/var/log/nginx/access/log`
   - 로그 포맷 정의

## Reverse Proxy

- 클라이언트로부터 요청을 받아 적절한 웹서버로 요청을 전송
- 웹 서버는 요청을 받아서 응답을 클라이언트로 보내지 않고, Reverse Proxy로 전송
- 요청을 받은 Reverse Proxy는 응답을 클라이언트에 전송
- 따라서 클라이언트의 요청이 웹서버에 전달되는 도중에 끼어들어 다양한 전후처리가 가능
