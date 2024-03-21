CREATE OR REPLACE TRIGGER TR_GANADEROS_BI
BEFORE INSERT ON GANADEROS
FOR EACH ROW
BEGIN
    :NEW.nombre := UPPER(:NEW.nombre);
    SELECT GANADEROS_SEQ.NEXTVAL INTO :NEW.id FROM DUAL;
END TR_GANADEROS_BI;
/

CREATE OR REPLACE TRIGGER TR_GANADEROS_BU
BEFORE UPDATE ON GANADEROS
FOR EACH ROW
BEGIN
    IF :NEW.id <> :OLD.id
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solo es permitido actualizar el nombre' ||
                                        ', la contraseña y el celular.');
    ELSE
        IF :NEW.nombre <> :OLD.nombre
        THEN
            :NEW.nombre := UPPER(:NEW.nombre);
        END IF;  
    END IF;
END TR_GANADEROS_BU;
/

CREATE OR REPLACE TRIGGER TR_GANADEROS_BD
BEFORE DELETE ON GANADEROS
FOR EACH ROW
DECLARE
    cantidadAnimales NUMBER;
    cantidadCompras NUMBER;
    cantidadVentas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO cantidadAnimales
    FROM ANIMALES A
    WHERE :OLD.id = A.propietario;
    
    SELECT COUNT(*)
    INTO cantidadCompras
    FROM COMPRAS C
    WHERE :OLD.id = C.comprador;
    
    SELECT COUNT(*)
    INTO cantidadCompras
    FROM VENTAS V
    WHERE :OLD.id = V.vendedor;

    IF cantidadAnimales > 0 OR
        cantidadCompras > 0 OR
        cantidadVentas > 0
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'No es posible eliminar un ganadero, si se tiene' ||
                                        ' registros de animales, compras o ventas asociados a el.');
    END IF;
END TR_GANADEROS_BD;
/


CREATE OR REPLACE TRIGGER TR_CASTRACIONES_BI
BEFORE INSERT ON CASTRACIONES
FOR EACH ROW
DECLARE
    edadAnimal NUMBER(3);
    estadoAnimal CHAR(1);
BEGIN
    :NEW.id := TO_CHAR(SYSDATE, 'YYYYMMDD') || :NEW.animal || TO_CHAR(:NEW.propietarioAnimal);
    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD');

    SELECT A.edad, A.estado
    INTO edadAnimal, estadoAnimal
    FROM ANIMALES A
    WHERE :NEW.animal = A.id AND :NEW.propietarioAnimal = A.propietario;

    IF (edadAnimal >= 12 AND edadAnimal <= 9) AND estadoAnimal <> 'A'
    THEN
        RAISE_APPLICATION_ERROR(-20025, 'No se pueden ingresar registros en animales' ||
                                        ' que no cumple con la edad de castracion (9 meses a aÃ±o y medio)' ||
                                        ' o que no su estado no se activo "A"');
    END IF;
END TR_CASTRACIONES_BI;
/

CREATE OR REPLACE TRIGGER TR_MUERTES_BI
BEFORE INSERT ON MUERTES
FOR EACH ROW
DECLARE
    estadoAnimal CHAR(1);
BEGIN
    SELECT A.estado
    INTO estadoAnimal
    FROM ANIMALES A
    WHERE :NEW.animal = A.id
      AND :NEW.propietarioAnimal = A.propietario;

    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD');
    :NEW.id := TO_CHAR(:NEW.fecha, 'YYYYMMDD') || :NEW.animal || TO_CHAR(:NEW.propietarioAnimal);

    IF estadoAnimal <> 'A'
    THEN
        RAISE_APPLICATION_ERROR(-20027, 'No se puede modificar el estado de un animal' ||
                                        ' que no sea activo.');
    ELSE
        UPDATE ANIMALES A
        SET A.estado = 'M'
        WHERE A.id = :NEW.animal;
    END IF;
END TR_MUERTES_BI;
/

CREATE OR REPLACE TRIGGER TR_ANIMALES_BI
    BEFORE INSERT ON ANIMALES
    FOR EACH ROW
DECLARE
    fechaNacimiento DATE;
    fechaCompra DATE;
