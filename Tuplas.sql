ALTER TABLE ANIMALES ADD CONSTRAINT CK_id_Sexo_Fecha_Animal
    CHECK ((
            (sexo = 'M' AND MOD(TO_NUMBER(SUBSTR(id, -4, 1)), 2) = 1) OR
            (sexo = 'H' AND MOD(TO_NUMBER(SUBSTR(id, -4, 1)), 2) = 0)) AND 
            (TO_NUMBER(SUBSTR(TO_CHAR(nacimiento, 'YYYY'), -2)) = TO_NUMBER(SUBSTR(ID, INSTR(ID, '-') + 1, 2))));
            
ALTER TABLE FERTILIDADES ADD CONSTRAINT CK_Diagnostico_Dias
    CHECK ((diagnostico = 'P' and dias IS NOT NULL) OR (diagnostico <> 'P'));

ALTER TABLE PARTOS ADD CONSTRAINT CK_FechaDestete_Partos
    CHECK (fechaDestete = ADD_MONTHS(fecha, 9));