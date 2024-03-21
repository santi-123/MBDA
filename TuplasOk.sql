-- Validacion CK_id_Sexo_Fecha_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
VALUES ('0101-21', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'I', 'C', 'BLANCO', 500, NULL, 'M', 12021102201, NULL, 8, NULL);
-- Validacion CK_Diagnostico_Dias
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('202310220002-211', '0002-21', 1, 'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'P', 180);
-- CK_FechaDestete_Partos
INSERT INTO FERTILIDADESCONFIRMADAS (fertilidad, machoActivo, propietarioMachoActivo)
    VALUES ('202310220002-211', '0001-21', 1);
INSERT INTO PARTOS (id, hembraActiva, propietarioHembraActiva, fecha, observacion, fechaDestete, fertilidadConfirmada)
    VALUES ('202301060002-211', '0002-21', 1, TO_DATE('2023-01-06', 'YYYY-MM-DD'), NULL, TO_DATE('2023-10-06', 'YYYY-MM-DD'), '202310220002-211');

COMMIT;