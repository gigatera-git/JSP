CREATE TABLE `tbl_board_upload` (
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `bidx` int(11) NOT NULL,
  `fileRealName` varchar(100) DEFAULT NULL,
  `fileSaveName` varchar(100) DEFAULT NULL,
  `fileType` varchar(40) DEFAULT NULL,
  `fileSize` varchar(10) DEFAULT NULL,
  `reg_ip` varchar(20) DEFAULT NULL,
  `mod_ip` varchar(20) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL,
  `mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8