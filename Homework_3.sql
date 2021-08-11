USE test;
  
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `value` INT NOT NULL,
   	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TRUNCATE TABLE  storehouses_products;

INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (1, 0, '2001-12-10 10:02:49', '2001-11-04 15:02:56');
INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (2, 2500, '1999-02-16 23:53:22', '2011-03-24 05:35:55');
INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (3, 0, '1999-02-16 23:53:22', '2011-03-24 05:35:55');
INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (4, 30, '2017-01-30 01:17:10', '1997-04-13 17:42:20');
INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (5, 500, '1999-02-16 23:53:22', '2011-03-24 05:35:55');
INSERT INTO `storehouses_products` (`id`, `value`, `created_at`, `updated_at`) VALUES (6, 1, '1999-02-16 23:53:22', '2011-03-24 05:35:55');

SELECT * FROM storehouses_products;

-- решение (сортируем записи таким образом, чтобы они выводились в порядке увеличения значения value. Нулевые запасы выводим в конце, после всех записей)
SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;
