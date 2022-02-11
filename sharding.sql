/** ================================================= */
CREATE DATABASE springboot;
CREATE TABLE `user_1` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE `user_2` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE DATABASE springboot1;
CREATE TABLE `user_1` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE `user_2` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE common(
	common_id BIGINT(20) PRIMARY KEY,
	remark VARCHAR(50) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/** ================================================= */
CREATE DATABASE springboot2;

CREATE TABLE `user_1` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE `user_2` (
  `id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `user_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE common(
	common_id BIGINT(20) PRIMARY KEY,
	remark VARCHAR(50) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/** ================================================= */
CREATE DATABASE detail;

CREATE TABLE user_detail(
	user_id BIGINT(20) PRIMARY KEY,
	age VARCHAR(50) NOT NULL,
	sex VARCHAR(2) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;