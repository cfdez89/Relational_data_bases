/*
	*	PROYECTO I
    *	AUTOR: CARLOS FERNANDEZ JIMENEZ
	*	CURSO: BASES DE DATOS 2
	*   DESCRIPCION: CODIGO FUENTE PARA ORACLE
*/

/*
	*   DESCRIPCION: Despliegue	todos	los	años	donde	más	de	15	empleados	hayan	entrado	a	la compañía.
*/
CREATE PROCEDURE SP_CONSULTA_1
AS
DECLARE numeroAnnos INT;
BEGIN
	SET numeroAnnos := 15;
    SELECT TOP 1 H.FECHA_INICIO AS FECHA FROM EMPLEADO AS E
    INNER JOIN HISTORIAL_PUESTO AS H
	ON H.ID_EMPLEADO = E.ID_EMPLEADO
	GROUP BY H.FECHA_INICIO
	HAVING COUNT(H.FECHA_INICIO) > numeroAnnos
END;

/*
	*   DESCRIPCION: Despliegue	todos	los	departamentos	donde	haya	al	menos	un	empleado	que	reciba	comisiones.
*/
CREATE PROCEDURE SP_CONSULTA_2
AS
BEGIN
	SELECT D.NOMBRE_DEPARTAMENTO FROM EMPLEADO AS E
	INNER JOIN DEPARTAMENTO AS D
	ON D.ID_DEPARTAMENTO = E.ID_DEPARTAMENTO
	GROUP BY D.NOMBRE_DEPARTAMENTO
	HAVING SUM(E.POR_COMISION) = 0;
END;

/*
	*   DESCRIPCION: Despliegue	todos	los	empleados	que	hayan	cambiado	de	puesto	en	el	último	año.
*/
CREATE PROCEDURE SP_CONSULTA_3
AS
BEGIN
	SELECT DISTINCT NOMBRE 
	FROM (SELECT E.ID_EMPLEADO, COUNT(ID_EMPLEADO) FROM HISTORIAL_PUESTO 
		  INNER JOIN EMPLEADO AS E 
		  ON H.ID_EMPLEADO = E.ID_EMPLEADO
          WHERE H.FECHA_INICIO BETWEEN ADD_MONTHS(CURRENT_DATE,-120) AND CURRENT_DATE
          GROUP BY E.ID_EMPLEADO)
    WHERE Cantidad_Puestos > 1) 
    INNER JOIN EMPLEADO 
    ON ID_DEL_EMPLEADO = E.ID_EMPLEADO;
END;

/*
	*   DESCRIPCION: Despliegue	por	empleado	la	cantidad	de	días	que	lleva	haciendo	el	trabajo	actual.
*/
CREATE PROCEDURE SP_CONSULTA_4
AS
BEGIN
	SELECT E.NOMBRE, E.APELLIDO, (CURRENT_DATE - FECHA) AS DIAS
    FROM (SELECT E.ID_EMPLEADO AS E_AUX, MAX(H.FECHA_INICIO) AS FECHA
    FROM EMPLEADO 
    INNER JOIN HISTORIAL_PUESTO AS H
    ON H.ID_EMPLEADO = E.ID_EMPLEADO
    GROUP BY (E.ID_EMPLEADO)) 
    INNER JOIN EMPLEADO 
    ON E_AUX = E.ID_EMPLEADO 
    ORDER BY (E.ID_EMPLEADO) ASC;
END;

/*
	*   DESCRIPCION: Despliegue	el	salario	promedio	para	todos	los	empleados	que	reciben	comisiones.
*/

CREATE PROCEDURE SP_CONSULTA_5
AS
BEGIN
	SELECT AVG(E.SALARIO) AS SALARIO_PROMEDIO 
	FROM EMPLEADO AS E
	WHERE E.POR_COMISION > 0;
END;

/*
	*   DESCRIPCION: Despliegue	todos	los	empleados	que	llevan	más	de	un	año	trabajando	y	su	salario	sea	más	de	10000.
*/
CREATE PROCEDURE SP_CONSULTA_6
AS
DECLARE salario DECIMAL(18,2);
BEGIN
	SET salario := 10000;
	SELECT TOP 1 E.NOMBRE, E.APELLIDO FROM EMPLEADO AS E
    INNER JOIN HISTORIAL_PUESTO AS H
	ON H.ID_EMPLEADO = E.ID_EMPLEADO
	WHERE (E.SALARIO > salario)  AND ((CURRENT_DATE - H.FECHA_INICIO) >= 365);
END;

