/*
	*	PROYECTO I
    *	AUTOR: CARLOS FERNANDEZ JIMENEZ
	*	CURSO: BASES DE DATOS 2
	*   DESCRIPCION: CODIGO FUENTE PARA SQL SERVER
*/


/*
	*   DESCRIPCION: LLENA LA TABLA REGION
*/
GO
CREATE PROCEDURE SP_LLENAR_REGION
(
	@pCantidad INT	
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cont INT;
	SET @cont = 1;

	BEGIN TRY
		WHILE @cont < @pCantidad
        BEGIN
			INSERT INTO REGION (NOMBRE_REGION) 
			VALUES (CONCAT('Region ', CAST(@cont AS VARCHAR)));
			
			SET @cont = @cont + 1;
	    END;
		
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA PAIS
*/
GO
CREATE PROCEDURE SP_LLENAR_PAIS
(
	@pCantidad INT	
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cont INT;
    DECLARE @IdRegion INT;
	SET @cont = 1;

	BEGIN TRY
		WHILE @cont < @pCantidad
        BEGIN
			SET @IdRegion = ( SELECT TOP 1 ID_REGION FROM REGION ORDER BY NEWID() );
			INSERT INTO PAIS (NOMBRE_PAIS, ID_REGION) 
			VALUES (CONCAT('Pais ', CAST(@cont AS VARCHAR)), @IdRegion);
			
			SET @cont = @cont + 1;
	    END;
		
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA LOCALIZACION
*/
GO
CREATE PROCEDURE SP_LLENAR_LOCALIZACION
(
	@pCantidad INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Cantidad INT;
	DECLARE @cont INT;
	DECLARE @tmpCodigo VARCHAR(60);
    DECLARE @tmpDireccion VARCHAR(320);
	DECLARE @tmpCiudad  VARCHAR(100);
	DECLARE @tmpProvincia VARCHAR(100); 
	DECLARE @tmpIdPais  INT;    

	CREATE TABLE TEMP_LOCALIZACION
	(
		ID_TEMP_LOCALIZACION INT IDENTITY(1,1) PRIMARY KEY,
		DIRECCION  VARCHAR(320),
		CODIGO_POSTAL VARCHAR(60),
		CIUDAD VARCHAR(100),
		PROVINCIA VARCHAR(100)
	)
	
	INSERT INTO TEMP_LOCALIZACION (DIRECCION, CODIGO_POSTAL, CIUDAD, PROVINCIA)
	VALUES('P.O. Box 690, 5400 Cursus. Av.','4539','Howrah','British Indian Ocean Territory'),
		('896-5898 Suspendisse Street','68009','Gentinnes','French Polynesia'),
		('Ap #751-7787 Cras Street','74430','Gandhidham','Nauru'),
		('9672 Aliquam Avenue','B35 7OJ','Kozan','Swaziland'),
		('Ap #240-6123 Suspendisse St.','67-038','Gullegem','South Africa'),
		('Ap #180-4196 Phasellus Street','71900','Moorsele','Mauritius'),
		('Ap #217-4246 Quisque St.','4205','Ougr�e','Macedonia'),
		('2848 Nec, Rd.','46914','Dro','Brunei'),
		('Ap #786-9106 Consequat, Ave','X5K 7M7','Rutigliano','Korea, North'),
		('Ap #890-7700 Pellentesque Ave','74575','Worksop','Qatar'),
		('P.O. Box 496, 1025 Vel Rd.','382459','Cajazeiras','Lebanon'),
		('9961 Blandit Rd.','767290','Kasur','Malta'),
		('608-4756 Sed Rd.','80925','Austin','Bahrain'),
		('937-2914 Erat, Avenue','58166-724','Hatfield','El Salvador'),
		('Ap #773-7249 Duis Ave','67653','Neuville','China'),
		('211-5408 Consectetuer St.','48823','Erpion','Ireland'),('907-2680 Eget St.','88544','Souvret','Puerto Rico'),
		('Ap #497-8133 Lorem Street','31215','Hudson''s Hope','Mauritania'),
		('728 Placerat. St.','20201','Spiere-Helkijn','New Zealand'),
		('7331 Dui, Avenue','56205','Bever Bievene','Ecuador'),
		('8431 Erat Av.','163074','Lennik','Romania');
	

	SET @cont = 1;
    BEGIN TRY	   
		WHILE @cont <= @pCantidad 
		BEGIN
			SET @tmpDireccion  = ( SELECT TOP 1 DIRECCION FROM TEMP_LOCALIZACION ORDER BY NEWID() );
			SET @tmpCodigo     = ( SELECT TOP 1 CODIGO_POSTAL FROM TEMP_LOCALIZACION ORDER BY NEWID() );
			SET @tmpCiudad     = ( SELECT TOP 1 CIUDAD FROM TEMP_LOCALIZACION ORDER BY NEWID() );
			SET @tmpProvincia  = ( SELECT TOP 1 PROVINCIA FROM TEMP_LOCALIZACION ORDER BY NEWID() );
			SET @tmpIdPais     = ( SELECT TOP 1 ID_PAIS FROM PAIS ORDER BY NEWID() );
       
	        INSERT INTO LOCALIZACION (DIRECCION, CODIGO_POSTAL, CIUDAD, PROVINCIA, ID_PAIS) 
			VALUES (@tmpDireccion, @tmpCodigo, @tmpCiudad, @tmpProvincia, @tmpIdPais);
	  
			SET @cont = @cont + 1;
		END;
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA PUESTO
*/
GO
CREATE PROCEDURE SP_LLENAR_PUESTO
(
	@pCantidad INT	
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cont INT;
    DECLARE @tmpSalarioMin MONEY;
    DECLARE @tmpSalarioMax MONEY;

	SET @cont = 1;

	BEGIN TRY
		WHILE @cont < @pCantidad
        BEGIN
			SET @tmpSalarioMin = (FLOOR(1000 + RAND() * ( 5000-1)));
			SET @tmpSalarioMax = (FLOOR(100000 + RAND() * ( 500000-1)));
			INSERT INTO PUESTO (TITULO_PUESTO, SALARIO_MIN, SALARIO_MAX) 
			VALUES (CONCAT('Puesto ', CAST(@cont AS VARCHAR)), @tmpSalarioMin, @tmpSalarioMax);
			
			SET @cont = @cont + 1;
	    END;
		
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA DEPARTAMENTO
*/
GO
CREATE PROCEDURE SP_LLENAR_DEPARTAMENTO
(
	@pCantidad INT	
)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @cont INT;
	DECLARE @tmpDepartamento VARCHAR(100);
	DECLARE @tmpIdLocalizacion INT;

	CREATE TABLE TEMP_DEPARTAMENTO
	(
		ID_TEMP_DEPARTAMENTO INT IDENTITY(1,1) PRIMARY KEY,
		NOMBRE_DEPARTAMENTO VARCHAR(100)
	)

	INSERT INTO TEMP_DEPARTAMENTO(NOMBRE_DEPARTAMENTO) 
	VALUES('Public Relations'),
		('Research and Development'),
		('Customer Relations'),
		('Advertising'),
		('Finances'),
		('Payroll'),
		('Quality Assurance'),
		('Media Relations'),
		('Advertising'),
		('Customer Relations'),
		('Accounting');

	SET @cont = 1;
    BEGIN TRY	   
		WHILE @cont <= @pCantidad 
		BEGIN
			SET @tmpDepartamento   = ( SELECT TOP 1 NOMBRE_DEPARTAMENTO FROM TEMP_DEPARTAMENTO ORDER BY NEWID() );
			SET @tmpIdLocalizacion = ( SELECT TOP 1 ID_LOCALIZACION FROM LOCALIZACION ORDER BY NEWID() );
       
	        INSERT INTO DEPARTAMENTO (NOMBRE_DEPARTAMENTO, ID_LOCALIZACION) 
			VALUES (CONCAT(@tmpDepartamento, @cont), @tmpIdLocalizacion);
	  
			SET @cont = @cont + 1;
		END;
	
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA EMPLEADO
*/
GO
CREATE PROCEDURE SP_INSERT_EMPLEADO
(
	@pCantidad INT
)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @cont INT;
    DECLARE @tmpNombre VARCHAR(100);
	DECLARE @tmpApellido VARCHAR(100);
    DECLARE @tmpEmail VARCHAR(100);
    DECLARE @tmpTelefono VARCHAR(100);
    DECLARE @tmpFechaContratacion DATE;
    DECLARE @tmpSalario MONEY;
    DECLARE @tmpPorComision FLOAT;
    DECLARE @tmpIdPuesto INT; 
    DECLARE @tmpIdDepartamento INT;

	CREATE TABLE TEMP_EMPLEADO(NOMBRE VARCHAR(100)) ;
	CREATE TABLE TEMP_FECHA_CONTRATACION(FECHA DATE) ;
	
	INSERT INTO TEMP_EMPLEADO(NOMBRE) 
	VALUES ('Diego'), 		('Kistein'),	('Jose'),		('Raymund'),
			('Vladimir'), 	('Sebastian'),	('Eddy'),		('Kenny'),
			('Ivannia'), 	('Ivan'),		('Pablo'),		('Brandon'),	
			('Manuel'), 	('Steven'),		('Hellen'),		('Joel'),	
			('Roberto'), 	('Carlos'),		('Joselyn'),	('Douglas'),	
			('Maria'), 		('Juana'),		('Lucy'),		('Oscar'), 		
			('Belen'), 		('Camila'),		('Sofia'),		('Katherine'),
			('Vanessa'), 	('Valeria'),	('Melissa'),	('Michelle'),	
			('Gabriel'), 	('Minor'),		('Jonhy'),		('Ariel'), 		
			('Enrique'), 	('Alexander'),	('Mauricio'),	('Luis'),
			('Ronald'), 	('Wilber'),		('Guilberth'),	('Otto'),
			('Nancy'), 		('Cecilia'),	('Grettel'),	('Ottón'),		
			('Jennifer'), 	('Alejandra'),	('Braulio'),	('Issabel'),
			('Ana'),		('María'),		('Fernanda'),	('Jafet'),		
			('Francisco'),	('Fabian'),		('Fernando'),	('Daniel'), 	
			('Eduardo'), 	('Edisson'),	('Rodrigo'),	('Ianka'),
			('Silvestre'),	('Homero'),		('Bob'),		('Walter'),		
			('Pedro'),		('Tommy'),		('Gohan'),		('Okabe'), 		
			('Hermione'),	('Milk'),		('Minnie'),		('Peter'),		
			('Angelina'),	('Cameron'),	('Amelia'),		('Mario'),		
			('Osama'),		('Laura'),		('Megan'),		('Esmeregildo'),
			('Isabella'), 	('Daniel'), 	('Olivia'), 	('David'), 
			('Alexis'), 	('Gabriel'), 	('Sofía'), 		('Benjamín'), 
			('Victoria'), 	('Samuel'), 	('Amelia'), 	('Lucas'),
			('Alexa'), 		('Ángel'), 		('Julia'), 		('José'), 
			('Camila'), 	('Adrián'), 	('Alexandra'), 	('Sebastián'), 
			('Maya'), 		('Xavier'), 	('Andrea'), 	('Juan'),
			('Ariana'),		('Luis'), 		('María'), 		('Diego'), 
			('Eva'), 		('Óliver'),		('Angelina'),	('Carlos'), 
			('Valeria'), 	('Jesús'), 		('Natalia'), 	('Alex'),
			('Isabel'), 	('Max'), 		('Sara'), 		('Alejandro'), 
			('Liliana'), 	('Antonio'),	('Adriana'), 	('Miguel'), 
			('Juliana'), 	('Víctor'), 	('Gabriela'), 	('Joel'),
			('Daniela'), 	('Santiago'), 	('Valentina'), 	('Elías'), 
			('Lila'), 		('Iván'), 		('Vivian'), 	('Óscar'), 
			('Nora'), 		('Leonardo'), 	('Ángela'), 	('Harry'),
			('Elena'), 		('Alan'), 		('Clara'), 		('Nicolás'), 
			('Eliana'), 	('Jorge'), 		('Alana'), 		('Omar'), 
			('Miranda'), 	('Paúl'), 		('Amanda'), 	('Andrés'),
			('Diana'), 		('Julián'), 	('Ana'), 		('Josué'), 
			('Penélope'), 	('Román'), 		('Aurora'), 	('Fernando'), 
			('Alexandría'),	('Javier'), 	('Lola'), 		('Abraham'),
			('Alicia'), 	('Ricardo'),	('Amaya'), 		('Francisco'), 
			('Alexia'), 	('César'), 		('Jazmín'), 	('Mario'), 
			('Mariana'), 	('Manuel'), 	('Alina'), 		('Édgar'),
			('Lucía'), 		('Alexis'), 	('Fátima'), 	('Israel');

	INSERT INTO TEMP_FECHA_CONTRATACION(FECHA)
	VALUES ('1975-04-05'),
		('1980-04-05'),
		('1990-04-05'),
		('1995-04-08'),
		('2000-04-05'),
		('2004-04-07'),
		('2008-04-05'),
		('2010-04-06'),
		('2012-04-02'),
		('2015-01-03');

    SET @cont = 1;
    BEGIN TRY	   
		WHILE @cont <= @pCantidad 
		BEGIN
			SET @tmpNombre            = ( SELECT TOP 1 NOMBRE FROM TEMP_EMPLEADO ORDER BY NEWID() );
			SET @tmpApellido          = (CONCAT('Apellido ', @cont));
			SET @tmpEmail             = (CONCAT('user',@tmpApellido, '@gmail.com' ));
			SET @tmpTelefono          = '8888-8888';
			SET @tmpFechaContratacion = ( SELECT TOP 1 FECHA FROM TEMP_FECHA_CONTRATACION ORDER BY NEWID());
			SET @tmpIdPuesto          = ( SELECT TOP 1 ID_PUESTO FROM PUESTO ORDER BY NEWID());
			SET @tmpSalario           = ( SELECT TOP 1 SALARIO_MAX FROM PUESTO ORDER BY NEWID());
			SET @tmpPorComision       = (FLOOR(1000 + RAND() * ( 50000-1)));          
			SET @tmpIdDepartamento    = ( SELECT TOP 1 ID_DEPARTAMENTO FROM DEPARTAMENTO ORDER BY NEWID());
       
			INSERT INTO EMPLEADO (NOMBRE, APELLIDO, EMAIL, TELEFONO, FECHA_CONTRATACION, SALARIO, POR_COMISION, ID_PUESTO, ID_DEPARTAMENTO)
			VALUES (@tmpNombre, @tmpApellido, @tmpEmail, @tmpTelefono, @tmpFechaContratacion, @tmpSalario, @tmpPorComision, @tmpIdPuesto, @tmpIdDepartamento);
	  
			SET @cont = @cont + 1;
		END;
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: ASIGNA Y RELACIONA LOS GERENTES EN EL MODELO
*/
GO
CREATE PROCEDURE SP_ESTABLECER_GERENTES
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cont INT;
	DECLARE @cantidadDepartamentos INT;
	DECLARE @tmpIdEmpleado INT;

	SET @cont = 1;
	SET @cantidadDepartamentos = (SELECT COUNT(ID_DEPARTAMENTO) FROM DEPARTAMENTO);
	BEGIN TRY	   
		WHILE @cont <= @cantidadDepartamentos
		BEGIN
		SET @tmpIdEmpleado         = ( SELECT TOP 1 ID_EMPLEADO FROM EMPLEADO
		                               WHERE ID_DEPARTAMENTO = @cont ORDER BY NEWID());

		UPDATE DEPARTAMENTO
		SET ID_GERENTE = @tmpIdEmpleado
		WHERE ID_DEPARTAMENTO = @cont;

		UPDATE EMPLEADO 
		SET ID_GERENTE = @tmpIdEmpleado
		WHERE ID_EMPLEADO = @tmpIdEmpleado;

		SET @cont = @cont + 1;
	END;	
	RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR*-1
	END CATCH;
END;
GO

/*
	*   DESCRIPCION: LLENA LA TABLA HISTORIAL_EMPLEADO
*/