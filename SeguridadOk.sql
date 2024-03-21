GRANT SOCIOGANADERO TO BD1000095277;
GRANT DUENIO TO BD1000095277;
GRANT ENCARGADO TO BD1000095277;
GRANT VETERINARIO TO BD1000095277;

commit;

--Adicionar una compra
EXECUTE bd1000095277.PA_SOCIOGANADERO.compraadicionar('0311@Santi', 3, 'fabian gutierrez', 1, 6000000, 500);
--Actualizar una compra
EXECUTE bd1000095277.PA_SOCIOGANADERO.compraactualizar('0311@Santi', 3, 3202312153, 'julian gutierrez', 2, 12000000, 1200);
--Consultar los animales asociados a una compra
SELECT bd1000095277.PA_SOCIOGANADERO.animalesasociadoscompra('0311@Santi', 3, 3202312151) FROM DUAL;
--Consultar una compra
SELECT bd1000095277.PA_SOCIOGANADERO.informacioncompra('0311@Santi', 3, 3202312153) FROM DUAL;
--Agregar una Venta
EXECUTE bd1000095277.PA_SOCIOGANADERO.ventaadicionar('0311@Santi', 3, 'samuel sanchez', 1, 3700000, 600);
--Actualizar una venta
EXECUTE bd1000095277.PA_SOCIOGANADERO.ventaactualizar('0311@Santi', 3, 3202312151, 'GABRIEL SANCHEZ', 1, 3650000, 600);
--Conusltar los animales asociados a una venta
SELECT bd1000095277.PA_SOCIOGANADERO.animalesasociadosventa('0311@Santi', 3, 3202312151) FROM DUAL;
--Consultar una venta
SELECT bd1000095277.PA_SOCIOGANADERO.informacionventa('0311@Santi', 3, 3202312151) FROM DUAL;
--Agregar un ganadero
EXECUTE bd1000095277.PA_DUENIO.ganaderoadicionar('EVARISTO tobon', '0311@Tobon', 3212835465);
-- Actualizar ganadero
EXECUTE bd1000095277.PA_DUENIO.ganaderoactualizar(48, '0511@jOrge');
EXECUTE bd1000095277.PA_SOCIOGANADERO.ganaderoactualizar('0311@Santi', 3, 'SANTIAGO DIAZ ROJAS', 3202293663);
-- Consultar los socios ganaderos
SELECT PA_ENCARGADO.versociosganaderos FROM DUAL;
SELECT PA_DUENIO.versociosganaderos FROM DUAL;
--Adicionar un animal
EXECUTE bd1000095277.PA_SOCIOGANADERO.animaladicionar(3, '0311@Santi', 'C', 'ROJO', 600, 'LE', 'M', 3202312153, 10, NULL);
--Actualizar animal(Cambio de peso)
EXECUTE bd1000095277.PA_SOCIOGANADERO.actualizaranimal('0311@Santi', '1-23', 3, 'ROJO', 650, 'LE', 'A', NULL);
--Adiciona una muerte
EXECUTE bd1000095277.PA_ENCARGADO.muerteadicionar('5-23', 1, 'Picadura alacran.');
--Actualizar una muerte
EXECUTE bd1000095277.PA_ENCARGADO.muerteactualizar('No se sabe, se desconoce motivo de muerte.', '202312155-231');
--Agregar una castracion
EXECUTE bd1000095277.PA_ENCARGADO.castracionadicionar('5-23', 3);
--Adicionar herraje especial
EXECUTE bd1000095277.PA_SOCIOGANADERO.herrajeespecialanimal('0311@Santi', '5-23', 3, '1234-05')