/*
	*   DESCRIPCION: Despliegue	todos	los	trabajos	para	los	cuales	se	contrató	personal	en	el	último	año.
*/
CREATE PROCEDURE SP_CONSULTA_7
AS
BEGIN
    SELECT  DISTINCT P.TITULO_PUESTO AS TRABAJO FROM EMPLEADO AS E
	INNER JOIN PUESTO AS P
	ON P.ID_PUESTO = E.ID_PUESTO
	INNER JOIN HISTORIAL_PUESTO AS H
	ON H.ID_EMPLEADO = E.ID_EMPLEADO
	WHERE ((CURRENT_DATE - H.FECHA_INICIO) <= 365)
	ORDER BY P.TITULO_PUESTO;
END;

/*
	*   DESCRIPCION: Despliegue	toda	la	localización	geográfica,	país,	ciudad	y	departamento,	
	*                para	aquellos departamentos	que	tienen	más	de	10	empleados.
*/
CREATE PROCEDURE SP_CONSULTA_8
AS
DECLARE cantidad INT;
BEGIN
   
	SET cantidad := 10;
    SELECT DISTINCT  D.NOMBRE_DEPARTAMENTO, P.NOMBRE_PAIS, R.NOMBRE_REGION, L.DIRECCION, L.PROVINCIA, L.CIUDAD FROM EMPLEADO AS E
    INNER JOIN DEPARTAMENTO AS D
    ON D.ID_DEPARTAMENTO = E.ID_DEPARTAMENTO
    INNER JOIN lOCALIZACION AS L
    ON L.ID_LOCALIZACION = D.ID_LOCALIZACION
    INNER JOIN PAIS AS P
    ON P.ID_PAIS = L.ID_PAIS
    INNER JOIN REGION AS R
    ON R.ID_REGION = P.ID_REGION
	WHERE (SELECT COUNT(E_AUX.ID_EMPLEADO) FROM EMPLEADO AS E_AUX
	       WHERE E_AUX.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO) > cantidad;
END;

/*
	*   DESCRIPCION: Despliegue	todas	las	personas	que	tienen	al	menos	10	personas	a	cargo.
*/
CREATE PROCEDURE SP_CONSULTA_9
AS
DECLARE cantidad INT;
BEGIN
	SET cantidad := 10;
	SELECT DISTINCT E.NOMBRE, E.APELLIDO AS GERENTE FROM EMPLEADO AS E
	INNER JOIN EMPLEADO AS G
	ON G.ID_GERENTE = E.ID_EMPLEADO
	WHERE (SELECT COUNT(E_AUX.ID_EMPLEADO) 
		   FROM EMPLEADO AS E_AUX 
		   WHERE E_AUX.ID_GERENTE = E.ID_EMPLEADO) > cantidad;
END;

-----------------------------------------------------------------------------------------------------------------------------------------
/*
	*   DESCRIPCION: Intercambie	los	salarios	de	los	empleados	110	y	120.
*/
CREATE PROCEDURE SP_CONSULTA_1A
AS
BEGIN
	DECLARE salarioEmp_1 DECIMAL(18,2);
	DECLARE salarioEmp_2 DECIMAL(18,2);
	DECLARE numEmpleado_1 INT;
	DECLARE numEmpleado_2 INT;
	SET numEmpleado_1 := 110;
	SET numEmpleado_2 := 120;

	SELECT E.SALARIO INTO salarioEmp_1  FROM EMPLEADO AS E WHERE ID_EMPLEADO = numEmpleado_1;
    SELECT E.SALARIO INTO salarioEmp_2 FROM EMPLEADO AS E WHERE ID_EMPLEADO = numEmpleado_2;

    UPDATE EMPLEADO
    SET SALARIO := salarioEmp_2
	WHERE ID_EMPLEADO = numEmpleado_1; 

	UPDATE EMPLEADO
	SET SALARIO := salarioEmp_1
	WHERE ID_EMPLEADO = numEmpleado_2; 
END

/*
	*   DESCRIPCION: Incremente	el	salario	del	empleado	115,	si	ha	trabajado	en	la	empresa	más	de	15	años,	
	*   incremente en	20%,	más	de	10	años,	10%,	en	cualquier	otro	caso	5%.
*/
CREATE PROCEDURE SP_CONSULTA_2A
AS
DECLARE @salarioEmp DECIMAL(18,2);
DECLARE numEmpleado INT;
DECLARE numAnnos INT;
DECLARE idEmpleado INT;
DECLARE fechaIngreso DATE;
BEGIN
    SET numEmpleado := 115;
    SELECT TOP 1 H.FECHA_INICIO  INTO fechaIngreso  
    FROM HISTORIAL_PUESTO AS H
    WHERE H.ID_EMPLEADO = @idEmpleado;

    SET numAnnos := (DATEDIFF(YEAR, GETDATE(), fechaIngreso));
    SELECT E.SALARIO INTO salarioEmp 
    FROM EMPLEADO AS E 
    WHERE ID_EMPLEADO = numEmpleado;

    IF (numAnnos > 15)
    	SET salarioEmp := salarioEmp + ((20*salarioEmp)/100);
    IF (numAnnos > 10)
    	SET salarioEmp := salarioEmp + ((10*salarioEmp)/100);
    ELSE
    	SET salarioEmp := salarioEmp + ((5*salarioEmp)/100);

	UPDATE EMPLEADO
	SET SALARIO := salarioEmp
	WHERE ID_EMPLEADO = numEmpleado; 
