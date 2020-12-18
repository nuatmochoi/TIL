# WebRTC

webRTC는 중간자 없이 브라우저 간 오디오, 비디오, 데이터를 스트림하고 데이터를 교환할 수 있도록 하는 기술

## 개념

- WebRTC는 자바스크립트 API를 활용한다.
- peer 간 연결은 `RTCPeerConnection` 인터페이스를 통해 이루어진다.
- 커넥션 이후 `MediaStream` (미디어 스트림)과 `RTCDataChannel` (데이터 채널)을 커넥션에 연결할 수 있다.
  - RTCPeerConnection
    - 로컬 컴퓨터와 원격 peer 간 WebRTC 연결을 담당
    - 원격 peer에 연결하기 위한 method 제공
    - 연결을 유지하고 연결 상태를 모니터링하며, 연결이 필요하지 않으면 연결 종료
  - MediaStream (== getUserMedia)
    - 미디어 정보를 가지는 다수의 트랙으로 구성
    - 스트림은 한 개 이상의 음성(or 영상) 트랙으로 구성되어 있다.
    - 라이브 미디어(Web Cam) 혹은 저장된 미디어(스트리밍)을 송수신할 수 있다.
  - RTCDataChannel
    - 임의의 바이너리 데이터(image, text, file 대부분의 data)를 `RTCDataChannel`을 통해 peer 간 교환할 수 있다.
    - 메타데이터 교환, status 패킷 교환, 파일 교환 등에 쓰일 수 있다.

## 절차

1. **미디어 장치 세팅** - `getUserMedia()` 함수를 이용하여 일치하는 미디어 장치(마이크, 카메라)에 접근

   ```js
   const openMediaDevices = async (constraints) => {
   	return await navigator.mediaDevices.getUserMedia(constraints);
   };

   try {
   	const stream = openMediaDevices({ video: true, audio: true });
   	console.log('Got MediaStream:', stream);
   } catch (error) {
   	console.error('Error accessing media devices.', error);
   }
   ```

2. **로컬 재생** - 미디어 장치가 열리고 사용 가능한 MediaStream이 있으면 비디오 및 오디오 요소에 할당하여 스트림을 로컬로 재생할 수 있음

   ```js
   async function playVideoFromCamera() {
   	try {
   		const constraints = { video: true, audio: true };
   		const stream = await navigator.mediaDevices.getUserMedia(constraints);
   		const videoElement = document.querySelector('video#localVideo');
   		videoElement.srcObject = stream;
   	} catch (error) {
   		console.error('Error opening video camera.', error);
   	}
   }
   ```

   ```html
    <html>
    <head><title>Local video playback</video></head>
    <body>
        <video id="localVideo" autoplay playsinline controls="false"/>
    </body>
    </html>
   ```

3. **피어 연결 시작하기**

   - 두 클라이언트 모두 ICE(Internet Connectivity Establishment) 서버 구성을 제공해야 한다. (STUN or TURN)
     ```js
     async function makeCall() {
     	const configuration = {
     		iceServers: [{ urls: 'stun:stun.l.google.com:19302' }],
     	};
     	const peerConnection = new RTCPeerConnection(configuration);
     	signalingChannel.addEventListener('message', async (message) => {
     		if (message.answer) {
     			const remoteDesc = new RTCSessionDescription(message.answer);
     			await peerConnection.setRemoteDescription(remoteDesc);
     		}
     	});
     	const offer = await peerConnection.createOffer();
     	await peerConnection.setLocalDescription(offer);
     	signalingChannel.send({ offer: offer });
     }
     ```
   - 각 피어 연결은 `RTCPeerConnection` 객체에 의해 처리됨
   - 호출 측에서 피어 연결을 시작하기 위해 `RTCPeerConnection` 객체를 생성한 이후, `createOffer()`을 호출하여 ``RTCSessionDescription` 객체를 생성, `setLocalDescription()`을 사용하여 신호 채널을 통해 수신 측으로 전송된다.
   - 수신 측에서는 `RTCPeerConnection`를 생성하기 전에 호출 측의 suggestion을 기다린다. 완료되면 `setRemoteDescription()`을 통해 수신된 제안을 설정, 다음으로 `createAnswer()`을 호출하여 받은 suggestion에 대한 answer을 생성한다. 이것은 `setLocalDescription()`을 사용하여 신호채널을 통해 다시 호출 측으로 전송된다.
   - 원격 피어의 설정을 완료한 것이고, 피어 간의 연결을 위해서는 ICE 후보를 수집하고 신호채널을 통해 다른 peer로 전송해야 한다.

#### ICE 후보

- 잠재적으로 연결될 수 있는 엔드포인트를 ICE 후보라고 한다.

## Reference

[WebRTC API - MDN](https://developer.mozilla.org/ko/docs/Web/API/WebRTC_API)
[WebRTC.org](https://webrtc.org/getting-started/peer-connections?hl=ko)

```

```
