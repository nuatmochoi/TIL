# 파이어베이스 사용자분석(firebase analytics)

- 앱의 사용량과 행동 데이터 수집
- 이벤트 (사용자가 광고를 클릭할 때 등), 사용자 속성(연령, 성별, 휴대기기 등)에 대한 로깅을 SDK 설정을 통해 별도 코드 없이 이용 가능

  [사용자 속성](https://support.google.com/firebase/answer/6317486?hl=ko)

  [이벤트](https://support.google.com/firebase/answer/6317485?hl=ko&ref_topic=6317484)

## 안드로이드

[Google 애널리틱스 시작하기- 안드로이드](https://firebase.google.com/docs/analytics/get-started?platform=android)

1. Firebase 홈페이지에서 새로운 Firebase 프로젝트를 시작하고, Google 애널리틱스를 사용함으로 설정한다.
2. 앱에 애널리틱스 SDK 추가

   1. App/build.gradle 에 Google 애널리틱스의 dependency 추가
      ```java
      implementation 'com.google.firebase:firebase-analytics:17.4.1'
      ```
   2. `com.google.firebase.analytics.FirebaseAnalytics` 객체를 선언
      ```java
      private FirebaseAnalytics mFirebaseAnalytics;
      ```
   3. onCreate() 메소드에서 초기화
      ```java
      mFirebaseAnalytics = FirebaseAnalytics.getInstance(this);
      ```

3. 이벤트 로깅 시작
   - `FirebaseAnalytics` 인스턴스를 만든 후 `logEvent()` 메서드로 이벤트에 대한 로깅을 할 수 있다.
     ```java
     Bundle bundle = new Bundle();
     bundle.putString(FirebaseAnalytics.Param.ITEM_ID, id);
     bundle.putString(FirebaseAnalytics.Param.ITEM_NAME, name);
     bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "image");
     mFirebaseAnalytics.logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle);
     ```

## iOS

[Google 애널리틱스 시작하기(iOS)](https://firebase.google.com/docs/analytics/get-started?platform=ios#swift_1)

1. Firebase 홈페이지에서 새로운 Firebase 프로젝트를 시작하고, Google 애널리틱스를 사용함으로 설정한다. (안드로이드와 같은 프로젝트 사용)
2. 앱에 애널리틱스 SDK 추가

   1. Firebase에 대한 dependency을 Podfile에 추가
      ```
      pod 'Firebase/Analytics'
      ```
   2. `pod install` 이후, .xcworkspace 파일을 연다
   3. `UIApplicationDelegate`에서 파이어베이스 모듈을 import
      ```swift
      import Firebase
      ```
   4. `FirebaseApp` 인스턴스 구성
      ```swift
      FirebaseApp.configure()
      ```

3. 이벤트 로깅 시작
   - `FirebaseeApp` 인스턴스를 만든 후, `logEvnet()` 메소드를 이용해 이벤트에 대해 로깅을 사용할 수 있음
   ```swift
   Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
       AnalyticsParameterItemID: "id-\(title!)",
       AnalyticsParameterItemName: title!,
       AnalyticsParameterContentType: "cont"
       ])
   ```
