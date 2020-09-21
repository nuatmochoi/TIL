# Expo

react native를 위해 node와 npm이 필요하고 expo-cli 설치가 필요함

`npm install -g expo-cli`

expo는 create-react-app 같은 것. 리액트 네이티브를 위한 설정 파일 등이 모두 셋업되어있다.

다른 방식은 React Native CLI 방식이 있는데, native file 들을 더 많이 컨트롤하기를 원할 때 사용한다.
expo는 모든 native file을 숨기고, 모든 것을 관리. expo의 장점은 휴대폰에서 앱을 테스트할 수 있다는 것. (안드로이드, iOS 모두 expo 앱을 통해 테스트 가능)
expo는 iOS, 안드로이드를 위한 앱을 빌드해준다. 윈도우 개발자라도 iOS 앱을 빌드할 수 있게 되는 것이다.

expo api는 payment, printing, sensor, sqlite, updates, video, web-browser, facebook-ads, barcode-scanner, barometer, brightness 등 다양한 기능을 지원한다.

`expo init {프로젝트명}`

app.json은 expo가 읽게 될 configuration file
App.js는 기본적인 리액트 컴포넌트

expo 애플리케이션 시작을 위해 `npm start`

자동으로 export dev tool이 오픈되고, tunnel과 metro bundler가 자동으로 시작될 것이다.
QR코드가 있는데, 안드로이드 폰에서 QR코드를 스캔하면 프로젝트 앱을 폰에서 테스트 할 수 있다.
iOS는 QR코드가 없기 때문에, expo 앱으로 로그인하고 콘솔에서 `expo login` 을 통해 접속할 수 있을 것이다.

expo는 live reloading을 지원. 저장하면 자동으로 refresh가 되고, 변경을 확인할 수 있다.
폰을 흔들면 개발자 메뉴를 확인할 수 있음. 시뮬레이터에서는 ctrl + D 를 통해 개발자 메뉴 확인 가능

# 리액트 네이티브 작동 방식

리액트 네이티브는 Android, iOS 모두 자바스크립트 엔진을 가지고 있어 자바스크립트를 실행할 수 있는 것을 이용한다.

리액트 컴포넌트를 사용하지만 결국 브릿지를 거쳐서 안드로이드와 아이폰으로 가기 때문에 느린 성능을 유발할 수 있다.

브릿지로 많은 데이터를 보내면 브릿지에 많은 부하가 걸리게 된다. 3D 비디오 게임 같은 경우 등 코드를 최적화시켜야 하는 경우에는 리액트 네이티브가 적절하지 않을 수 있다.

리액트 네이티브에서 모든 text는 `<Text></Text>` 컴포넌트 안에 들어가야 한다. 또한 `<div>` 대신에 `<View>` 컴포넌트를 사용한다. 이러한 룰의 존재 이유는 브릿지 때문이다.

리액트 네이티브는 css 엔진을 구현했기 때문에, flex box 등을 사용할 수 있다. 몇가지 예외 경우가 있고 웹사이트의 css처럼 적용이 되지 않을 수도 있다. StyleSheet API는 stytlesheet을 쉽게 만들 수 있도록 도와준다.
