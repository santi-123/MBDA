CREATE OR REPLACE PACKAGE BODY PA_SOCIOGANADERO AS
    
    PROCEDURE animalAdicionar(x_idGanadero NUMBER, x_clave VARCHAR2,x_proveniencia CHAR, x_color VARCHAR2, x_peso NUMBER, x_grupo VARCHAR2, x_sexo CHAR, x_compra NUMBER, x_edad NUMBER, x_parto VARCHAR2) IS
        v_propietario NUMBER;
        v_clave VARCHAR2(15);
    BEGIN
        SELECT clave 
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
        
            IF x_proveniencia = 'C'
            THEN
                SELECT comprador
                INTO v_propietario
                FROM COMPRAS
                WHERE x_compra = idCompra;
                
                IF v_propietario = x_idGanadero
                THEN 
                    PA_ANIMALES.ad_animal(x_proveniencia, x_color, x_peso, x_grupo, x_sexo, x_compra, x_edad, x_parto);
                ELSE
                    RAISE_APPLICATION_ERROR(-20200, 'No tiene acceso a adicionar animales con esta compra.');
                END IF;
            ELSE
                SELECT propietarioHembraActiva
                INTO v_propietario
                FROM PARTOS
                WHERE x_parto = id;
                
                IF v_propietario = x_idGanadero
                THEN 
                    PA_ANIMALES.ad_animal(x_proveniencia, x_color, x_peso, x_grupo, x_sexo, x_compra, x_edad, x_parto);
                
                ELSE
                    RAISE_APPLICATION_ERROR(-20201, 'No tiene acceso a adicionar animales con este parto.');
                END IF;
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END animalAdicionar;
                
    PROCEDURE actualizarAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_color CHAR, x_peso NUMBER, x_grupo VARCHAR2, x_estado CHAR, x_venta NUMBER) IS
        v_clave VARCHAR2(15);
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            PA_ANIMALES.up_animal(x_animal, x_propietarioAnimal, x_color, x_peso, x_grupo, x_estado, x_venta);
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END actualizarAnimal;
       
    PROCEDURE herrajeEspecialAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_herraje VARCHAR2) IS
        v_clave VARCHAR2(15);
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            PA_ANIMALES.ad_herrajeEspecial(x_animal, x_propietarioAnimal, x_herraje);
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END herrajeEspecialAnimal;
    
    FUNCTION animalesPosibilidadVenta(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        animalesPosibilidadVenta_Cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietario = id;
        
        IF v_clave = x_clave
        THEN
            animalesPosibilidadVenta_Cursor := PA_ANIMALES.coPosibilidadVenta(x_propietario);
            RETURN animalesposibilidadventa_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END animalesPosibilidadVenta;
    
    FUNCTION inventarioTotalPropio(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        inventarioTotalPropio_Cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietario = id;
        
        IF v_clave = x_clave
        THEN
            inventariototalpropio_cursor  :=  PA_ANIMALES.coInventarioTotalPropio(x_propietario);
            RETURN inventariototalpropio_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END inventarioTotalPropio;
    
    FUNCTION informacionAnimalesPropios(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        informacionAnimalesPropios_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietario = id;
        
        IF v_clave = x_clave
        THEN
            informacionanimalespropios_cursor := PA_ANIMALES.coAnimalesPropios(x_propietario);
            RETURN informacionanimalespropios_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END informacionAnimalesPropios;
    
    FUNCTION informacionAnimal(x_clave VARCHAR2, x_animal VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        informacionAnimal_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            informacionanimal_cursor := PA_ANIMALES.coInfoAnimal(x_animal, x_propietarioAnimal);
            RETURN informacionanimal_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END informacionAnimal;
    
    FUNCTION informacionAnimalesGrupo(x_clave VARCHAR2, x_grupo VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        informacionAnimalesGrupo_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            informacionanimalesgrupo_cursor := PA_ANIMALES.coAnimalesPropiosXGrupo(x_grupo, x_propietarioAnimal);
            RETURN informacionanimalesgrupo_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END informacionAnimalesGrupo;
    
    FUNCTION muertesUltimoMes(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        muertesUltimoMes_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietario = id;
        
        IF v_clave = x_clave
        THEN
            muertesultimomes_cursor := PA_ANIMALES.coMuertesUltimoMes(x_propietario);
            RETURN muertesultimomes_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END muertesUltimoMes;
    
    FUNCTION muerteAnimal(x_clave VARCHAR2,x_idMuerte VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
        muerteAnimal_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            SELECT propietarioAnimal
            INTO v_idGanadero
            FROM MUERTES
            WHERE x_idMuerte = id;
            
            IF v_idGanadero = x_propietarioAnimal
            THEN
                muerteanimal_cursor := PA_ANIMALES.coMuerteAnimal(x_idMuerte, x_propietarioAnimal);
                RETURN muerteanimal_cursor;
            ELSE
                RAISE_APPLICATION_ERROR(-20203, 'No es posible acceder a esta muerte');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END  muerteAnimal;
    
    FUNCTION castracionesUltimoAño(x_clave VARCHAR2, x_propietario NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        castracionesUltimoAño_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietario = id;
        
        IF v_clave = x_clave
        THEN
            castracionesultimoaño_cursor := PA_ANIMALES.coCastracionesAnuales(x_propietario);
            RETURN castracionesultimoaño_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END castracionesUltimoAño;
    
    FUNCTION castracionAnimal(x_clave VARCHAR2, x_id VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
        castaracionAnimal_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_propietarioAnimal = id;
        
        IF v_clave = x_clave
        THEN
            SELECT propietarioAnimal
            INTO v_idGanadero
            FROM castraciones
            WHERE x_id = id;
            
            IF v_idGanadero = x_propietarioAnimal
            THEN
                castaracionanimal_cursor := PA_ANIMALES.coCastracionAnimal(x_id, x_propietarioAnimal);
                RETURN castaracionanimal_cursor;
            ELSE
                RAISE_APPLICATION_ERROR(-20204, 'No es posible acceder a esta castracion');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END  castracionAnimal;
    
    PROCEDURE compraAdicionar(x_clave VARCHAR2, x_comprador NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER) IS
         v_clave VARCHAR2(15);
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_comprador = id;
        
        IF v_clave = x_clave
        THEN
            PA_COMPRAVENTA.ad_compra(x_comprador, x_vendedor, x_cantidadAnimales, x_valorTotal, x_pesoCompra);
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END compraAdicionar;
    
    PROCEDURE compraActualizar(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER) IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            SELECT comprador
            INTO v_idGanadero
            FROM COMPRAS
            WHERE x_idCompra = idCompra;
            
            IF v_idGanadero = x_idGanadero
            THEN
                PA_COMPRAVENTA.up_compra(x_idCompra, x_vendedor, x_cantidadAnimales, x_valorTotal, x_pesoCompra);
            ELSE
                RAISE_APPLICATION_ERROR(-20205, 'No es posible acceder a la actualizacion de esta compra');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END compraActualizar;
    
    FUNCTION animalesAsociadosCompra(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
        animalesAsociadosCompra_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            SELECT comprador
            INTO v_idGanadero
            FROM COMPRAS
            WHERE x_idCompra = idCompra;
            
            IF v_idGanadero = x_idGanadero
            THEN
                animalesasociadoscompra_cursor := PA_COMPRAVENTA.coAnimalesAsociadosCompra(x_idCompra);
                RETURN animalesasociadoscompra_cursor;
            ELSE
                RAISE_APPLICATION_ERROR(-20206, 'No es posible acceder a esta compra');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END animalesAsociadosCompra;
        
    FUNCTION informacionCompra(x_clave VARCHAR2, x_idGanadero NUMBER, x_idCompra NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        informacionCompra_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            informacioncompra_cursor := PA_COMPRAVENTA.coCompra(x_idCompra);
            RETURN informacioncompra_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END informacionCompra;
    
    PROCEDURE ventaAdicionar(x_clave VARCHAR2, x_vendedor NUMBER, x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER) IS
        v_clave VARCHAR2(15);
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_vendedor = id;
        
        IF v_clave = x_clave
        THEN
            PA_COMPRAVENTA.ad_venta(x_vendedor, x_comprador, x_cantidadAnimales, x_valorTotal, x_pesoVenta);
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END ventaAdicionar;
    
    PROCEDURE ventaActualizar(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER,x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER) IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            SELECT vendedor
            INTO v_idGanadero
            FROM VENTAS
            WHERE x_idVenta = idVenta;
            
            IF v_idGanadero = x_idGanadero
            THEN
                PA_COMPRAVENTA.up_venta(x_idVenta, x_comprador, x_cantidadAnimales, x_valorTotal, x_pesoVenta);
            ELSE
                RAISE_APPLICATION_ERROR(-20207, 'No es posible acceder a la actualizacion de esta venta');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END ventaActualizar;
    
    FUNCTION animalesAsociadosVenta(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        v_idGanadero NUMBER;
        animalesAsociadosVenta_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            SELECT vendedor
            INTO v_idGanadero
            FROM VENTAS
            WHERE x_idVenta = idVenta;
            
            IF v_idGanadero = x_idGanadero
            THEN
                animalesasociadosventa_cursor := PA_COMPRAVENTA.coAnimalesAsociadosCompra(x_idVenta);
                RETURN animalesasociadosventa_cursor;
            ELSE
                RAISE_APPLICATION_ERROR(-20208, 'No es posible acceder a esta venta');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END animalesAsociadosVenta;
    
    FUNCTION informacionVenta(x_clave VARCHAR2, x_idGanadero NUMBER, x_idVenta NUMBER)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        informacionVenta_Cursor SYS_REFCURSOR;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_idGanadero = id;
        
        IF v_clave = x_clave
        THEN
            informacionventa_cursor := PA_COMPRAVENTA.coVenta(x_idVenta);
            RETURN informacionventa_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END informacionVenta;
    
    PROCEDURE ganaderoActualizar(x_clave VARCHAR2, x_id NUMBER, x_nombre VARCHAR2, x_celular NUMBER) IS
        v_clave VARCHAR2(15);
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE x_id = id;
        
        IF v_clave = x_clave
        THEN
            PA_GANADEROS.up_ganadero_socioGanadero(x_id, x_nombre, x_celular);
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END ganaderoActualizar;
    
    FUNCTION proximidadHerraje(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        proximidadHerraje_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            proximidadHerraje_cursor := PA_PARTOS.coproximidadherraje(x_idGanadero);
            RETURN proximidadHerraje_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END proximidadHerraje;
    
    FUNCTION partosUltimoMes(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        partosUltimoMes_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            partosUltimoMes_cursor := PA_PARTOS.copartosultimomes(x_idGanadero);
            RETURN partosUltimoMes_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END partosUltimoMes;
    
    FUNCTION partoAnimal(x_idGanadero NUMBER, x_parto VARCHAR2, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        partoAnimal_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            partoAnimal_cursor := PA_PARTOS.copartoanimal(x_idGanadero, x_parto);
            RETURN partoAnimal_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END partoAnimal;
    
    FUNCTION proximidadParto(x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        proximidadParto_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            proximidadParto_cursor := PA_FERTILIDADES.coproximidadparto(x_idGanadero);
            RETURN proximidadParto_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END proximidadParto;
    
    FUNCTION historialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        historialClinicoAnimal_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            historialClinicoAnimal_cursor := PA_HISTORIALESCLINICOS.cohistorialclinicoanimal(x_idGanadero, x_animal);
            RETURN historialClinicoAnimal_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END historialClinicoAnimal;
    
    FUNCTION medicamentosHistorialClinico(x_registro VARCHAR2, x_idGanadero NUMBER, x_clave VARCHAR2)
    RETURN sys_refcursor IS
        v_clave VARCHAR2(15);
        medicamentosHistorialClinico_cursor sys_refcursor;
    BEGIN
        SELECT clave
        INTO v_clave
        FROM GANADEROS
        WHERE id = x_idGanadero;
        
        IF v_clave = x_clave
        THEN
            medicamentosHistorialClinico_cursor := PA_HISTORIALESCLINICOS.comedicamentoshistorialclinico(x_registro);
            RETURN medicamentosHistorialClinico_cursor;
        ELSE
            RAISE_APPLICATION_ERROR(-20202, 'La clave no coincide con el id');
        END IF;
    END medicamentosHistorialClinico;
    
END PA_SOCIOGANADERO;
/
    
CREATE OR REPLACE PACKAGE BODY PA_DUENIO AS

    PROCEDURE ganaderoAdicionar(x_nombre VARCHAR2, x_clave VARCHAR2, x_celular NUMBER) IS
    BEGIN
        PA_GANADEROS.ad_ganadero(x_nombre, x_clave, x_celular);
    END ganaderoAdicionar;
    
    PROCEDURE ganaderoActualizar(x_id NUMBER, x_clave VARCHAR) IS
    BEGIN
        PA_GANADEROS.up_ganadero_dueno(x_id, x_clave);
    END ganaderoActualizar;
    
    FUNCTION cantidadAnimalesXsocio
    RETURN sys_refcursor IS
        cantidadAnimalesXsocio_Cursor SYS_REFCURSOR;
    BEGIN
        cantidadAnimalesXsocio_Cursor := PA_ANIMALES.coCantidadAnimalesXSocio;
        RETURN cantidadAnimalesXsocio_Cursor;
    END cantidadAnimalesXsocio;
    
    FUNCTION inventarioTotal
    RETURN sys_refcursor IS
        inventarioTotal_Cursor SYS_REFCURSOR;
    BEGIN
        inventarioTotal_Cursor := PA_ANIMALES.coInventarioTotal;
        RETURN inventarioTotal_Cursor;
    END inventarioTotal;
         
    FUNCTION verSociosGanaderos
    RETURN sys_refcursor IS
        verSociosGanaderos_Cursor SYS_REFCURSOR;
    BEGIN
        verSociosGanaderos_Cursor := PA_GANADEROS.coSociosGanaderos;
        RETURN verSociosGanaderos_Cursor;
    END verSociosGanaderos;
    
    PROCEDURE profesionalAdicionar(x_profesion VARCHAR2, x_noTProfesional NUMBER, x_nombre VARCHAR2) IS
    BEGIN
        PA_PERSONAL.ad_profesional(x_profesion, x_noTProfesional, x_nombre);
    END profesionalAdicionar;
    
    PROCEDURE profesionalEliminar(x_id VARCHAR2) IS
    BEGIN
        PA_PERSONAL.el_profesional(x_id);
    END profesionalEliminar;
    
    FUNCTION profesional(x_id VARCHAR2)
    RETURN sys_refcursor IS
        profesional_cursor sys_refcursor;
    BEGIN
        profesional_cursor := PA_PERSONAL.coprofesional(x_id);
        RETURN profesional_cursor;
    END profesional;
    
    PROCEDURE empleadoAdicionar(x_noDocumento NUMBER, x_tipoDocumento VARCHAR2, x_nombre VARCHAR2, x_cargo VARCHAR2) IS
    BEGIN
        PA_PERSONAL.ad_empleado(x_noDocumento, x_tipoDocumento, x_nombre, x_cargo);
    END empleadoAdicionar;
    
    PROCEDURE empleadoEliminar(x_id VARCHAR2) IS
    BEGIN
        PA_PERSONAL.el_empleado(x_id);
    END empleadoEliminar;
    
    FUNCTION empleado(x_id VARCHAR2)
    RETURN sys_refcursor IS
        empleado_cursor sys_refcursor;
    BEGIN
        empleado_cursor := PA_PERSONAL.coempleado(x_id);
        RETURN empleado_cursor;
    END empleado;
    
    PROCEDURE medicamentoAdicionar(x_unidades NUMBER, x_nombre VARCHAR2) IS
    BEGIN
        PA_HISTORIALESCLINICOS.ad_medicamento(x_unidades, x_nombre);
    END medicamentoAdicionar;
    
    PROCEDURE medicamentoActualizar(x_idMedicamento NUMBER, x_unidades NUMBER) IS
    BEGIN
        PA_HISTORIALESCLINICOS.up_medicamento(x_idMedicamento, x_unidades);
    END medicamentoActualizar;
    
    FUNCTION medicamentosExcasos
    RETURN sys_refcursor IS
        medicamentosExcasos_cursor sys_refcursor;
    BEGIN
        medicamentosExcasos_cursor := PA_HISTORIALESCLINICOS.comedicamentosexcasos;
        RETURN medicamentosexcasos_cursor;
    END medicamentosExcasos;
         
END PA_DUENIO;
/

CREATE OR REPLACE PACKAGE BODY PA_ENCARGADO AS

    PROCEDURE muerteAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2) IS
    BEGIN
        PA_ANIMALES.ad_muerte(x_animal, x_propietarioAnimal, x_detalle);
    END muerteAdicionar;
    
    PROCEDURE muerteActualizar(x_detalle VARCHAR2, x_idMuerte VARCHAR2) IS
    BEGIN
        PA_ANIMALES.up_muerte(x_detalle, x_idMuerte);
    END muerteActualizar;
    
    PROCEDURE castracionAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER) IS
    BEGIN
        PA_ANIMALES.ad_castracion(x_animal, x_propietarioAnimal);
    END castracionAdicionar;
       
    FUNCTION informacionGrupo(x_grupo VARCHAR2)
    RETURN sys_refcursor IS
        informacionGrupo_Cursor SYS_REFCURSOR;
    BEGIN
        informacionGrupo_Cursor := PA_ANIMALES.coInformacionGrupo(x_grupo);
        RETURN informacionGrupo_Cursor;
    END informacionGrupo;
    
    FUNCTION cantiadadAnimalesGrupo
    RETURN sys_refcursor IS
        cantiadadAnimalesGrupo_Cursor SYS_REFCURSOR;
    BEGIN
        cantiadadAnimalesGrupo_Cursor := PA_ANIMALES.cocantidadanimalesxgrupo;
        RETURN cantiadadAnimalesGrupo_Cursor;
    END cantiadadAnimalesGrupo;
        
    FUNCTION verSociosGanaderos
    RETURN sys_refcursor IS
        verSociosGanaderos_Cursor SYS_REFCURSOR;
    BEGIN
        verSociosGanaderos_Cursor := PA_GANADEROS.coSociosGanaderos;
        RETURN verSociosGanaderos_Cursor;
    END verSociosGanaderos;
    
    PROCEDURE partoAdicionar(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_observacion VARCHAR2, x_fertilidadConfirmada VARCHAR2) IS
    BEGIN
        PA_PARTOS.ad_parto(x_hembraActiva, x_propietarioHembraActiva, x_observacion, x_fertilidadConfirmada);
    END partoAdicionar;
    
    FUNCTION desteteMes
    RETURN sys_refcursor IS
        desteteMes_cursor sys_refcursor;
    BEGIN
        desteteMes_cursor := PA_PARTOS.codestetosmes;
        RETURN desteteMes_cursor;
    END desteteMes;
    
    PROCEDURE usoMedicamentoAdicionar(x_historialClinico VARCHAR2, x_medicamento NUMBER, x_cantidad NUMBER, x_empleado VARCHAR2) IS
    BEGIN
        PA_HISTORIALESCLINICOS.ad_Usomedicamento(x_historialClinico, x_medicamento, x_cantidad, x_empleado);
    END;
    
    FUNCTION usoMedicamento(x_idMedicamento NUMBER)
    RETURN sys_refcursor IS
        usoMedicamento_Cursor sys_refcursor;
    BEGIN
        usoMedicamento_Cursor := PA_HISTORIALESCLINICOS.coUsoMedicamento(x_idMedicamento);
        RETURN usoMedicamento_Cursor;
    END usoMedicamento;
    
END PA_ENCARGADO;
/

CREATE OR REPLACE PACKAGE BODY PA_VETERINARIO AS

    PROCEDURE historialClinicoAdicionar(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2, x_profesional VARCHAR2) IS
    BEGIN
        PA_HISTORIALESCLINICOS.ad_HistorialClinico(x_animal, x_propietarioAnimal, x_detalle, x_profesional);
    END historialClinicoAdicionar;
    
    FUNCTION medicamentosHistorialClinico(x_registro VARCHAR2)
    RETURN sys_refcursor IS
        medicamentosHistorialClinico_cursor sys_refcursor;
    BEGIN
        medicamentosHistorialClinico_cursor := PA_HISTORIALESCLINICOS.coMedicamentosHistorialClinico(x_registro);
        RETURN medicamentosHistorialClinico_cursor;
    END medicamentosHistorialClinico;
    
    FUNCTION historialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2)
    RETURN sys_refcursor IS
        historialClinicoAnimal_cursor sys_refcursor;
    BEGIN
        historialClinicoAnimal_cursor := PA_HISTORIALESCLINICOS.coHistorialClinicoAnimal(x_idGanadero, x_animal);
        RETURN historialClinicoAnimal_cursor;
    END historialClinicoAnimal;

    PROCEDURE fertilidadAdicionar(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_diagnostico VARCHAR2, x_dias NUMBER, x_veterinario VARCHAR2) IS
    BEGIN
        PA_FERTILIDADES.ad_fertilidad(x_hembraActiva, x_propietarioHembraActiva, x_diagnostico, x_dias, x_veterinario);
    END fertilidadAdicionar;

    FUNCTION fertilidadesHembraActiva(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER)
    RETURN sys_refcursor IS
        fertilidadesHembraActiva_cursor sys_refcursor;
    BEGIN
        fertilidadesHembraActiva_cursor := PA_FERTILIDADES.coFertilidadesHembraActiva(x_hembraActiva, x_propietarioHembraActiva);
        RETURN fertilidadesHembraActiva_cursor;
    END fertilidadesHembraActiva;
    
END PA_VETERINARIO;
/