BEGIN
    :NEW.estado := 'A';
    :NEW.venta := NULL;

    IF :NEW.proveniencia = 'P'
    THEN
        IF :NEW.parto IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20003, 'No se permite agregar un animal con' ||
                                            ' proveniencia "P", sin un parto asignado.');
        ELSE

            SELECT P.fecha
            INTO fechaNacimiento
            FROM PARTOS P
            WHERE :NEW.parto = P.id;

            :NEW.nacimiento := TO_DATE(TO_CHAR(fechaNacimiento, 'YYYYMMDD'), 'YYYY-MM-DD');
            :NEW.edad := 0;
            :NEW.compra := NULL;

            DECLARE
                madre VARCHAR2(7);
                propietarioMadre NUMBER(3);
                secuencia NUMBER;
            BEGIN
                SELECT P.hembraActiva, P.propietarioHembraActiva
                INTO madre, propietarioMadre
                FROM PARTOS P
                WHERE P.id = :NEW.parto;

                :NEW.propietario := propietarioMadre;
                :NEW.grupo := NULL;

                SELECT COUNT(*)
                INTO secuencia
                FROM ANIMALES A
                WHERE A.propietario = :NEW.propietario
                AND TO_NUMBER(SUBSTR(A.id,-2)) = TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2))
                AND :NEW.sexo = A.sexo;

                IF :NEW.sexo = 'M'
                THEN
                    :NEW.id := TO_CHAR((2*secuencia) + 1) || '-' || SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2);
                ELSE
                    :NEW.id := TO_CHAR((2*secuencia) + 2) || '-' || SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2);
                END IF;
            END;
        END IF;
    ELSE
        IF :NEW.compra IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20004, 'No se puede agregar un animal' ||
                                            ' con proveniencia "C" sin una compra asociada');
        ELSE
            SELECT C.fecha
            INTO fechaCompra
            FROM COMPRAS C
            WHERE :NEW.compra = C.idCompra;

            :NEW.parto := NULL;
            :NEW.nacimiento := TO_DATE(TO_CHAR(fechaCompra, 'YYYYMMDD'), 'YYYYMMDD');


            DECLARE
                propietarioCompra NUMBER(3);
                secuencia NUMBER;
                cantidadCompra NUMBER;
                cantidadRegistrada NUMBER;
                cantidadMachosActivosGrupo NUMBER;
            BEGIN
                SELECT C.comprador, C.cantidadAnimales
                INTO propietarioCompra, cantidadCompra
                FROM COMPRAS C
                WHERE :NEW.compra = C.idCompra;

                SELECT COUNT(*)
                INTO cantidadRegistrada
                FROM ANIMALES A
                WHERE :NEW.compra = A.compra;

                IF cantidadRegistrada = cantidadCompra
                THEN
                    RAISE_APPLICATION_ERROR(-20005, 'No se pueden registrar mas animles' ||
                                                    ' con esta compra, cantidad limite sobrepasada.');
                END IF;

                :NEW.propietario := propietarioCompra;

                SELECT COUNT(*)
                INTO secuencia
                FROM ANIMALES A
                WHERE A.propietario = :NEW.propietario
                  AND TO_NUMBER(SUBSTR(A.id,-2)) = TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2))
                  AND :NEW.sexo = A.sexo;

                IF :NEW.EDAD < 0
                THEN RAISE_APPLICATION_ERROR(-20006, 'No se puede insertar animales con una edad menor ' ||
                                                     'a 0');
                ELSE
                    IF :NEW.sexo = 'M'
                    THEN
                        :NEW.id := TO_CHAR((2*secuencia) + 1) || '-' || SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2);
                        IF :NEW.edad >= 0 AND :NEW.edad < 9
                        THEN
                            :NEW.grupo := 'L';
                        ELSIF :NEW.edad >= 9 AND :NEW.edad < 36
                        THEN
                            :NEW.grupo := 'LE';
                        ELSE
                            IF :NEW.grupo IS NULL OR :NEW.grupo = 'LE'
                            THEN
                                RAISE_APPLICATION_ERROR(-20007, 'No se puede agregar una macho' ||
                                                                ' mayor a los tres aÃ±os sin un grupo ' ||
                                                                'definido o en el grupo "LE"');
                            ELSIF :NEW.grupo <> 'CE'
                            THEN
                                SELECT COUNT(*)
                                INTO cantidadMachosActivosGrupo
                                FROM ANIMALES A
                                WHERE :NEW.grupo = A.grupo
                                    AND A.sexo = 'M'
                                    AND A.edad >= 36;

                                IF cantidadMachosActivosGrupo = 1
                                THEN
                                    RAISE_APPLICATION_ERROR(-20008,'No se puede insertar a un macho activo' ||
                                                                ' en un grupo, si en dicho grupo ya existe otro ' ||
                                                                'macho activo');
                                END IF;
                            END IF;
                        END IF;
                    ELSE
                        :NEW.id := TO_CHAR((2*secuencia) + 2) || '-' || SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), -2);
                        IF :NEW.edad >= 0 AND :NEW.edad < 9
                        THEN
                            :NEW.grupo := 'L';
                        ELSIF :NEW.edad >= 9 AND :NEW.edad < 36
                        THEN
                            :NEW.grupo := 'LE';
                        ELSE
                            IF :NEW.edad < 45
                            THEN
                                :NEW.grupo := 'NV';
                            ELSE
                                IF :NEW.grupo IS NULL OR :NEW.grupo = 'LE' OR :NEW.grupo = 'NV'
                                THEN
                                    RAISE_APPLICATION_ERROR(-20009, 'No se puede agregar una hembra' ||
                                                                    ' mayor a los tres aÃ±os sin un grupo ' ||
                                                                    'definido o en los grupos "LE", "NV"');
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END;
        END IF;
    END IF;
