# 자바 가상 머신(JVM)

- 자바 애플리케이션(ByteCode)을 클래스 로더를 통해 읽어들여 자바 API와 함께 실행
- JAVA와 OS 사이에서 중개자 역할 – 따라서 JAVA가 OS에 구애받지 않게 재사용
- 가장 중요한 메모리 관리(Garbage collection)을 수행
- 스택 기반의 가상 머신

**JVM 구성 = Class loader + Execution engine + GC + Runtime Data Area**

- **클래스 로더** : 클래스(.class)를 로드하고, 링크를 통해 배치
- **실행 엔진** : 클래스를 실행 / ByteCode -> 기계어로 변환하는2가지 방식

  - 인터프리터 : 명령어 단위로 읽음. 한 줄씩 실행해서 느림
  - JIT (just in time)

    - 인터프리터 방식으로 실행하다가 byte code 전체 컴파일
    - 네이티브 코드로 실행하고 네이티브 코드로 직접 실행
    - 네이티브 코드는 캐시에 보관하므로 컴파일 후 빠르게 수행됨

  - GC : 힙 내의 객체 중 참조되고 있지 않은 객체를 찾아내 메모리 회수 (실제로는 실행 엔진 내부에 존재한다고 봐도 된다)

    - Minor GC
      - 새로 생성된 객체는 Eden 영역에 위치
      - Eden 영역에서 GC가 발생하고 남은 객체는 Survivor 영역(2개) 이동
      - 위 과정 반복하다 계속 살아남은 객체는 계속 참조 – Old 영역 이동
    - Major GC
      - Old 영역의 객체 모두 검사 -> 참조되지 않은 객체 한꺼번에 삭제
      - Major GC가 발생하면 GC 실행 스레드 제외 나머지 스레드 모두 중지
      - GC 작업 이후에 중단 작업 다시 시작
      - Full GC가 일어나는 수초간 모든 Thread가 정지한다면 심각한 장애 발생

- **Runtime Data Area** = Method, Heap, Stack, PC register, native method stack

  - 쓰레드가 생성되었을 때 기준으로 메소드, 힙 영역은 모든 쓰레드가 공유 / 스택, PC register, native method stack은 각 쓰레드마다 생성되고 공유 X
  - Method Area : 메소드 영역 (ex> 변수 이름 등 필드 정보, 메소드 정보,static 변수)
  - Heap Area : new 키워드로 생성된 객체와 배열이 생성되는 영역. 메소드 영역에 로드된 클래스만 생성, GC가 참조되지 않는 메모리를 확인하고 제거하는 영역
  - Stack Area : 지역변수, 파라미터, 리턴 값, 임시값 등이 생성되는 영역, 인스턴스 생성시 스택 영역에 생성된 변수 값이 힙 영역에 생성된 객체를 가리키는 것 (메소드 스택)
  - PC register : Thread가 생성될 때마다 생성되는 영역, program counter, 즉, 현재 쓰레드가 실행되는 부분의 주소와 명령을 저장
  - Native method stack : 자바 외 언어로 작성된 네이티브 코드를 위한 메모리 영역(ex> C)
