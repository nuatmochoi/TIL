# 호이스팅 (Hoisting)

**호이스팅**이란 함수 안에 있는 선언들을 모두 끌어올려서 해당 함수 유효 범위의 최상단에 선언하는 것이다.

오해가 있을 수 있는 부분인데, 실제로 코드가 끌어올려지는 것은 아니며, javascript Parser 내부적으로 컴파일 단계에서 끌어올려 처리하는 것이다.

```js
catName('Chloe');

function catName(name) {
	console.log("My cat's name is " + name);
}
```

위 코드에서 함수를 작성하기 전에 함수를 호출하였지만, 코드는 정상적으로 작동한다.

`var 변수 선언`과 `함수선언문`에서만 호이스팅이 일어난다.
`var foo2 = function(){...}` 형식의 `함수표현식`과 `let/const 변수 선언`에서는 호이스팅이 발생하지 않는다.

var 변수/함수의 초기화(할당)가 아닌 `선언`만 끌어올린다. 변수를 선언한 뒤에 나중에 초기화시켜서 사용한다면, 그 값은 아래 예시와 같이 undefined로 지정된다.

```js
var x = 1; // Initialize x
var y; // Declare y
console.log(x + ' ' + y); // '1 undefined'
y = 2; // Initialize y
```

코드의 가독성과 유지보수를 위해 호이스팅이 일어나지 않게 해야하며, `let/const` 를 사용함으로써 이 문제를 방지할 수 있다.

ES6를 모든 브라우저가 지원하는 것이 아니므로, ES5로 `babel` 등을 통해 트랜스컴파일을 진행해야 하고 이것이 `var`의 동작에 대해 FE 개발자가 이해하고 있어야 하는 이유이다.