END TR_ANIMALES_BI;
/

CREATE OR REPLACE TRIGGER TR_ANIMALES_AI
AFTER INSERT ON ANIMALES
FOR EACH ROW
BEGIN
    IF :NEW.proveniencia = 'P'
    THEN
        DECLARE
        madre VARCHAR2(7);
        propietarioMadre NUMBER(3);
        padre VARCHAR2(7);
        propietarioPadre NUMBER(3);
        fertilidadCon VARCHAR2(30);
        BEGIN
            SELECT P.hembraActiva, P.propietarioHembraActiva, P.fertilidadConfirmada
            INTO madre, propietarioMadre, fertilidadCon
            FROM PARTOS P
            WHERE P.id = :NEW.parto;

            IF fertilidadCon IS NOT NULL
            THEN
                SELECT FC.machoActivo, FC.propietarioMachoActivo
                INTO padre, propietarioPadre
                FROM FERTILIDADESCONFIRMADAS FC
                WHERE fertilidadCon = FC.fertilidad;

                IF padre IS NOT NULL
                THEN
                    INSERT INTO PADRES(animal1, propietario1, animal2, propietario2)
                    VALUES(padre, propietarioPadre, :NEW.id, :NEW.propietario);
                    INSERT INTO PADRES(animal1, propietario1, animal2, propietario2)
                    VALUES(madre, propietarioMadre, :NEW.id, :NEW.propietario);
                ELSE
                    INSERT INTO PADRES(animal1, propietario1, animal2, propietario2)
                    VALUES(madre, propietarioMadre, :NEW.id, :NEW.propietario);
                END IF;
            ELSE
                INSERT INTO PADRES(animal1, propietario1, animal2, propietario2)
                VALUES(madre, propietarioMadre, :NEW.id, :NEW.propietario);
            END IF;
        END;
    ELSE
        IF :NEW.edad > 35
        THEN
            IF :NEW.sexo = 'M'
            THEN
                INSERT INTO MACHOSACTIVOS (animal, propietarioAnimal)
                VALUES (:NEW.id, :NEW.propietario);
            ELSE
                INSERT INTO HEMBRASACTIVAS (animal, propietarioAnimal)
                VALUES(:NEW.id, :NEW.propietario);
            END IF;
        END IF;
    END IF;
END TR_ANIMALES_AI;
/

CREATE OR REPLACE TRIGGER TR_HERRAJESESPECIALES_BI
BEFORE INSERT ON HERRAJESESPECIALES
FOR EACH ROW
DECLARE
    proveniencia CHAR(1);
BEGIN
    SELECT A.proveniencia
    INTO proveniencia
    FROM ANIMALES A
    WHERE :NEW.animal = A.id
      AND :NEW.propietarioAnimal = A.propietario;

    IF proveniencia <> 'C'
    THEN
        RAISE_APPLICATION_ERROR(-20028, 'No se permite registrar herrajes especiales de animales' ||
                                        ' que no sean comprados.');
    END IF;
END TR_HERRAJESESPECIALES_BI;
/

