CREATE TABLE ANIMALES(
    ID VARCHAR2(7) NOT NULL,
    PROPIETARIO NUMBER(3) NOT NULL,
    NACIMIENTO DATE NOT NULL,
    ESTADO CHAR(1) NOT NULL,
    PROVENIENCIA CHAR(1) NOT NULL,
    COLOR VARCHAR2(20) NOT NULL,
    PESO NUMBER(4) NOT NULL,
    GRUPO VARCHAR2(2),
    SEXO CHAR(1) NOT NULL,
    COMPRA NUMBER(30),
    VENTA NUMBER(30),
    EDAD NUMBER(3) NOT NULL,
    PARTO VARCHAR2(30)
);

CREATE TABLE GANADEROS(
    ID NUMBER(3) NOT NULL,
    NOMBRE VARCHAR2(50)NOT NULL,
    CLAVE VARCHAR2(15) NOT NULL,
    CELULAR NUMBER(10) NOT NULL
);

CREATE TABLE PADRES(
    ANIMAL1 VARCHAR2(7) NOT NULL,
    PROPIETARIO1 NUMBER(3) NOT NULL,
    ANIMAL2 VARCHAR2(7) NOT NULL,
    PROPIETARIO2 NUMBER(3) NOT NULL
);

CREATE TABLE COMPRAS(
    IDCOMPRA NUMBER(30) NOT NULL,
    COMPRADOR NUMBER(3) NOT NULL,
    FECHA DATE NOT NULL,
    VENDEDOR VARCHAR2(50) NOT NULL,
    CANTIDADANIMALES NUMBER(3) NOT NULL,
    VALORTOTAL NUMBER(9) NOT NULL,
    VALORPROMEDIO NUMBER NOT NULL,
    VALORKILO NUMBER NOT NULL,
    PESOCOMPRA NUMBER(6)NOT NULL
);

CREATE TABLE VENTAS(
    IDVENTA NUMBER(30) NOT NULL,
    VENDEDOR NUMBER(3) NOT NULL,
    FECHA DATE NOT NULL,
    COMPRADOR VARCHAR2(50) NOT NULL,
    CANTIDADANIMALES NUMBER(9),
    VALORTOTAL NUMBER(9),
    VALORPROMEDIO NUMBER,
    VALORKILO NUMBER,
    PESOVENTA NUMBER(6)
);

CREATE TABLE HEMBRASACTIVAS(
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER(3) NOT NULL
);

CREATE TABLE MACHOSACTIVOS(
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER(3) NOT NULL
);

CREATE TABLE MUERTES(
    ID VARCHAR2(30) NOT NULL,
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER,
    FECHA DATE NOT NULL,
    DETALLE CHAR(100) NOT NULL
);

CREATE TABLE CASTRACIONES(
    ID VARCHAR2(30) NOT NULL,
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER NOT NULL,
    FECHA DATE NOT NULL
);

CREATE TABLE HERRAJESESPECIALES(
    HERRAJE VARCHAR2(10) NOT NULL,
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER(3) NOT NULL
);

CREATE TABLE PARTOS(
    ID VARCHAR2(30) NOT NULL,
    FERTILIDADCONFIRMADA VARCHAR2(30),
    HEMBRAACTIVA VARCHAR2(7) NOT NULL,
    PROPIETARIOHEMBRAACTIVA NUMBER(3) NOT NULL,
    FECHA DATE NOT NULL,
    OBSERVACION VARCHAR2(100),
    FECHADESTETE DATE NOT NULL
);

CREATE TABLE FERTILIDADES(
    ID VARCHAR2(30) NOT NULL,
    HEMBRAACTIVA VARCHAR2(7) NOT NULL,
    PROPIETARIOHEMBRAACTIVA NUMBER(3) NOT NULL,
    VETERINARIO VARCHAR2(30),
    FECHA DATE NOT NULL,
    DIAGNOSTICO VARCHAR2(2)NOT NULL,
    DIAS NUMBER(3)
);

CREATE TABLE FERTILIDADESCONFIRMADAS(
    FERTILIDAD VARCHAR2(30) NOT NULL,
    MACHOACTIVO VARCHAR2(7),
    PROPIETARIOMACHOACTIVO NUMBER(3)
);

CREATE TABLE PROFESIONALES(
    ID VARCHAR2(30) NOT NULL,
    NOTPROFESIONAL NUMBER NOT NULL,
    NOMBRE VARCHAR2(50) NOT NULL,
    PROFESION VARCHAR2(50) NOT NULL
);

CREATE TABLE EMPLEADOS(
    ID VARCHAR2(30) NOT NULL,
    NODOCUMENTO NUMBER NOT NULL,
    TIPODOCUMENTO VARCHAR2(2) NOT NULL,
    NOMBRE VARCHAR2(50) NOT NULL,
    CARGO CHAR(50) NOT NULL
);

CREATE TABLE HISTORIALESCLINICOS(
    REGISTRO VARCHAR2(30) NOT NULL,
    ANIMAL VARCHAR2(7) NOT NULL,
    PROPIETARIOANIMAL NUMBER(3),
    PROFESIONAL VARCHAR2(30),
    DETALLE VARCHAR2(150) NOT NULL,
    FECHA DATE NOT NULL
);

CREATE TABLE USAMEDICAMENTOS(
    MEDICAMENTO NUMBER NOT NULL,
    HISTORIALCLINICO VARCHAR2(30) NOT NULL,
    CANTIDAD NUMBER(2) NOT NULL,
    EMPLEADO VARCHAR2(30)
);

CREATE TABLE MEDICAMENTOS(
    ID NUMBER NOT NULL,
    UNIDADES NUMBER(3) NOT NULL,
    NOMBRE VARCHAR2(50) NOT NULL
);