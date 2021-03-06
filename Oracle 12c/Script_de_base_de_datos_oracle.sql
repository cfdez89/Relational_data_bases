/*
    *	PROYECTO I
    *	AUTOR: CARLOS FERNANDEZ JIMENEZ
    *	CURSO: BASES DE DATOS 2
    *   DESCRIPCION: CODIGO FUENTE PARA ORACLE
*/


---GRANT "CONNECT" TO "FERNANDEZC";

--crear tablespace permanentes

/*
    *   DESCRIPCION: TABLESPACE PARA DATOS
*/
CREATE TABLESPACE FERNANDEZC_TBL
	DATAFILE 'FERNANDEZC_TBL.dbf' 
	SIZE 20M
	AUTOEXTEND OFF
	BLOCKSIZE 8K
	ONLINE;

/*
    *   DESCRIPCION: TABLESPACE PARA INDICES
*/
CREATE TABLESPACE FERNANDEZC_IDX
	DATAFILE 'FERNANDEZC_IDX.dbf' 
	SIZE 20M
	AUTOEXTEND OFF
	BLOCKSIZE 8K
	ONLINE;

DROP TABLESPACE FERNANDEZC_IDX INCLUDING contents and datafiles

--ALTER TABLE FERNANDEZC.REGION
--DROP CONSTRAINT ID_REGION_PK
--DROP TABLE FERNANDEZC.REGION



--CREAR LA TABLA REGION
CREATE TABLE FERNANDEZC.REGION
(
	ID_REGION INT NOT NULL,
	NOMBRE_REGION VARCHAR2(100) NOT NULL
)
CREATE UNIQUE INDEX FERNANDEZC.ID_REGION_IDX ON FERNANDEZC.REGION (ID_REGION) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.REGION ADD CONSTRAINT ID_REGION_PK PRIMARY KEY(ID_REGION) USING INDEX FERNANDEZC.ID_REGION_IDX;

--CREAR LA TABLA PAIS
CREATE TABLE FERNANDEZC.PAIS
(
	ID_PAIS INT NOT NULL,
	NOMBRE_PAIS VARCHAR2(100) NOT NULL,
	ID_REGION INT NOT NULL,
  	FOREIGN KEY(ID_REGION) REFERENCES FERNANDEZC.REGION(ID_REGION)
)
CREATE UNIQUE INDEX FERNANDEZC.ID_PAIS_IDX ON FERNANDEZC.PAIS(ID_PAIS) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.PAIS ADD CONSTRAINT ID_PAIS_PK PRIMARY KEY(ID_PAIS) USING INDEX FERNANDEZC.ID_PAIS_IDX;

--CREAR LA TABLA LOCALIZACION
CREATE TABLE FERNANDEZC.LOCALIZACION
(
	ID_LOCALIZACION INT NOT NULL,
	DIRECCION VARCHAR2(320) NOT NULL,
	CODIGO_POSTAL VARCHAR2(60) NOT NULL,
	CIUDAD VARCHAR2(100) NOT NULL,
	PROVINCIA VARCHAR2(100) NOT NULL,
	ID_PAIS INT NOT NULL,
  	FOREIGN KEY(ID_PAIS) REFERENCES  FERNANDEZC.PAIS(ID_PAIS)
)
CREATE UNIQUE INDEX FERNANDEZC.ID_LOCALIZACION_IDX ON FERNANDEZC.LOCALIZACION (ID_LOCALIZACION) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.LOCALIZACION ADD CONSTRAINT ID_LOCALIZACION_PK PRIMARY KEY(ID_LOCALIZACION) USING INDEX FERNANDEZC.ID_LOCALIZACION_IDX;

--CREAR LA TABLA DEPARTAMENTO
CREATE TABLE FERNANDEZC.DEPARTAMENTO
(
	ID_DEPARTAMENTO INT NOT NULL,
	NOMBRE_DEPARTAMENTO VARCHAR2(100) NOT NULL,
	ID_GERENTE INT,
	ID_LOCALIZACION INT NOT NULL,
  	FOREIGN KEY(ID_LOCALIZACION) REFERENCES FERNANDEZC.LOCALIZACION(ID_LOCALIZACION)
)
CREATE UNIQUE INDEX FERNANDEZC.ID_DEPARTAMENTO_IDX ON FERNANDEZC.DEPARTAMENTO (ID_DEPARTAMENTO) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.DEPARTAMENTO ADD CONSTRAINT ID_DEPARTAMENTO_PK PRIMARY KEY(ID_DEPARTAMENTO) USING INDEX FERNANDEZC.ID_DEPARTAMENTO_IDX;

