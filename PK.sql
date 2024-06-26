/*PK*/

ALTER TABLE GANADEROS ADD CONSTRAINT PK_Ganaderos
    PRIMARY KEY (id);
ALTER TABLE ANIMALES ADD CONSTRAINT PK_Animales
    PRIMARY KEY (id, propietario);
ALTER TABLE PADRES ADD CONSTRAINT PK_Padres
    PRIMARY KEY (animal1,propietario1,animal2,propietario2);
ALTER TABLE COMPRAS ADD CONSTRAINT PK_Compras
    PRIMARY KEY (idCompra);
ALTER TABLE VENTAS ADD CONSTRAINT PK_Ventas
    PRIMARY KEY (idVenta);
ALTER TABLE HEMBRASACTIVAS ADD CONSTRAINT PK_HembrasActivas
    PRIMARY KEY (animal, propietarioAnimal);
ALTER TABLE MACHOSACTIVOS ADD CONSTRAINT PK_MachosActivos
    PRIMARY KEY (animal, propietarioAnimal);
ALTER TABLE MUERTES ADD CONSTRAINT PK_Muertes
    PRIMARY KEY (id);
ALTER TABLE FERTILIDADES ADD CONSTRAINT PK_Fertilidades
    PRIMARY KEY (id);
ALTER TABLE PARTOS ADD CONSTRAINT PK_Partos
    PRIMARY KEY (id);
ALTER TABLE PROFESIONALES ADD CONSTRAINT PK_Profesionales
    PRIMARY KEY (id);
ALTER TABLE EMPLEADOS ADD CONSTRAINT PK_Epleados
    PRIMARY KEY (id);
ALTER TABLE HISTORIALESCLINICOS ADD CONSTRAINT PK_HistorialesClinicos
    PRIMARY KEY (registro);
ALTER TABLE USAMEDICAMENTOS ADD CONSTRAINT PK_UsaMedicamentos
    PRIMARY KEY (medicamento, historialClinico);
ALTER TABLE MEDICAMENTOS ADD CONSTRAINT PK_Medicamentos
    PRIMARY KEY (id);
ALTER TABLE CASTRACIONES ADD CONSTRAINT PK_Castraciones
    PRIMARY KEY (id);
ALTER TABLE HERRAJESESPECIALES ADD CONSTRAINT PK_HerrajesEspeciales
    PRIMARY KEY (animal, propietarioAnimal);
ALTER TABLE FERTILIDADESCONFIRMADAS ADD CONSTRAINT PK_FertilidadesConfirmadas
    PRIMARY KEY (fertilidad);

