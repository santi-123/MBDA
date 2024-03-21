CREATE INDEX IPartos
ON ANIMALES(parto);

CREATE INDEX IHembraActiva_Fertilidades
ON FERTILIDADES(hembraActiva, propietarioHembraActiva);

CREATE INDEX IHistorialesClinicos
ON USAMEDICAMENTOS(historialClinico);

CREATE INDEX IMedicamento
ON USAMEDICAMENTOS(medicamento);

CREATE INDEX IAnimales_HistorialesClinicos
ON HISTORIALESCLINICOS(animal, propietarioAnimal);