CREATE OR REPLACE TRIGGER TR_MUERTES_BU
BEFORE UPDATE ON MUERTES
FOR EACH ROW
BEGIN
    IF :OLD.id <> :NEW.id OR
        :OLD.animal <> :NEW.animal OR
        :OLD.propietarioAnimal <> :NEW.propietarioAnimal OR
        :OLD.fecha <> :NEW.fecha
    THEN
        RAISE_APPLICATION_ERROR(-20041, 'Solo se permite modificar el detalle');
    
    ELSE
        IF ABS(:OLD.FECHA - SYSDATE) > 15
        THEN
            RAISE_APPLICATION_ERROR(-20042, 'No se permite modificar el detalle despues de 15 dias' ||
                                            'de haber fallecido el animal.');
        END IF;
    END IF;
END TR_MUERTES_BU;
/

CREATE OR REPLACE TRIGGER TR_ANIMALES_BU
BEFORE UPDATE ON ANIMALES
FOR EACH ROW
DECLARE
    animalCastrciones NUMBER(1);
    cantidadMachosActivosGrupo NUMBER;
BEGIN
    IF :OLD.estado <> 'A'
    THEN
        RAISE_APPLICATION_ERROR(-20010, 'No se puede hacer actualizaciones sobre' ||
                                        ' animales que se encuentran en un estado "I" o "M"');
    ELSIF :NEW.id <> :OLD.id OR
          :NEW.propietario <> :OLD.propietario OR
          :NEW.proveniencia <> :OLD.proveniencia OR
          :NEW.sexo <> :OLD.sexo OR
          :NEW.compra <> :OLD.compra OR
          :NEW.nacimiento <> :OLD.nacimiento
    THEN
        RAISE_APPLICATION_ERROR(-20011, 'No se permite hacer actualizaciones sobre,' ||
                                        ' id, propietario, proveniencia, sexo, compra.');
    ELSE
        :NEW.edad := MONTHS_BETWEEN(SYSDATE, :OLD.nacimiento) + :OLD.edad;

        IF :NEW.estado <> :OLD.estado
        THEN
            IF :NEW.estado = 'I'
            THEN
                IF :NEW.venta IS NULL
                THEN
                    RAISE_APPLICATION_ERROR(-20012, 'No se permite actualizar el estado' ||
                                                    ' a "I" sin una venta en la cual el' ||
                                                    ' animal participe.');
                ELSE
                    :NEW.grupo := NULL;
                END IF;
            ELSE
                :NEW.grupo := NULL;
            END IF;
        END IF;
    END IF;
    IF :NEW.edad < 9
    THEN
        IF :NEW.grupo <> :OLD.grupo AND :OlD.grupo IS NOT NULL
        THEN
            raise_application_error(-20013, 'No se permite hacer cambio de grupo a' ||
                                            ' animales con una edad menor a los nueve meses.');
        END IF;
    ELSE
        IF :OLD.color <> :NEW.color
        THEN
             RAISE_APPLICATION_ERROR(-20014, 'No se permite hacer cambio de color en animales mayores' ||
                                            ' a 9 meses');
        ELSIF :NEW.edad < 36
        THEN
            IF :NEW.grupo <> 'LE'
            THEN RAISE_APPLICATION_ERROR(-20015, 'Para animales entre los 9 meses y los 3 años' ||
                                                    'solo se permite cambiar el grupo a "LE"');
            END IF;
        ELSE
            IF :OLD.grupo = 'CE'
            THEN
                IF :NEW.grupo <> :OLD.grupo
                THEN
                    RAISE_APPLICATION_ERROR(-20016, 'No es posible cambiar de grupo a un animal' ||
                                                    ' que tiene como grupo actual "CE"');
                END IF;

            ELSIF :OLD.grupo = 'L' OR :OLD.grupo = 'H' OR :OLD.grupo = 'C'
            THEN
                IF :NEW.grupo = 'LE'
                THEN
                    RAISE_APPLICATION_ERROR(-20017, 'No es posible cambiar de grupo a un animal' ||
                                                    ' que tiene como grupo actual "L", "H" , "C"' ||
                                                    ' a "LE"');
                END IF;

            ELSIF :OLD.grupo = 'LE'
            THEN
                IF :OLD.sexo = 'M'
                THEN
                    SELECT COUNT(CASTRACIONES.animal)
                    INTO animalCastrciones
                    FROM CASTRACIONES
                    WHERE CASTRACIONES.animal = :OLD.id;

                    IF animalCastrciones= 0
                    THEN
                        SELECT COUNT(*)
                        INTO cantidadMachosActivosGrupo
                        FROM ANIMALES A
                        WHERE :NEW.grupo = A.grupo
                        AND :OLD.sexo = A.sexo;

                        IF cantidadMachosActivosGrupo > 1 AND
                            :NEW.grupo NOT IN ('CE', 'LE')
                            THEN
                                RAISE_APPLICATION_ERROR(-20018,'No se puede cambiar a un macho activo' ||
                                                             ' de grupo, si en dicho grupo ya existe otro macho activo');
                        END IF;

                        INSERT INTO MACHOSACTIVOS(animal, propietarioAnimal)
                        VALUES (:OLD.id, :OLD.propietario);

                    ELSE
                        IF :NEW.grupo <> 'CE'
                        THEN
                            RAISE_APPLICATION_ERROR(-20019, 'No se puede registrar un macho mayor a los 3 años' ||
                                                            ' con registro de castracion en un grupo que no sea' ||
                                                            ' "CE"' );
                        END IF;
                    END IF;

                ELSE
                    IF :NEW.grupo <> 'NV' OR
                           :NEW.grupo <> 'CE'
                    THEN
                        RAISE_APPLICATION_ERROR(-20021, 'No es posible registrar una hembra con grupo actual "LE"' ||
                                                            ' en un grupo que no sea "NV" o "CE"');

                    INSERT INTO HEMBRASACTIVAS(animal, propietarioAnimal)
                    VALUES (:OLD.id, :OLD.propietario);
                    END IF;
                END IF;
            ELSE
                IF :OLD.sexo = 'H'
                THEN
                    IF :OLD.grupo = 'C' OR
                            :OLD.grupo = 'L'
                    THEN
                        IF :NEW.grupo <> 'H' OR
                        :NEW.grupo <> 'CE'
                        THEN
                        RAISE_APPLICATION_ERROR(-20023, 'No se puede registrar hembras que pertenecian' ||
                                                        'a "C", "L" en grupos diferentes a "H", "CE"');
                        END IF;
                    ELSIF :OLD.grupo = 'NV' OR :OLD.grupo = 'H'
                    THEN
                        IF :NEW.grupo <> 'C' OR
                            :NEW.grupo <> 'L' OR
                            :NEW.grupo <> 'CE'
                        THEN
                            RAISE_APPLICATION_ERROR(-20022, 'No se puede registrar hembras que pertenecian' ||
                                                                    'a "NV" en grupos diferentes a "C", "L", "CE"');
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
END TR_ANIMALES_BU;
/

