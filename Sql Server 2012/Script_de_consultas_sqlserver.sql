/*
	*	PROYECTO I
    *	AUTOR: CARLOS FERNANDEZ JIMENEZ
	*	CURSO: BASES DE DATOS 2
	*   DESCRIPCION: CODIGO FUENTE PARA SQL SERVER
*/


/*
	*   DESCRIPCION: Despliegue	todos	los	años	donde	más	de	15	empleados	hayan	entrado	a	la compañía.
*/
GO
CREATE PROCEDURE SP_CONSULTA_1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE numeroAnnos INT;
	SET numeroAnnos = 15;
	BEGIN TRY
        SELECT TOP 1 H.FECHA_INICIO AS FECHA FROM EMPLEADO AS E
		INNER JOIN HISTORIAL_PUESTO AS H
		ON H.ID_EMPLEADO = E.ID_EMPLEADO
		GROUP BY H.FECHA_INICIO
		HAVING COUNT(H.FECHA_INICIO) > @numeroAnnos

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	todos	los	departamentos	donde	haya	al	menos	un	empleado	que	reciba	comisiones.
*/
GO
CREATE PROCEDURE SP_CONSULTA_2
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT D.NOMBRE_DEPARTAMENTO FROM EMPLEADO AS E
		INNER JOIN DEPARTAMENTO AS D
		ON D.ID_DEPARTAMENTO = E.ID_DEPARTAMENTO
		GROUP BY D.NOMBRE_DEPARTAMENTO
		HAVING SUM(E.POR_COMISION) = 0;

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	todos	los	empleados	que	hayan	cambiado	de	puesto	en	el	último	año.
*/
GO
CREATE PROCEDURE SP_CONSULTA_3
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT DISTINCT E.NOMBRE FROM EMPLEADO AS E
		INNER JOIN HISTORIAL_PUESTO AS H
		ON H.ID_EMPLEADO = E.ID_EMPLEADO
		WHERE DATEDIFF(YEAR, E.FECHA_CONTRATACION, GETDATE()) = 0;

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	el	salario	promedio	para	todos	los	empleados	que	reciben	comisiones.
*/
GO
CREATE PROCEDURE SP_CONSULTA_5
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT AVG(E.SALARIO) AS SALARIO_PROMEDIO 
		FROM EMPLEADO AS E
		WHERE E.POR_COMISION > 0;
		
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	todos	los	empleados	que	llevan	más	de	un	año	trabajando	y	su	salario	sea	más	de	10000.
*/
GO
CREATE PROCEDURE SP_CONSULTA_6
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @salario MONEY;
	SET @salario = 10000;
	SELECT TOP 1 E.NOMBRE, E.APELLIDO FROM EMPLEADO AS E
    INNER JOIN HISTORIAL_PUESTO AS H
	ON H.ID_EMPLEADO = E.ID_EMPLEADO
	WHERE (E.SALARIO > @salario)  AND (DATEDIFF(YEAR, H.FECHA_INICIO, GETDATE()) > 1) 
	                              AND (DATEDIFF(MONTH, H.FECHA_INICIO, GETDATE()) >= (DATEPART(MONTH,H.FECHA_INICIO))) 
	                              AND (DATEDIFF(DAY, H.FECHA_INICIO, GETDATE()) > (DATEPART(DAY,H.FECHA_INICIO)));
		
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	todos	los	trabajos	para	los	cuales	se	contrató	personal	en	el	último	año.
*/
GO
CREATE PROCEDURE SP_CONSULTA_7
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
    SELECT  DISTINCT P.TITULO_PUESTO AS TRABAJO FROM EMPLEADO AS E
	INNER JOIN PUESTO AS P
	ON P.ID_PUESTO = E.ID_PUESTO
	INNER JOIN HISTORIAL_PUESTO AS H
	ON H.ID_EMPLEADO = E.ID_EMPLEADO
	WHERE DATEDIFF(YEAR, H.FECHA_INICIO, GETDATE()) = 0
	ORDER BY P.TITULO_PUESTO;

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	toda	la	localización	geográfica,	país,	ciudad	y	departamento,	
	*                para	aquellos departamentos	que	tienen	más	de	10	empleados.
*/
GO
CREATE PROCEDURE SP_CONSULTA_8
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
    DECLARE @cantidad INT;
	SET @cantidad = 10;
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
	       WHERE E_AUX.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO) > @cantidad;


	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	todas	las	personas	que	tienen	al	menos	10	personas	a	cargo.
