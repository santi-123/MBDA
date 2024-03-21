CREATE OR REPLACE PACKAGE BODY PA_ANIMALES AS

    PROCEDURE ad_animal(x_proveniencia CHAR, x_color VARCHAR2, x_peso NUMBER, x_grupo VARCHAR2, x_sexo CHAR, x_compra NUMBER, x_edad NUMBER, x_parto VARCHAR2) IS
        ex_parto NUMBER;
        cant_animales_parto NUMBER;
        cant_animales_compra NUMBER;
        ex_compra NUMBER;
        cant_animales NUMBER;
    BEGIN
        IF x_proveniencia = 'C'
        THEN
            SELECT COUNT(*)
            INTO ex_compra
            FROM COMPRAS
            WHERE idCompra = x_compra;
            
            IF ex_compra = 1
            THEN
                SELECT COUNT(*) 
                INTO cant_animales_compra
                FROM ANIMALES 
                WHERE x_compra = compra;
                
                SELECT cantidadAnimales 
                INTO cant_animales
                FROM COMPRAS 
                WHERE x_compra = idCompra;
            
                IF cant_animales_compra < cant_animales
                THEN
                    INSERT INTO ANIMALES(proveniencia, color, peso, grupo, sexo, compra, edad, parto)
                    VALUES(x_proveniencia, x_color, x_peso, x_grupo, x_sexo, x_compra, x_edad, x_parto);
    
                    COMMIT;
                ELSE
                    ROLLBACK;
                    RAISE_APPLICATION_ERROR(-20104, 'La cantidad de registros con esta compra' ||
                                                    ' ha sido sobrepasada.');
                END IF;
            ELSE
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20100, 'No se encontro una compra asociada.');
            END IF;
        ELSE
            SELECT COUNT(*)
            INTO ex_parto
            FROM PARTOS
            WHERE id = x_parto;
            
            IF ex_parto = 1
            THEN
                SELECT COUNT(*) 
                INTO cant_animales_parto
                FROM ANIMALES 
                WHERE x_parto = parto;
                
                IF  cant_animales_parto < 1
                THEN
                    INSERT INTO ANIMALES(proveniencia, color, peso, grupo, sexo, compra, edad, parto)
                    VALUES(x_proveniencia, x_color, x_peso, x_grupo, x_sexo, x_compra, x_edad, x_parto);
    
                    COMMIT;
                ELSE
                    ROLLBACK;
                    RAISE_APPLICATION_ERROR(-20105, 'La cantidad de registros con este parto' ||
                                                    ' ha sido sobrepasada.');
                END IF;
            ELSE
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20106, 'No se encontro un parto asociado.');
            END IF;
        END IF;
    END ad_animal;
    
    PROCEDURE up_animal(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_color CHAR, x_peso NUMBER, x_grupo VARCHAR2, x_estado CHAR, x_venta NUMBER) IS
        v_animal NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF v_animal = 1
        THEN
            UPDATE ANIMALES
            SET color = x_color, peso = x_peso, grupo = x_grupo, estado = x_estado, venta = x_venta
            WHERE id = x_animal AND propietario = x_propietarioAnimal;
            
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro una animal asociado.');
        END IF;   
    END up_animal;
    
    PROCEDURE ad_muerte(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2) IS
        v_animal NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF v_animal = 1
        THEN
            INSERT INTO MUERTES(animal, propietarioAnimal, detalle)
            VALUES (x_animal, x_propietarioAnimal, x_detalle);
            
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro una animal asociado.');
        END IF;   
        
    END ad_muerte;
    
    PROCEDURE up_muerte(x_detalle VARCHAR2, x_idMuerte VARCHAR2) IS
        v_idMuerte NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_idMuerte
        FROM MUERTES
        WHERE id = x_idMuerte;
        
        IF v_idMuerte = 1
        THEN
            UPDATE MUERTES
            SET detalle = x_detalle
            WHERE id = x_idMuerte;
            
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20107, 'No se encontro una muerte asociada.');
        END IF;
            
    END up_muerte;
    
    PROCEDURE ad_castracion(x_animal VARCHAR2, x_propietarioAnimal NUMBER) IS
        v_animal NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF v_animal = 1
        THEN
            INSERT INTO CASTRACIONES(animal, propietarioAnimal)
            VALUES(x_animal, x_propietarioAnimal);
            
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro un animal asociado.');
        END IF; 
    END ad_castracion; 
    
    PROCEDURE ad_herrajeEspecial(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_herraje VARCHAR2) IS
        v_animal NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF v_animal = 1
        THEN
            INSERT INTO HERRAJESESPECIALES(animal, propietarioAnimal, herraje)
            VALUES(x_animal, x_propietarioAnimal, x_herraje);
            
            COMMIT;
        ELSE
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro un animal asociado.');
        END IF;
        
    END ad_herrajeEspecial;
    
    FUNCTION coCantidadAnimalesXSocio
    RETURN sys_refcursor IS
        animalesXSocio sys_refcursor;
    BEGIN
        OPEN animalesXSocio FOR
            SELECT V.propietario, G.nombre, COUNT(V.id) AS cantidadAnimales
            FROM VInformacion_Animales_Propios V 
            JOIN GANADEROS G ON V.propietario = G.id
            WHERE V.estado = 'A'
            GROUP BY V.propietario, G.nombre
            ORDER BY propietario;
        
        RETURN animalesXSocio;
    
    END coCantidadAnimalesXSocio;
    
    FUNCTION coInventarioTotal
    RETURN sys_refcursor IS
        inventarioTotal sys_refcursor;
    BEGIN
        OPEN inventarioTotal FOR
            SELECT COUNT(*)
            FROM VInformacion_Animales_Propios
            WHERE estado = 'A';
        
        RETURN inventarioTotal;
        
    END coInventarioTotal;
    
    FUNCTION coPosibilidadVenta(x_propietario NUMBER)
    RETURN sys_refcursor IS
        animalesPosibilidadVenta sys_refcursor;
    BEGIN
        OPEN animalesPosibilidadVenta FOR
            SELECT id, propietario, peso, ROUND(edad/12, 1) AS edadAños, grupo
            FROM VInformacion_Animales_Propios
            WHERE (grupo = 'LE' OR grupo = 'CE')
                AND propietario = x_propietario
            ORDER BY peso, edad;
        
        RETURN animalesPosibilidadVenta;
    
    END coPosibilidadVenta;
               
    FUNCTION coInventarioTotalPropio(x_propietario NUMBER)
    RETURN sys_refcursor IS
        inventarioTotalPropio sys_refcursor;
    BEGIN
        OPEN inventarioTotalPropio FOR
            SELECT COUNT(*) AS cantidadAnimales
            FROM VInformacion_Animales_Propios
            WHERE estado = 'A' AND propietario = x_propietario;
            
        RETURN inventarioTotalPropio;
    
    END coInventarioTotalPropio;
    
    FUNCTION coAnimalesPropios(x_propietario NUMBER)
    RETURN sys_refcursor IS
        AnimalesPropios sys_refcursor;
    BEGIN
        OPEN AnimalesPropios FOR
            SELECT id, nacimiento, ROUND(edad/12, 1) AS edadAños, estado, proveniencia, peso, color, grupo, sexo, 
            herrajeEspecial, idCastracion, idMuerte
            FROM VInformacion_Animales_Propios
            WHERE propietario = x_propietario
            ORDER BY nacimiento;
        
        RETURN AnimalesPropios;
    
    END coAnimalesPropios;
                
    FUNCTION coInfoAnimal(x_animal VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_animal NUMBER;
        infoAnimal sys_refcursor;
    BEGIN 
        SELECT COUNT(*)
        INTO v_animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF v_animal = 1
        THEN
            OPEN infoAnimal FOR
                SELECT id, nacimiento, ROUND(edad/12, 1) AS edadAños, estado, proveniencia, peso, color, grupo, sexo, 
                herrajeEspecial, idCastracion, idMuerte, idPadre, propietarioPadre, idMadre, propietarioMadre, parto
                FROM VInformacion_Animales_Propios
                WHERE id = x_animal AND propietario = x_propietarioAnimal;
                
            RETURN infoAnimal;
        ELSE
           RAISE_APPLICATION_ERROR(-20106, 'No se encontro un animal asociado.'); 
        END IF;
    END coInfoAnimal;
    
    FUNCTION coAnimalesPropiosXGrupo(x_grupo VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        animalesPropiosXGrupo sys_refcursor;
    BEGIN
        IF x_grupo IN ('C', 'CE', 'L', 'LE', 'H', 'NV')
        THEN
            OPEN animalesPropiosXGrupo FOR
                SELECT id, nacimiento, ROUND(edad/12, 1) AS edadAños, estado, proveniencia, peso, color, grupo, sexo, 
                herrajeEspecial, idCastracion
                FROM VInformacion_Animales_Propios
                WHERE grupo = x_grupo AND propietario = x_propietarioAnimal
                ORDER BY nacimiento;
            
            RETURN animalesPropiosXGrupo;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20107, 'El grupo a consultar es invalido');
        END IF;  
    END coAnimalesPropiosXGrupo;
    
    FUNCTION coMuertesUltimoMes(x_propietario NUMBER)
    RETURN sys_refcursor IS 
        muertesUltimoMes sys_refcursor;
    BEGIN
        OPEN muertesUltimoMes FOR
            SELECT id, animal, fecha, detalle 
            FROM MUERTES
            WHERE MONTHS_BETWEEN(sysdate, fecha) <= 12
            AND propietarioAnimal = x_propietario;
        
        RETURN muertesUltimoMes;
    
    END coMuertesUltimoMes;
    
    FUNCTION coMuerteAnimal(x_idMuerte VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        v_animal NUMBER;
        muerteAnimal sys_refcursor;
    BEGIN
        SELECT COUNT(*)
        INTO v_animal
        FROM MUERTES
        WHERE id = x_idMuerte;
        
        IF v_animal = 1
        THEN
            OPEN muerteAnimal FOR
                SELECT animal, fecha, detalle 
                FROM MUERTES
                WHERE id = x_idMuerte;
        
            RETURN muerteAnimal;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20108, 'Muerte no asociada.');
        END IF;
        
    END coMuerteAnimal;
    
    FUNCTION coCastracionesAnuales(x_propietario NUMBER)
    RETURN sys_refcursor IS
        castracionesAnuales sys_refcursor;
    BEGIN
        OPEN castracionesAnuales FOR
            SELECT id, animal, fecha
            FROM CASTRACIONES
            WHERE  MONTHS_BETWEEN(sysdate, fecha) <= 1
            AND propietarioAnimal = x_propietario;
        RETURN castracionesAnuales;
        
    END coCastracionesAnuales;
    
    FUNCTION coCastracionAnimal(x_id VARCHAR2, x_propietarioAnimal NUMBER)
    RETURN sys_refcursor IS
        castracion NUMBER;
        castracionAnimal sys_refcursor;
    BEGIN
        SELECT COUNT(*)
        INTO castracion
        FROM CASTRACIONES
        WHERE x_id = id;
        
        IF castracion = 1
        THEN
            OPEN castracionAnimal FOR
                SELECT id, animal, fecha
                FROM CASTRACIONES
                WHERE id = x_id AND propietarioAnimal = x_propietarioAnimal;
            
            RETURN castracionAnimal;
        ELSE
            RAISE_APPLICATION_ERROR(-20109, 'Castracion no asociada.');
        END IF;
        
    END coCastracionAnimal;
    
    FUNCTION coInformacionGrupo(x_grupo VARCHAR2)
    RETURN sys_refcursor IS
        informacionGrupo sys_refcursor;
    BEGIN
        IF x_grupo IN ('C', 'CE', 'L', 'LE', 'H', 'NV') 
        THEN
            OPEN informacionGrupo FOR
                SELECT id, propietario, nacimiento, ROUND(edad/12, 1) AS edadAños, peso, color, sexo, herrajeEspecial, idcastracion
                FROM VInformacion_Animales_Propios
                WHERE grupo = x_grupo;
                
            RETURN informacionGrupo;
        ELSE
             RAISE_APPLICATION_ERROR(-20107, 'El grupo a consultar es invalido');
        END IF;
        
    END coInformacionGrupo;
    
    FUNCTION coCantidadAnimalesXGrupo
    RETURN sys_refcursor IS 
        cantidadAnimalesXGrupo sys_refcursor;
    BEGIN
        OPEN cantidadAnimalesXGrupo FOR
            SELECT grupo, COUNT(id) AS cantidad
            FROM VInformacion_Animales_Propios
            WHERE grupo IS NOT NULL
            GROUP BY(grupo)
            ORDER BY(COUNT(id));
        
        RETURN cantidadAnimalesXGrupo;
    
    END coCantidadAnimalesXGrupo;
    
END PA_ANIMALES;
/

CREATE OR REPLACE PACKAGE BODY PA_GANADEROS AS

    PROCEDURE ad_ganadero(x_nombre VARCHAR2, x_clave VARCHAR2, x_celular NUMBER) IS
        v_clave CHAR;
    BEGIN
        SELECT COUNT(clave)
        INTO v_clave
        FROM GANADEROS
        WHERE clave = x_clave;
        
        IF v_clave = 0
        THEN
            INSERT INTO GANADEROS(nombre, clave, celular)
            VALUES(x_nombre, x_clave, x_celular);
        
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20103, 'la clave ya existe.');
            ROLLBACK;
        END IF;
            
    END ad_ganadero;
    
    PROCEDURE up_ganadero_socioGanadero(x_id NUMBER, x_nombre VARCHAR2, x_celular NUMBER) IS
    BEGIN
        UPDATE GANADEROS
        SET nombre = x_nombre, celular = x_celular
        WHERE id = x_id;
        
    COMMIT;
    
    END up_ganadero_socioGanadero;

    PROCEDURE up_ganadero_dueno(x_id NUMBER, x_clave VARCHAR2) IS
    v_clave CHAR;
    BEGIN
        SELECT COUNT(clave)
        INTO v_clave
        FROM GANADEROS
        WHERE clave = x_clave;
        
        IF v_clave = 0
        THEN
            UPDATE GANADEROS
            SET clave = x_clave
            WHERE id = x_id;
            
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20103, 'la clave ya existe.');
            ROLLBACK;
        END IF;
    END up_ganadero_dueno;
    
    FUNCTION coSociosGanaderos
    RETURN sys_refcursor IS
        sociosGanaderos sys_refcursor;
    BEGIN
        OPEN sociosGanaderos FOR
            SELECT id, nombre, celular
            FROM GANADEROS;
        
        RETURN sociosGanaderos;
    
    END coSociosGanaderos;
    

