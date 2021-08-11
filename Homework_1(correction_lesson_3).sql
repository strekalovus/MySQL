
USE vk;



DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT NOT NULL,
    community_id INT NOT NULL,
    visibility VARCHAR(100) NOT NULL,
	post_body TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_posts_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

ALTER TABLE posts DROP CONSTRAINT fk_posts_user_id;
ALTER TABLE posts DROP CONSTRAINT fk_posts_community_id;

DROP TABLE IF EXISTS visibility;
CREATE TABLE visibility (
    `value` VARCHAR(100) NOT NULL PRIMARY KEY
);
ALTER TABLE posts ADD CONSTRAINT fk_posts_visibility FOREIGN KEY (visibility) REFERENCES visibility(`value`);

ALTER TABLE posts DROP CONSTRAINT fk_posts_visibility;


DROP TABLE IF EXISTS media_files;
CREATE TABLE media_files (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT NOT NULL,
    media_type VARCHAR(100) NOT NULL,
	link VARCHAR(1000) NOT NULL,
    file_size INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE media_files ADD CONSTRAINT fk_mf_user_id FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE media_files DROP CONSTRAINT fk_mf_user_id;

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
    `name` VARCHAR(100) NOT NULL PRIMARY KEY
);
ALTER TABLE media_files ADD CONSTRAINT fk_media_type FOREIGN KEY (media_type) REFERENCES media_types(`name`);

ALTER TABLE media_files DROP CONSTRAINT fk_media_type;


DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    from_user_id INT NOT NULL,
    entity_id INT NOT NULL,
    entity_name VARCHAR(128) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE likes ADD CONSTRAINT fk_likes_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);

ALTER TABLE likes DROP CONSTRAINT fk_likes_user_id;

DROP TABLE IF EXISTS entity_types;
CREATE TABLE entity_types (
    `name` VARCHAR(128) NOT NULL PRIMARY KEY
);
ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_name FOREIGN KEY (entity_name) REFERENCES entity_types(`name`);

ALTER TABLE likes DROP CONSTRAINT fk_likes_entity_name;


DROP TABLE IF EXISTS posts_media_files;
CREATE TABLE posts_media_files (
	post_id INT NOT NULL,
	media_file_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, media_file_id)
);
ALTER TABLE posts_media_files ADD CONSTRAINT fk_pm_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_media_files ADD CONSTRAINT fk_pm_media_file_id FOREIGN KEY (media_file_id) REFERENCES media_files(id);

ALTER TABLE posts_media_files DROP CONSTRAINT fk_pm_post_id;
ALTER TABLE posts_media_files DROP CONSTRAINT fk_pm_media_file_id;


DROP TABLE IF EXISTS messages_media_files;
CREATE TABLE messages_media_files (
	message_id INT NOT NULL,
	media_file_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (message_id, media_file_id)
);
ALTER TABLE messages_media_files ADD CONSTRAINT fk_mm_message_id FOREIGN KEY (message_id) REFERENCES messages(id);
ALTER TABLE messages_media_files ADD CONSTRAINT fk_mm_media_file_id FOREIGN KEY (media_file_id) REFERENCES media_files(id);

ALTER TABLE messages_media_files DROP CONSTRAINT fk_mm_message_id;
ALTER TABLE messages_media_files DROP CONSTRAINT fk_mm_media_file_id;
