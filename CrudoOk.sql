SET SERVEROUTPUT ON;
--Adicionar una compra
BEGIN
    PA_COMPRAVENTA.ad_compra(3, 'DANIEL DIAZ', 10, 3000000, 450);
END;
/
--Actualizar una compra
BEGIN
    PA_COMPRAVENTA.up_compra(3202312152, 'Daniel Gonzales', 2, 5500000, 1000);
END;
/
--Consultar los animales asociados a una compra
SELECT PA_COMPRAVENTA.coanimalesasociadoscompra(1202312152) FROM DUAL;
--Consultar una compra
SELECT PA_COMPRAVENTA.coCompra(3202312152) FROM DUAL;
--Agregar una Venta
BEGIN
    PA_COMPRAVENTA.ad_venta(1, 'FERNANDO SANCHEZ', 1, 3500000, 600);
END;
/
--Actualizar una venta
BEGIN
    PA_COMPRAVENTA.up_venta(1202312152, 'FERNANDO SANCHEZ', 1, 3650000, 600);
END;
/
--Conusltar los animales asociados a una venta
SELECT PA_COMPRAVENTA.coanimalesasociadosventa(1202312151) FROM DUAL;
--Consultar una venta
SELECT PA_COMPRAVENTA.coVenta(1202312151) FROM DUAL;
--Agregar un ganadero
BEGIN 
    PA_GANADEROS.ad_ganadero('Jorge Malpelo', 'Jorge@0511', 3212395599);
END;
/
-- Actualizar ganadero
--Clave
BEGIN
    PA_GANADEROS.up_ganadero_dueno(3, '0311@Santi');
END;
/
--Nombre y otros datos
BEGIN
    PA_GANADEROS.up_ganadero_socioganadero(1, 'MANUEL DIAZ', 3202293663);
END;
/
--Consultar los socios ganaderos
SELECT PA_GANADEROS.cosociosganaderos FROM DUAL;
--Adicionar un animal
BEGIN
    PA_ANIMALES.ad_animal('C', 'ROJO', 450, 'LE', 'M', 3202312152, 30, NULL);
END;
/
BEGIN
    PA_ANIMALES.ad_animal('C', 'ROJO', 450, 'LE', 'M', 3202312152, 10, NULL);
END;
/
--Actualizar animal(Camabio de peso)
BEGIN
    PA_ANIMALES.up_animal('1-23', 3, 'ROJO', 500, 'LE', 'A', NULL);
END;
/
--Adiciona una muerte
BEGIN
    PA_ANIMALES.ad_muerte('3-23', 3, 'Picadura de culebra');
END;
/
--Actualizar muerte
BEGIN
    PA_ANIMALES.up_muerte('Picadura de culebra Cascabel, en la ingle','202312153-233');
END;
/
--Agregar castracion
BEGIN 
    PA_ANIMALES.ad_castracion('1-23', 3);
END;
/
--Adicionar herraje especial
BEGIN
    PA_ANIMALES.ad_herrajeespecial('1-23', 3, '1005-123');
END;
/
--Consultar cuantos animales hay por socio.
SELECT PA_ANIMALES.cocantidadanimalesxsocio FROM DUAL;
--Consultar inventario total
SELECT PA_ANIMALES.coinventariototal FROM DUAL;
--Consultar animales con posibilidad de venta de un socio.
SELECT PA_ANIMALES.coposibilidadventa(3) FROM DUAL;
--Consultar inventario total de un socio.
SELECT PA_ANIMALES.coinventariototalpropio(3) FROM DUAL;
--Consultar todos lo animales propio.
SELECT PA_ANIMALES.coanimalespropios(3) FROM DUAL;
--Consultar la informacion de un animal.
SELECT PA_ANIMALES.coinfoanimal('3-23', 3) FROM DUAL;
--Consultar la informacion de los animales de un socio de un grupo.
SELECT PA_ANIMALES.coanimalespropiosxgrupo('LE', 3) FROM DUAL;
--Consultar las muertes del ultimo mes.
SELECT PA_ANIMALES.comuertesultimomes(3) FROM DUAL;
--Consultar la muerte de un animal.
SELECT PA_ANIMALES.comuerteanimal('202312153-233', 3) FROM DUAL;
--Consultar castraciones anuales.
SELECT PA_ANIMALES.cocastracionesanuales(3) FROM DUAL;
--Consultra la castracion de un animal.
SELECT PA_ANIMALES.cocastracionanimal('202312151-233', 3) FROM DUAL;
--Consultar informacion de un grupo.
SELECT PA_ANIMALES.coinformaciongrupo('LE') FROM DUAL;
--Consultar la cantidad de animales por grupo.
SELECT PA_ANIMALES.cocantidadanimalesxgrupo FROM DUAL;