END PA_GANADEROS;
/

CREATE OR REPLACE PACKAGE BODY PA_COMPRAVENTA AS
    
    PROCEDURE ad_compra(x_comprador NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER) IS
        ganadero NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO ganadero
        FROM GANADEROS
        WHERE id = x_comprador;
        
        IF ganadero = 1
        THEN
            INSERT INTO COMPRAS(comprador, vendedor, cantidadAnimales, valorTotal, pesoCompra)
            VALUES (x_comprador, x_vendedor, x_cantidadAnimales, x_valorTotal, x_pesoCompra);
            
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20101, 'No se encontro un socio ganadero asociado.');
            ROLLBACK;
        END IF;
    END ad_compra;
    
    PROCEDURE up_compra(x_idCompra NUMBER, x_vendedor VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoCompra NUMBER) IS
        cantidadCompras NUMBER;
    BEGIN
    
        SELECT COUNT(*)
        INTO cantidadCompras
        FROM COMPRAS
        WHERE idCompra = x_idCompra;
            
        IF cantidadCompras > 0 THEN
        
            UPDATE COMPRAS
            SET vendedor = x_vendedor, cantidadAnimales = x_cantidadAnimales, valorTotal = x_valorTotal, pesoCompra = x_pesoCompra
            WHERE idCompra = x_idCompra;
            
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20100, 'No se encontro una compra asociada.');
            ROLLBACK;
        END IF;   
    END up_compra;
    
    PROCEDURE ad_venta(x_vendedor NUMBER, x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER) IS
        ganadero NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO ganadero
        FROM GANADEROS
        WHERE id = x_vendedor;
        
        IF ganadero = 1
        THEN
            INSERT INTO VENTAS(vendedor, comprador, cantidadAnimales, valorTotal, pesoVenta)
            VALUES (x_vendedor, x_comprador, x_cantidadAnimales, x_valorTotal, x_pesoVenta);
            COMMIT;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20101, 'No se encontro un socio ganadero asociado.');
            ROLLBACK;
        END IF;
    END ad_venta;
    
    PROCEDURE up_venta(x_idVenta NUMBER,x_comprador VARCHAR2, x_cantidadAnimales NUMBER, x_valorTotal NUMBER, x_pesoVenta NUMBER) IS
        venta NUMBER;
    BEGIN
    
        SELECT COUNT(*)
        INTO venta
        FROM VENTAS
        WHERE idVenta = x_idVenta;
        
        IF venta = 1
        THEN 
            UPDATE VENTAS
            SET comprador = x_comprador, cantidadAnimales = x_cantidadAnimales, valorTotal = x_valorTotal, pesoVenta = x_pesoVenta
            WHERE idVenta = x_idVenta;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20102, 'No se encontro una venta asociada.');    
            ROLLBACK;
        END IF;

    END up_venta;
    
    FUNCTION coAnimalesAsociadosCompra(x_idCompra NUMBER)
    RETURN sys_refcursor IS
        compra NUMBER;
        animalesAsociadosCompra sys_refcursor;
    BEGIN
        SELECT COUNT(*)
        INTO compra
        FROM COMPRAS
        WHERE x_idCompra = idCompra;
        
        IF compra = 1
        THEN
            OPEN animalesAsociadosCompra FOR
                SELECT id, estado, peso, color, grupo, sexo, edad, venta, herrajeEspecial
                FROM VInformacion_Animales_Propios
                WHERE compra = x_idCompra;
        
            RETURN animalesAsociadosCompra;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20100, 'No se encontro una compra asociada.');
        END IF;
    END coAnimalesAsociadosCompra;
    
    FUNCTION coCompra(x_idCompra NUMBER)
    RETURN sys_refcursor IS
        ex_compra NUMBER;
        compra sys_refcursor;
    BEGIN
    
        SELECT COUNT(*)
        INTO ex_compra
        FROM COMPRAS
        WHERE idCompra = x_idCompra;
        
        IF ex_compra = 1
        THEN
            OPEN compra FOR
                SELECT fecha, vendedor, cantidadAnimales, valorTotal, valorPromedio, valorKilo, pesoCompra, cantidadInscritos
                FROM COMPRAS C FULL OUTER JOIN (SELECT compra, COUNT(*) AS cantidadInscritos
                FROM ANIMALES A
                WHERE compra = x_idCompra
                GROUP BY compra) S
                ON C.idcompra = S.compra
                WHERE C.idCompra = x_idCompra;
                
            RETURN compra;
            
        ELSE 
            RAISE_APPLICATION_ERROR(-20100, 'No se encontro una compra asociada.');
        END IF;
    END coCompra;
    
    
    FUNCTION coAnimalesAsociadosVenta(x_idVenta NUMBER)
    RETURN sys_refcursor IS
        venta NUMBER;
        animalesAsociadosVenta sys_refcursor;
    BEGIN
    
        SELECT COUNT(*)
        INTO venta
        FROM VENTAS
        WHERE idVenta = x_idVenta;
    
        IF venta = 1
        THEN
            OPEN animalesAsociadosVenta FOR
                SELECT id, estado, peso, color, grupo, sexo, edad, proveniencia, compra, herrajeEspecial
                FROM VInformacion_Animales_Propios
                WHERE venta = x_idVenta;
            
            RETURN animalesAsociadosVenta;
        
        ELSE
            RAISE_APPLICATION_ERROR(-20102, 'No se encontro una venta asociada.');
        END IF;
    END coAnimalesAsociadosVenta;
    
    FUNCTION coVenta(x_idVenta NUMBER)
    RETURN sys_refcursor IS
        ex_venta NUMBER;
        venta sys_refcursor;
    BEGIN       
        SELECT COUNT(*)
        INTO ex_venta 
        FROM VENTAS
        WHERE idVenta = x_idVenta;
        
        IF ex_venta = 1
        THEN
            OPEN venta FOR
                SELECT fecha, comprador, cantidadAnimales, valorTotal, valorPromedio, valorKilo, pesoVenta, cantidadInscritos
                FROM VENTAS V FULL OUTER JOIN (SELECT venta, COUNT(*) AS cantidadInscritos
                FROM ANIMALES A
                WHERE venta = x_idVenta
                GROUP BY venta) S
                ON V.idVenta = S.venta
                WHERE V.idventa = x_idVenta;
                
            RETURN venta;
            
        ELSE
            RAISE_APPLICATION_ERROR(-20102, 'No se encontro una venta asociada.');
        END IF;
    END coVenta;
    
