CREATE OR REPLACE PACKAGE PA_SOCIOGANADERO AS
    
    PROCEDURE animalAdicionar(x_idGanadero NUMBER, x_clave VARCHAR2,x_proveniencia CHAR, x_color VARCHAR2, x_peso NUMBER, x_grupo VARCHAR2, x_sexo CHAR, x_compra NUMBER, x_edad NUMBER, x_parto VARCHAR2);
    
    PROCEDURE actualizarAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_color CHAR, x_peso NUMBER, x_grupo VARCHAR2, x_estado CHAR, x_venta NUMBER);
    
    PROCEDURE herrajeEspecialAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_herraje VARCHAR2);
    
    FUNCTION animalesPosibilidadVenta(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION inventarioTotalPropio(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION informacionAnimalesPropios(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION informacionAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION informacionAnimalesGrupo(x_clave VARCHAR2, x_grupo VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION muertesUltimoMes(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION muerteAnimal(x_clave VARCHAR2,x_idMuerte VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION castracionesUltimoAño(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION castracionAnimal(x_clave VARCHAR2, x_id VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    PROCEDURE compraAdicionar(x_clave VARCHAR2, x_comprador NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER);
    
    PROCEDURE compraActualizar(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER);
    
    FUNCTION animalesAsociadosCompra(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION informacionCompra(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER)
    RETURN sys_refcursor;
    
    PROCEDURE ventaAdicionar(x_clave VARCHAR2, x_vendedor NUMBER, x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER);
    
    PROCEDURE ventaActualizar(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER,x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER);
    
    FUNCTION animalesAsociadosVenta(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION informacionVenta(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER)
    RETURN sys_refcursor;
    
    PROCEDURE ganaderoActualizar(x_clave VARCHAR2, x_id NUMBER, x_nombre VARCHAR2, x_celular NUMBER);
    
    FUNCTION proximidadHerraje(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION partosUltimoMes(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION partoAnimal(x_idGanadero NUMBER, x_parto VARCHAR2, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION proximidadParto(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION historialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION medicamentosHistorialClinico(x_registro VARCHAR2, x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor;
    
END PA_SOCIOGANADERO;
/
    
CREATE OR REPLACE PACKAGE PA_DUENIO AS

    PROCEDURE ganaderoAdicionar(x_nombre VARCHAR2, x_clave VARCHAR2, x_celular NUMBER);
    
    PROCEDURE ganaderoActualizar(x_id NUMBER, x_clave VARCHAR);
    
    FUNCTION cantidadAnimalesXsocio
    RETURN sys_refcursor;
    
    FUNCTION inventarioTotal
    RETURN sys_refcursor;
    
    FUNCTION verSociosGanaderos
    RETURN sys_refcursor;
    
    PROCEDURE profesionalAdicionar(x_profesion VARCHAR2, x_noTProfesional NUMBER, x_nombre VARCHAR2);
    
    PROCEDURE profesionalEliminar(x_id VARCHAR2);
    
    FUNCTION profesional(x_id VARCHAR2)
    RETURN sys_refcursor;
    
    PROCEDURE empleadoAdicionar(x_noDocumento NUMBER, x_tipoDocumento VARCHAR2, x_nombre VARCHAR2, x_cargo VARCHAR2);
    
    PROCEDURE empleadoEliminar(x_id VARCHAR2);
    
    FUNCTION empleado(x_id VARCHAR2)
    RETURN sys_refcursor;
    
    PROCEDURE medicamentoAdicionar(x_unidades NUMBER, x_nombre VARCHAR2);
    
    PROCEDURE medicamentoActualizar(x_idMedicamento NUMBER, x_unidades NUMBER);
    
    FUNCTION medicamentosExcasos
    RETURN sys_refcursor;
    
END PA_DUENIO;
/

CREATE OR REPLACE PACKAGE PA_ENCARGADO AS

    PROCEDURE muerteAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2);
    
    PROCEDURE muerteActualizar(x_detalle VARCHAR2, x_idMuerte VARCHAR2);
    
    PROCEDURE castracionAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER);
    
    FUNCTION informacionGrupo(x_grupo VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION cantiadadAnimalesGrupo
    RETURN sys_refcursor;
    
    FUNCTION verSociosGanaderos
    RETURN sys_refcursor;
    
    PROCEDURE partoAdicionar(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_observacion VARCHAR2, x_fertilidadConfirmada VARCHAR2);
    
    FUNCTION desteteMes
    RETURN sys_refcursor;
    
    PROCEDURE usoMedicamentoAdicionar(x_historialClinico VARCHAR2, x_medicamento NUMBER, x_cantidad NUMBER, x_empleado VARCHAR2);
    
    FUNCTION usoMedicamento(x_idMedicamento NUMBER)
    RETURN sys_refcursor;
    
END PA_ENCARGADO;
/

CREATE OR REPLACE PACKAGE PA_VETERINARIO AS

    PROCEDURE historialClinicoAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2, x_profesional VARCHAR2);
    
    FUNCTION medicamentosHistorialClinico(x_registro VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION historialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2)
    RETURN sys_refcursor;

    PROCEDURE fertilidadAdicionar(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_diagnostico VARCHAR2, x_dias NUMBER, x_veterinario VARCHAR2);

    FUNCTION fertilidadesHembraActiva(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER)--INDICE
    RETURN sys_refcursor;
    
END PA_VETERINARIO;
/
 
    
    
    
    