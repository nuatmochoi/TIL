# Spring

## IoC, DI
- `Singleton` :애플리케이션이 시작될 때 클래스가 최초에 한 번만 메모리를 할당하여 메모리에서 인스턴스를 만들어 사용하는 디자인 패턴
- Spring은 싱글톤 개념이 투영된 프레임워크로, `Bean`이라는 객체가 애플리케이션에 하나만 존재하는 객체를 일컫음
    - ex> `@Controller`, `@Service`, `@Repository`, `@Component`, `@Bean`
- `Bean`은 IoC Container에서 명령을 기다리고 있음
    - IoC : 제어의 역전. 개발자가 작성한 프로그램이 재사용 라이브러리의 흐름 제어를 받게 되는 디자인 패턴
    ![IoC Container](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbNpuC5%2FbtqByGsTnS5%2FCd9vNQd4eZp8XiYZH42ti0%2Fimg.jpg)
- DI (Dependency Injection) : 상위 모듈에 의존하는 하위 모듈의 생성자, property, method를 통해 주입하는 것
