# Primitive

Javascript에서 `원시값(primitive, 원시 자료형)`이란 `객체`도 아니고 `메서드`도 아닌 data이다.
총 7개의 원시 자료형이 존재한다.

- string
- number
- bigint
- boolean
- null
- undefined
- symbol (ES16에서 추가)

모든 primitive는 불변이다. primitive 자체와 primitive을 할당한 변수를 혼동하지 않아야 한다. 변수는 새로운 값을 다시 할당할 수 있지만, 이미 생성한 primitive는 객체, 배열, 함수와 달리 변형이 불가하다. 여기서 객체, 배열, 함수를 `참조 타입(reference type)` 이라고 부른다.

```js
var numberPrimitive = 10;
var booleanPrimitive = false;
var stringPrimitivie = 'string boy';
```

위 코드에서 예를 들어 설명을 하자면, 대입되는 오른쪽 값이 primitive로 보면 되고, 실제 작동할 때는 변수를 이용하여 작업을 한다. 원시값이 변하지 않는 이유는, 원시값에 직접 작업하는 것이 아니라, 원본을 건드리지 않고 복사본을 가져와 작업을 하는 것이기 때문.

- 각각의 값은 모두 스택에 저장된다
- 변수 자체가 하나의 값을 가진다.
- 인자가 전달될 때 call by value의 형태로 넘어간다.
- primitive type의 값은 immutable하다.

null과 undefined를 제외하고, 모든 primitive는 원시값을 래핑한 객체를 가진다

- 문자열 원시값을 위한 `String` 객체
- 숫자 원시값을 위한 `Number` 객체
- 빅인트 원시값을 위한 `BigInt` 객체
- 불리언 원시값을 위한 `Boolean` 객체
- 심볼 원시값을 위한 `Symbol` 객체

## Reference

- [원시값 - 용어 사전 | MDN](https://developer.mozilla.org/ko/docs/Glossary/Primitive)
- [ECMAScript 스펙 톺아보기: Primitive](https://meetup.toast.com/posts/143)