*/
GO
CREATE PROCEDURE SP_CONSULTA_9
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @cantidad INT;
	SET @cantidad = 10;
	SELECT DISTINCT E.NOMBRE, E.APELLIDO AS GERENTE FROM EMPLEADO AS E
	INNER JOIN EMPLEADO AS G
	ON G.ID_GERENTE = E.ID_EMPLEADO
	WHERE (SELECT COUNT(E_AUX.ID_EMPLEADO) 
		   FROM EMPLEADO AS E_AUX 
		   WHERE E_AUX.ID_GERENTE = E.ID_EMPLEADO) > @cantidad;

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO
-----------------------------------------------------------------------------------------------------------------------------------------
/*
	*   DESCRIPCION: Intercambie	los	salarios	de	los	empleados	110	y	120.
*/
GO
CREATE PROCEDURE SP_CONSULTA_1A
AS
BEGIN
	SET NOCOUNT ON;
	-- Variables para control de transaccion
	DECLARE @errorNumber INT, @errorSeverity INT, @errorState INT, @customError INT;
	DECLARE @message VARCHAR(200);
	DECLARE @inicieTransaccion BIT;
	-- Variables necesarias del sp
	DECLARE @salarioEmp_1 MONEY;
	DECLARE @salarioEmp_2 MONEY;
	DECLARE @numEmpleado_1 INT;
	DECLARE @numEmpleado_2 INT;
	SET @numEmpleado_1 = 110;
	SET @numEmpleado_2 = 120;
    -- Operaciones de lectura posibles y precalculos
	SET @salarioEmp_1 = (SELECT E.SALARIO FROM EMPLEADO AS E WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @salarioEmp_2 = (SELECT E.SALARIO FROM EMPLEADO AS E WHERE ID_EMPLEADO = @numEmpleado_2);
    -- Control de transacciones
    SET @inicieTransaccion = 0 
	IF @@TRANCOUNT=0 BEGIN
		SET @inicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END;
	-- Control de excepciones
	BEGIN TRY 
		-- Aca mi codigo de transaccion	
        UPDATE EMPLEADO
		SET SALARIO = @salarioEmp_2
		WHERE ID_EMPLEADO = @numEmpleado_1; 

		UPDATE EMPLEADO
		SET SALARIO = @salarioEmp_1
		WHERE ID_EMPLEADO = @numEmpleado_2; 

		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END;	
	END TRY
	BEGIN CATCH
		SET @errorNumber = ERROR_NUMBER()
		SET @errorSeverity = ERROR_SEVERITY()
		SET @errorState = ERROR_STATE()
		SET @message = ERROR_MESSAGE()
		
		IF @inicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', @errorSeverity, @errorState, @message, @customError);
	END CATCH;
  
END
  RETURN 0	
GO

/*
	*   DESCRIPCION: Incremente	el	salario	del	empleado	115,	si	ha	trabajado	en	la	empresa	más	de	15	años,	
	*   incremente en	20%,	más	de	10	años,	10%,	en	cualquier	otro	caso	5%.
*/
GO
CREATE PROCEDURE SP_CONSULTA_2A
AS
BEGIN
	SET NOCOUNT ON;
	-- Variables para control de transaccion
	DECLARE @errorNumber INT, @errorSeverity INT, @errorState INT, @customError INT;
	DECLARE @message VARCHAR(200);
	DECLARE @inicieTransaccion BIT;
	-- Variables necesarias del sp
	DECLARE @salarioEmp MONEY;
	DECLARE @numEmpleado INT;
	DECLARE @numAnnos INT;
    DECLARE @idEmpleado INT;
	DECLARE @fechaIngreso DATE;
    -- Operaciones de lectura posibles y precalculos
    SET @numEmpleado = 115;

    IF EXISTS(SELECT TOP 1 H.FECHA_INICIO FROM HISTORIAL_PUESTO AS H
             WHERE @idEmpleado IN(SELECT H_AUX.ID_EMPLEADO FROM HISTORIAL_PUESTO AS H_AUX)) 
    	SET @fechaIngreso = (SELECT TOP 1 H.FECHA_INICIO FROM HISTORIAL_PUESTO AS H
                             WHERE H.ID_EMPLEADO = @idEmpleado);
    ELSE
    	SET @fechaIngreso = (SELECT E.FECHA_CONTRATACION FROM EMPLEADO AS E
                             WHERE E.ID_EMPLEADO = @idEmpleado);

    SET @numAnnos = (DATEDIFF(YEAR, GETDATE(), @fechaIngreso));
    SET @salarioEmp = (SELECT E.SALARIO FROM EMPLEADO AS E WHERE ID_EMPLEADO = @numEmpleado);

    IF (@numAnnos > 15)
    	SET @salarioEmp = @salarioEmp + ((20*@salarioEmp)/100);
    IF (@numAnnos > 10)
    	SET @salarioEmp = @salarioEmp + ((10*@salarioEmp)/100);
    ELSE
    	SET @salarioEmp = @salarioEmp + ((5*@salarioEmp)/100);

    -- Control de transacciones
    SET @inicieTransaccion = 0 
	IF @@TRANCOUNT=0 BEGIN
		SET @inicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END;
	-- Control de excepciones
	BEGIN TRY 
		-- Aca mi codigo de transaccion
		UPDATE EMPLEADO
		SET SALARIO = @salarioEmp
		WHERE ID_EMPLEADO = @numEmpleado; 

		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END;	
	END TRY
	BEGIN CATCH
		SET @errorNumber = ERROR_NUMBER()
		SET @errorSeverity = ERROR_SEVERITY()
		SET @errorState = ERROR_STATE()
		SET @message = ERROR_MESSAGE()
		
		IF @inicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', @errorSeverity, @errorState, @message, @customError);
	END CATCH;
  
END
  RETURN 0	
GO

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	los	números	de	empleado	que	no	han	sido	asignados.
*/
GO
CREATE PROCEDURE SP_CONSULTA_3A
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @message VARCHAR(5000);
	DECLARE @numero INT;

	DECLARE numeroCursor CURSOR FOR 
	SELECT E.ID_EMPLEADO FROM EMPLEADO AS E
	WHERE E.ID_PUESTO IS NULL;

	OPEN numeroCursor
	FETCH NEXT FROM numeroCursor
	INTO @numero
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @message = CONCAT(@message, CAST(@numero AS VARCHAR));
		FETCH NEXT FROM nombreCursor
		INTO @numero

	END
	CLOSE numeroCursor
	DEALLOCATE numeroCursor
	PRINT @message;

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	todos	los	empleados	que	fueron	los	primeros	en	ocupar
    *   un	puesto,	junto	con	qué	puesto	y	la	fecha	en	que	iniciaron.
*/
GO
CREATE PROCEDURE SP_CONSULTA_5A
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @message VARCHAR(5000);
	DECLARE @nombre VARCHAR(100);
	DECLARE @apellido VARCHAR(100);
	DECLARE @puesto VARCHAR(100);
	DECLARE @fecha DATE;

	DECLARE nombreCursor CURSOR FOR 
    SELECT E.NOMBRE, E.APELLIDO, P.TITULO_PUESTO, MIN(E.FECHA_CONTRATACION) AS FECHA FROM EMPLEADO AS E 
	INNER JOIN PUESTO AS P
	ON P.ID_PUESTO = E.ID_PUESTO
	GROUP BY E.NOMBRE, E.APELLIDO, P.TITULO_PUESTO
	ORDER BY E.NOMBRE;

	OPEN nombreCursor
	FETCH NEXT FROM nombreCursor
	INTO @nombre, @apellido, @puesto, @fecha
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @message = CONCAT(@message, @nombre,' ', @apellido,' ', @puesto,' ', CAST(@fecha AS VARCHAR),',');
		FETCH NEXT FROM nombreCursor
		INTO @nombre, @apellido, @puesto, @fecha

	END
	CLOSE nombreCursor
	DEALLOCATE nombreCursor
	PRINT SUBSTRING(@message, 1, LEN(@message)-1);

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Despliegue	usando	dbms_output.put_line	el	empleado	20	y	el	100	de	la	tabLa	de	empleados.
*/
GO
CREATE PROCEDURE SP_CONSULTA_6A
AS
BEGIN--NO SE QUE QUIERE DECIR
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @numEmpleado_1 INT;
	DECLARE @numEmpleado_2 INT;
	DECLARE @nombre_1 VARCHAR(100);
	DECLARE @nombre_2 VARCHAR(100);
	DECLARE @apellido_1 VARCHAR(100);
	DECLARE @apellido_2 VARCHAR(100);
	DECLARE @email_1 VARCHAR(100);
	DECLARE @email_2 VARCHAR(100);
	DECLARE @telefono_1 VARCHAR(100);
	DECLARE @telefono_2 VARCHAR(100);
	DECLARE @fecha_1 DATE;
	DECLARE @fecha_2 DATE;
	DECLARE @puesto_1 VARCHAR(100);
	DECLARE @puesto_2 VARCHAR(100);
    DECLARE @salario_1 MONEY;
    DECLARE @salario_2 MONEY;

	SET @numEmpleado_1 = 20;
	SET @numEmpleado_2 = 100;
    SET @nombre_1   = (SELECT E.NOMBRE FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @nombre_2   = (SELECT E.NOMBRE FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_2);
    SET @apellido_1 = (SELECT E.APELLIDO FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @apellido_2 = (SELECT E.APELLIDO FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_2);
    SET @email_1    = (SELECT E.EMAIL FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @email_2    = (SELECT E.EMAIL FROM EMPLEADO AS E
	                   WHERE ID_EMPLEADO = @numEmpleado_2);
    SET @telefono_1 = (SELECT E.TELEFONO FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @telefono_2 = (SELECT E.TELEFONO FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_2);
    SET @fecha_1    = (SELECT E.FECHA_CONTRATACION FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @fecha_2    = (SELECT E.FECHA_CONTRATACION FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @puesto_1   = (SELECT P.TITULO_PUESTO FROM EMPLEADO AS E
	                   INNER JOIN PUESTO AS P
					   ON P.ID_PUESTO = E.ID_PUESTO
	                   WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @puesto_2   = (SELECT P.TITULO_PUESTO FROM EMPLEADO AS E
	                   INNER JOIN PUESTO AS P
					   ON P.ID_PUESTO = E.ID_PUESTO
	                   WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @salario_1  = (SELECT E.SALARIO FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_1);
    SET @salario_2  = (SELECT E.SALARIO FROM EMPLEADO AS E
	                         WHERE ID_EMPLEADO = @numEmpleado_1);

    PRINT 'NOMBRE: '+@nombre_1+' '+@apellido_1+' CORREO: '+@email_1+' TELEFONO: '+@telefono_1+' FECHA: '+ RTRIM(CAST(@fecha_1 AS VARCHAR))+
          ' PUESTO:'+@puesto_1+' SALARIO: '+ RTRIM(CAST(@salario_1 AS VARCHAR));
    PRINT 'NOMBRE: '+@nombre_2+' '+@apellido_2+' CORREO: '+@email_2+' TELEFONO: '+@telefono_2+' FECHA: '+ RTRIM(CAST(@fecha_2 AS VARCHAR))+
          ' PUESTO:'+@puesto_2+' SALARIO: '+ RTRIM(CAST(@salario_2 AS VARCHAR));

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Cree	una	función	que	tome	el	identificador	del	departamento	y	retorne	el	nombre	del	manager	del
    *   departamento.
*/
CREATE FUNCTION FN_CONSULTA_7A
(
	@pIdentificador INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @nombre VARCHAR(100);
	DECLARE @idEmpleado INT;
	SET @idEmpleado = (SELECT D.ID_GERENTE FROM DEPARTAMENTO AS D
	                   WHERE D.ID_DEPARTAMENTO = @pIdentificador);
	SET @nombre = (SELECT E.NOMBRE FROM EMPLEADO AS E
	               WHERE E.ID_EMPLEADO = @idEmpleado);

	RETURN @nombre;
END;
GO

/*
	*   DESCRIPCION: Cree	una	función	que	tome	el	identificador	del	empleado	y	retorne	cuentos	puestos	
	*   ha	tenido	en	la compañía.
*/
CREATE FUNCTION FN_CONSULTA_8A
(
	@pIdentificador INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @numPuestos INT;

	SET @numPuestos = (SELECT COUNT(H.ID_EMPLEADO) FROM H.HISTORIAL_PUESTO AS H
	                   WHERE H.ID_EMPLEADO = @pIdentificador);
	SET @numPuestos = @numPuestos + 1;

	RETURN @numPuestos;
END;
GO

/*
	*   DESCRIPCION: Cree	un	procedimiento	que	tome	el	identificador	un	departamento	y	cambie	al	manager	por	el
    *   empleado	con	mayor	salario	dentro	del	departamento.
*/
GO
CREATE PROCEDURE SP_CONSULTA_9A
(
	@pIdentificador INT
)
AS
BEGIN
	SET NOCOUNT ON;
	-- Variables para control de transaccion
	DECLARE @errorNumber INT, @errorSeverity INT, @errorState INT, @customError INT;
	DECLARE @message VARCHAR(200);
	DECLARE @inicieTransaccion BIT;
	-- Variables necesarias del sp


    DECLARE @idEmpleado INT;
    DECLARE @idGerente INT;

    -- Operaciones de lectura posibles y precalculos
   SET @idEmpleado = (SELECT TOP 1 E.ID_EMPLEADO FROM EMPLEADO AS E
                      INNER JOIN DEPARTAMENTO AS D
                      ON D.ID_DEPARTAMENTO = @pIdentificador
   	                  ORDER BY E.SALARIO DESC)
   SET @idGerente = (SELECT D.ID_GERENTE FROM DEPARTAMENTO AS D
   	                 WHERE D.ID_DEPARTAMENTO = @pIdentificador);

    -- Control de transacciones
    SET @inicieTransaccion = 0 
	IF @@TRANCOUNT=0 BEGIN
		SET @inicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END;
	-- Control de excepciones
	BEGIN TRY 
		-- Aca mi codigo de transaccion
		UPDATE DEPARTAMENTO
		SET ID_GERENTE = @idEmpleado
		WHERE ID_GERENTE = @idGerente; 

		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END;	
	END TRY
	BEGIN CATCH
		SET @errorNumber = ERROR_NUMBER()
		SET @errorSeverity = ERROR_SEVERITY()
		SET @errorState = ERROR_STATE()
		SET @message = ERROR_MESSAGE()
		
		IF @inicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', @errorSeverity, @errorState, @message, @customError);
	END CATCH;
  
END
  RETURN 0	
GO

/*
	*   DESCRIPCION: Cree	un	procedimiento	que	tome	el	identificador	del	departamento	y	retorne	todos	los	empleados
    *   separados	por	coma	en	un	solo	string.
*/
GO
CREATE PROCEDURE SP_CONSULTA_10A
(
	@pIdentificador INT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @message VARCHAR(5000);
	DECLARE @nombre VARCHAR(100);

	DECLARE nombreCursor CURSOR FOR 
	SELECT E.NOMBRE FROM EMPLEADO AS E
	INNER JOIN DEPARTAMENTO AS D 
	ON D.ID_DEPARTAMENTO = E.ID_DEPARTAMENTO
	WHERE D.ID_DEPARTAMENTO = @pIdentificador;

	OPEN nombreCursor
	FETCH NEXT FROM nombreCursor
	INTO @nombre
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @message = CONCAT(@message, @nombre, ',');
		FETCH NEXT FROM nombreCursor
		INTO @nombre

	END
	CLOSE nombreCursor
	DEALLOCATE nombreCursor
	PRINT SUBSTRING(@message, 1, LEN(@message)-1);

	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: Cree	un	trigger	que	asegure	que	el	salario	no	se	reduzca	y	no	sea incrementado	en	más	de	5%.
*/
CREATE TRIGGER TR_CONSULTA_11A
ON EMPLEADO AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @saldoActual MONEY;
	DECLARE @saldoAnterior MONEY;
	DECLARE @saldoSuperior MONEY;
	DECLARE @saldoinferior MONEY;
	SET @saldoActual = (SELECT SALARIO FROM INSERTED);
	SET @saldoAnterior = (SELECT SALARIO FROM DELETED);
	SET @saldoSuperior = @saldoAnterior + ((5*@saldoAnterior)/100);
	SET @saldoinferior = @saldoSuperior - ((5*@saldoSuperior)/100);

	IF (UPDATE SALARIO )
	BEGIN	
		IF (saldoActual > saldoSuperior)
			UPDATE EMPLEADO
			SET SALARIO = @saldoAnterior;
			
			RAISERROR('No se puede modificar el salario');
			ROLLBACK;
		IF (saldoActual < @saldoinferior)
			UPDATE EMPLEADO
			SET SALARIO = @saldoAnterior;
			
			RAISERROR('No se puede modificar el salario');
			ROLLBACK;

	END	

END;
GO

/*
	*   DESCRIPCION: Cree	un	trigger	que	inserte	en	la	tabla	de	historial	de	trabajo	cada	vez	que	se	actualice	
	*   el	trabajo	de un	empleado,	note	que	debe	actualizar	las	fechas	de	ingreso.
*/
CREATE TRIGGER TR_CONSULTA_12A
ON EMPLEADO AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF (UPDATE ID_PUESTO)
	BEGIN	
		INSERT INTO HISTORIAL_PUESTO(ID_EMPLEADO, FECHA_INICIO, ID_PUESTO, ID_DEPARTAMENTO)
		SELECT ID_EMPLEADO, FECHA_CONTRATACION, ID_PUESTO, ID_DEPARTAMENTO
		FROM DELETED

		UPDATE EMPLEADO
		SET FECHA_CONTRATACION = GETDATE();
		WHERE ID_EMPLEADO = (SELECT ID_EMPLEADO FROM DELETED);
	END
	
END;
GO