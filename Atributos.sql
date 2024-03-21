--Ganaderos
ALTER TABLE GANADEROS ADD CONSTRAINT CK_TClave_Ganaderos
    CHECK (REGEXP_LIKE(clave, '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$'));
-- Animales
ALTER TABLE ANIMALES ADD CONSTRAINT CK_THerraje_Animal
    CHECK (REGEXP_LIKE(id, '^\d{1,4}-\d{2}$'));
ALTER TABLE ANIMALES ADD CONSTRAINT CK_Estado_Animal
    CHECK (estado IN ('M', 'A', 'I'));
ALTER TABLE ANIMALES ADD CONSTRAINT CK_Proveniencia_Animal
    CHECK (proveniencia IN ('P', 'C'));  
ALTER TABLE ANIMALES ADD CONSTRAINT CK_Grupo_Animal
    CHECK (grupo IN ('L', 'H', 'C', 'CE', 'LE', 'NV'));
ALTER TABLE ANIMALES ADD CONSTRAINT CK_Sexo_Animal
    CHECK (sexo IN ('H', 'M'));
--Compras
ALTER TABLE COMPRAS ADD CONSTRAINT CK_IdCompra_Compras
    CHECK (idCompra LIKE(comprador || TO_CHAR(fecha, 'YYYYMMDD') || '%'));
--Ventas
ALTER TABLE VENTAS ADD CONSTRAINT CK_IdVentas_Ventas
    CHECK (idVenta LIKE(vendedor || TO_CHAR(fecha, 'YYYYMMDD') || '%'));
--HembrasActivas
ALTER TABLE HEMBRASACTIVAS ADD CONSTRAINT CK_Animal_HembrasActivas
    CHECK (MOD(TO_NUMBER(SUBSTR(animal, -4, 1)), 2) = 0);
--MachosActivos
ALTER TABLE MACHOSACTIVOS ADD CONSTRAINT CK_Animal_MachosActivos
    CHECK (MOD(TO_NUMBER(SUBSTR(animal, -4, 1)), 2) = 1);
--Muertes
ALTER TABLE MUERTES ADD CONSTRAINT CK_Id_Muertes
    CHECK (id = (TO_CHAR(fecha, 'YYYYMMDD') || animal || TO_CHAR(propietarioAnimal)));
--Profesionales
ALTER TABLE PROFESIONALES ADD CONSTRAINT CK_Id_Profesionales
    CHECK (id = UPPER(SUBSTR(profesion, 1, 2)) || TO_CHAR(NoTProfesional));
--Fertilidades
ALTER TABLE FERTILIDADES ADD CONSTRAINT CK_Id_Fertilidades
    CHECK (id = (TO_CHAR(fecha, 'YYYYMMDD') || hembraActiva || TO_CHAR(propietarioHembraActiva)));
ALTER TABLE FERTILIDADES ADD CONSTRAINT CK_Diagnostico_Fertilidades
    CHECK (diagnostico IN ('P', 'PP', 'VA', 'VN'));
ALTER TABLE FERTILIDADES ADD CONSTRAINT CK_Dias_Fertilidades
    CHECK ((dias > 30 AND dias <= 270 AND MOD(dias, 30) = 0) OR (dias = 45));
--Partos
ALTER TABLE PARTOS ADD CONSTRAINT CK_Id_Partos
    CHECK (id = (TO_CHAR(fecha, 'YYYYMMDD') || hembraActiva || TO_CHAR(propietarioHembraActiva)));
--Empleados
ALTER TABLE EMPLEADOS ADD CONSTRAINT CK_TipoDocumento_Empleados
    CHECK (tipoDocumento IN('CC', 'CE', 'PS'));
ALTER TABLE EMPLEADOS ADD CONSTRAINT CK_Id_Empleados
    CHECK (id = tipoDocumento || UPPER(SUBSTR(cargo,1,1)) || TO_CHAR(noDocumento));
--HistorialesClinicos
ALTER TABLE HISTORIALESCLINICOS ADD CONSTRAINT CK_registro_HistorialesClinicos 
    CHECK (registro = (TO_CHAR(fecha, 'YYYYMMDD') || animal || TO_CHAR(propietarioAnimal)));
--Castraciones
ALTER TABLE CASTRACIONES ADD CONSTRAINT CK_id_Castraciones
    CHECK (id = (TO_CHAR(fecha, 'YYYYMMDD') || animal || TO_CHAR(propietarioAnimal)));
