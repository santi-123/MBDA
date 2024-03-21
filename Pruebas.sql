/*Historia de uso ganadero*/


--El ganadero hace una compra y la registra.
EXECUTE bd1000095277.PA_SOCIOGANADERO.compraadicionar('0311@Santi',3, 'fabian gutierrez', 1, 6000000, 500);
--El ganadero comete un error y requiere actualizar la cantidad de animales de la compra, el precio, el peso total y el vendedor de la compra.
EXECUTE bd1000095277.PA_SOCIOGANADERO.compraactualizar('0311@Santi', 3, 3202312154, 'julian gutierrez', 2, 12000000, 1200);
--El ganadero requiere añadir los anuimales de la compra.
EXECUTE bd1000095277.PA_SOCIOGANADERO.animaladicionar(3, '0311@Santi', 'C', 'ROJO', 600, 'LE', 'M', 3202312154, 10, NULL);
EXECUTE bd1000095277.PA_SOCIOGANADERO.animaladicionar(3, '0311@Santi', 'C', 'ROJO', 600, 'LE', 'H', 3202312154, 10, NULL);
--El ganadero requiere consultar el estado de la compra y cuantos animales estan sujetos a ella.
SELECT bd1000095277.PA_SOCIOGANADERO.informacioncompra('0311@Santi', 3, 3202312154) FROM DUAL;
--El ganadero requiere cuales son los animales adjuntos a la compra para validadr que sean los mismos que adiciono a ella.
SELECT bd1000095277.PA_SOCIOGANADERO.animalesasociadoscompra('0311@Santi', 3, 3202312154) FROM DUAL;
--El ganadero quiere consultar ambos animales de la compra.
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimal('0311@Santi', '7-23', 3) FROM DUAL;
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimal('0311@Santi', '26-23', 3) FROM DUAL;
--Por ultimo el ganadero quiere ver inventario total del grupo al que pertenecen estos animales.
SELECT bd1000095277.PA_SOCIOGANADERO.informacionanimalesgrupo('0311@Santi' ,'LE', 3) FROM DUAL;


/*Historia de uso dueño*/

--A el dueño le interesa estar constantemente pendiente de la finca es por esto que mensualmente siempre hace algunas consultas.

--Consulta cuantos animales hay por socio.
SELECT bd1000095277.PA_DUENIO.cantidadanimalesxsocio FROM DUAL;
--Consulta el inventario total
SELECT bd1000095277.PA_DUENIO.inventariototal FROM DUAL;
--Por ultimo ha llegado el socio numero 3 hacer un cambio de contraseña de su usuario, es por esto que le permite el acceso para cambiarla desde su usuario como dueño
EXECUTE bd1000095277.PA_DUENIO.ganaderoactualizar(3, '0911@sANTI');


/*Historia de uso veterinario*/

--El veterinario ha llegado a realizar el control de fertilidades

--Como primer paso revisa las fertilidades de la primer hembra a pasar
SELECT bd1000095277.PA_VETERINARIO.fertilidadeshembraactiva('12-23', 2) FROM DUAL;
--Como ve que esta tiene una proximidad de parto de un mes decide continuar con la siguiente hembra
SELECT bd1000095277.PA_VETERINARIO.fertilidadeshembraactiva('16-23', 2) FROM DUAL;
--Ve que esta tiene una proximidad de parto de dos meses, decide palparla y denota una serie de incidentes dentro del utero de la hembra
--Procede a registrar la fertilidad y el historial clinico.
EXECUTE bd1000095277.PA_VETERINARIO.fertilidadadicionar('16-23', 2, 'P', 240, 'VE12577');
EXECUTE bd1000095277.PA_VETERINARIO.historialclinicoadicionar('16-23', 2, 'Ligera inflamacion en los ovarios, aplicacion de antibiotico por 5 dias, oxitocina 5 mg diarios.', 'VE12577')
--El encargado comienza el tratamiento y registra el uso de medicamento.
EXECUTE bd1000095277.PA_ENCARGADO.usomedicamentoadicionar('2023121816-232', 12, 1, 'PSA5432109876');
--Por ultimo el veterinario comprueba el registro del historial y continua con su labor.
SELECT bd1000095277.PA_VETERINARIO.historialclinicoanimal(2, '16-23') FROM DUAL;

/*Historia de uso ganadero 2*/

--Dentro de las actividades del socio ganadero esta estar pendiente de todas las actualizaciones dentro de la finca por eso es importanmte hacer una evaluacion del dia a dia

--El ganadero siempre tiene curiosidad de lo que sucede con sus animales es por eso que siempre esta consultando cierta informacion.
--1. muertes
SELECT bd1000095277.PA_SOCIOGANADERO.muertesultimomes('0911@sANTI', 3) FROM DUAL;
--2. partos
SELECT bd1000095277.PA_SOCIOGANADERO.partosultimomes(3, '0911@sANTI') FROM DUAL;
--3. proximidad herraje
SELECT bd1000095277.PA_SOCIOGANADERO.proximidadherraje(3, '0911@sANTI') FROM DUAL;
--4. proximidad de parto
SELECT bd1000095277.PA_SOCIOGANADERO.proximidadParto(3, '0911@sANTI') FROM DUAL;
--Despues de hacer estas consultas el ganadero sabe cual es el estado actual de sus animales y procede a contactarce con el encargado si lo requiere 