--Adicionar una fertilidad
BEGIN
    PA_FERTILIDADES.ad_fertilidad('12-23', 2, 'P', 240, 'VE12577');
END;
/
-- Consultar proximidad de parto
SELECT PA_FERTILIDADES.coproximidadparto(2) FROM DUAL;
-- Consultar fertilidades hembra activa
SELECT PA_FERTILIDADES.cofertilidadeshembraactiva('12-23', 2) FROM DUAL;
--Adicionar un parto
BEGIN
    PA_PARTOS.ad_parto('12-23', 2, NULL, '2023121712-232');
END;
/
--Consultar animales con proximidad de herraje
SELECT PA_PARTOS.coproximidadherraje(2) FROM DUAL;
--Consultar partos del ultimo mes
SELECT PA_PARTOS.copartosultimomes(2) FROM DUAL;
--Consultar parto de un animal
SELECT PA_PARTOS.copartoanimal(2, '2023121812-232') FROM DUAL;
--Consultar destetos del mes
SELECT PA_PARTOS.codestetosmes FROM DUAL;
--Adicionar un historial clinico
BEGIN
    PA_HISTORIALESCLINICOS.ad_historialclinico('12-23', 2, 'detalle', 'VE12577');
END;
/
--Consultar historial clinico de un animal
SELECT PA_HISTORIALESCLINICOS.cohistorialclinicoanimal(2, '12-23') FROM DUAL;
--Consultar medicamentos de un histroial clinico
SELECT PA_HISTORIALESCLINICOS.comedicamentoshistorialclinico('202312157-231') FROM DUAL;
--Adiciona un medicamento
BEGIN
    PA_HISTORIALESCLINICOS.ad_medicamento(20, 'Piroxican');
END;
/
--Actualizar un medicamento
BEGIN
    PA_HISTORIALESCLINICOS.up_medicamento(51, 20);
END;
/
--Consultar medicamento excasos
SELECT PA_HISTORIALESCLINICOS.comedicamentosexcasos FROM DUAL;
--Adicionar uos de medicamentos
BEGIN
    PA_HISTORIALESCLINICOS.ad_usomedicamento('2023121812-232', 51, 15,'PSA5432109876');
END;
/
--Consultar uso de medicemnto
SELECT PA_HISTORIALESCLINICOS.cousomedicamento(51) FROM DUAL;
--Adicionar un profesional
BEGIN
    PA_PERSONAL.ad_profesional('veterinario', 1234567890, 'Santiago diaz rojas');
END;
/
--Eliminar un profesional
BEGIN
    PA_PERSONAL.el_profesional('VE1234567890');
END;
/
--Consultar un profesional
SELECT PA_PERSONAL.coprofesional('VE12577') FROM DUAL;
--Adicionar un empleado
BEGIN
    PA_PERSONAL.ad_empleado(1105781643, 'CC', 'Evaristo Rendon', 'Vaquero');
END;
/
--Eliminar un empleado
BEGIN
    PA_PERSONAL.el_empleado('CCV1105781643');
END;
/
--Consultar un empleado
SELECT PA_PERSONAL.coempleado('CCE1105785643') FROM DUAL;