/*Vistas*/

--Consulta general de la vista
SELECT * FROM VInformacion_Animales_Propios;
--Informacion de los animales del ganadero con id '1'
SELECT * FROM VInformacion_Animales_Propios
WHERE propietario = 1;
--Informacion de los animales pertenecientes a lecheria 'L'
SELECT * FROM VInformacion_Animales_Propios
WHERE grupo = 'L';
--Informacion de animales con un estado activo 'A'
SELECT * FROM VInformacion_Animales_Propios
WHERE estado = 'A';
--Informacion de partos de animales con estado 'A'
SELECT * FROM VAnimal_Parto
WHERE estado = 'A';
--Informacion de los partos del ultimo mes
SELECT * FROM VAnimal_Parto
WHERE estado = 'A' AND ABS(nacimiento - SYSDATE) < 3;

/*Indices*/

--Consulta de los medicamentos que se usaron en el historial clinico  '202312157-231'
SELECT U.medicamento, M.nombre, U.cantidad, U.empleado 
FROM USAMEDICAMENTOS U LEFT JOIN MEDICAMENTOS M ON  U.medicamento = M.id 
WHERE historialclinico = '202312157-231';
--Consulta de los historiales clinicos donde se uso el medicamento 1.
SELECT historialClinico, cantidad, empleado
FROM USAMEDICAMENTOS
WHERE medicamento = 1;
--Consultar las fertilidades de la hembra '10-23' del ganadero 1.
SELECT id, fecha, diagnostico, dias, veterinario
FROM FERTILIDADES
WHERE hembraActiva = '10-23' AND propietarioHembraActiva = 1;
