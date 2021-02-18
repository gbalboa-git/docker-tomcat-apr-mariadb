/*
For Database User (required in server.xml)
docker run -it --rm gbalboa72/tomcat-apr-mariadb-arm64:latest bin/encrypt.sh 'webap\$\@91\#0.\$2\#8'
webap$@91#0.$2#8:b45b2a92ce4cd1e027dc3f511064235fb390518a1d892b490ce7352ddd25b73a0e1a10c6e6c467e0e696d91bd47d34bc107e26f68205d3f6503c1b3ee625055b


For Tomcat users
docker run -it --rm \
      gbalboa72/tomcat-apr-mariadb-arm64:latest \
      bin/digest.sh -a "PBKDF2WithHmacSHA512" -h "org.apache.catalina.realm.SecretKeyCredentialHandler" 'admin\#904'

admin#904:50faf2e59ba7e704cc02c084685ac605292569b0fdd080ce38f0dd359fcefe6d$20000$a0db78b4c2ef216e8ede53d5740ca932a04e4193

docker run -it --rm \
      gbalboa72/tomcat-apr-mariadb-arm64:latest \
      bin/digest.sh -a "PBKDF2WithHmacSHA512" -h "org.apache.catalina.realm.SecretKeyCredentialHandler" 'deployer\#904'
deployer#904:ef7a67770bdac3166d28d189cadc0d3cc343bb6cca72cf1be6f8893d5f02d231$20000$aa3e0d1b8e832de984f80d0bce30022165094b52

*/
CREATE USER webappusr IDENTIFIED BY 'webap$@91#0.$2#8';
GRANT ALL PRIVILEGES ON testdb.* TO webappusr;
FLUSH PRIVILEGES;

CREATE TABLE Roles (RoleId CHAR(20) NOT NULL,RoleDesc VARCHAR(200) NOT NULL,PRIMARY KEY (RoleId));
CREATE TABLE Users (LoginName VARCHAR(25) NOT NULL,PwdHash CHAR(200) NOT NULL, PRIMARY KEY (LoginName));
CREATE TABLE UserRoles (LoginName VARCHAR(25) NOT NULL,RoleId CHAR(20) NOT NULL, PRIMARY KEY (LoginName, RoleId));

ALTER TABLE UserRoles ADD CONSTRAINT roles_userroles_fk
FOREIGN KEY (RoleId)
REFERENCES Roles (RoleId)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE UserRoles ADD CONSTRAINT users_userroles_fk
FOREIGN KEY (LoginName)
REFERENCES Users (LoginName)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

insert into Roles (RoleId, RoleDesc) values ("admin-gui", "Gui Administrator");
insert into Roles (RoleId, RoleDesc) values ("admin-script", "Script Administrator");
insert into Roles (RoleId, RoleDesc) values ("manager-gui", "Administrator of Manager App");
insert into Roles (RoleId, RoleDesc) values ("manager-script", "User with grant to script in Manager app");
insert into Roles (RoleId, RoleDesc) values ("manager-status", "User with status grant for manager app");
insert into Roles (RoleId, RoleDesc) values ("manager-jmx", "Verify");

insert into Users (LoginName, PwdHash) values ("admin", "50faf2e59ba7e704cc02c084685ac605292569b0fdd080ce38f0dd359fcefe6d$20000$a0db78b4c2ef216e8ede53d5740ca932a04e4193");
insert into Users (LoginName, PwdHash) values ("deployer","ef7a67770bdac3166d28d189cadc0d3cc343bb6cca72cf1be6f8893d5f02d231$20000$aa3e0d1b8e832de984f80d0bce30022165094b52");
 
insert into UserRoles (LoginName, RoleId)values	("admin","admin-gui");
insert into UserRoles (LoginName, RoleId)values	("admin","admin-script");
insert into UserRoles (LoginName, RoleId)values	("admin","manager-gui");
insert into UserRoles (LoginName, RoleId)values	("admin","manager-script");
insert into UserRoles (LoginName, RoleId)values	("admin","manager-status");
insert into UserRoles (LoginName, RoleId)values	("admin","manager-jmx");

insert into UserRoles (LoginName, RoleId)values	("deployer","manager-script");