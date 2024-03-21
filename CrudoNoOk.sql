SET SERVEROUTPUT ON;

/*PA_COMPRAVENTA*/
--Adicionar una compra con un ganadero no existente.
BEGIN
    PA_COMPRAVENTA.ad_compra(70, 'DANIEL DIAZ', 1, 3000000, 450);
END;
/
--Actualizar una compra
BEGIN
    PA_COMPRAVENTA.up_compra(9202312092, 'Daniel Gonzales', 2, 5500000, 1000);
END;
/
--Consultar los animales asociados a una compra
SELECT PA_COMPRAVENTA.coanimalesasociadoscompra(3202312059) FROM DUAL;
--Consultar una compra
SELECT PA_COMPRAVENTA.coCompra(3202312099) FROM DUAL;
--Agregar una Venta
BEGIN
    PA_COMPRAVENTA.ad_venta(80, 'FERNANDO SANCHEZ', 1, 3500000, 600);
END;
/
--Actualizar una venta
BEGIN
    PA_COMPRAVENTA.up_venta(1202312099, 'FERNANDO SANCHEZ', 1, 3650000, 600);
END;
/
--Conusltar los animales asociados a una venta
SELECT PA_COMPRAVENTA.coanimalesasociadosventa(1202312059) FROM DUAL;
--Consultar una venta
SELECT PA_COMPRAVENTA.coVenta(1202312099) FROM DUAL;

/*PA_GANADERO*/
--Agregar un ganadero
BEGIN 
    PA_GANADEROS.ad_ganadero('Jorge Malpelo', 'Abc123@$!', 3212395599);
END;
/
-- Actualizar ganadero
--Clave
BEGIN
    PA_GANADEROS.up_ganadero_dueno(3, 'Abc123@$!');
END;
/

/*PA_ANIMALES*/

--Adicionar un animal con una compra no sin capacidad de incripcion y con un parto lleno
BEGIN
    PA_ANIMALES.ad_animal('C', 'ROJO', 450, 'LE', 'H', 3202312152, 30, NULL);
END;
/
BEGIN
    PA_ANIMALES.ad_animal('P', 'ROJO', 450, 'LE', 'M', NULL, 10, '2023121510-232');
END;
/
--Actualizar animal(Cambio de peso), animal no existente
BEGIN
    PA_ANIMALES.up_animal('89-23', 3, 'ROSADO', 500, 'LE', 'A', NULL);
END;
/
--Adicionar una muerte
BEGIN
    PA_ANIMALES.ad_muerte('80-23', 3, 'Picadura de culebra');
END;
/
--Actualizar muerte
BEGIN
    PA_ANIMALES.up_muerte('Picadura de culebra Cascabel, en la ingle','2023120928-233');
END;
/
--Agregar castracion
BEGIN 
    PA_ANIMALES.ad_castracion('80-23', 3);
END;
/
--Adicionar herraje especial
BEGIN
    PA_ANIMALES.ad_herrajeespecial('80-23', 3, '1005-123');
END;
/

--Consultar la informacion de un animal.
SELECT PA_ANIMALES.coinfoanimal('80-23', 3) FROM DUAL;
--Consultar la informacion de los animales de un socio de un grupo.
SELECT PA_ANIMALES.coanimalespropiosxgrupo('E', 3) FROM DUAL;
--Consultar la muerte de un animal.
SELECT PA_ANIMALES.comuerteanimal('202312091-233', 3) FROM DUAL;
--Consultra la castracion de un animal.
SELECT PA_ANIMALES.cocastracionanimal('200312091-233', 3) FROM DUAL;
--Consultar informacion de un grupo.
SELECT PA_ANIMALES.coinformaciongrupo('E') FROM DUAL;

--Adicionar una fertilidad
BEGIN
    PA_FERTILIDADES.ad_fertilidad('15-23', 2, 'P', 240, 'VE12577');
END;
/
-- Consultar fertilidades hembra activa
SELECT PA_FERTILIDADES.cofertilidadeshembraactiva('15-23', 2) FROM DUAL;
--Adicionar un parto
BEGIN
    PA_PARTOS.ad_parto('12-23', 2, NULL, '2023121712-232');
END;
/
--Consultar parto de un animal
SELECT PA_PARTOS.copartoanimal(2, '2023121820-232') FROM DUAL;

--Adicionar un historial clinico
BEGIN
    PA_HISTORIALESCLINICOS.ad_historialclinico('199-23', 2, 'detalle', 'VE12577');
END;
/
--Consultar historial clinico de un animal
SELECT PA_HISTORIALESCLINICOS.cohistorialclinicoanimal(2, '199-23') FROM DUAL;
--Consultar medicamentos de un histroial clinico
SELECT PA_HISTORIALESCLINICOS.comedicamentoshistorialclinico('20231215100-231') FROM DUAL;
--Adicionar uos de medicamentos
BEGIN
    PA_HISTORIALESCLINICOS.ad_usomedicamento('202312181-232', 1000, 15,'PSA5432109876');
END;
/
