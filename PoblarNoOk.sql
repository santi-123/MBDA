-- Inserción errónea que incumple la restricción CK_THerraje_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0014318', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'I', 'C', 'BLANCO', 500, NULL, 'M', 12021102201, 12023100901, 8, NULL);
-- Inserción errónea que incumple la restricción CK_Estado_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0003-18', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'H', 'C', 'ROJO', 550, 'L', 'M', 12021102201, NULL, 8, NULL);
-- Inserción errónea que incumple la restricción CK_Proveniencia_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0015-18', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'I', 'O', 'BLANCO', 500, NULL, 'M', 12021102201, 12023100901, 8, NULL);
-- Inserción errónea que incumple la restricción CK_Grupo_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0015-18', 1, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 'I', 'C', 'BLANCO', 500, 'S', 'M', 12021102201, 12023100901, 8, NULL);
-- Inserción errónea que incumple la restricción CK_Sexo_Animal
INSERT INTO ANIMALES (id, propietario, nacimiento, estado, proveniencia, color, peso, grupo, sexo, compra, venta, edad, parto)
    VALUES ('0002-18', 1, TO_DATE('2021-03-11', 'YYYY-MM-DD'), 'A', 'C', 'BLANCO', 480, 'C', 'A', 12021031101, NULL, 8, NULL);
-- Inserción errónea que incumple la restricción CK_IdCompra_Compras
INSERT INTO COMPRAS (idCompra, fecha, comprador, vendedor, cantidadAnimales, valorTotal, valorPromedio, valorKilo, pesoCompra)
    VALUES(1234567890, TO_DATE('2021-10-22', 'YYYY-MM-DD'), 1, 'Juan Mesa', 3, 13000000, 4333333, 9629, 1350);
-- Inserción errónea que incumple la restricción CK_IdVentas_Ventas
INSERT INTO VENTAS (idVenta, fecha, comprador, vendedor, cantidadAnimales, valorTotal, valorPromedio, valorKilo, pesoVenta)
    VALUES(1234567890, TO_DATE('2023-10-09', 'YYYY-MM-DD'), 'Alfredo Herrera', 1, 1, 6000000, 6000000, 8510, 705);
-- Inserción errónea que incumple la restricción CK_Animal_HembrasActivas    
INSERT INTO HEMBRASACTIVAS (animal, propietarioAnimal)
    VALUES ('0921-18', 1);
-- Inserción errónea que incumple la restricción CK_Animal_MachosActivos
INSERT INTO MACHOSACTIVOS (animal, propietarioAnimal)
    VALUES ('0002-18', 2);
-- Inserción errónea que incumple la restricción CK_Id_Muertes
INSERT INTO MUERTES (id, animal, propietarioAnimal, fecha, detalle)
    VALUES ('20231028-232', '0048-23', 2, TO_DATE(20231028, 'YYYYMMDD'), 'Muerte natural');
-- Inserción errónea que incumple la restricción CK_Id_Profesionales
INSERT INTO PROFESIONALES (id, noTProfesional, nombre, profesion)
    VALUES ('ME12577', 12577, 'Yasmin Rojas Delgado', 'Veterinario');
-- Inserción errónea que incumple la restricción CK_Id_Fertilidades
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('20231022', '0002-18', 2,'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'PP', NULL);
-- Inserción errónea que incumple la restricción CK_Diagnostico_Fertilidades
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('202310220002-182', '0002-18', 2, 'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'AA', NULL);
-- Inserción errónea que incumple la restricción CK_Dias_Fertilidades
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('202310220002-182', '0002-18', 2,'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'P', 25);
-- Inserción errónea que incumple la restricción CK_Id_Partos
INSERT INTO PARTOS (id, hembraActiva, propietarioHembraActiva, fecha, observacion, fechaDestete, fertilidadConfirmada)
    VALUES ('202301060002-18', '0002-18', 1, TO_DATE('2023-01-06', 'YYYY-MM-DD'), NULL, TO_DATE('2023-10-06', 'YYYY-MM-DD'), '202310220002-181');
-- Inserción errónea que incumple la restricción CK_registro_HistorialesClinicos
INSERT INTO  HISTORIALESCLINICOS (registro, animal, propietarioAnimal, profesional, detalle, fecha)
    VALUES('202308010001-18', '0001-18', 1, 'VE12577','laceracion en la pierna, aplicacion antibiotico por 5 dias, analgesico y anti-inflamatorio por 3 dias.', TO_DATE('2023-08-01', 'YYYY-MM-DD'));
-- Inserción errónea que incumple la restricción CK_Diagnostico_Dias
INSERT INTO FERTILIDADES (id, hembraActiva, propietarioHembraActiva, veterinario, fecha, diagnostico, dias)
    VALUES ('202310220002-182', '0002-18', 2, 'VE12577', TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'P', 25);