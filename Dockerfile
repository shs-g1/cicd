# 기본 이미지 설정: PHP와 Apache 웹 서버를 포함하는 이미지
FROM php:7.4-apache

# 작업 디렉토리 설정 (Apache의 DocumentRoot와 일치해야 함)
WORKDIR /var/www/html

# 필요한 PHP 확장 모듈 설치 (예: mysqli)
RUN docker-php-ext-install mysqli

# HTML 폴더 내의 파일들을 이미지 내의 작업 디렉토리로 복사
COPY ./html/ .

# Apache 서버 재시작
RUN service apache2 restart

# 컨테이너가 80 포트에서 실행되도록 설정 (웹 애플리케이션을 노출)
EXPOSE 80

# MySQL 및 stress 패키지 설치 (적절한 명령어를 사용)
RUN apt-get update && apt-get install -y default-mysql-client stress

# 컨테이너 시작 시 실행할 명령 설정 (Apache 웹 서버 시작)
CMD ["apache2-foreground"]
