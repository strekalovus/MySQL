/*
Список сущностей

1. профиль
2. пост
3. друзья
4. сообщества
5. сообщения
6. медиа
*/

CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(11) UNIQUE NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    b_date DATE,
	user_id INT UNIQUE NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    profile_status ENUM('ONLINE', 'OFFLINE', 'INACTIVE'),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE profiles DROP CONSTRAINT fk_profiles_user_id;


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	from_user_id INT NOT NULL,
	to_user_id INT NOT NULL,
	message_header VARCHAR(255),
	message_body TEXT NOT NULL,
	sent_flag TINYINT NOT NULL,
	recieved_flag TINYINT NOT NULL,
	edited_flag TINYINT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -- ,FOREIGN KEY (from_user_id) REFERENCES users(id),
    -- FOREIGN KEY (to_user_id) REFERENCES users(id)
);
ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);

ALTER TABLE messages DROP CONSTRAINT fk_messages_from_user_id;
ALTER TABLE messages DROP CONSTRAINT fk_messages_to_user_id;


DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED'),
    requested_at DATETIME NOT NULL,
    accepted_at DATETIME,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

ALTER TABLE friendship DROP CONSTRAINT fk_friendship_user_id;
ALTER TABLE friendship DROP CONSTRAINT fk_friendship_friend_id;


DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
	community_id INT NOT NULL,
	user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (community_id, user_id)
);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

ALTER TABLE communities_users DROP CONSTRAINT fk_cu_user_id;
ALTER TABLE communities_users DROP CONSTRAINT fk_cu_community_id;



