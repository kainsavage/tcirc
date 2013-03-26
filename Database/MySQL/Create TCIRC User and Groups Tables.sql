/*
 * Data definition script for TCIRC
 *
 * MySQL version
 *
 * This script provides the standard Gemini/Pyxis web application
 * tables for Users and User Groups.
 *
 * Please note that the selection of InnoDB for the table type
 * may not be appropriate for your application.  Consider using
 * MyISAM as needed.
 */

DROP TABLE IF EXISTS `TCGroup`;
CREATE TABLE `TCGroup` (
  `id` int(10) unsigned NOT NULL default '0',
  `Name` varchar(50) default NULL,
  `Description` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `TCMapUserToGroup`;
CREATE TABLE `TCMapUserToGroup` (
  `UserID` int(10) unsigned NOT NULL default '0',
  `GroupID` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`UserID`,`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `TCUser`;
CREATE TABLE  `TCUser` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `UserUsername` varchar(30) NOT NULL default '',
  `UserFirstname` varchar(25) default NULL,
  `UserLastname` varchar(25) default NULL,
  `UserInitials` char(3) default NULL,
  `UserEmail` varchar(50) default NULL,
  `UserPassword` varchar(255) NOT NULL default '',
  `EmailVerificationTicket` varchar(15) default NULL,
  `EmailVerificationDate` datetime default NULL,
  `LastNotificationRead` datetime default NULL,
  `Enabled` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
