CREATE TABLE IF NOT EXISTS users (
  id int(6) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL,
  email varchar(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO users (first_name, last_name, email) VALUES('Carlos', 'Ayala', 'ceal1818@gmail.com');
INSERT INTO users (first_name, last_name, email) VALUES('Beatriz', 'Leandro', 'beatriz.leandro15@gmail.com');
INSERT INTO users (first_name, last_name, email) VALUES('Juan', 'Perez', 'juan.perez@gmail.com');
