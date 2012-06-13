/* Create the hackrLog database, user and assign a password to the user. */
create database hackrlog;

create user 'hackrlog'@'localhost' identified by 'h4ckrl0g43v3r';

grant select, insert, update, delete, create, drop, index, lock tables on hackrlog.* to 'hackrlog'@'localhost';