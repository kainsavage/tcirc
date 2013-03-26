/* Inserts some testing user accounts.  Delete these in a production environment. */

INSERT INTO TCUser (UserUsername, UserFirstname, UserLastname, UserInitials, UserEmail, UserPassword, Enabled) VALUES ('user', 'first', 'last', 'fl', 'none-user@techempower.com', 'test', 1);
INSERT INTO TCUser (UserUsername, UserFirstname, UserLastname, UserInitials, UserEmail, UserPassword, Enabled) VALUES ('admin', 'first', 'last', 'fl', 'none-admin@techempower.com', 'test', 1);

INSERT INTO TCMapUserToGroup (UserID, GroupID) VALUES (1, 1);
INSERT INTO TCMapUserToGroup (UserID, GroupID) VALUES (2, 1);
INSERT INTO TCMapUserToGroup (UserID, GroupID) VALUES (2, 1000);