END

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	los	números	de	empleado	que	no	han	sido	asignados.
*/
CREATE PROCEDURE SP_CONSULTA_3A
AS
BEGIN
   FOR cursor_tmp IN (SELECT ID_EMPLEADO FROM EMPLEADO WHERE ID_PUESTO IS NULL) LOOP       
   dbms_output.put_line(TO_CHAR(cursor_tmp.ID_EMPLEADO) || ' ');
   END LOOP;
END;

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	todos	los	empleados	que	fueron	los	primeros	en	ocupar
    *   un	puesto,	junto	con	qué	puesto	y	la	fecha	en	que	iniciaron.
*/
CREATE PROCEDURE SP_CONSULTA_5A
AS
BEGIN
	 FOR cursor_tmp IN (SELECT E.NOMBRE, E.APELLIDO, P.TITULO_PUESTO, MIN(E.FECHA_CONTRATACION) AS FECHA FROM EMPLEADO AS E 
	                    INNER JOIN PUESTO AS P
	                    ON P.ID_PUESTO = E.ID_PUESTO
	                    GROUP BY E.NOMBRE, E.APELLIDO, P.TITULO_PUESTO
	                    ORDER BY E.NOMBRE;)
	 LOOP       
     dbms_output.put_line(cursor_tmp.NOMBRE || cursor_tmp.APELLIDO || TO_CHAR(cursor_tmp.FECHA) || ' ');
     END LOOP;
  
END;

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	el	empleado	20	y	el	100	de	la	tabLa	de	empleados.
*/
CREATE PROCEDURE SP_CONSULTA_6A
AS
DECLARE numEmpleado_1 INT;
DECLARE numEmpleado_2 INT;
DECLARE nombre_1 VARCHAR(100);
DECLARE nombre_2 VARCHAR(100);
DECLARE apellido_1 VARCHAR(100);
DECLARE apellido_2 VARCHAR(100);
DECLARE email_1 VARCHAR(100);
DECLARE email_2 VARCHAR(100);
DECLARE telefono_1 VARCHAR(100);
DECLARE telefono_2 VARCHAR(100);
DECLARE fecha_1 DATE;
DECLARE fecha_2 DATE;
DECLARE puesto_1 VARCHAR(100);
DECLARE puesto_2 VARCHAR(100);
DECLARE salario_1 DECIMAL(18,2);
DECLARE salario_2 DECIMAL(18,2);
BEGIN
	SET numEmpleado_1 := 20;
	SET numEmpleado_2 := 100;

    SELECT E.NOMBRE INTO nombre_1 
    FROM EMPLEADO AS E
    WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.NOMBRE INTO nombre_2 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_2;

    SELECT E.APELLIDO INTO apellido_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.APELLIDO INTO apellido_2 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_2;

    SELECT E.EMAIL INTO email_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.EMAIL INTO email_2 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_2;

    SELECT E.TELEFONO INTO telefono_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.TELEFONO INTO telefono_2
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_2;

    SELECT E.FECHA_CONTRATACION INTO fecha_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.FECHA_CONTRATACION INTO fecha_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT P.TITULO_PUESTO INTO puesto_1 
    FROM EMPLEADO AS E
	INNER JOIN PUESTO AS P
    ON P.ID_PUESTO = E.ID_PUESTO
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT P.TITULO_PUESTO INTO puesto_2
    FROM EMPLEADO AS E
	INNER JOIN PUESTO AS P
	ON P.ID_PUESTO = E.ID_PUESTO
	WHERE ID_EMPLEADO = @numEmpleado_1);
    SELECT E.SALARIO INTO salario_1 
    FROM EMPLEADO AS E
	WHERE ID_EMPLEADO = @numEmpleado_1;

    SELECT E.SALARIO salario_2 
    FROM EMPLEADO AS E
    WHERE ID_EMPLEADO = @numEmpleado_1;

    dbms_output.put_line('NOMBRE: '||nombre_1||apellido_1||' CORREO: '||@email_1||' TELEFONO: '||telefono_1||' FECHA: '||to_char(@fecha_1));
    dbms_output.put_line('NOMBRE: '||nombre_2||apellido_2||' CORREO: '||@email_2||' TELEFONO: '||telefono_2||' FECHA: '||to_char(@fecha_2));