END PA_COMPRAVENTA;
/

CREATE OR REPLACE PACKAGE BODY PA_FERTILIDADES AS

    PROCEDURE ad_fertilidad(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_diagnostico VARCHAR2, x_dias NUMBER, x_veterinario VARCHAR2) IS
        ex_HembraActiva NUMBER;
    BEGIN
        
        SELECT COUNT(*)
        INTO ex_HembraActiva
        FROM ANIMALES
        WHERE x_hembraActiva = id AND x_propietarioHembraActiva = propietario;
        
        IF ex_HembraActiva = 1
        THEN 
            INSERT INTO FERTILIDADES(hembraActiva, propietarioHembraActiva, diagnostico, dias, veterinario)
            VALUES(x_hembraActiva, x_propietarioHembraActiva, x_diagnostico, x_dias, x_veterinario);
            
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20110, 'No se ha encontrado una hembra activa');
            ROLLBACK;
            
        END IF;
    END ad_fertilidad;
    
    FUNCTION coProximidadParto(x_idGanadero NUMBER)
    RETURN sys_refcursor IS
        proximidadParto sys_refcursor;
    BEGIN
    
        OPEN proximidadParto FOR
            SELECT id, hembraActiva, (fecha + (270 - dias)) AS estimacionFechaParto
            FROM FERTILIDADES 
            WHERE propietarioHembraActiva = x_idGanadero AND ABS((fecha + (270 - dias)) - SYSDATE) < 45;
        
        RETURN proximidadParto;
    
    END coProximidadParto;
        
    FUNCTION coFertilidadesHembraActiva(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER)
    RETURN sys_refcursor IS
        FertilidadesHembraActiva sys_refcursor;
        ex_hembraActiva number;
    BEGIN
    
        SELECT COUNT(*)
        INTO ex_HembraActiva
        FROM ANIMALES
        WHERE x_hembraActiva = id AND x_propietarioHembraActiva = propietario;
        
        IF ex_hembraActiva = 1
        THEN
        
            OPEN FertilidadesHembraActiva FOR
                SELECT id, fecha, diagnostico, dias, veterinario
                FROM FERTILIDADES
                WHERE hembraActiva = x_hembraActiva AND propietarioHembraActiva = x_propietarioHembraActiva;
            
            RETURN FertilidadesHembraActiva;
            
        ELSE
            RAISE_APPLICATION_ERROR(-20120, 'No se encontro una hembra asociada.');
        END IF;
    END coFertilidadesHembraActiva;
