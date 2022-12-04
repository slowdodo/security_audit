-- 사용자 계정 목록을 가져옵니다.
SELECT user, host FROM mysql.user;

-- 사용자 계정의 접근 권한을 확인합니다.
SHOW GRANTS FOR 'user'@'host';

-- 사용자 계정에 암호가 설정되어 있는지 확인합니다.
SELECT user, host, password FROM mysql.user WHERE password = '';

-- 사용자 계정의 암호 정책을 확인합니다.
SHOW VARIABLES LIKE 'validate_password%';