CREATE OR REPLACE TRIGGER TR_VENTAS_BI
BEFORE INSERT ON VENTAS
FOR EACH ROW
DECLARE
    secuencia NUMBER;
BEGIN
    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYY-MM-DD');

    SELECT COUNT(*)
    INTO secuencia
    FROM VENTAS
    WHERE fecha = :NEW.fecha
      AND vendedor = :NEW.vendedor;

    :NEW.comprador := UPPER(:NEW.comprador);
    :NEW.idVenta := TO_CHAR(:NEW.vendedor) || TO_CHAR(:NEW.fecha, 'YYYYMMDD') || TO_CHAR(secuencia + 1);
    :NEW.valorPromedio := ROUND(:NEW.valorTotal / :NEW.cantidadAnimales, 2);
    :NEW.valorKilo := ROUND(:NEW.valorTotal / :NEW.pesoVenta, 2);
END TR_VENTAS_BI;
/

CREATE OR REPLACE TRIGGER TR_VENTAS_BU
BEFORE UPDATE ON VENTAS
FOR EACH ROW
BEGIN
    IF SYSDATE - :OLD.fecha > 15
    THEN
        RAISE_APPLICATION_ERROR(-20023, 'No es posible hacer cambios en la ' ||
                                        'venta después de 15 días.');
    ELSE
        IF :OLD.idVenta <> :NEW.idVenta OR
           :OLD.vendedor <> :NEW.vendedor OR
           :OLD.fecha <> :NEW.fecha
        THEN
            RAISE_APPLICATION_ERROR(-20024, 'No es posible actualizar el idVenta' ||
                                            ' el vendedor y la fecha');
        END IF;

        IF :OLD.cantidadAnimales <> :NEW.cantidadAnimales OR
           :OLD.valorTotal <> :NEW.valorTotal OR
           :OLD.pesoVenta <> :NEW.pesoVenta
        THEN
            :NEW.valorPromedio := ROUND(:NEW.valorTotal / :NEW.cantidadAnimales, 2);
            :NEW.valorKilo := ROUND(:NEW.valorTotal / :NEW.pesoVenta, 2);
        END IF;

        :NEW.comprador := UPPER(:NEW.comprador);
    END IF;
