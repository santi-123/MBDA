DELETE FROM GANADEROS
WHERE ID = '1';

INSERT INTO ANIMALES (proveniencia, color, peso, sexo, parto)
VALUES ('P', 'ROJO', 55, 'H', NULL);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 480, 'C', 'H', NULL, 48);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 580, 'C', 'H', 1202312151, 48);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 580, 'C', 'H', 1202312152, -1);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 580, NULL, 'M', 1202312152, 45);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 580, 'L', 'M', 1202312152, 45);

INSERT INTO ANIMALES (proveniencia, color, peso, grupo, sexo, compra, edad)
VALUES ('C', 'BLANCO', 580, NULL, 'H', 1202312152, 45);

UPDATE ANIMALES
SET grupo = 'L'
WHERE id = '1-23'
AND propietario = 1;

UPDATE ANIMALES
SET id = '100-30'
WHERE id = '3-23'
  AND propietario = 1;

UPDATE ANIMALES
SET GRUPO = 'H'
WHERE id = '18-23'
  AND propietario = 3;

UPDATE ANIMALES
SET COLOR = 'AZUL'
WHERE id = '10-23'
  AND propietario = 3;