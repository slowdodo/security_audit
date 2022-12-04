-- Check for empty passwords
SELECT user, host FROM mysql.user WHERE password = '';

-- Check for users with global CREATE privilege
SELECT user, host FROM mysql.user WHERE Create_priv = 'Y';

-- Check for users with global DROP privilege
SELECT user, host FROM mysql.user WHERE Drop_priv = 'Y';

-- Check for users with global DELETE privilege
SELECT user, host FROM mysql.user WHERE Delete_priv = 'Y';

-- Check for users with global INSERT privilege
SELECT user, host FROM mysql.user WHERE Insert_priv = 'Y';

-- Check for users with global UPDATE privilege
SELECT user, host FROM mysql.user WHERE Update_priv = 'Y';

-- Check for users with global SELECT privilege
SELECT user, host FROM mysql.user WHERE Select_priv = 'Y';