END TR_VENTAS_BU;
/


CREATE OR REPLACE TRIGGER TR_COMPRAS_BI
BEFORE INSERT ON COMPRAS
FOR EACH ROW
DECLARE
    secuencia NUMBER;
BEGIN

    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYY-MM-DD');

    SELECT COUNT(*)
    INTO secuencia
    FROM COMPRAS
    WHERE fecha = :NEW.fecha
    AND comprador = :NEW.comprador;

    :NEW.vendedor := UPPER(:NEW.vendedor);
    :NEW.idCompra := TO_NUMBER(TO_CHAR(:NEW.comprador) || TO_CHAR(:NEW.fecha, 'YYYYMMDD') || TO_CHAR(secuencia + 1));
    :NEW.valorPromedio := ROUND(:NEW.valorTotal / :NEW.cantidadAnimales, 2);
    :NEW.valorKilo := ROUND(:NEW.valorTotal / :NEW.pesoCompra, 2);
END TR_COMPRAS_BI;
/

CREATE OR REPLACE TRIGGER TR_COMPRAS_BU
BEFORE UPDATE ON COMPRAS
FOR EACH ROW
BEGIN
    IF SYSDATE - :OLD.fecha > 15
    THEN
        RAISE_APPLICATION_ERROR(-20025, 'No es posible hacer cambios en la ' ||
                                        'compra después de 15 días.');
    ELSE
        IF :OLD.idCompra <> :NEW.idCompra OR
           :OLD.comprador <> :NEW.comprador OR
           :OLD.fecha <> :NEW.fecha
        THEN
            RAISE_APPLICATION_ERROR(-20024, 'No es posible actualizar el idCompra' ||
                                            ' el comprador y la fecha');
        END IF;

        IF :OLD.cantidadAnimales <> :NEW.cantidadAnimales OR
           :OLD.valorTotal <> :NEW.valorTotal OR
           :OLD.pesoCompra <> :NEW.pesoCompra
        THEN
            :NEW.valorPromedio := ROUND(:NEW.valorTotal / :NEW.cantidadAnimales, 2);
            :NEW.valorKilo := ROUND(:NEW.valorTotal / :NEW.pesoCompra, 2);
        END IF;

        :NEW.vendedor := UPPER(:NEW.vendedor);
    END IF;
END TR_COMPRAS_BU;
/

CREATE OR REPLACE TRIGGER TR_FERTILIDADES_BI
    BEFORE INSERT ON FERTILIDADES
    FOR EACH ROW
DECLARE
    estadoHembraActiva CHAR(1);
    profesionProfesional VARCHAR2(50);
BEGIN
    IF :NEW.veterinario IS NULL
    THEN
        RAISE_APPLICATION_ERROR(-20053, 'No es posible agregar una fertilidad' ||
                                        ' sin un veterinario asignado.');
    ELSE
        :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYY-MM-DD');
        :NEW.id := TO_CHAR(:NEW.fecha, 'YYYYMMDD') || :NEW.hembraActiva || TO_CHAR(:NEW.propietarioHembraActiva);
    
        SELECT A.estado
        INTO estadoHembraActiva
        FROM ANIMALES A
        WHERE :NEW.hembraActiva = A.id
          AND :NEW.propietarioHembraActiva = A.propietario;
    
        SELECT P.profesion
        INTO profesionProfesional
        FROM PROFESIONALES P
        WHERE :NEW.veterinario = P.id;
    
        IF profesionProfesional NOT LIKE('%VETERINARIO%')
        THEN
            RAISE_APPLICATION_ERROR(-20029, 'No se puede hacer registros, si el profesional no es ' ||
                                            'veterinario.');
        ELSIF estadoHembraActiva <> 'A'
        THEN
            RAISE_APPLICATION_ERROR(-20030, 'No se puede registrar un fertilidad, si la hembra activa tiene un' ||
                                            'estado diferente a "A"');
        END IF;
    END IF;
END TR_FERTILIDADES_BI;
/

CREATE OR REPLACE TRIGGER TR_FERTILIDADES_AI
AFTER INSERT ON FERTILIDADES
FOR EACH ROW
DECLARE
    grupoHembraActiva VARCHAR(2);
    provenienciaHembraActiva CHAR(1);