END;

/*
	*   DESCRIPCION: Cree	una	función	que	tome	el	identificador	del	departamento	y	retorne	el	nombre	del	manager	del
    *   departamento.
*/
CREATE FUNCTION FN_CONSULTA_7A
(
	pIdentificador INT
)
RETURNS VARCHAR(100)
AS
DECLARE nombre VARCHAR(100);
DECLARE idEmpleado INT;
BEGIN
	
	SELECT D.ID_GERENTE INTO idEmpleado FROM DEPARTAMENTO AS D
	                                    WHERE D.ID_DEPARTAMENTO = pIdentificador;
	SELECT E.NOMBRE INTO nombre FROM EMPLEADO AS E
	                            WHERE E.ID_EMPLEADO = idEmpleado;
	RETURN nombre;
END;

/*
	*   DESCRIPCION: Cree	una	función	que	tome	el	identificador	del	empleado	y	retorne	cuentos	puestos	
	*   ha	tenido	en	la compañía.
*/
CREATE FUNCTION FN_CONSULTA_8A
(
	pIdentificador INT
)
RETURNS VARCHAR(100)
AS
DECLARE numPuestos INT;
BEGIN
	SELECT COUNT(H.ID_EMPLEADO) INTO numPuestos FROM H.HISTORIAL_PUESTO AS H
	                                            WHERE H.ID_EMPLEADO = pIdentificador;
	SET numPuestos := numPuestos + 1;

	RETURN numPuestos;
END;

/*
	*   DESCRIPCION: Cree	un	procedimiento	que	tome	el	identificador	un	departamento	y	cambie	al	manager	por	el
    *   empleado	con	mayor	salario	dentro	del	departamento.
*/
CREATE PROCEDURE SP_CONSULTA_9A
(
	pIdentificador INT
)
AS
DECLARE idEmpleado INT;
DECLARE idGerente INT;
BEGIN
   
    SELECT TOP 1 E.ID_EMPLEADO INTO idEmpleado 
    FROM EMPLEADO AS E
    INNER JOIN DEPARTAMENTO AS D
    ON D.ID_DEPARTAMENTO = pIdentificador
    ORDER BY E.SALARIO DESC
    SELECT D.ID_GERENTE INTO idGerente 
    FROM DEPARTAMENTO AS D
   	WHERE D.ID_DEPARTAMENTO = pIdentificador;
	UPDATE DEPARTAMENTO
	SET ID_GERENTE := idEmpleado
	WHERE ID_GERENTE = idGerente;  
END

/*
	*   DESCRIPCION: Cree	un	procedimiento	que	tome	el	identificador	un	departamento	y	cambie	al	manager	por	el
    *   empleado	con	mayor	salario	dentro	del	departamento.
*/
CREATE PROCEDURE SP_CONSULTA_9A
(
	pIdentificador INT
)
AS
DECLARE idEmpleado INT;
DECLARE idGerente INT;
BEGIN
    SELECT TOP 1 E.ID_EMPLEADO INTO idEmpleado 
    FROM EMPLEADO AS E
    INNER JOIN DEPARTAMENTO AS D
    ON D.ID_DEPARTAMENTO = pIdentificador
   	ORDER BY E.SALARIO DESC;
    SELECT D.ID_GERENTE INTO idGerente 
    FROM DEPARTAMENTO AS D
   	WHERE D.ID_DEPARTAMENTO = pIdentificador;

	UPDATE DEPARTAMENTO
	SET ID_GERENTE   := idEmpleado;
	WHERE ID_GERENTE := idGerente;   
END

/*
	*   DESCRIPCION: Cree	un	procedimiento	que	tome	el	identificador	del	departamento	y	retorne	todos	los	empleados
    *   separados	por	coma	en	un	solo	string.
*/
CREATE PROCEDURE SP_CONSULTA_10A
(
	pIdentificador INT
)
AS
BEGIN
   FOR cursor_tmp IN (SELECT E.NOMBRE FROM EMPLEADO AS E
	                  INNER JOIN DEPARTAMENTO AS D 
	                  ON D.ID_DEPARTAMENTO = E.ID_DEPARTAMENTO
	                  WHERE D.ID_DEPARTAMENTO = pIdentificador) 
   LOOP       
   dbms_output.put_line(cursor_tmp.NOMBRE || ' ');
   END LOOP;
END;



