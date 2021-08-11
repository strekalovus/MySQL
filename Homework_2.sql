/*
Список сущностей

1. профиль
2. пост
3. друзья
4. сообщества
5. сообщения
6. медиа
*/



USE vk;


DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT NOT NULL,
	post_body TEXT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE posts DROP CONSTRAINT fk_posts_user_id;


DROP TABLE IF EXISTS media_files;
CREATE TABLE media_files (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT NOT NULL,
    file_size INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE media_files ADD CONSTRAINT fk_mf_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE media_files DROP CONSTRAINT fk_mf_user_id;


DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    from_user_id INT NOT NULL,
    to_user_id INT,
    to_post_id INT,
    to_file_id INT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE likes ADD CONSTRAINT fk_likes_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);

ALTER TABLE likes DROP CONSTRAINT fk_likes_user_id;


