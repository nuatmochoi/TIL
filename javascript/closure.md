# 클로저(Closure)

**클로저**는 함수의 실행이 끝난 뒤에도 함수에 선언된 변수의 값을 접근할 수 있는 자바스크립트의 성질이다. 바로 예시로 들어가보자.

```js
function addCounter() {
	var counter = 0;

	return function () {
		return counter++;
	};
}

addCounter();
console.log(counter);
```

위 코드는 오류가 나는 코드이다. `addCounter()` 함수의 실행이 끝난 시점에서 `counter`라는 변수는 더이상 접근을 할 수 없는 상태이다. **함수 안에 선언한 변수는 함수 안에서만 유효 범위를 갖기 때문이다.**

```js
function addCounter() {
	var counter = 0;

	return function () {
		return counter++;
	};
}

var add = addCounter();
add();
add();
add();
```

아까와는 달리 이 코드는 오류 없이 실행된다. `addCounter()` 함수가 반환한 함수를 `add`라는 변수에 담아놓았기 때문에 `add` 자체가 함수처럼 동작하는 것이다.

`addCounter()`의 반환 함수는 자신이 생성된 렉시컬 스코프에서 벗어나 global에서 `add`라는 이름으로 호출이 되었다. 이런 `add` 와 같은 함수를 클로저라고 부른다.

`addCounter()` 의 렉시컬 스코프에서 생성된 instance는 `addCounter();` 수행이 끝난 후에 Garbage Collector가 회수해야 하는데, 사실은 그렇게 작동하지 않는다. 위에서 설명한 것과 같이, `addCounter()`의 반환 함수는 렉시컬 환경인 `addCounter()`의 렉시컬 환경을 계속 참조하고 있고, global에서 add가 해당 함수를 계속 참조하고 있기 때문이다. 이 때문에 클로저를 남용하게 되면 메모리 이슈가 생기게 된다.

클로저를 응용하여 자바스크립트에 없는 private 변수를 구현할 수 있다.

```js
function counter() {
	var _count = 0;

	return function () {
		_count += 1;

		return _count;
	};
}
var counterFirst = counter();
console.log(counterFirst());
console.log(counterFirst());
```

위와 같이 구현하면, `_count` 변수는 외부에서 접근할 수 없는 방법이 없다. `counter()` 함수 내에서만 접근할 수 있는 private 변수가 구현된 것이다.

## Reference

- [클로저(Closure)](https://joshua1988.github.io/vue-camp/js/closure.html#%ED%95%A8%EC%88%98%ED%98%95-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D)
- [자바스크립트의 스코프와 클로저](https://meetup.toast.com/posts/86)
- [클로저, 그리고 캡슐화와 은닉화](https://meetup.toast.com/posts/90)