--CREAR LA TABLA PUESTO
CREATE TABLE FERNANDEZC.PUESTO
(
	ID_PUESTO INT NOT NULL,
	TITULO_PUESTO VARCHAR2(100) NOT NULL,
	SALARIO_MIN DECIMAL(18,2) NOT NULL,
  	SALARIO_MAX DECIMAL(18,2) NOT NULL
)
CREATE UNIQUE INDEX FERNANDEZC.ID_PUESTO_IDX ON FERNANDEZC.PUESTO (ID_PUESTO) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.PUESTO ADD CONSTRAINT ID_PUESTO_PK PRIMARY KEY(ID_PUESTO) USING INDEX FERNANDEZC.ID_PUESTO_IDX;
 
--CREAR LA TABLA EMPLEADO
CREATE TABLE FERNANDEZC.EMPLEADO
(
	ID_EMPLEADO INT NOT NULL,
	NOMBRE VARCHAR2(100) NOT NULL,
	APELLIDO VARCHAR2(100) NOT NULL,
	EMAIL VARCHAR2(100) NOT NULL,
	TELEFONO VARCHAR2(100) NOT NULL,
	FECHA_CONTRATACION DATE NOT NULL,
	SALARIO DECIMAL(18,2) NOT NULL,
	POR_COMISION FLOAT NOT NULL,
	ID_PUESTO INT NOT NULL,
	ID_GERENTE INT,
	ID_DEPARTAMENTO INT NOT NULL
)
CREATE UNIQUE INDEX FERNANDEZC.ID_EMPLEADO_IDX ON FERNANDEZC.EMPLEADO (ID_EMPLEADO) 
TABLESPACE FERNANDEZC_IDX;
ALTER TABLE FERNANDEZC.EMPLEADO ADD CONSTRAINT ID_EMPLEADO_PK PRIMARY KEY(ID_EMPLEADO) USING INDEX FERNANDEZC.ID_EMPLEADO_IDX;
 
ALTER TABLE FERNANDEZC.EMPLEADO ADD CONSTRAINT ID_PUESTO_FK FOREIGN KEY(ID_PUESTO) REFERENCES FERNANDEZC.PUESTO(ID_PUESTO);
ALTER TABLE FERNANDEZC.EMPLEADO ADD CONSTRAINT ID_GERENTE_FK FOREIGN KEY(ID_GERENTE) REFERENCES FERNANDEZC.EMPLEADO(ID_EMPLEADO);
ALTER TABLE FERNANDEZC.EMPLEADO ADD CONSTRAINT ID_DEPARTAMENTO_FK FOREIGN KEY(ID_DEPARTAMENTO) REFERENCES FERNANDEZC.DEPARTAMENTO(ID_DEPARTAMENTO);

--CREAR LA TABLA HISTORIAL PUESTO
CREATE TABLE FERNANDEZC.HISTORIAL_PUESTO
(
	ID_EMPLEADO INT NOT NULL, 
	FECHA_INICIO DATE NOT NULL,
	ID_PUESTO INT NOT NULL,
	ID_DEPARTAMENTO INT NOT NULL
)
ALTER TABLE FERNANDEZC.HISTORIAL_PUESTO ADD CONSTRAINT ID_EMPLEADO_FK FOREIGN KEY(ID_EMPLEADO) REFERENCES FERNANDEZC.EMPLEADO(ID_EMPLEADO);
ALTER TABLE FERNANDEZC.HISTORIAL_PUESTO ADD CONSTRAINT ID_PUESTO_FK_IDX FOREIGN KEY(ID_PUESTO) REFERENCES FERNANDEZC.PUESTO(ID_PUESTO);
ALTER TABLE FERNANDEZC.HISTORIAL_PUESTO ADD CONSTRAINT ID_DEPARTAMENTO_FK_IDX FOREIGN KEY(ID_DEPARTAMENTO) REFERENCES FERNANDEZC.DEPARTAMENTO(ID_DEPARTAMENTO);