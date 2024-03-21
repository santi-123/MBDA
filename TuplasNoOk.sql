-- Ingreso del id de un macho primeras cuatro cifras numero par y numero significativo del año no considiente.
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0114-18', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'I', 'P', 'BLANCO', 500, NULL, 'M', NULL, 12023100901, 8, NULL);
-- Ingreso de fertilidad con diagnostico 'P' y sin dias.
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('202310220002-211', '0002-21', 1, 'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'P', NULL);
-- Fecha de destete mayor a los 9 meses de la fecha de parto.
INSERT INTO PARTOS (id, hembraActiva, propietarioHembraActiva, fecha, observacion, fechaDestete, fertilidadConfirmada)
    VALUES ('202301060002-211', '0002-21', 1, TO_DATE('2023-01-06', 'YYYY-MM-DD'), NULL, TO_DATE('2023-10-07', 'YYYY-MM-DD'), '202310220002-211');
