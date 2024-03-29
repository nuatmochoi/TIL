## final

- Immutable/Read-only 속성을 지시하는 지시어
- final class : 다른 클래스에서 상속하지 못함
- final method : 다른 메소드에서 오버라이딩하지 못한다.
- final variable : 변하지 않는 상수값이 되어 새로 할당할 수 없는 변수
- 클래스와 메소드를 제한함으로써 Override로 인한 실수를 최소화, 버그 줄이기 위함
- 함수의 경우 절대 상속되면 안되는 경우 final 정의

## 오버로딩, 오버라이딩

- 오버로딩 : 같은 이름의 메서드 여러 개일 때 매개 변수의 유형과 개수를 다르게 하여, 다양한 호출이 가능하게 함 (ex> cat(int a, int b), cat(String c) ) - 매개변수만 다름
- 오버라이딩 : 상위 클래스가 가진 메소드를 하위 클래스로 상속하여 하위클래스에서 사용할 수 있게 하는 것. 하위 클래스에서 메소드를 재정의해서 쓸 수 있게 함 – 오버라이딩하려는 메소드의 이름, parameter, 리턴 값 모두 동일해야함

## 묵시적 형변환, 명시적 형변환

- 묵시적 형변환 : 자동으로 형 변환 (ex> float to double) - 더 넓은 범위로 데이터 저장하기 때문에 데이터 손실이 없다.
- 명시적 형변환 : 데이터 앞에 변환할 타입으로 명시 (Type) - 큰 범위에서 작은 범위로의 형변환 – 데이터의 손실이 발생할 수 있다.

## 가상 함수

- 다형성의 측면에서, 메소드 호출에 대해 실행 시점에 호출된 객체의 타입을 보고 어떤 메소드가 호출될 것인지 결정하는 것
- 프로그램 실행 전에 결정되지 않는 동적바인딩이 이루어진다. 가상함수는 실행시점에 동적바인딩을 통해 어떤 메소드를 호출할지 결정하는데, 이 때 객체에 타입에 따라 어떤 메소드가 호출될지 결정하는 vtable(가상함수 테이블)을 이용한다.
- 메소드를 호출할 때마다 vtable을 찾아서 주소로 가야하기 때문에 실행시간이 느려질 수 있으나, 자바는 모든 메소드가 가상함수로 구현되어 있다. 상속 클래스 작성이나, 코드 설계 시 무조건 오버라이드할 수 있는 장점.