--Consultar cuantos animales hay por socio.
SELECT bd1000095277.PA_DUENIO.cantidadanimalesxsocio FROM DUAL;
--Consultar inventario total
SELECT bd1000095277.PA_DUENIO.inventariototal FROM DUAL;
--Consultar animales con posibilidad de venta de un socio.
SELECT bd1000095277.PA_SOCIOGANADERO.animalesposibilidadventa('0311@Santi', 3) FROM DUAL;
--Consultar inventario total de un socio.
SELECT bd1000095277.PA_SOCIOGANADERO.inventariototalpropio('0311@Santi', 3) FROM DUAL;
--Consultar todos lo animales propio.
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimalespropios('0311@Santi', 3) FROM DUAL;
--Consultar la informacion de un animal.
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimal('0311@Santi', '5-23', 3) FROM DUAL;
--Consultar la informacion de los animales de un socio de un grupo.
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimalesgrupo('0311@Santi' ,'LE', 3) FROM DUAL;
--Consultar las muertes del ultimo mes.
SELECT bd1000095277.PA_SOCIOGANADERO.muertesultimomes('0311@Santi', 3) FROM DUAL;
--Consultar la muerte de un animal.
SELECT bd1000095277.PA_SOCIOGANADERO.muerteanimal('0311@Santi', '202312152-233', 3) FROM DUAL;
--Consultar castraciones anuales.
SELECT bd1000095277.PA_SOCIOGANADERO.castracionesultimoaño('0311@Santi', 3) FROM DUAL;
--Consultra la castracion de un animal. 
SELECT bd1000095277.PA_SOCIOGANADERO.castracionanimal('0311@Santi', '202312155-233', 3) FROM DUAL;
--Consultar informacion de un grupo.
SELECT bd1000095277.PA_ENCARGADO.informaciongrupo('LE') FROM DUAL;
--Consultar la cantidad de animales por grupo.
SELECT bd1000095277.PA_ENCARGADO.cantiadadanimalesgrupo FROM DUAL;

--Adicionar una fertilidad
EXECUTE bd1000095277.PA_VETERINARIO.fertilidadadicionar('10-23', 2, 'P', 240, 'VE12577');
-- Consultar proximidad de parto
SELECT bd1000095277.PA_SOCIOGANADERO.proximidadParto(2, 'Abc123@$!') FROM DUAL;
-- Consultar fertilidades hembra activa
SELECT bd1000095277.PA_VETERINARIO.fertilidadeshembraactiva('12-23', 2) FROM DUAL;
--Adicionar un parto
EXECUTE bd1000095277.PA_ENCARGADO.partoadicionar('10-23', 2, NULL, '2023121810-232');
--Consultar animales con proximidad de herraje
SELECT bd1000095277.PA_SOCIOGANADERO.proximidadherraje(2, 'Abc123@$!') FROM DUAL;
--Consultar partos del ultimo mes
SELECT bd1000095277.PA_SOCIOGANADERO.partosultimomes(2, 'Abc123@$!') FROM DUAL;
--Consultar parto de un animal
SELECT bd1000095277.PA_SOCIOGANADERO.partoanimal(2, '2023121812-232', 'Abc123@$!') FROM DUAL;
--Consultar destetos del mes
SELECT bd1000095277.PA_ENCARGADO.destetemes FROM DUAL;
--Adicionar un historial clinico
EXECUTE bd1000095277.PA_VETERINARIO.historialclinicoadicionar('14-23', 2, 'detalle', 'VE12577');
--Consultar historial clinico de un animal
SELECT bd1000095277.PA_VETERINARIO.historialclinicoanimal(2, '14-23') FROM DUAL;
--Consultar medicamentos de un histroial clinico
SELECT bd1000095277.PA_VETERINARIO.medicamentoshistorialclinico('202312157-231') FROM DUAL;
--Adiciona un medicamento
EXECUTE bd1000095277.PA_DUENIO.medicamentoAdicionar(20, 'Enrovet');
--Actualizar un medicamento
EXECUTE bd1000095277.PA_DUENIO.medicamentoactualizar(52, 29);
--Consultar medicamento excasos
SELECT bd1000095277.PA_DUENIO.medicamentosexcasos FROM DUAL;
--Adicionar uso de medicamentos
EXECUTE bd1000095277.PA_ENCARGADO.usomedicamentoadicionar('2023121812-232', 52, 15,'PSA5432109876');
--Consultar uso de medicemnto
SELECT bd1000095277.PA_ENCARGADO.usomedicamento(52) FROM DUAL;
--Adicionar un profesional
EXECUTE bd1000095277.PA_DUENIO.profesionaladicionar('veterinario', 1234567891, 'Santiago diaz rojas');
--Eliminar un profesional
EXECUTE bd1000095277.PA_DUENIO.profesionaleliminar('VE1234567891');
--Consultar un profesional
SELECT bd1000095277.PA_DUENIO.profesional('VE12577') FROM DUAL;
--Adicionar un empleado
EXECUTE bd1000095277.PA_DUENIO.empleadoadicionar(1105781643, 'CE', 'Evaristo Rendon', 'Vaquero');
--Eliminar un empleado
EXECUTE bd1000095277.PA_DUENIO.empleadoeliminar('CEV1105781643');
--Consultar un empleado
SELECT bd1000095277.PA_DUENIO.empleado('CCE1105785643') FROM DUAL;






