/*
 * Data definition script for TCIRC
 *
 * Microsoft SQL Server version
 *
 * This script provides the standard Gemini/Pyxis web application
 * tables for Users and User Groups.
 */

CREATE TABLE TCUser (
	id            int     IDENTITY (1, 1) NOT NULL ,
	UserUsername  varchar (30) NOT NULL ,
	UserFirstname varchar (25) NULL ,
	UserLastname  varchar (25) NULL ,
	UserInitials  varchar (3)  NULL ,
	UserEmail     varchar (50) NULL ,
	UserPassword  varchar (255) NOT NULL,
	EmailVerificationTicket varchar (15) NULL ,
	EmailVerificationDate   datetime NULL,
	LastNotificationRead    datetime NULL,
	Enabled       bit NOT NULL
)
GO

CREATE TABLE TCGroup (
	id            int     NOT NULL ,
	Name          varchar (50) NULL ,
	Description   varchar (50) NULL
)
GO

CREATE TABLE TCMapUserToGroup (
	UserID        int     NOT NULL ,
	GroupID       int     NOT NULL
)

