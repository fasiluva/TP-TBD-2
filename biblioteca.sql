/*
Valentin Sosa, S-5621/9.
Santiago Bussanich, B-6488/2.
Ángelo Alvarez, A-4429/6.
*/

CREATE DATABASE IF NOT EXISTS biblioteca_db;

USE biblioteca_db;

DROP TABLE IF EXISTS Escribe;
DROP TABLE IF EXISTS Autor;
DROP TABLE IF EXISTS Libro;

CREATE TABLE Autor (
	id INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(30) NOT NULL,
	apellido VARCHAR(30) NOT NULL,
	nacionalidad VARCHAR(30) NOT NULL,
	residencia VARCHAR(30) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Libro (
	isbn INT NOT NULL,
	titulo VARCHAR(40) NOT NULL,
	editorial VARCHAR(30) NOT NULL,
	precio FLOAT NOT NULL,
	PRIMARY KEY (isbn)
);

CREATE TABLE Escribe (
	id INT NOT NULL,
	isbn INT NOT NULL,
	anio INT NOT NULL,
	PRIMARY KEY (id, isbn),
	FOREIGN KEY (id) REFERENCES Autor(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (isbn) REFERENCES Libro(isbn) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX titulo_idx ON Libro(titulo);
CREATE INDEX apellido_idx ON Autor(apellido);

INSERT INTO Autor (nombre, apellido, nacionalidad, residencia)
VALUES ("Jorge Luis","Borges","Argentina","Pellegrini 270"),
        ("Julio","Cortazar","Argentina","Moreno 1650"),
        ("Gabriel Jose García","Márquez","Colombia","Bolívar 1204"),
        ("Abelardo","Castillo","Argentina","Belgrano 200");

INSERT INTO Libro
VALUES  (1001, 'El Aleph', 'Emecé', 15000),
        (1002, 'Cien años de soledad', 'Sudamericana', 18000),
        (1003, 'Rayuela', 'Alfaguara', 16000),
        (1004, 'Bases de datos', 'UNR', 20000);

INSERT INTO Escribe
VALUES  (1, 1001, 1945),
        (2,1002,1963),
        (3,1003,1982);

/*Ejercicio 4a)*/
UPDATE Autor SET residencia = "Buenos Aires" WHERE nombre = "Abelardo" AND apellido = "Castillo";

/*Ejercicio 4b)*/
UPDATE Libro SET precio = precio * 1.1 WHERE editorial = "UNR";


/*Ejercicio 4c)*/
UPDATE Libro SET precio = CASE
	WHEN precio <= 200 THEN precio*1.2 ELSE precio*1.1
END
WHERE Libro.isbn IN (SELECT DISTINCT Escribe.isbn FROM Escribe WHERE Escribe.id IN (SELECT Autor.id FROM Autor WHERE nacionalidad = "Argentina"));


/*Ejercicio 4d)*/
DELETE FROM Libro 
WHERE Libro.isbn IN (SELECT isbn FROM Escribe WHERE anio = "1998");