BEGIN
    SELECT A.proveniencia, A.grupo
    INTO provenienciaHembraActiva, grupoHembraActiva
    FROM ANIMALES A
    WHERE :NEW.hembraActiva = A.id
      AND :NEW.propietarioHembraActiva = A.propietario;

    IF :NEW.diagnostico = 'P'
    THEN
        DECLARE
            machoA VARCHAR(7);
            propietarioMActivo NUMBER(3);
        BEGIN
            IF provenienciaHembraActiva = 'C'
            THEN
                DECLARE
                    fechaCompra DATE;
                BEGIN
                    SELECT C.fecha
                    INTO fechaCompra
                    FROM ANIMALES A JOIN COMPRAS C
                        ON A.COMPRA = C.IDCOMPRA
                    WHERE :NEW.hembraActiva = A.id
                      AND :NEW.propietarioHembraActiva = A.propietario;

                    IF :NEW.dias < ABS(fechaCompra - SYSDATE)
                    THEN
                        SELECT M.animal, M.propietarioAnimal
                        INTO machoA, propietarioMActivo
                        FROM MACHOSACTIVOS M INNER JOIN ANIMALES A
                                                        ON M.ANIMAL = A.ID and M.propietarioANIMAL = A.propietario
                        WHERE A.estado = 'A' AND A.GRUPO = grupoHembraActiva;

                        INSERT INTO FERTILIDADESCONFIRMADAS(fertilidad, machoActivo, propietarioMachoActivo)
                        VALUES(:NEW.id, machoA, propietarioMActivo);

                    ELSE
                        INSERT INTO FERTILIDADESCONFIRMADAS(fertilidad, machoActivo, propietarioMachoActivo)
                        VALUES(:NEW.id, NULL, NULL);
                    END IF;
                END;
            ELSE
                SELECT M.animal, M.propietarioAnimal
                INTO machoA, propietarioMActivo
                FROM MACHOSACTIVOS M INNER JOIN ANIMALES A
                    ON M.ANIMAL = A.ID and M.propietarioANIMAL = A.propietario
                WHERE A.estado = 'A' AND A.GRUPO = grupoHembraActiva;

                INSERT INTO FERTILIDADESCONFIRMADAS(fertilidad, machoActivo, propietarioMachoActivo)
                VALUES(:NEW.id, machoA, propietarioMActivo);
            END IF;
        END;
    END IF;
END TR_FERTILIDADES_AI;
/

CREATE OR REPLACE TRIGGER TR_HISTORIALESCLINICOS_BI
BEFORE INSERT ON HISTORIALESCLINICOS
FOR EACH ROW
DECLARE
    estadoAnimal CHAR(1);
    profesionProfesional VARCHAR2(50);
BEGIN
    IF :NEW.profesional IS NULL
    THEN
        RAISE_APPLICATION_ERROR(-20051, 'No es posible agregar historial clinico' ||
                                        ' sin un veterinario asignado.');
    ELSE
        SELECT A.estado
        INTO estadoAnimal
        FROM ANIMALES A
        WHERE :NEW.animal = A.id
        AND :NEW.propietarioAnimal = A.propietario;

        SELECT P.profesion
        INTO profesionProfesional
        FROM PROFESIONALES P
        WHERE :NEW.profesional = P.id;

        IF profesionProfesional NOT LIKE('%VETERINARIO%')
        THEN
            RAISE_APPLICATION_ERROR(-20029, 'No se puede hacer registros, si el profesional no es ' ||
                                            'veterinario.');
        END IF;
    
        IF estadoAnimal <> 'A'
        THEN
            RAISE_APPLICATION_ERROR(-20031, 'No es posible registrar historiales' ||
                                            ' clinicos de animales con un estado ' ||
                                            'diferente a "A"');
        END IF;
    END IF;

    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYY-MM-DD');
    :NEW.registro := TO_CHAR(:NEW.fecha, 'YYYYMMDD') || :NEW.animal || TO_CHAR(:NEW.propietarioAnimal);

END TR_HISTORIALESCLINICOS_BI;
/


CREATE OR REPLACE TRIGGER TR_MEDICAMENTOS_BI
BEFORE INSERT ON MEDICAMENTOS
FOR EACH ROW
BEGIN
    :NEW.nombre := UPPER(:NEW.nombre);
    SELECT MEDICAMENTOS_SEQ.NEXTVAL INTO :NEW.id FROM DUAL;
