SELECT COUNT(*) AS CANTIDAD 
FROM MUERTES
WHERE detalle LIKE '%natural%';

SELECT COUNT(*), propietario 
FROM ANIMALES
WHERE estado = 'A'
GROUP BY(propietario);

SELECT H.anImal, COUNT(P.id) AS CANTIDAD_PARTOS
FROM HEMBRASACTIVAS H
JOIN PARTOS P ON H.animal = P.hembraActiva
GROUP BY H.anImal;

SELECT hembraActiva, fecha, id
FROM PARTOS
WHERE fecha >= ADD_MONTHS(TRUNC(SYSDATE), -9);

SELECT G.id, COUNT(A.propietario)
FROM GANADEROS G JOIN ANIMALES A ON G.id = A.propietario
GROUP BY G.id;

SELECT unidades, nombre, id
FROM MEDICAMENTOS
WHERE unidades < 10;

SELECT cargo, COUNT(cargo) AS CANTIDAD
FROM EMPLEADOS
GROUP BY cargo;

SELECT H.profesional AS id_veterinario, P.nombre AS nombre_veterinario
FROM HISTORIALESCLINICOS H
JOIN PROFESIONALES P ON H.profesional = P.id
GROUP BY H.profesional, P.nombre;

SELECT C.*
FROM COMPRAS C
WHERE C.fecha = (SELECT MAX(fecha) FROM COMPRAS);

SELECT V.*
FROM VENTAS V
WHERE V.idVenta IN (SELECT venta FROM animales WHERE estado = 'I');
