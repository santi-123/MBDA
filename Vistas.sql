CREATE OR REPLACE VIEW VInformacion_Animales_Propios AS
SELECT A.id, A.propietario, A.proveniencia, A.nacimiento, A.peso, A.color, A.sexo, A.grupo, A.estado,
        A.edad, H.herraje AS herrajeEspecial, C.id AS idCastracion, M.id AS idMuerte,
        A.compra, A.venta, A.parto, P.animal1 AS idPadre, P.propietario1 AS propietarioPadre,
        M.animal1 AS idMadre, M.propietario1 AS propietarioMadre
FROM ANIMALES A LEFT JOIN HERRAJESESPECIALES H 
    ON A.id = H.animal AND A.propietario = H.propietarioAnimal LEFT JOIN CASTRACIONES C 
    ON A.id = C.animal AND A.propietario = C.propietarioAnimal LEFT JOIN MUERTES M
    ON A.id = M.animal AND A.propietario = M.propietarioAnimal LEFT JOIN 
        (SELECT animal1, propietario1, animal2, propietario2
        FROM PADRES
        WHERE MOD(TO_NUMBER(SUBSTR(animal1, -4, 1)), 2) = 1) P 
    ON A.id = P.animal2 AND A.propietario = P.propietario2 LEFT JOIN
        (SELECT animal1, propietario1, animal2, propietario2
        FROM PADRES
        WHERE MOD(TO_NUMBER(SUBSTR(animal1, -4, 1)), 2) = 0) M
    ON A.id = M.animal2 AND A.propietario = M.propietario2
    ORDER BY TO_NUMBER(SUBSTR(A.id, -4, 1)) DESC;

CREATE OR REPLACE VIEW VAnimal_Parto AS
SELECT A.id, A.propietario, A.parto, A.nacimiento, P.fechaDestete, P.observacion, A.edad, A.estado
FROM PARTOS P LEFT JOIN  ANIMALES A ON P.id = A.parto;
    
