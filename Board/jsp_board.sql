CREATE TABLE `tbl_board` (
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `uname` varchar(10) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `pwd` varchar(100) CHARACTER SET latin1 NOT NULL,
  `contents` text,
  `click` smallint(6) NOT NULL DEFAULT '0',
  `ref` int(11) DEFAULT NULL,
  `re_step` smallint(6) DEFAULT NULL,
  `re_lvl` smallint(6) DEFAULT NULL,
  `deleted` char(1) CHARACTER SET latin1 DEFAULT NULL,
  `reg_ip` varchar(20) CHARACTER SET latin1 NOT NULL,
  `mod_ip` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `reg_date` datetime NOT NULL,
  `mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8