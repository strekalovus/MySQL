CREATE DATABASE test;
  
USE test;
  
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(11) UNIQUE NOT NULL,
	created_at VARCHAR(256),
	updated_at VARCHAR(256)
);

INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'rberge@example.com', '(976)527-02', '2001-12-10 10:02:49', '2001-11-04 15:02:56');
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'dtowne@example.org', '(729)915-40', NULL, NULL);
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'andres.gutmann@example.net', '360.943.385', '1999-02-16 23:53:22', '2011-03-24 05:35:55');
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'juston09@example.com', '1-394-698-4', '2017-01-30 01:17:10', '1997-04-13 17:42:20');
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'bashirian.rashad@example.net', '491.967.779', NULL, NULL);
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'sebastian.corwin@example.org', '219-769-209', '2008-06-19 10:09:15', '2002-07-01 02:42:01');
INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'crooks.clementina@example.org', '1-680-628-8', NULL, NULL);

SELECT * FROM users;

-- решение (заполнение пустых полей)
UPDATE users SET created_at = NOW() WHERE created_at IS NULL AND id > 0;
UPDATE users SET updated_at = NOW() WHERE updated_at IS NULL AND id > 0;

SELECT * FROM users;