USE sakila;

/*In this activity we are going to do some database maintenance. 
In the current database we only have information on movies for the year 2006. 
Now we have received the film catalog for 2020 as well. For this new data we 
will create another table and bulk insert all the data there. 
Code to create a new table has been provided below.*/

drop table if exists films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year DEFAULT NULL,
  `language_id` tinyint unsigned NOT NULL,
  `original_language_id` tinyint unsigned DEFAULT NULL,
  `rental_duration` int NULL,
  `rental_rate` decimal(4,2) NULL,
  `length` smallint unsigned NULL,
  `replacement_cost` decimal(5,2) NULL,
  `rating` VARCHAR(20),
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8mb4;


-- Check that your local_infile is ON:
SHOW VARIABLES LIKE 'local_infile';  
-- If not:
SET GLOBAL local_infile = true;

/* Recordar que al ejecutar LOAD DATA LOCA INFILE y especificar la ruta del archivo a importar puede 
haber problemas si un directorio tiene espacios, por ejemplo el directorio 'Daniel Castañeda' */
LOAD DATA LOCAL INFILE 'C:/Users/films_2020.csv'
INTO TABLE films_2020
CHARACTER SET utf8mb4        #Incluye acentos y ñ
FIELDS TERMINATED BY ','     #Para especificar el tipo de separador en un archivo csv
ENCLOSED BY '"'              /*Para indicar que los valores en el archivo están delimitados por un 
carácter específico. Si existe un campo que contenga en su nombre una coma, y el valor está entre 
comillas, se interpretará como un solo valor y no como dos campos separados por la coma*/ 
IGNORE 1 ROWS;

/*We have just one item for each film, and all will be placed in the new table. 
For 2020, the rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost 
of 8.99€ (these are all fixed values for all movies for this year).*/

/*Instructions
	- Add the new films to the database.
	- Update information on rental_duration, rental_rate, and replacement_cost.*/


/*Error Code: 1175. You are using safe update mode and you tried to update a table without a 
WHERE that uses a KEY column

Este error se debe a que el modo seguro de actualización está habilitado. El modo seguro de 
actualización evita que se realicen actualizaciones que puedan afectar a un gran número de filas 
en una tabla sin especificar una cláusula WHERE que utilice una columna de índice.

Para resolver este problema, hay que deshabilitar el modo seguro de actualización temporalmente 
ejecutando el siguiente comando:*/

SET SQL_SAFE_UPDATES = 0;
UPDATE films_2020
SET rental_duration = 3, rental_rate = 2.99, replacement_cost = 8.99;

SELECT * FROM films_2020;
SET SQL_SAFE_UPDATES = 1;