END PA_FERTILIDADES;
/

CREATE OR REPLACE PACKAGE BODY PA_PARTOS AS

    PROCEDURE ad_parto(x_hembraActiva VARCHAR2, x_propietarioHembraActiva NUMBER, x_observacion VARCHAR2, x_fertilidadConfirmada VARCHAR2) IS
        ex_fertilidadConfirmada NUMBER;
        hembra_FertilidadConfirmada VARCHAR(7);
        propietario_FertilidadConfirmada NUMBER;
    BEGIN
        
        IF x_fertilidadConfirmada IS NOT NULL
        THEN
            SELECT COUNT(*) 
            INTO ex_fertilidadConfirmada
            FROM FERTILIDADESCONFIRMADAS
            WHERE fertilidad = x_fertilidadConfirmada;
            
            IF ex_fertilidadConfirmada = 1
            THEN
                SELECT hembraActiva, propietarioHembraActiva
                INTO hembra_FertilidadConfirmada, propietario_FertilidadConfirmada
                FROM FERTILIDADES 
                WHERE id = x_fertilidadConfirmada;
                
                IF hembra_FertilidadConfirmada = x_hembraActiva AND propietario_FertilidadConfirmada = x_propietarioHembraActiva
                THEN
                    INSERT INTO PARTOS(hembraActiva, propietarioHembraActiva, observacion, fertilidadConfirmada)
                    VALUES(x_hembraActiva, x_propietarioHembraActiva, x_observacion, x_fertilidadConfirmada);
                    
                    COMMIT;
                ELSE
                    RAISE_APPLICATION_ERROR(-20111, 'No coinciden la hembra a registrar el parto con la hembra asociada a la'
                                                    ||' fertilidad confirmada.');
                    ROLLBACK;
                END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20112, 'No se ha encontrado la fertilidadConfirmada asociada.');
                ROLLBACK;
            END IF;
        ELSE
            INSERT INTO PARTOS(hembraActiva, propietarioHembraActiva, observacion, fertilidadConfirmada)
                    VALUES(x_hembraActiva, x_propietarioHembraActiva, x_observacion, x_fertilidadConfirmada);
            COMMIT;
        END IF;
    END ad_parto;
    
    FUNCTION coProximidadHerraje(x_idGanadero NUMBER)
    RETURN sys_refcursor IS
        ProximidadHerraje sys_refcursor;
    BEGIN
        OPEN ProximidadHerraje FOR
            SELECT id, nacimiento, fechaDestete, ROUND((edad / 12), 1) AS edad
            FROM VAnimal_Parto
            WHERE propietario = x_idGanadero AND ABS(SYSDATE - fechaDestete) <= 30;
        
        RETURN ProximidadHerraje;
    
    END coProximidadHerraje;
    
    FUNCTION coPartosUltimoMes(x_idGanadero NUMBER)
    RETURN sys_refcursor IS
        PartosUltimoMes sys_refcursor;
    BEGIN
        OPEN PartosUltimoMes FOR
            SELECT id, fecha, observacion, fechaDestete
            FROM PARTOS
            WHERE propietarioHembraActiva = x_idGanadero AND ABS(SYSDATE - fecha) <= 30;
        
        RETURN PartosUltimoMes;
        
    END coPartosUltimoMes;
            
    FUNCTION coPartoAnimal(x_idGanadero NUMBER, x_parto VARCHAR2)
    RETURN sys_refcursor IS 
        PartoAnimal sys_refcursor;
        ex_Parto NUMBER;
    BEGIN
        
        SELECT COUNT(*)
        INTO ex_Parto
        FROM PARTOS 
        WHERE id = x_parto;
        
        IF ex_Parto = 1
        THEN
            OPEN PartoAnimal FOR
                SELECT hembraActiva AS madre, fecha, observacion, fechaDestete
                FROM PARTOS
                WHERE id = x_parto;
                
            RETURN PartoAnimal;
        ELSE
            RAISE_APPLICATION_ERROR(-20113, 'No se ha encontrado un parto un parto Asociado.');
        END IF;
    END coPartoAnimal;
        
    FUNCTION coDestetosMes
    RETURN sys_refcursor IS
        DestetosMes sys_refcursor;
    BEGIN
        OPEN DestetosMes FOR
            SELECT id, propietario
            FROM vanimal_parto
            WHERE ABS(SYSDATE - fechaDestete) <= 30;
            
        RETURN DestetosMes;
        
    END coDestetosMes;
            
