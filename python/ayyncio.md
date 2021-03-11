# 파이썬 asyncio

## 이벤트 루프
1. loop = asyncio.get_event_loop()
    - 현재 OS 스레드에서 실행중인 이벤트 루프 반환 
2. loop.run_until_complete(Future)
    - future가 완료될 때까지 실행
    - future는 awaitable한 객체
3. loop.close()
    - 이벤트 루프를 닫음
