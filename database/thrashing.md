## Thread Thrashing

주기억장치의 모든 페이지가 활발히 사용되고 있어 어떤 page가 교체된 후 곧바로 반복적인 page fault가 발생하여, 프로세스의 실행보다 페이징을 위해 더 많은 시간이 소요되는 것

- page : 가상 메모리를 일정한 크기로 나눈 블록 (4K)
- frame : 물리 메모리를 일정한 크기로 나눈 블록 (4K)
- 가상 메모리

  - 32 bit 는 이론상 2^32
  - 64 bit 는 이론상 2^64

- RDB에서 connection의 수는 DB서버의 thread나 process 수