END PA_PARTOS;
/

CREATE OR REPLACE PACKAGE BODY PA_HISTORIALESCLINICOS AS

    PROCEDURE ad_historialClinico(x_animal VARCHAR2, x_propietarioAnimal NUMBER, x_detalle VARCHAR2, x_profesional VARCHAR2) IS
        ex_Animal NUMBER;
    BEGIN 
        
        SELECT COUNT(*) 
        INTO ex_Animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_propietarioAnimal;
        
        IF ex_Animal = 1 
        THEN 
            INSERT INTO HISTORIALESCLINICOS(animal, propietarioAnimal, detalle, profesional) 
            VALUES (x_animal, x_propietarioAnimal, x_detalle, x_profesional);
            
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro un animal asociado.');
            ROLLBACK;
        END IF;
    END ad_historialClinico;
    
    FUNCTION coHistorialClinicoAnimal(x_idGanadero NUMBER, x_animal VARCHAR2)
    RETURN sys_refcursor IS
        HistorialClinicoAnimal sys_refcursor;
        ex_Animal NUMBER;
    BEGIN 
        
        SELECT COUNT(*) 
        INTO ex_Animal
        FROM ANIMALES
        WHERE id = x_animal AND propietario = x_idGanadero;
        
        IF ex_Animal = 1
        THEN 
            OPEN HistorialClinicoAnimal FOR
                SELECT registro, detalle, fecha, profesional
                FROM HISTORIALESCLINICOS
                WHERE animal = x_animal AND propietarioAnimal = x_idGanadero;
            RETURN HistorialClinicoAnimal;
        ELSE
            RAISE_APPLICATION_ERROR(-20106, 'No se encontro un animal asociado.');
        END IF;
    END coHistorialClinicoAnimal;
    
    FUNCTION coMedicamentosHistorialClinico(x_registro VARCHAR2)
    RETURN sys_refcursor IS
        MedicamentosHistorialClinico sys_refcursor;
        ex_registro NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO ex_registro
        FROM HISTORIALESCLINICOS
        WHERE registro = x_registro;
        
        IF ex_registro = 1
        THEN 
            OPEN MedicamentosHistorialClinico FOR
                SELECT U.medicamento, M.nombre, U.cantidad, U.empleado 
                FROM USAMEDICAMENTOS U LEFT JOIN MEDICAMENTOS M ON  U.medicamento = M.id 
                WHERE historialclinico = x_registro;
            RETURN MedicamentosHistorialClinico;
        ELSE
            RAISE_APPLICATION_ERROR(-20114, 'No se encontro el registro asociado.');
        END IF;
    END coMedicamentosHistorialClinico;
    
    PROCEDURE ad_medicamento(x_unidades NUMBER, x_nombre VARCHAR2) IS
    BEGIN
        INSERT INTO MEDICAMENTOS(unidades, nombre)
        VALUES(x_unidades, x_nombre);
        COMMIT;
    END ad_medicamento;
    
    PROCEDURE up_medicamento(x_idMedicamento NUMBER, x_unidades NUMBER) IS
    BEGIN 
        UPDATE MEDICAMENTOS 
        SET unidades = unidades +  x_unidades
        WHERE id = x_idMedicamento;
        
        COMMIT;
    END up_medicamento;
    
    FUNCTION coMedicamentosExcasos
    RETURN sys_refcursor IS
        MedicamentosExcasos sys_refcursor;
    BEGIN
        OPEN MedicamentosExcasos FOR
            SELECT * 
            FROM MEDICAMENTOS
            WHERE unidades <= 10;
        
        RETURN MedicamentosExcasos;
    
    END coMedicamentosExcasos;
    
    PROCEDURE ad_usoMedicamento(x_historialClinico VARCHAR2, x_medicamento NUMBER, x_cantidad NUMBER, x_empleado VARCHAR2) IS
        ex_registro NUMBER;
        ex_medicamento NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO ex_registro
        FROM HISTORIALESCLINICOS
        WHERE registro = x_historialClinico;
        
        SELECT COUNT(*)
        INTO ex_medicamento
        FROM MEDICAMENTOS
        WHERE id = x_medicamento;
        
        IF ex_registro = 1 OR ex_medicamento = 1
        THEN
            INSERT INTO USAMEDICAMENTOS(historialClinico, medicamento, cantidad, empleado)
            VALUES (x_historialClinico, x_medicamento, x_cantidad, x_empleado);
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20115, 'No se encontro un historial medico o medicamento asociado.');
            ROLLBACK;
        END IF;
    END ad_usoMedicamento;
    
    FUNCTION coUsoMedicamento(x_idMedicamento NUMBER)
    RETURN sys_refcursor IS
        UsoMedicamento sys_refcursor;
    BEGIN
        OPEN UsoMedicamento FOR
            SELECT historialClinico, cantidad, empleado
            FROM USAMEDICAMENTOS
            WHERE medicamento = x_idMedicamento;
        RETURN UsoMedicamento;
    
    END coUsoMedicamento;
        
