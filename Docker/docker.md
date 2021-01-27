# Docker

도커는 컨테이너 기반 오픈소스 가상화 플랫폼이며,
라이브러리, 시스템 도구, 코드, 런타임을 포함한 소프트웨어를 컨테이너로 패키징시키는 것이다.

로컬 PC, AWS, GCP, Azure 등 환경에 관계없이 빠르게 배포 및 테스트할 수 있다.

## Container 가상화
![VM:container](https://images.contentstack.io/v3/assets/blt300387d93dabf50e/bltb6200bc085503718/5e1f209a63d1b6503160c6d5/containers-vs-virtual-machines.jpg)

- Virtual Machine 가상화
  - Hypervisor 위에 Guest OS가 구동
  - 별도의 VM과 OS를 필요로 하기 때문에 자원의 비효율성(용량, 메모리)
- Container 가상화
  - Docker 엔진을 통해 각 App이 OS 자원을 직접 사용 (앱 실행에 필요한 자원만 사용)
  - 별도의 OS 없이 Docker 엔진 공유 (가벼움)


## Docker image

이미지는 컨테이너 실행에 필요한 파일과 설정값을 포함하고 있는 것이다. 즉, 컨테이너는 이미지를 실행한 상태이다.

## Docker Container

컨테이너란 격리된 공간에서 프로세스가 동작하는 기술이다. 컨테이너는 프로세스를 격리하는 방식이기 때문에 기존 가상화 기술에 비해 가볍고 빠르다.

## Docker cacheing

한번 이미지를 빌드한 뒤 dockerfile에 동일한 명령어가 있으면 이전의 빌드에서 사용했던 캐시를 사용한다. build할 때 using Cache log가 나오는 것을 확인할 수 있다. 캐시가 필요하지 않다면 `--no-cache` 옵션을 추가하면 된다.

## Dockerfile

- FROM절 : 컨테이너의 원형(틀) 역할을 할 도커 이미지(OS)를 정의한다.
- COPY절 : 쉘 스크립트 파일을 도커 컨테이너 안의 /usr/local/bin에 복사하기 위하여 정의한다.
- RUN절 : 도커 컨테이너 안에서 명령을 수행하기 위함. 여기까지 도커 빌드 과정에서 실행되며 그 결과로 새로운 이미지가 만들어진다.
- CMD절 : 완성된 이미지를 도커 컨테이너로 실행하기 전에 먼저 실행할 명령을 정의한다.

## 코드로 관리하는 인프라(IaC)와 불변 인프라(Immutable Infrastructure)

- IaC : 서버를 어떻게 구성할 것인지, 어떤 라이브러리와 도구를 설치할지를 코드로 정의하고 Chef나 Ansible 같은 프로비저닝 도구로 서버를 구축
  - stable 버전을 install하는 코드를 실행하는 예시를 들면, stable 버전은 자주 변하기 때문에 항상 같은 결과를 보장하지 않는 단점이 있음
- 불변 인프라(Immutable Infrastructure) : 어떤 시점의 서버 상태를 저장해 복제할 수 있게 하는 개념
  - 서버에 변경을 원할 때는 새로운 서버를 구축하고 그 상태를 이미지로 저장한 다음, 해당 이미지를 복제
- 도커를 사용하면 IaC와 불변 인프라의 개념을 간단하고 낮은 비용으로 실현할 수 있음
  - 인프라 구성이 Dockerfile로 관리되므로 IaC는 도커의 대원칙
  - 컨테이너형 가상화 기술 사용을 통해, 기존 컨테이너를 빠르게 폐기하고 새롭게 구축 가능 (불변 인프라)

## Container Orchestration

- 도커 컴포즈를 단일 서버를 넘어 여러 서버에 걸쳐 있는 여러 컨테이너를 관리할 수 있도록 한것이 도커 스웜(Docker Swarm)이다.
- 도커 스웜은 컨테이너 증가, 감소는 물론, 노드의 리소스를 효율적으로 활용하기 위해 컨테이너 배치 및 로드 밸런싱 등의 기능을 갖춤
- 배포 시 롤링 업데이트가 가능 (오래된 컨테이너와 새로운 컨테이너를 단계적으로 서비스에 교체 투입하는 것)
- 이렇게 여러 서버에 걸쳐 있는 여러 컨테이너를 관리하는 기법은 컨테이너 오케스트레이션이라고 한다.
- 컨테이너 오케스트레이션의 표준은 쿠버네티스(k8s)이다.

## Docker Network Mode

1. bridge
  - docker 기본 네트워크 방식
  - 각 컨테이너마다 고유한 network namespace 영역이 생성
  - docker daemon을 실행하면 docker0라는 bridge가 생성되며 해당 bridge에 container들의 인터페이스들이 하나씩 binding되는 구조
2. host
  - 컨테이너가 독립적인 네트워크 영역을 갖지 않고 host와 네트워크를 함께 사용
  - `docker run --net=host httpd web01` 과 같이 생성
  - 컨테이너의 ip와 인터페이스 정보는 host의 네트워크 정보와 동일
  - host옵션으로 생성된 컨테이너는 bridge를 사용하지 않으므로 docker0에 바인딩되지 않는다.
3. container
  - 기존 존재하는 다른 컨테이너의 network 환경을 공유
4. none
  - 격리된 네트워크 영역을 가지지만, 인터페이스가 없는 상태로 컨테이너 생성
  - bridge에도 연결되지 않은 상태이며, 이 상태로는 외부 통신 불가
  - 인터페이스를 직접 커스터마이징하기 위한 옵션

## How to fix docker error processing tar file

공간이 부족하거나 권한 문제로 발생하는 도커 오류 (컨테이너 배포가 잦은 환경이라면 내려받은 도커 이미지나 종료한 컨테이너가 디스크 용량을 많이 차지)

1. sudo docker image prune
2. sudo systemctl stop docker
3. sudo rm -rf /var/lib/docker
4. sudo systemctl start docker

이후 permission issue가 발생한다면

5. sudo chmod 666 /var/run/docker.sock

`docker system prune -a` 명령어 하나로도 해결할 수 있음.
  - 이를 야간에 cron 설정으로 스케줄링하는 방법도 있음

