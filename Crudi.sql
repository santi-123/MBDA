CREATE OR REPLACE PACKAGE PA_ANIMALES AS

    PROCEDURE ad_animal(x_proveniencia CHAR, x_color VARCHAR2, x_peso NUMBER, x_grupo VARCHAR2, x_sexo CHAR, x_compra NUMBER, x_edad NUMBER, x_parto VARCHAR2);
    
    PROCEDURE up_animal(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_color CHAR, x_peso NUMBER, x_grupo VARCHAR2, x_estado CHAR, x_venta NUMBER);
    
    PROCEDURE ad_muerte(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2);
    
    PROCEDURE up_muerte(x_detalle VARCHAR2, x_idMuerte VARCHAR2);
    
    PROCEDURE ad_castracion(x_animal VARCHAR2, x_propietarioAnimal NUMBER);
    
    PROCEDURE ad_herrajeEspecial(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_herraje VARCHAR2);
    
    FUNCTION coCantidadAnimalesXSocio
    RETURN sys_refcursor;
    
    FUNCTION coInventarioTotal
    RETURN sys_refcursor;
    
    FUNCTION coPosibilidadVenta(x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coInventarioTotalPropio(x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coAnimalesPropios(x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coInfoAnimal(x_animal VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coAnimalesPropiosXGrupo (x_grupo VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coMuertesUltimoMes(x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coMuerteAnimal(x_idMuerte VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coCastracionesAnuales(x_propietario NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coCastracionAnimal(x_id VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coInformacionGrupo(x_grupo VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION coCantidadAnimalesXGrupo
    RETURN sys_refcursor;
    
END PA_ANIMALES;
/


CREATE OR REPLACE PACKAGE PA_GANADEROS AS

    PROCEDURE ad_ganadero(x_nombre VARCHAR2, x_clave VARCHAR2, x_celular NUMBER);
    
    PROCEDURE up_ganadero_socioGanadero(x_id NUMBER, x_nombre VARCHAR2, x_celular NUMBER);
    
    PROCEDURE up_ganadero_dueno(x_id NUMBER, x_clave VARCHAR2);
    
    FUNCTION coSociosGanaderos
    RETURN sys_refcursor;
    
END PA_GANADEROS;
/

CREATE OR REPLACE PACKAGE PA_COMPRAVENTA AS
    
    PROCEDURE ad_compra(x_comprador NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER);
    
    PROCEDURE up_compra(x_idCompra NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER);
    
    PROCEDURE ad_venta(x_vendedor NUMBER, x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER);
    
    PROCEDURE up_venta(x_idVenta NUMBER,x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER);
    
    FUNCTION coAnimalesAsociadosCompra(x_idCompra NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coCompra(x_idCompra NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coAnimalesAsociadosVenta(x_idVenta NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coVenta(x_idVenta NUMBER)
    RETURN sys_refcursor;
    
END PA_COMPRAVENTA;
/

CREATE OR REPLACE PACKAGE PA_FERTILIDADES AS

    PROCEDURE ad_fertilidad(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_diagnostico VARCHAR2, x_dias NUMBER, x_veterinario VARCHAR2);
    
    FUNCTION coProximidadParto(x_idGanadero NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coFertilidadesHembraActiva(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER)
    RETURN sys_refcursor;
    
END PA_FERTILIDADES;
/

CREATE OR REPLACE PACKAGE PA_PARTOS AS

    PROCEDURE ad_parto(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_observacion VARCHAR2, x_fertilidadConfirmada VARCHAR2);
    
    FUNCTION coProximidadHerraje(x_idGanadero NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coPartosUltimoMes(x_idGanadero NUMBER)
    RETURN sys_refcursor;
    
    FUNCTION coPartoAnimal(x_idGanadero NUMBER, x_parto VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION coDestetosMes
    RETURN sys_refcursor;
    
END PA_PARTOS;
/

CREATE OR REPLACE PACKAGE PA_HISTORIALESCLINICOS AS

    PROCEDURE ad_historialClinico(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2, x_profesional VARCHAR2);
    
    FUNCTION coHistorialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2)
    RETURN sys_refcursor;
    
    FUNCTION coMedicamentosHistorialClinico(x_registro VARCHAR2)
    RETURN sys_refcursor;
    
    PROCEDURE ad_medicamento(x_unidades NUMBER, x_nombre VARCHAR2);
    
    PROCEDURE up_medicamento(x_idMedicamento NUMBER, x_unidades NUMBER);
    
    FUNCTION coMedicamentosExcasos
    RETURN sys_refcursor;
    
    PROCEDURE ad_usoMedicamento(x_historialClinico VARCHAR2, x_medicamento NUMBER, x_cantidad NUMBER, x_empleado VARCHAR2);
    
    FUNCTION coUsoMedicamento(x_idMedicamento NUMBER)
    RETURN sys_refcursor;
    
END PA_HISTORIALESCLINICOS;
/

CREATE OR REPLACE PACKAGE PA_PERSONAL AS

    PROCEDURE ad_profesional(x_profesion VARCHAR2, x_noTProfesional NUMBER, x_nombre VARCHAR2);
    
    PROCEDURE el_profesional(x_id VARCHAR2);
    
    FUNCTION coProfesional(x_id VARCHAR2)
    RETURN sys_refcursor;
    
    PROCEDURE ad_empleado(x_noDocumento NUMBER, x_tipoDocumento VARCHAR2, x_nombre VARCHAR2, x_cargo VARCHAR2);
    
    PROCEDURE el_empleado(x_id VARCHAR2);
    
    FUNCTION coEmpleado(x_id VARCHAR2)
    RETURN sys_refcursor;
    
END PA_PERSONAL;
/