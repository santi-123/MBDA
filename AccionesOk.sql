--Prueba borrado de historial clinico

--(FK_UsaMedicamentos_HistorialesClinicos)
--1. Visualizacion de tablas antes de la eliminacion
SELECT * FROM HISTORIALESCLINICOS
    WHERE registro = '202310240006-211';
SELECT * FROM USAMEDICAMENTOS
    WHERE historialclinico = '202310240006-211';
    
--2. Eliminacon del registro en 'HISTORIALESCLINICOS'
DELETE FROM HISTORIALESCLINICOS
    WHERE REGISTRO = '202310240006-211';
    
--3. Visualizacion de tablas despues de la eliminacion
SELECT * FROM HISTORIALESCLINICOS
    WHERE registro = '202310240006-211';
SELECT * FROM USAMEDICAMENTOS
    WHERE historialclinico = '202310240006-211';
    
--Prueba eliminacion de empleado 

--(FK_USAMEDICAMENTOS_EMPLEADOS)
--1. Visualizacion de tablas antes de la eliminacion
SELECT * FROM EMPLEADOS
    WHERE id = 'CCA4321098765';
SELECT * FROM USAMEDICAMENTOS
    WHERE empleado = 'CCA4321098765';
    
--2. Eliminacon del registro en 'EMPLEADOS'
DELETE FROM EMPLEADOS
    WHERE id = 'CCA4321098765';
    
--3. Visualizacion de tablas despues de la eliminacion
SELECT * FROM EMPLEADOS
    WHERE id = 'CCA4321098765';
SELECT * FROM USAMEDICAMENTOS;
    
--Prueba eliminacion de profesional 

--(FK_FERTILIDADES_PROFESIONALES)
--(FK_HistorialesClinicos_Profesionales;)

--1. Visualizacion de tablas antes de la eliminacion
SELECT * FROM PROFESIONALES
    WHERE id = 'VE12577';
SELECT * FROM FERTILIDADES
    WHERE veterinario = 'VE12577';
SELECT * FROM HISTORIALESCLINICOS
    WHERE profesional = 'VE12577';
    
--2. Eliminacon del registro en 'PROFESIONALES'
DELETE FROM PROFESIONALES
    WHERE id = 'VE12577';
    
--3. Visualizacion de tablas despues de la eliminacion
SELECT * FROM PROFESIONALES
    WHERE id = 'VE12577';
SELECT * FROM FERTILIDADES;
SELECT * FROM HISTORIALESCLINICOS

COMMIT;




    