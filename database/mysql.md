# Ubuntu에 mysql 초기 세팅

1. mysql 설치

   ```sh
   sudo apt-get install mysql-server
   ```

2. 로그인

   ```sh
   mysql -u root -p
   ```

   비밀번호 입력후 mysql shell 접속

3. 데이터 베이스 생성

   ```sh
   CREATE DATABASE [database이름] default CHARACTER SET UTF8;
   ```

   `show databases;` 로 데이터베이스가 생성되었음을 확인하고
   `use [database이름];`로 데이터베이스 변경

4) 데이터베이스 사용자 추가

   외부 접속을 허용하기 위해서는 localhost 부분에 '%'를 써야한다.

   ```sh
   GRANT ALL PRIVILEGES ON [database이름].* TO '[유저이름]'@localhost IDENTIFIED BY '[비밀번호]';
   ```

   ex> GRANT ALL PRIVILEGES ON newdb.\* TO 'newuser'@'%' IDENTIFIED BY 'passwd';

   grant 테이블을 reload하여 변경사항을 바로 적용

   ```sh
   FLUSH PRIVILEGES;
   ```

   `exit`로 shell 나가고

   새로운 사용자로 재로그인

   ```sh
   mysql -u [유저이름] -p
   ```

5. 외부 접속 허용

   localhost가 아닌 환경에서 외부 접속을 허용하기 위해서는 추가적인 설정을 해줘야 한다.

   ```sh
   sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
   ```

   bind-address부분을 수정

   ```
   # bind-address            = 127.0.0.1   # Before
   bind-address            = 0.0.0.0       # After
   ```

   mysql 재시작

   ```sh
   sudo service mysql restart
   ```

   변경된 bind-address로 연결되어 있는지 확인

   ```sh
   sudo netstat -ntlp | grep mysqld
   ```
