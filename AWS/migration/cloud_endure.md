# CloudEndure
- rehosting 솔루션 (lift & shift)
- Source 서버를 aws 계정에 지속적 복제, 마이그레이션 준비가 되면 서버를 자동으로 변환하고 실행 (전환 시간 단축)
- Agent 기반 솔루션 
- [지원 버전](https://docs.cloudendure.com/#Getting_Started_with_CloudEndure/Supported_Operating_Systems/Supported_Operating_Systems.htm#Supported_Operating_Systems%3FTocPath%3DNavigation%7CGetting%2520Started%2520with%2520CloudEndure%7CSupported%2520Operating%2520Systems%7C_____0) 

![CloudEndure](https://d2908q01vomqb2.cloudfront.net/fc074d501302eb2b93e2554793fcaf50b3bf7291/2020/06/08/CloudEndure-Migration.png)

## 기능 
1. 재해 복구
    - CloudEndure Disaster Recovery
        - 스냅샷 기반 솔루션이 아니라 비동기적 복제이므로 초 단위의 RPO(복구 지점 목표)를 실현
        - 자동화된 시스템 변환 및 오케스트레이션을 통해 몇 분 단위의 RTO(복구 시간 목표)를 구현
        - 랜섬웨어로부터의 보호 : 손상되지 않은 서버 버전을 대상 aws 리전에서 시작
        - 온프레미스 to Cloud, 온프레미스 to 온프레미스(Outposts), 리전 간 재해 복구, 클라우드 간 재해 복구를 모두 지원
2. 데이터 무결성 보장
3. 중단없는 workflow
    - 백그라운드 실행을 통해 시스템 성능에 영향을 주지 않고, 데이터의 지속 흐름을 보장
    - 스냅샷, 디스크에 데이터 Write를 하지 않고도 메모리상에서 소스 서버를 복제
4. 보안
    - AES 256 bit를 이용해 전송 중 데이터를 암호화
    - hand-shake, 모니터링을 위해 TCP port 443에 대한 송신 액세스 필요
    - 복제 서버와 통신하기 위해 TCP port 1500에 대한 송신 액세스 필요


## 절차
1. Source 시스템에 CloudEndure Agent 설치
    - CloudEndure Agent는 CloudEndure 콘솔에 연결한 다음, destination이 되는 aws region으로 api를 호출하여, 고객 계정에 staging 영역 생성
    - staging 영역은 경량 EC2 (복제 서버 - default: t3.small)와 저렴한 EBS 볼륨으로 구성
    - 복제 서버는 CloudEndure Agent로부터 데이터를 수신하여 EBS 볼륨에 Write 수행
        - Public IP address가 자동 할당됨
    - 리눅스 machine
        1. agent 설치 
            ```sh
            wget -O ./installer_linux.py https://console.cloudendure.com/installer_linux.py
            ``` 
        2. installer 실행 (Token 값은 Machine Actions -> Add Machine에서 확인 가능)
            ```sh
            sudo python ./installer_linux.py -t THIS-NUMB-ERWI-LLBE-DIFF-EREN-TFOR-YOU1-THIS-NUMB-ERWI-LLBE-DIFF-EREN-TFOR-YOU1 --no-prompt
            ```
    - 윈도우 machine
        1. agent 설치
            ```sh
            https://console.cloudendure.com/installer_win.exe
            ```
        2. installer 실행
            ```
            installer_win.exe -t THIS-NUMB-ERWI-LLBE-DIFF-EREN-TFOR-YOU1-THIS-NUMB-ERWI-LLBE-DIFF-EREN-TFOR-YOU1 --no-prompt
            ```
2. 모든 source 디스크가 staging 영역으로 복제된 후, agent는 source의 변경 사항을 추적하고 복제
    - 1초 미만의 지연시간으로 연속 비동기 블록 수준 데이터 복제(CDP)를 수행
3. 고객이 CloudEndure의 [Setup & Info] - [Replication settings] 에서 Source와 Target(destination)을 지정할 수 있음
    - 온프레미스 Source의 경우 `Other Infrastructure`을 지정
4. test 및 cutover 진행하면 대상 리전으로 마이그레이션 진행됨

## CloudEndure 제한사항
- Agent 설치 이후에 복제가 완료되면, 지속적으로 변경 사항을 추적한다. 이 변경 사항이 실제로 서버에 반영되는 것은 Test나 Cutover를 했을 때 반영된다.
- Blueprint에서 EIP 지정을 하지 않으면, 새롭게 test 요청을 했을 때 IP 주소가 바뀐다.
- CloudEndure 복제 속도는 다음과 같은 요소에 의해 영향을 받는다.
    - Source에서 복제 서버까지의 up-link 속도 및 대역폭 
        - `iperf3`로 테스트 가능. 테스팅은 replication 서버가 있는 서브넷에 linux 인스턴스를 추가해서 테스팅한다.
        - `sudo apt-get install iperf3 -y`로 설치한 뒤, 서버 인스턴스에서 `iperf3 -s`, 클라이언트 인스턴스에서 `iperf3 -c [IP 주소]`를 실행하여 확인 가능
    - 전체 디스크 스토리지
    - 복제 중 디스크 변경
        - 쓰기가 많은 서버에서 복제 데이터의 전송을 따라잡지 못할 수 있다.
        - 따라서 DB서버 migration은 SMS나 DMS 권장
    - 원본 서버 I/O 성능
- 네트워크 대역폭 조절(스로틀링) 옵션을 통해 기존 시스템의 트래픽 압박을 줄일 수 있으나, Source 서버의 쓰기 작업량(최소 대역폭) 보다 높게 설정해야 한다. 그렇지 않으면 복제 작업이 완료되지 않음. 이 부분이 사전에 예측이 어렵기 때문에, 사전 test 진행을 통해 어느 정도로 제한할 것인지 결정해야 함.

## vs AWS Server Migration Service (SMS)
|CloudEndure|SMS|
|--- | --- |
|x86을 지원하는 모든 소스|Azuze 가상머신 + VMWare + Hyper-V|
|에이전트 설치 | 에이전트 설치 X, SMS 커넥터 사용(스냅샷 생성-> AMI 변환)|
|실시간 복제에 더 적합 | 스냅샷 기반으로 복제 간 시간 1h~24h|
|네트워크 대역폭 제어 가능 | 네트워크 대역폭 제어 불가|
|EC2 속성 사용자 지정에 Blueprint 사용 or 권장 사항 선택 | 애플리케이션 마이그레이션의 경우, AMI 변환 이후 CloudFormation 템플릿 생성(재사용성)|
|스냅샷 저장 비용| 스냅샷 저장 비용 + S3가 서버 볼륨을 일시 저장하는 요금|
|복제 트래픽을 AES-256으로 암호화 + TLS로 전송, BitLocker 지원 X | 서버 측 암호화 + 7일 후 버킷 객체 모두 삭제 + AMI 암호화 옵션 + TLS로 전송|
|데이터 전송에 Direct Connect 사용 가능 | 데이터 전송에 Direct Connect 사용 불가 |

![SMS](https://d2908q01vomqb2.cloudfront.net/fc074d501302eb2b93e2554793fcaf50b3bf7291/2020/06/08/AWS-Server-Migration-Service.png)

## Reference
- [CloudEndure Migration](https://aws.amazon.com/ko/cloudendure-migration/)
- [CloudEndure Disaster Recovery](https://aws.amazon.com/ko/cloudendure-disaster-recovery/)
- [CloudEndure vs AWS SMS](https://aws.amazon.com/ko/blogs/architecture/field-notes-choosing-a-rehost-migration-tool-cloudendure-or-aws-sms/)