END PA_HISTORIALESCLINICOS;
/

CREATE OR REPLACE PACKAGE BODY PA_PERSONAL AS

    PROCEDURE ad_profesional(x_profesion VARCHAR2, x_noTProfesional NUMBER, x_nombre VARCHAR2) IS
    BEGIN
        INSERT INTO PROFESIONALES(profesion, noTProfesional, nombre)
        VALUES (x_profesion, x_noTProfesional, x_nombre);
        COMMIT;
    END ad_profesional;
    
    PROCEDURE el_profesional(x_id VARCHAR2) IS
    BEGIN 
        DELETE FROM PROFESIONALES
        WHERE id = x_id;
        COMMIT;
    END el_profesional;
    
    FUNCTION coProfesional(x_id VARCHAR2)
    RETURN sys_refcursor IS
        Profesional_cursor sys_refcursor;
    BEGIN
        OPEN Profesional_cursor FOR
            SELECT * 
            FROM PROFESIONALES
            WHERE id = x_id;
        RETURN Profesional_cursor;
    END coProfesional;
        
    PROCEDURE ad_empleado(x_noDocumento NUMBER, x_tipoDocumento VARCHAR2, x_nombre VARCHAR2, x_cargo VARCHAR2) IS
    BEGIN 
        INSERT INTO EMPLEADOS(noDocumento, tipoDocumento, nombre, cargo)
        VALUES (x_noDocumento, x_tipoDocumento, x_nombre, x_cargo);
        COMMIT;
    END ad_empleado;
    
    PROCEDURE el_empleado(x_id VARCHAR2) IS
    BEGIN
        DELETE FROM EMPLEADOS
        WHERE id = x_id;
        COMMIT;
    END el_empleado;
    
    FUNCTION coEmpleado(x_id VARCHAR2)
    RETURN sys_refcursor IS
        Empleado_cursor sys_refcursor;
    BEGIN
        OPEN Empleado_cursor FOR
            SELECT * 
            FROM EMPLEADOS
            WHERE id = x_id;
        RETURN Empleado_cursor;
    END coEmpleado;
    
END PA_PERSONAL;
/