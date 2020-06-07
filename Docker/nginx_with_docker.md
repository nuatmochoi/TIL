# Nginx 를 이용한 Django 배포 (feat. Docker)

runserver로만 장고 서버를 구동하고 있었는데, 성능이나 안정성 이슈가 있다고 한다. 따라서 프로젝트를 진행하면서 django에 웹 서버인 nginx를 연동하는 과정이 있었다.

**Docker를 이용하여 nginx를 쉽게 연동하는 방법이 있어 소개해보자 한다.**

기존 장고 프로젝트가 있는 상태를 가정하고 진행하겠다.

1.  가상환경으로 들어가서 gunicorn을 설치한다. (무거운 uWSGI 대신 gunicorn으로 nginx와 연결하였다)

    ```sh
    source venv/bin/activate

    pip install gunicorn
    ```

    - 참고로 uWSGI나 gunicorn같은 웹서버를 쓸 때, static file을 모으지 않으면 css가 적용되지 않은 상태로 나온다. 해결을 위해서,

      1. settings.py에 아래 코드 추가
         ```py
         STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
         ```
      2. collectstatic 명령어를 통해 static file을 모아줌
         ```sh
         python manage.py collectstatic
         ```

2.  도커 설치

    - 설치에 필요한 패키지들 설치

      ```sh
      sudo apt-get update && sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
      ```

    - ppa관련 에러가 뜬다면 아래 스크립트 실행

      ```sh
      sudo add-apt-repository -r ppa:jonathonf/python-3.6

      sudo apt update
      ```

    - 도커 설치

      ```sh
      curl -fsSL https://get.docker.com/ | sudo sh
      ```

    - 설치된 도커는 아래 스크립트로 확인할 수 있다.
      ```sh
      docker version
      ```
      permission denied가 난다면, `/var/run/docker.sock` 파일의 권한을 변경
      ```sh
      sudo chmod 666 /var/run/docker.sock
      ```

3.  프로젝트의 루트 디렉토리에 **Dockerfile** 이라는 파일을 추가해준다. 내용은 아래와 같다.

    ```
    FROM python:3.6
    RUN mkdir /code
    WORKDIR /code
    ADD requirements.txt /code/
    RUN pip install -r requirements.txt
    ADD . /code/
    ```

    - 파이썬 버전에 맞게 첫 줄을 작성해주고
    - 도커 내에서 /code 라는 이름의 폴더를 생성
    - 로컬의 requirements.txt 파일을 mount하고 패키지를 설치하는 과정
    - 현재 로컬의 모든 파일, 폴더를 /code/ 로 마운트

4.  nginx 폴더를 만들고, **nginx.conf** 파일 생성

    ```
    server {
        location / {
            proxy_pass http://web:8000/;
        }

        location /static/ {
            alias /static/;
        }

        listen 80;
        server_name <도메인 주소>;
    }
    ```

    server_name에는 도메인 주소를 넣으면 된다. (ex> ec2-54-180-94-185.ap-northeast-2.compute.amazonaws.com)

5.  프로젝트의 루트 디렉토리에 **docker-compose.yml** 파일 생성

    ```yml
    version: '3'
    services:
      nginx:
        image: nginx:latest
        ports:
          - '80:80'
        volumes:
          - .:/code
          - ./nginx:/etc/nginx/conf.d
          - ./staticfiles:/static
        depends_on:
          - web
      web:
        build:
          context: .
          dockerfile: Dockerfile
        command: gunicorn <프로젝트이름>.wsgi:application --bind 0.0.0.0:8000
        volumes:
          - .:/code
          - ./staticfiles:/staticfiles
        expose:
          - '8000'
    ```

    <프로젝트이름> 는 wsgi.py가 속한 폴더의 이름 (커스텀하지 않는다면 프로젝트 이름)

    depends_on을 통해 순서가 있게 서비스가 실행될 것이다. (web -> nginx)

6.  settings.py의 ALLOWED_HOSTS에 'web'을 추가

    ```py
    ALLOWED_HOSTS = ['web']
    ```

7.  도커를 실행하고, 브라우저에서 도메인명을 입력하여 정상 작동하는지 확인

    - docker-compose 설치

    ```sh
    sudo pip install docker-compose
    ```

    ```sh
    docker-compose up --build
    ```

    shell을 꺼도 작동을 하도록 백그라운드 실행을 원한다면 -d 옵션을 추가하면 된다.

    ```sh
     docker-compose up --build -d
    ```
