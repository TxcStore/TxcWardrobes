CREATE TABLE IF NOT EXISTS `txc_wardrobes` (id VARCHAR(50) NOT NULL, job TINYINT(1) NOT NULL DEFAULT 0, outfits LONGTEXT DEFAULT '[]', PRIMARY KEY (id))