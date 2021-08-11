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
