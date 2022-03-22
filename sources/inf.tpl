use mysql;
UPDATE user SET Password=PASSWORD('X_PASSWD_X') WHERE user='root';
FLUSH PRIVILEGES;