END TR_MEDICAMENTOS_BI;
/

CREATE OR REPLACE TRIGGER TR_MEDICAMENTOS_BU
BEFORE UPDATE ON MEDICAMENTOS
FOR EACH ROW
BEGIN
    IF :OLD.id <> :NEW.id OR
       :OLD.nombre <> :NEW.nombre
    THEN
        RAISE_APPLICATION_ERROR(-20032, 'Solo es permitido modificar las unidades' ||
                                        ' disponibles del medicamento.');
    END IF;
END TR_MEDICAMENTOS_BU;
/

CREATE OR REPLACE TRIGGER TR_USAMEDICAMENTOS_BI
BEFORE INSERT ON USAMEDICAMENTOS
FOR EACH ROW
DECLARE
    cantidadMedicamento NUMBER;
BEGIN
    SELECT unidades INTO cantidadMedicamento
    FROM MEDICAMENTOS
    WHERE :NEW.medicamento = id;

    IF :NEW.empleado IS NULL
    THEN
        RAISE_APPLICATION_ERROR(-20050, 'No es posible agregar un uso de medicamento' ||
                                        ' sin un empleado asignado.');
    ELSE
        IF cantidadMedicamento - :NEW.cantidad < 0
        THEN
            RAISE_APPLICATION_ERROR(-20034, 'No es posible registrar el uso de medicamento' ||
                                            ' unidades inexistentes.');
        ELSE
            UPDATE MEDICAMENTOS M
            SET M.unidades = M.unidades - :NEW.cantidad
            WHERE :NEW.medicamento = M.id;
        END IF;
    END IF;
END TR_USAMEDICAMENTOS_BI;
/


CREATE OR REPLACE TRIGGER TR_EMPLEADOS_BI
BEFORE INSERT ON EMPLEADOS
FOR EACH ROW
BEGIN
    :NEW.nombre := UPPER(:NEW.nombre);
    :NEW.cargo := UPPER(:NEW.cargo);
    :NEW.id := :NEW.tipoDocumento || SUBSTR(:NEW.cargo,1,1) || TO_CHAR(:NEW.noDocumento);
END TR_EMPLEADOS_BI;
/

CREATE OR REPLACE TRIGGER TR_PROFESIONALES_BI
BEFORE INSERT ON PROFESIONALES
FOR EACH ROW
BEGIN
    :NEW.nombre := UPPER(:NEW.nombre);
    :NEW.profesion := UPPER(:NEW.profesion);
    :NEW.id := SUBSTR(:NEW.profesion, 1, 2) || TO_CHAR(:NEW.NoTProfesional);
END TR_PROFESIONALES_BI;
/

CREATE OR REPLACE TRIGGER TR_PARTOS_BI
    BEFORE INSERT ON PARTOS
    FOR EACH ROW
DECLARE
    estadoMadreParto VARCHAR(7);
    fertilidadesMadre NUMBER;
BEGIN
    :NEW.fecha := TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYY-MM-DD');
    :NEW.fechaDestete := ADD_MONTHS(:NEW.fecha, 9);

    SELECT A.estado
    INTO estadoMadreParto
    FROM ANIMALES A
    WHERE :NEW.hembraActiva = A.id
      AND :NEW.propietarioHembraActiva = A.propietario;

    :NEW.id := TO_CHAR(:NEW.fecha, 'YYYYMMDD') || :NEW.hembraActiva || TO_CHAR(:NEW.propietarioHembraActiva);

    IF estadoMadreParto <> 'A'
    THEN
        raise_application_error(-20035, 'No se puede registrar el parto de una hembra activa' ||
                                        ' que tiene un estado diferente a "A"');
    END IF;

    IF :NEW.FERTILIDADCONFIRMADA IS NULL
    THEN
        SELECT COUNT(*)
        INTO fertilidadesMadre
        FROM FERTILIDADES F
        WHERE :NEW.hembraActiva = F.HEMBRAACTIVA
        AND :NEW.propietarioHembraActiva = F.propietarioHembraActiva;

        IF fertilidadesMadre > 0
        THEN
            raise_application_error(-20036, 'No se puede registrar el parto de una hembra activa que ya' ||
                                            ' tiene fertilidades abiertas, sin el registor de una fertilidad confirmada.');
        END IF;
    END IF;
END TR_PARTOS_BI;
/

