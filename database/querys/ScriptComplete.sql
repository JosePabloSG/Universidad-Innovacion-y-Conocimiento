USE master;
GO

CREATE DATABASE Universidad_InnovacionConocimiento
ON PRIMARY 
(
    NAME = 'UIC_DataFile',  
    FILENAME = 'C:\SQLData\UIC_DataFile.mdf',
    SIZE = 10MB,             
    MAXSIZE = 50MB,        
    FILEGROWTH = 5MB         
),
FILEGROUP [UIC_FileGroup1]   
(
    NAME = 'UIC_SecondaryDataFile',
    FILENAME = 'C:\SQLData\UIC_SecondaryDataFile.ndf',
    SIZE = 5MB,              
    MAXSIZE = 20MB,         
    FILEGROWTH = 5MB         
)
LOG ON 
(
    NAME = 'UIC_LogFile',
    FILENAME = 'C:\SQLLog\UIC_LogFile.ldf',
    SIZE = 3MB,              
    MAXSIZE = 15MB,          
    FILEGROWTH = 1MB         
);
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TABLE Facultad (
    Id_Facultad INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL
);

CREATE TABLE Nivel_Academico (
    Id_Nivel_Academico INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Programa_Academico (
    Id_Prog_Academico INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Duracion INT,
    Id_Nivel_Academico INT NOT NULL,
    Id_Facultad INT NOT NULL,
    FOREIGN KEY (Id_Nivel_Academico) REFERENCES Nivel_Academico(Id_Nivel_Academico),
    FOREIGN KEY (Id_Facultad) REFERENCES Facultad(Id_Facultad)
);

CREATE TABLE Recurso_Academico (
    Id_Recurso_Academico INT IDENTITY(1,1) PRIMARY KEY,
    Estado VARCHAR(50),
    Tipo VARCHAR(150)
);

CREATE TABLE Aula (
    Id_Aula INT IDENTITY(1,1) PRIMARY KEY,
    Codigo_Aula VARCHAR(20) NOT NULL,
    Capacidad INT,
    Ubicacion VARCHAR(100),
    Equipamiento VARCHAR(255)
);

CREATE TABLE Curso (
    Id_Curso INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Codigo_Curso VARCHAR(20),
    Creditos INT,
    Horas_Semana INT,
    Id_Prog_Academico INT NOT NULL,
    FOREIGN KEY (Id_Prog_Academico) REFERENCES Programa_Academico(Id_Prog_Academico)
);

CREATE TABLE Estudiante (
   Id_Estudiante INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido1 VARCHAR(100),
    Apellido2 VARCHAR(100),
	  Telefono VARCHAR(15),
    Email VARCHAR(150),
    Direccion VARCHAR(150)
);

CREATE TABLE Docente (
    Id_Docente INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido1 VARCHAR(100),
    Apellido2 VARCHAR(100),
    Email VARCHAR(150),
    Especialidad VARCHAR(100),
    Telefono VARCHAR(15)
);

CREATE TABLE Inscripcion (
    Id_Inscripcion INT IDENTITY(1,1) PRIMARY KEY,
    Fecha_Inscripcion DATE,
    Estado VARCHAR(50),
    Id_Curso INT NOT NULL,
    Id_Estudiante INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Estudiante) REFERENCES Estudiante(Id_Estudiante)
);

CREATE TABLE Horario (
    Id_Horario INT IDENTITY(1,1) PRIMARY KEY,
    FechaInicio DATE,
    FechaFin DATE,
    Id_Docente INT NOT NULL,
    Id_Curso INT NOT NULL,
    FOREIGN KEY (Id_Docente) REFERENCES Docente(Id_Docente),
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso)
);

CREATE TABLE Docente_Curso (
    Id_Docente_Curso INT IDENTITY(1,1) PRIMARY KEY,
    Id_Curso INT NOT NULL,
    Id_Docente INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Docente) REFERENCES Docente(Id_Docente)
);

CREATE TABLE Curso_Recurso_Academico (
    Id_Curso_Rec_Academico INT IDENTITY(1,1) PRIMARY KEY,
    Id_Recurso_Academico INT NOT NULL,
    Id_Curso INT NOT NULL,
    FOREIGN KEY (Id_Recurso_Academico) REFERENCES Recurso_Academico(Id_Recurso_Academico),
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso)
);

CREATE TABLE Curso_Aula (
    Id_Curso_Aula INT IDENTITY(1,1) PRIMARY KEY,
    Horario_clase DATETIME,
    Id_Curso INT NOT NULL,
    Id_Aula INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Aula) REFERENCES Aula(Id_Aula)
);

CREATE TABLE Historial_Academico (
    Id_Historial_Academico INT IDENTITY(1,1) PRIMARY KEY,
    Nota DECIMAL(5,2),
    Fecha_Calificacion DATE,
    Id_Curso INT NOT NULL,
    Id_Estudiante INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Estudiante) REFERENCES Estudiante(Id_Estudiante)
);
GO


CREATE TABLE Auditoria_Accion (
    Id_Accion INT IDENTITY(1,1) PRIMARY KEY,
    Accion_Realizada VARCHAR(50) NOT NULL
);
GO


CREATE TABLE Historial_Cambio (
    Id_Historial_Cambio INT IDENTITY(1,1) PRIMARY KEY,
    Usuario VARCHAR(100) NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    Id_Registro INT NOT NULL,
    Tabla VARCHAR(50) NOT NULL,
    Id_Accion INT NOT NULL,
    Datos_Anteriores NVARCHAR(MAX),
    Datos_Nuevos NVARCHAR(MAX),
    CONSTRAINT FK_Historial_Cambio_Accion FOREIGN KEY (Id_Accion) REFERENCES Auditoria_Accion(Id_Accion)
);
GO

USE Universidad_InnovacionConocimiento;
GO
--Triggers para Facultad
CREATE TRIGGER TR_Facultad_Insert
ON Facultad
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Facultad,
            'Facultad',
            @IdAccion,
            (
                SELECT i2.Id_Facultad, i2.Nombre FROM inserted i2 WHERE i2.Id_Facultad = i.Id_Facultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_Facultad_Update
ON Facultad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Facultad,
            'Facultad',
            @IdAccion,
            (
                SELECT d2.Id_Facultad, d2.Nombre FROM deleted d2 WHERE d2.Id_Facultad = d.Id_Facultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i2.Id_Facultad, i2.Nombre FROM inserted i2 WHERE i2.Id_Facultad = i.Id_Facultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Facultad = d.Id_Facultad;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Facultad_Delete
ON Facultad
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Facultad,
            'Facultad',
            @IdAccion,
            (
                SELECT d2.Id_Facultad, d2.Nombre FROM deleted d2 WHERE d2.Id_Facultad = d.Id_Facultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Nivel Académico
CREATE TRIGGER TR_NivelAcademico_Insert
ON Nivel_Academico
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Nivel_Academico,
            'Nivel_Academico',
            @IdAccion,
            (
                SELECT i2.Id_Nivel_Academico, i2.Nombre FROM inserted i2 WHERE i2.Id_Nivel_Academico = i.Id_Nivel_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_NivelAcademico_Update
ON Nivel_Academico
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Nivel_Academico,
            'Nivel_Academico',
            @IdAccion,
            (
                SELECT d2.Id_Nivel_Academico, d2.Nombre FROM deleted d2 WHERE d2.Id_Nivel_Academico = d.Id_Nivel_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i2.Id_Nivel_Academico, i2.Nombre FROM inserted i2 WHERE i2.Id_Nivel_Academico = i.Id_Nivel_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Nivel_Academico = d.Id_Nivel_Academico;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_NivelAcademico_Delete
ON Nivel_Academico
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Nivel_Academico,
            'Nivel_Academico',
            @IdAccion,
            (
                SELECT d2.Id_Nivel_Academico, d2.Nombre FROM deleted d2 WHERE d2.Id_Nivel_Academico = d.Id_Nivel_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Programa Académico
CREATE TRIGGER TR_ProgramaAcademico_Insert
ON Programa_Academico
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Prog_Academico,
            'Programa_Academico',
            @IdAccion,
            (
                SELECT i2.Id_Prog_Academico, i2.Nombre, i2.Duracion, i2.Id_Nivel_Academico, i2.Id_Facultad
                FROM inserted i2 WHERE i2.Id_Prog_Academico = i.Id_Prog_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_ProgramaAcademico_Update
ON Programa_Academico
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Prog_Academico,
            'Programa_Academico',
            @IdAccion,
            (
                SELECT d2.Id_Prog_Academico, d2.Nombre, d2.Duracion, d2.Id_Nivel_Academico, d2.Id_Facultad
                FROM deleted d2 WHERE d2.Id_Prog_Academico = d.Id_Prog_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i2.Id_Prog_Academico, i2.Nombre, i2.Duracion, i2.Id_Nivel_Academico, i2.Id_Facultad
                FROM inserted i2 WHERE i2.Id_Prog_Academico = i.Id_Prog_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Prog_Academico = d.Id_Prog_Academico;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_ProgramaAcademico_Delete
ON Programa_Academico
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Prog_Academico,
            'Programa_Academico',
            @IdAccion,
            (
                SELECT d2.Id_Prog_Academico, d2.Nombre, d2.Duracion, d2.Id_Nivel_Academico, d2.Id_Facultad
                FROM deleted d2 WHERE d2.Id_Prog_Academico = d.Id_Prog_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Recurso Académico
CREATE TRIGGER TR_RecursoAcademico_Insert
ON Recurso_Academico
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Recurso_Academico,
            'Recurso_Academico',
            @IdAccion,
            (SELECT i.Id_Recurso_Academico, i.Tipo, i.Estado
             FROM inserted i2
             WHERE i2.Id_Recurso_Academico = i.Id_Recurso_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_RecursoAcademico_Update
ON Recurso_Academico
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Recurso_Academico,
            'Recurso_Academico',
            @IdAccion,
            (SELECT d.Id_Recurso_Academico, d.Tipo, d.Estado
             FROM deleted d2
             WHERE d2.Id_Recurso_Academico = d.Id_Recurso_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.Id_Recurso_Academico, i.Tipo, i.Estado
             FROM inserted i2
             WHERE i2.Id_Recurso_Academico = i.Id_Recurso_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Recurso_Academico = d.Id_Recurso_Academico;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_RecursoAcademico_Delete
ON Recurso_Academico
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Recurso_Academico,
            'Recurso_Academico',
            @IdAccion,
            (SELECT d.Id_Recurso_Academico, d.Tipo, d.Estado
             FROM deleted d2
             WHERE d2.Id_Recurso_Academico = d.Id_Recurso_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Aula
CREATE TRIGGER TR_Aula_Insert
ON Aula
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Aula,
            'Aula',
            @IdAccion,
            (SELECT i.Id_Aula, i.Codigo_aula, i.Ubicacion, i.Capacidad, i.Equipamiento
             FROM inserted i2
             WHERE i2.Id_Aula = i.Id_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Aula_Update
ON Aula
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Aula,
            'Aula',
            @IdAccion,
            (SELECT d.Id_Aula, d.Codigo_aula, d.Ubicacion, d.Capacidad, d.Equipamiento
             FROM deleted d2
             WHERE d2.Id_Aula = d.Id_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.Id_Aula, i.Codigo_aula, i.Ubicacion, i.Capacidad, i.Equipamiento
             FROM inserted i2
             WHERE i2.Id_Aula = i.Id_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Aula = d.Id_Aula;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Aula_Delete
ON Aula
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Aula,
            'Aula',
            @IdAccion,
            (SELECT d.Id_Aula, d.Codigo_aula, d.Ubicacion, d.Capacidad, d.Equipamiento
             FROM deleted d2
             WHERE d2.Id_Aula = d.Id_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Curso Recurso Académico
CREATE TRIGGER TR_CursoRecursoAcademico_Insert
ON Curso_Recurso_Academico
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso_Rec_Academico,
            'Curso_Recurso_Academico',
            @IdAccion,
            (SELECT i.Id_Curso_Rec_Academico, i.Id_Curso, i.Id_Recurso_Academico
             FROM inserted i2
             WHERE i2.Id_Curso_Rec_Academico = i.Id_Curso_Rec_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_CursoRecursoAcademico_Update
ON Curso_Recurso_Academico
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso_Rec_Academico,
            'Curso_Recurso_Academico',
            @IdAccion,
            (SELECT d.Id_Curso_Rec_Academico, d.Id_Curso, d.Id_Recurso_Academico
             FROM deleted d2
             WHERE d2.Id_Curso_Rec_Academico = d.Id_Curso_Rec_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.Id_Curso_Rec_Academico, i.Id_Curso, i.Id_Recurso_Academico
             FROM inserted i2
             WHERE i2.Id_Curso_Rec_Academico = i.Id_Curso_Rec_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Curso_Rec_Academico = d.Id_Curso_Rec_Academico;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_CursoRecursoAcademico_Delete
ON Curso_Recurso_Academico
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Curso_Rec_Academico,
            'Curso_Recurso_Academico',
            @IdAccion,
            (SELECT d.Id_Curso_Rec_Academico, d.Id_Curso, d.Id_Recurso_Academico
             FROM deleted d2
             WHERE d2.Id_Curso_Rec_Academico = d.Id_Curso_Rec_Academico
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Curso Aula
CREATE TRIGGER TR_CursoAula_Insert
ON Curso_Aula
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso_Aula,
            'Curso_Aula',
            @IdAccion,
            (SELECT i.Id_Curso_Aula, i.Id_Curso, i.Id_Aula, i.Horario_clase
             FROM inserted i2
             WHERE i2.Id_Curso_Aula = i.Id_Curso_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_CursoAula_Update
ON Curso_Aula
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso_Aula,
            'Curso_Aula',
            @IdAccion,
            (SELECT d.Id_Curso_Aula, d.Id_Curso, d.Id_Aula, d.Horario_clase
             FROM deleted d2
             WHERE d2.Id_Curso_Aula = d.Id_Curso_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.Id_Curso_Aula, i.Id_Curso, i.Id_Aula, i.Horario_clase
             FROM inserted i2
             WHERE i2.Id_Curso_Aula = i.Id_Curso_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Curso_Aula = d.Id_Curso_Aula;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_CursoAula_Delete
ON Curso_Aula
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Curso_Aula,
            'Curso_Aula',
            @IdAccion,
            (SELECT d.Id_Curso_Aula, d.Id_Curso, d.Id_Aula, d.Horario_clase
             FROM deleted d2
             WHERE d2.Id_Curso_Aula = d.Id_Curso_Aula
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Curso
CREATE TRIGGER TR_Curso_Insert
ON Curso
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso,
            'Curso',
            @IdAccion,
            (
                SELECT i.Id_Curso, i.Nombre, i.Codigo_Curso, i.Creditos, i.Horas_Semana, i.Id_Prog_Academico
                FROM inserted i2
                WHERE i2.Id_Curso = i.Id_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Curso_Update
ON Curso
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Curso,
            'Curso',
            @IdAccion,
            (
                SELECT d.Id_Curso, d.Nombre, d.Codigo_Curso, d.Creditos, d.Horas_Semana, d.Id_Prog_Academico
                FROM deleted d2
                WHERE d2.Id_Curso = d.Id_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i.Id_Curso, i.Nombre, i.Codigo_Curso, i.Creditos, i.Horas_Semana, i.Id_Prog_Academico
                FROM inserted i2
                WHERE i2.Id_Curso = i.Id_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Curso = d.Id_Curso;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Curso_Delete
ON Curso
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Curso,
            'Curso',
            @IdAccion,
            (
                SELECT d.Id_Curso, d.Nombre, d.Codigo_Curso, d.Creditos, d.Horas_Semana, d.Id_Prog_Academico
                FROM deleted d2
                WHERE d2.Id_Curso = d.Id_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Horario
CREATE TRIGGER TR_Horario_Insert
ON Horario
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Código similar al anterior, ajustando los nombres de columnas y tablas
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
        SELECT
            @Usuario,
            i.Id_Horario,
            'Horario',
            @IdAccion,
            (
                SELECT i.Id_Horario, i.FechaInicio, i.FechaFin, i.Id_Docente, i.Id_Curso
                FROM inserted i2
                WHERE i2.Id_Horario = i.Id_Horario
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Horario_Update
ON Horario
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaraciones iniciales
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (
            Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos
        )
        SELECT
            @Usuario,
            i.Id_Horario,
            'Horario',
            @IdAccion,
            (
                SELECT d2.Id_Horario, d2.FechaInicio, d2.FechaFin, d2.Id_Docente, d2.Id_Curso
                FROM deleted d2
                WHERE d2.Id_Horario = d.Id_Horario
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i2.Id_Horario, i2.FechaInicio, i2.FechaFin, i2.Id_Docente, i2.Id_Curso
                FROM inserted i2
                WHERE i2.Id_Horario = i.Id_Horario
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Horario = d.Id_Horario;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Horario_Delete
ON Horario
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaraciones iniciales
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (
            Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores
        )
        SELECT
            @Usuario,
            d.Id_Horario,
            'Horario',
            @IdAccion,
            (
                SELECT d2.Id_Horario, d2.FechaInicio, d2.FechaFin, d2.Id_Docente, d2.Id_Curso
                FROM deleted d2
                WHERE d2.Id_Horario = d.Id_Horario
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Docente Curso
CREATE TRIGGER TR_DocenteCurso_Insert
ON Docente_Curso
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaraciones iniciales
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (
            Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos
        )
        SELECT
            @Usuario,
            i.Id_Docente_Curso,
            'Docente_Curso',
            @IdAccion,
            (
                SELECT i2.Id_Docente_Curso, i2.Id_Curso, i2.Id_Docente
                FROM inserted i2
                WHERE i2.Id_Docente_Curso = i.Id_Docente_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_DocenteCurso_Update
ON Docente_Curso
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaraciones iniciales
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (
            Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos
        )
        SELECT
            @Usuario,
            i.Id_Docente_Curso,
            'Docente_Curso',
            @IdAccion,
            (
                SELECT d2.Id_Docente_Curso, d2.Id_Curso, d2.Id_Docente
                FROM deleted d2
                WHERE d2.Id_Docente_Curso = d.Id_Docente_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            (
                SELECT i2.Id_Docente_Curso, i2.Id_Curso, i2.Id_Docente
                FROM inserted i2
                WHERE i2.Id_Docente_Curso = i.Id_Docente_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i
        INNER JOIN deleted d ON i.Id_Docente_Curso = d.Id_Docente_Curso;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_DocenteCurso_Delete
ON Docente_Curso
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaraciones iniciales
    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        -- Insertar en Historial_Cambio
        INSERT INTO Historial_Cambio (
            Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores
        )
        SELECT
            @Usuario,
            d.Id_Docente_Curso,
            'Docente_Curso',
            @IdAccion,
            (
                SELECT d2.Id_Docente_Curso, d2.Id_Curso, d2.Id_Docente
                FROM deleted d2
                WHERE d2.Id_Docente_Curso = d.Id_Docente_Curso
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
--Triggers para Estudiantes
CREATE TRIGGER TR_Estudiante_Insert
ON Estudiante
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            i.Id_Estudiante,
            'Estudiante',
            @IdAccion,
            (
                SELECT i2.Nombre, i2.Apellido1, i2.Apellido2, i2.Email FROM inserted i2 WHERE i2.Id_Estudiante = i.Id_Estudiante FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Estudiante_Update
ON Estudiante
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Estudiante,
            'Estudiante',
            @IdAccion,
            (
                SELECT d2.Nombre, d2.Apellido1, d2.Apellido2, d2.Email FROM deleted d2 WHERE d2.Id_Estudiante = d.Id_Estudiante FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Estudiante_Delete
ON Estudiante
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Estudiante,
            'Estudiante',
            @IdAccion,
            (
                SELECT d2.Nombre, d2.Apellido1, d2.Apellido2, d2.Email FROM deleted d2 WHERE d2.Id_Estudiante = d.Id_Estudiante FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Inscripciones
CREATE TRIGGER TR_Incripcion_Insert
ON Inscripcion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            i.Id_Inscripcion,
            'Inscripciones',
            @IdAccion,
            (
                SELECT i2.Fecha_inscripcion, i2.Estado, i2.Id_Curso, i2.Id_Estudiante FROM inserted i2 WHERE i2.Id_Inscripcion = i.Id_Inscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Inscripcion_Update
ON Inscripcion
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Inscripcion,
            'Inscripciones',
            @IdAccion,
            (
                SELECT d2.Fecha_inscripcion, d2.Estado, d2.Id_Curso, d2.Id_Estudiante FROM deleted d2 WHERE d2.Id_Inscripcion = d.Id_Inscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Inscripcion_Delete
ON Inscripcion
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Inscripcion,
            'Inscripciones',
            @IdAccion,
            (
                SELECT d2.Fecha_inscripcion, d2.Estado, d2.Id_Curso, d2.Id_Estudiante FROM deleted d2 WHERE d2.Id_Inscripcion = d.Id_Inscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO 
-- Triggers para Historial Academico
CREATE TRIGGER TR_HistorialAcademico_Insert
ON Historial_Academico
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'INSERT';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            i.Id_Historial_Academico,
            'Historial_Academico',
            @IdAccion,
            (
                SELECT i2.Nota, i2.Fecha_Calificacion, i2.Id_Curso, i2.Id_Estudiante FROM inserted i2 WHERE i2.Id_Historial_Academico = i.Id_Historial_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_HistorialAcademico_Update
ON Historial_Academico
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'UPDATE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Historial_Academico,
            'Historial_Academico',
            @IdAccion,
            (
                SELECT d2.Nota, d2.Fecha_Calificacion, d2.Id_Curso, d2.Id_Estudiante FROM deleted d2 WHERE d2.Id_Historial_Academico = d.Id_Historial_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_HistorialAcademico_Delete
ON Historial_Academico
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion FROM Auditoria_Accion WHERE Accion_Realizada = 'DELETE';

    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
        SELECT
            @Usuario,
            d.Id_Historial_Academico,
            'Historial_Academico',
            @IdAccion,
            (
                SELECT d2.Nota, d2.Fecha_Calificacion, d2.Id_Curso, d2.Id_Estudiante FROM deleted d2 WHERE d2.Id_Historial_Academico = d.Id_Historial_Academico FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FROM deleted d;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Triggers para Docente
CREATE TRIGGER TR_Docente_Insert
ON Docente
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'INSERT'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'INSERT';

    -- Insertar en Historial_Cambio
    INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Nuevos)
    SELECT
        @Usuario,
        i.Id_Docente,
        'Docente',
        @IdAccion,
        (
            SELECT i.Id_Docente, i.Nombre, i.Apellido1, i.Apellido2, i.Email, i.Especialidad, i.Telefono
            FROM inserted i2
            WHERE i2.Id_Docente = i.Id_Docente
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    FROM inserted i;
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Docente_Update
ON Docente
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'UPDATE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'UPDATE';

    -- Insertar en Historial_Cambio
    INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
    SELECT
        @Usuario,
        i.Id_Docente,
        'Docente',
        @IdAccion,
        (
            SELECT d.Id_Docente, d.Nombre, d.Apellido1, d.Apellido2, d.Email, d.Especialidad, d.Telefono
            FROM deleted d2
            WHERE d2.Id_Docente = d.Id_Docente
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ),
        (
            SELECT i.Id_Docente, i.Nombre, i.Apellido1, i.Apellido2, i.Email, i.Especialidad, i.Telefono
            FROM inserted i2
            WHERE i2.Id_Docente = i.Id_Docente
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    FROM inserted i
    INNER JOIN deleted d ON i.Id_Docente = d.Id_Docente;
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TR_Docente_Delete
ON Docente
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Usuario VARCHAR(100) = SUSER_SNAME();
    DECLARE @IdAccion INT;

    -- Obtener el Id_Accion para 'DELETE'
    SELECT @IdAccion = Id_Accion
    FROM Auditoria_Accion
    WHERE Accion_Realizada = 'DELETE';

    -- Insertar en Historial_Cambio
    INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores)
    SELECT
        @Usuario,
        d.Id_Docente,
        'Docente',
        @IdAccion,
        (
            SELECT d.Id_Docente, d.Nombre, d.Apellido1, d.Apellido2, d.Email, d.Especialidad, d.Telefono
            FROM deleted d2
            WHERE d2.Id_Docente = d.Id_Docente
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    FROM deleted d;
END;
GO

USE Universidad_InnovacionConocimiento;
GO
--Procedimientos almacenados para Facultad
CREATE PROCEDURE SP_Facultad_Insert
    @IdFacultad INT,
    @Nombre VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdFacultad IS NULL
    BEGIN
        RAISERROR('El campo IdFacultad no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la facultad ya existe
        IF EXISTS (SELECT 1 FROM Facultad WHERE Id_Facultad = @IdFacultad)
        BEGIN
            RAISERROR('La facultad con Id %d ya existe.', 16, 1, @IdFacultad);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la nueva facultad
        INSERT INTO Facultad (Id_Facultad, Nombre)
        VALUES (@IdFacultad, @Nombre);

        COMMIT TRANSACTION;
        PRINT 'La facultad ha sido insertada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Facultad_Update
    @IdFacultad INT,
    @Nombre VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdFacultad IS NULL
    BEGIN
        RAISERROR('El campo IdFacultad no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la facultad existe
        IF NOT EXISTS (SELECT 1 FROM Facultad WHERE Id_Facultad = @IdFacultad)
        BEGIN
            RAISERROR('La facultad con Id %d no existe.', 16, 1, @IdFacultad);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar la facultad
        UPDATE Facultad
        SET Nombre = @Nombre
        WHERE Id_Facultad = @IdFacultad;

        COMMIT TRANSACTION;
        PRINT 'La facultad ha sido actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Facultad_Delete
    @IdFacultad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdFacultad IS NULL
    BEGIN
        RAISERROR('El campo IdFacultad no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la facultad existe
        IF NOT EXISTS (SELECT 1 FROM Facultad WHERE Id_Facultad = @IdFacultad)
        BEGIN
            RAISERROR('La facultad con Id %d no existe.', 16, 1, @IdFacultad);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar la facultad
        DELETE FROM Facultad
        WHERE Id_Facultad = @IdFacultad;

        COMMIT TRANSACTION;
        PRINT 'La facultad ha sido eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
--Procedimientos almacenados para nivel académico
CREATE PROCEDURE SP_NivelAcademico_Insert
    @IdNivelAcademico INT,
    @Nombre VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdNivelAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdNivelAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el nivel académico ya existe
        IF EXISTS (SELECT 1 FROM Nivel_Academico WHERE Id_Nivel_Academico = @IdNivelAcademico)
        BEGIN
            RAISERROR('El nivel académico con Id %d ya existe.', 16, 1, @IdNivelAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo nivel académico
        INSERT INTO Nivel_Academico (Id_Nivel_Academico, Nombre)
        VALUES (@IdNivelAcademico, @Nombre);

        COMMIT TRANSACTION;
        PRINT 'El nivel académico ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_NivelAcademico_Update
    @IdNivelAcademico INT,
    @Nombre VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdNivelAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdNivelAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el nivel académico existe
        IF NOT EXISTS (SELECT 1 FROM Nivel_Academico WHERE Id_Nivel_Academico = @IdNivelAcademico)
        BEGIN
            RAISERROR('El nivel académico con Id %d no existe.', 16, 1, @IdNivelAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el nivel académico
        UPDATE Nivel_Academico
        SET Nombre = @Nombre
        WHERE Id_Nivel_Academico = @IdNivelAcademico;

        COMMIT TRANSACTION;
        PRINT 'El nivel académico ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_NivelAcademico_Delete
    @IdNivelAcademico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdNivelAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdNivelAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el nivel académico existe
        IF NOT EXISTS (SELECT 1 FROM Nivel_Academico WHERE Id_Nivel_Academico = @IdNivelAcademico)
        BEGIN
            RAISERROR('El nivel académico con Id %d no existe.', 16, 1, @IdNivelAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar el nivel académico
        DELETE FROM Nivel_Academico
        WHERE Id_Nivel_Academico = @IdNivelAcademico;

        COMMIT TRANSACTION;
        PRINT 'El nivel académico ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
--Procedimientos almacenados para programa académico
CREATE PROCEDURE SP_ProgramaAcademico_Insert
    @IdProgAcademico INT,
    @Nombre VARCHAR(150),
    @Duracion INT,
    @IdNivelAcademico INT,
    @IdFacultad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdProgAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdProgAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    IF @Duracion IS NULL
    BEGIN
        RAISERROR('El campo Duracion no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdNivelAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdNivelAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdFacultad IS NULL
    BEGIN
        RAISERROR('El campo IdFacultad no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el programa académico ya existe
        IF EXISTS (SELECT 1 FROM Programa_Academico WHERE Id_Prog_Academico = @IdProgAcademico)
        BEGIN
            RAISERROR('El programa académico con Id %d ya existe.', 16, 1, @IdProgAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el nivel académico existe
        IF NOT EXISTS (SELECT 1 FROM Nivel_Academico WHERE Id_Nivel_Academico = @IdNivelAcademico)
        BEGIN
            RAISERROR('El nivel académico con Id %d no existe.', 16, 1, @IdNivelAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si la facultad existe
        IF NOT EXISTS (SELECT 1 FROM Facultad WHERE Id_Facultad = @IdFacultad)
        BEGIN
            RAISERROR('La facultad con Id %d no existe.', 16, 1, @IdFacultad);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo programa académico
        INSERT INTO Programa_Academico (Id_Prog_Academico, Nombre, Duracion, Id_Nivel_Academico, Id_Facultad)
        VALUES (@IdProgAcademico, @Nombre, @Duracion, @IdNivelAcademico, @IdFacultad);

        COMMIT TRANSACTION;
        PRINT 'El programa académico ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO


USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_ProgramaAcademico_Update
    @IdProgAcademico INT,
    @Nombre VARCHAR(150),
    @Duracion INT,
    @IdNivelAcademico INT,
    @IdFacultad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdProgAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdProgAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    IF @Duracion IS NULL
    BEGIN
        RAISERROR('El campo Duracion no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdNivelAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdNivelAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdFacultad IS NULL
    BEGIN
        RAISERROR('El campo IdFacultad no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el programa académico existe
        IF NOT EXISTS (SELECT 1 FROM Programa_Academico WHERE Id_Prog_Academico = @IdProgAcademico)
        BEGIN
            RAISERROR('El programa académico con Id %d no existe.', 16, 1, @IdProgAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el programa académico
        UPDATE Programa_Academico
        SET
            Nombre = @Nombre,
            Duracion = @Duracion,
            Id_Nivel_Academico = @IdNivelAcademico,
            Id_Facultad = @IdFacultad
        WHERE Id_Prog_Academico = @IdProgAcademico;

        COMMIT TRANSACTION;
        PRINT 'El programa académico ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_ProgramaAcademico_Delete
    @IdProgAcademico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdProgAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdProgAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el programa académico existe
        IF NOT EXISTS (SELECT 1 FROM Programa_Academico WHERE Id_Prog_Academico = @IdProgAcademico)
        BEGIN
            RAISERROR('El programa académico con Id %d no existe.', 16, 1, @IdProgAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar el programa académico
        DELETE FROM Programa_Academico
        WHERE Id_Prog_Academico = @IdProgAcademico;

        COMMIT TRANSACTION;
        PRINT 'El programa académico ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
--Procedimientos almacenados para recurso académico
CREATE PROCEDURE SP_RecursoAcademico_Insert
    @Tipo VARCHAR(50),
    @Estado VARCHAR(50)
AS
BEGIN
    DECLARE @Id_Recurso_Academico INT;
    
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de parámetros
        IF @Tipo IS NULL OR LTRIM(RTRIM(@Tipo)) = ''
        BEGIN
            RAISERROR('El campo Tipo no puede ser nulo o vacío.', 16, 1);
            RETURN;
        END

        IF @Estado IS NULL OR LTRIM(RTRIM(@Estado)) = ''
        BEGIN
            RAISERROR('El campo Estado no puede ser nulo o vacío.', 16, 1);
            RETURN;
        END

        -- Insertar el nuevo recurso académico
        INSERT INTO Recurso_Academico (Tipo, Estado)
        VALUES (@Tipo, @Estado);

        SET @Id_Recurso_Academico = SCOPE_IDENTITY(); -- Obtener el Id generado

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Recurso Académico insertado exitosamente con ID: ' + CAST(@Id_Recurso_Academico AS VARCHAR);
    END TRY
    BEGIN CATCH
        -- Si hay algún error, deshacer la transacción
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_RecursoAcademico_Update
    @Id_Recurso_Academico INT,
    @Tipo VARCHAR(50),
    @Estado VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de parámetros
        IF @Id_Recurso_Academico IS NULL
        BEGIN
            RAISERROR('El campo Id_Recurso_Academico no puede ser nulo.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Recurso_Academico WHERE Id_Recurso_Academico = @Id_Recurso_Academico)
        BEGIN
            RAISERROR('El recurso académico con Id %d no existe.', 16, 1, @Id_Recurso_Academico);
            RETURN;
        END

        -- Actualizar el recurso académico
        UPDATE Recurso_Academico
        SET Tipo = @Tipo, Estado = @Estado
        WHERE Id_Recurso_Academico = @Id_Recurso_Academico;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Recurso Académico actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_RecursoAcademico_Delete
    @Id_Recurso_Academico INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de existencia
        IF NOT EXISTS (SELECT 1 FROM Recurso_Academico WHERE Id_Recurso_Academico = @Id_Recurso_Academico)
        BEGIN
            RAISERROR('El recurso académico con Id %d no existe.', 16, 1, @Id_Recurso_Academico);
            RETURN;
        END

        -- Eliminar el recurso académico
        DELETE FROM Recurso_Academico
        WHERE Id_Recurso_Academico = @Id_Recurso_Academico;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Recurso Académico eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Aula_Insert
    @Codigo_aula VARCHAR(20),
    @Capacidad INT,
    @Ubicacion VARCHAR(100),
    @Equipamiento VARCHAR(255)
AS
BEGIN
    DECLARE @Id_Aula INT;
    
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de parámetros
        IF @Codigo_aula IS NULL OR LTRIM(RTRIM(@Codigo_aula)) = ''
        BEGIN
            RAISERROR('El campo Código_aula no puede ser nulo o vacío.', 16, 1);
            RETURN;
        END

        -- Insertar la nueva aula
        INSERT INTO Aula (Codigo_aula, Capacidad, Ubicacion, Equipamiento)
        VALUES (@Codigo_aula, @Capacidad, @Ubicacion, @Equipamiento);

        SET @Id_Aula = SCOPE_IDENTITY(); -- Obtener el Id generado

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Aula insertada exitosamente con ID: ' + CAST(@Id_Aula AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Aula_Update
    @Id_Aula INT,
    @Codigo_aula VARCHAR(20),
    @Capacidad INT,
    @Ubicacion VARCHAR(100),
    @Equipamiento VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de parámetros
        IF @Id_Aula IS NULL
        BEGIN
            RAISERROR('El campo Id_Aula no puede ser nulo.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Aula WHERE Id_Aula = @Id_Aula)
        BEGIN
            RAISERROR('El aula con Id %d no existe.', 16, 1, @Id_Aula);
            RETURN;
        END

        -- Actualizar el aula
        UPDATE Aula
        SET Codigo_aula = @Codigo_aula, Capacidad = @Capacidad, Ubicacion = @Ubicacion, Equipamiento = @Equipamiento
        WHERE Id_Aula = @Id_Aula;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Aula actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Aula_Delete
    @Id_Aula INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación de existencia
        IF NOT EXISTS (SELECT 1 FROM Aula WHERE Id_Aula = @Id_Aula)
        BEGIN
            RAISERROR('El aula con Id %d no existe.', 16, 1, @Id_Aula);
            RETURN;
        END

        -- Eliminar el aula
        DELETE FROM Aula
        WHERE Id_Aula = @Id_Aula;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Aula eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Curso Recurso Académico
CREATE PROCEDURE SP_CursoRecursoAcademico_Insert
    @Id_Curso INT,
    @Id_Recurso_Academico INT
AS
BEGIN
    DECLARE @Id_Curso_Rec_Academico INT;
    
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia del curso y del recurso académico
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @Id_Curso)
        BEGIN
            RAISERROR('El curso con Id %d no existe.', 16, 1, @Id_Curso);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Recurso_Academico WHERE Id_Recurso_Academico = @Id_Recurso_Academico)
        BEGIN
            RAISERROR('El recurso académico con Id %d no existe.', 16, 1, @Id_Recurso_Academico);
            RETURN;
        END

        -- Insertar el registro en Curso_Recurso_Academico
        INSERT INTO Curso_Recurso_Academico (Id_Curso, Id_Recurso_Academico)
        VALUES (@Id_Curso, @Id_Recurso_Academico);

        SET @Id_Curso_Rec_Academico = SCOPE_IDENTITY();

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Recurso académico asignado exitosamente al curso con ID: ' + CAST(@Id_Curso_Rec_Academico AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoRecursoAcademico_Update
    @Id_Curso_Rec_Academico INT,
    @Id_Curso INT,
    @Id_Recurso_Academico INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia del registro a actualizar
        IF NOT EXISTS (SELECT 1 FROM Curso_Recurso_Academico WHERE Id_Curso_Rec_Academico = @Id_Curso_Rec_Academico)
        BEGIN
            RAISERROR('El registro de Curso_Recurso_Academico con Id %d no existe.', 16, 1, @Id_Curso_Rec_Academico);
            RETURN;
        END

        -- Actualizar el registro en Curso_Recurso_Academico
        UPDATE Curso_Recurso_Academico
        SET Id_Curso = @Id_Curso, Id_Recurso_Academico = @Id_Recurso_Academico
        WHERE Id_Curso_Rec_Academico = @Id_Curso_Rec_Academico;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Registro de Curso_Recurso_Academico actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoRecursoAcademico_Delete
    @Id_Curso_Rec_Academico INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia del registro
        IF NOT EXISTS (SELECT 1 FROM Curso_Recurso_Academico WHERE Id_Curso_Rec_Academico = @Id_Curso_Rec_Academico)
        BEGIN
            RAISERROR('El registro de Curso_Recurso_Academico con Id %d no existe.', 16, 1, @Id_Curso_Rec_Academico);
            RETURN;
        END

        -- Eliminar el registro de Curso_Recurso_Academico
        DELETE FROM Curso_Recurso_Academico
        WHERE Id_Curso_Rec_Academico = @Id_Curso_Rec_Academico;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Registro de Curso_Recurso_Academico eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Curso Aula
CREATE PROCEDURE SP_CursoAula_Insert
    @Id_Curso INT,
    @Id_Aula INT,
    @Horario_clase DATETIME
AS
BEGIN
    DECLARE @Id_Curso_Aula INT;

    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar la existencia del curso y del aula
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @Id_Curso)
        BEGIN
            RAISERROR('El curso con Id %d no existe.', 16, 1, @Id_Curso);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Aula WHERE Id_Aula = @Id_Aula)
        BEGIN
            RAISERROR('El aula con Id %d no existe.', 16, 1, @Id_Aula);
            RETURN;
        END

        -- Insertar el registro en Curso_Aula
        INSERT INTO Curso_Aula (Id_Curso, Id_Aula, Horario_clase)
        VALUES (@Id_Curso, @Id_Aula, @Horario_clase);

        SET @Id_Curso_Aula = SCOPE_IDENTITY(); -- Obtener el Id generado

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Curso asignado al aula exitosamente con ID: ' + CAST(@Id_Curso_Aula AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoAula_Update
    @Id_Curso_Aula INT,
    @Id_Curso INT,
    @Id_Aula INT,
    @Horario_clase DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar la existencia del registro de Curso_Aula
        IF NOT EXISTS (SELECT 1 FROM Curso_Aula WHERE Id_Curso_Aula = @Id_Curso_Aula)
        BEGIN
            RAISERROR('El registro con Id %d en Curso_Aula no existe.', 16, 1, @Id_Curso_Aula);
            RETURN;
        END

        -- Validar la existencia del curso y del aula
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @Id_Curso)
        BEGIN
            RAISERROR('El curso con Id %d no existe.', 16, 1, @Id_Curso);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Aula WHERE Id_Aula = @Id_Aula)
        BEGIN
            RAISERROR('El aula con Id %d no existe.', 16, 1, @Id_Aula);
            RETURN;
        END

        -- Actualizar el registro en Curso_Aula
        UPDATE Curso_Aula
        SET Id_Curso = @Id_Curso, Id_Aula = @Id_Aula, Horario_clase = @Horario_clase
        WHERE Id_Curso_Aula = @Id_Curso_Aula;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Registro de Curso_Aula actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoAula_Delete
    @Id_Curso_Aula INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar la existencia del registro en Curso_Aula
        IF NOT EXISTS (SELECT 1 FROM Curso_Aula WHERE Id_Curso_Aula = @Id_Curso_Aula)
        BEGIN
            RAISERROR('El registro con Id %d en Curso_Aula no existe.', 16, 1, @Id_Curso_Aula);
            RETURN;
        END

        -- Eliminar el registro en Curso_Aula
        DELETE FROM Curso_Aula
        WHERE Id_Curso_Aula = @Id_Curso_Aula;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Registro de Curso_Aula eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Curso
CREATE PROCEDURE SP_Curso_Insert
    @IdCurso INT,
    @Nombre VARCHAR(150),
    @CodigoCurso VARCHAR(20),
    @Creditos INT,
    @HorasSemana INT,
    @IdProgAcademico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros antes de iniciar la transacción
    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    IF @CodigoCurso IS NULL OR LTRIM(RTRIM(@CodigoCurso)) = ''
    BEGIN
        RAISERROR('El campo CodigoCurso no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    IF @Creditos IS NULL
    BEGIN
        RAISERROR('El campo Creditos no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @HorasSemana IS NULL
    BEGIN
        RAISERROR('El campo HorasSemana no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdProgAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdProgAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción y bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el Curso ya existe
        IF EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d ya existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Programa Académico existe
        IF NOT EXISTS (SELECT 1 FROM Programa_Academico WHERE Id_Prog_Academico = @IdProgAcademico)
        BEGIN
            RAISERROR('El Programa Académico con Id %d no existe.', 16, 1, @IdProgAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo Curso
        INSERT INTO Curso (Id_Curso, Nombre, Codigo_Curso, Creditos, Horas_Semana, Id_Prog_Academico)
        VALUES (@IdCurso, @Nombre, @CodigoCurso, @Creditos, @HorasSemana, @IdProgAcademico);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El curso ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Curso_Update
    @IdCurso INT,
    @Nombre VARCHAR(150),
    @CodigoCurso VARCHAR(20),
    @Creditos INT,
    @HorasSemana INT,
    @IdProgAcademico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros antes de iniciar la transacción
    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END
    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END
    IF @CodigoCurso IS NULL OR LTRIM(RTRIM(@CodigoCurso)) = ''
    BEGIN
        RAISERROR('El campo CodigoCurso no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END
    IF @Creditos IS NULL
    BEGIN
        RAISERROR('El campo Creditos no puede ser nulo.', 16, 1);
        RETURN;
    END
    IF @HorasSemana IS NULL
    BEGIN
        RAISERROR('El campo HorasSemana no puede ser nulo.', 16, 1);
        RETURN;
    END
    IF @IdProgAcademico IS NULL
    BEGIN
        RAISERROR('El campo IdProgAcademico no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción y bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Programa Académico existe
        IF NOT EXISTS (SELECT 1 FROM Programa_Academico WHERE Id_Prog_Academico = @IdProgAcademico)
        BEGIN
            RAISERROR('El Programa Académico con Id %d no existe.', 16, 1, @IdProgAcademico);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el Curso
        DECLARE @affected_rows INT;
        UPDATE Curso
        SET
            Nombre = @Nombre,
            Codigo_Curso = @CodigoCurso,
            Creditos = @Creditos,
            Horas_Semana = @HorasSemana,
            Id_Prog_Academico = @IdProgAcademico
        WHERE Id_Curso = @IdCurso;

        -- Obtener filas afectadas
        SET @affected_rows = @@ROWCOUNT;

        -- Verificar si se afectó alguna fila
        IF @affected_rows = 0
        BEGIN
            RAISERROR('No se realizaron cambios al Curso con Id %d.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El curso ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO


USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Curso_Delete
    @IdCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro antes de iniciar la transacción
    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción y bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si existen inscripciones asociadas al Curso
        IF EXISTS (SELECT 1 FROM Inscripcion WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('No se puede eliminar el Curso con Id %d porque tiene inscripciones asociadas.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Otras verificaciones de integridad referencial pueden agregarse aquí

        -- Eliminar el Curso
        DELETE FROM Curso
        WHERE Id_Curso = @IdCurso;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El curso ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Horario
CREATE PROCEDURE SP_Horario_Insert
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdDocente INT,
    @IdCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros antes de iniciar la transacción
    IF @FechaInicio IS NULL
    BEGIN
        RAISERROR('El campo FechaInicio no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @FechaFin IS NULL
    BEGIN
        RAISERROR('El campo FechaFin no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción y bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el Docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El Docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo Horario sin especificar Id_Horario
        INSERT INTO Horario (FechaInicio, FechaFin, Id_Docente, Id_Curso)
        VALUES (@FechaInicio, @FechaFin, @IdDocente, @IdCurso);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El horario ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Horario_Update
    @IdHorario INT,
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdDocente INT,
    @IdCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros antes de iniciar la transacción
    IF @IdHorario IS NULL
    BEGIN
        RAISERROR('El campo IdHorario no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @FechaInicio IS NULL
    BEGIN
        RAISERROR('El campo FechaInicio no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @FechaFin IS NULL
    BEGIN
        RAISERROR('El campo FechaFin no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción y bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el Horario existe
        IF NOT EXISTS (SELECT 1 FROM Horario WHERE Id_Horario = @IdHorario)
        BEGIN
            RAISERROR('El Horario con Id %d no existe.', 16, 1, @IdHorario);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El Docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el Horario
        UPDATE Horario
        SET
            FechaInicio = @FechaInicio,
            FechaFin = @FechaFin,
            Id_Docente = @IdDocente,
            Id_Curso = @IdCurso
        WHERE Id_Horario = @IdHorario;

        -- Verificar si se afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se realizaron cambios al Horario con Id %d.', 16, 1, @IdHorario);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El horario ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Horario_Delete
    @IdHorario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro antes de iniciar la transacción
    IF @IdHorario IS NULL
    BEGIN
        RAISERROR('El campo IdHorario no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio del bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el Horario existe
        IF NOT EXISTS (SELECT 1 FROM Horario WHERE Id_Horario = @IdHorario)
        BEGIN
            RAISERROR('El Horario con Id %d no existe.', 16, 1, @IdHorario);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si existen dependencias referenciales
        -- Aquí podrías agregar verificaciones adicionales si existen tablas relacionadas

        -- Eliminar el Horario
        DELETE FROM Horario
        WHERE Id_Horario = @IdHorario;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El horario ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Docente_Curso
CREATE PROCEDURE SP_CursoDocente_Insert
    @IdDocente INT,
    @IdCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de los parámetros
    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio del bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si ya existe una asignación de ese docente a ese curso
        IF EXISTS (SELECT 1 FROM Docente_Curso WHERE Id_Docente = @IdDocente AND Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('La asignación del Docente con Id %d al Curso con Id %d ya existe.', 16, 1, @IdDocente, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El Docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la nueva asignación (sin especificar Id_Docente_Curso)
        INSERT INTO Docente_Curso (Id_Docente, Id_Curso)
        VALUES (@IdDocente, @IdCurso);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'La asignación del docente al curso ha sido insertada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO


USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoDocente_Update
    @IdDocenteCurso INT,
    @IdDocente INT,
    @IdCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros antes de iniciar la transacción
    IF @IdDocenteCurso IS NULL
    BEGIN
        RAISERROR('El campo IdDocenteCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @IdCurso IS NULL
    BEGIN
        RAISERROR('El campo IdCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio del bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la asignación existe
        IF NOT EXISTS (SELECT 1 FROM Docente_Curso WHERE Id_Docente_Curso = @IdDocenteCurso)
        BEGIN
            RAISERROR('La asignación Docente_Curso con Id %d no existe.', 16, 1, @IdDocenteCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El Docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el Curso existe
        IF NOT EXISTS (SELECT 1 FROM Curso WHERE Id_Curso = @IdCurso)
        BEGIN
            RAISERROR('El Curso con Id %d no existe.', 16, 1, @IdCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar la asignación
        UPDATE Docente_Curso
        SET
            Id_Docente = @IdDocente,
            Id_Curso = @IdCurso
        WHERE Id_Docente_Curso = @IdDocenteCurso;

        -- Verificar si se afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se realizaron cambios a la asignación con Id %d.', 16, 1, @IdDocenteCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'La asignación del docente al curso ha sido actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_CursoDocente_Delete
    @IdDocenteCurso INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro antes de iniciar la transacción
    IF @IdDocenteCurso IS NULL
    BEGIN
        RAISERROR('El campo IdDocenteCurso no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio del bloque TRY...CATCH
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la asignación existe
        IF NOT EXISTS (SELECT 1 FROM Docente_Curso WHERE Id_Docente_Curso = @IdDocenteCurso)
        BEGIN
            RAISERROR('La asignación Docente_Curso con Id %d no existe.', 16, 1, @IdDocenteCurso);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si existen dependencias referenciales
        -- Aquí podrías agregar verificaciones adicionales si existen tablas relacionadas

        -- Eliminar la asignación
        DELETE FROM Docente_Curso
        WHERE Id_Docente_Curso = @IdDocenteCurso;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'La asignación del docente al curso ha sido eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores y rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Relanzar el error original
        THROW;
    END CATCH
END
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Estudiante
CREATE PROCEDURE SP_Estudiante_Insert
    @Nombre VARCHAR(100),
    @Apellido1 VARCHAR(100),
    @Apellido2 VARCHAR(100),
    @Email VARCHAR(150),
    @Telefono VARCHAR(15),
    @Direccion VARCHAR(150)
AS
BEGIN
    DECLARE @Existe INT;

    -- Etiqueta de inicio
    BEGIN TRY
        BEGIN TRANSACTION InsertEstudiante;

        -- Verificar si el estudiante ya existe
        SELECT @Existe = COUNT(1) 
        FROM Estudiante 
        WHERE Email = @Email;

        IF @Existe > 0
        BEGIN
            RAISERROR('El estudiante con este email ya existe.', 16, 1);
            ROLLBACK TRANSACTION InsertEstudiante;
            RETURN;
        END

        -- Insertar el nuevo estudiante
        INSERT INTO Estudiante (Nombre, Apellido1, Apellido2, Email, Telefono, Direccion)
        VALUES (@Nombre, @Apellido1, @Apellido2, @Email, @Telefono, @Direccion);

        -- Confirmar la transacción
        COMMIT TRANSACTION InsertEstudiante;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION InsertEstudiante;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Estudiante_Update
    @IdEstudiante INT,
    @Nombre VARCHAR(100),
    @Apellido1 VARCHAR(100),
    @Apellido2 VARCHAR(100),
    @Email VARCHAR(150),
    @Telefono VARCHAR(15),
    @Direccion VARCHAR(150)
AS
BEGIN
    DECLARE @Existe INT;

    BEGIN TRY
        BEGIN TRANSACTION UpdateEstudiante;

        -- Verificar si el estudiante existe
        SELECT @Existe = COUNT(1) 
        FROM Estudiante 
        WHERE Id_Estudiante = @IdEstudiante;

        IF @Existe = 0
        BEGIN
            RAISERROR('El estudiante no existe.', 16, 1);
            ROLLBACK TRANSACTION UpdateEstudiante;
            RETURN;
        END

        -- Actualizar la información del estudiante
        UPDATE Estudiante
        SET Nombre = @Nombre, Apellido1 = @Apellido1, Apellido2 = @Apellido2,
            Email = @Email, Telefono = @Telefono, Direccion = @Direccion
        WHERE Id_Estudiante = @IdEstudiante;

        -- Confirmar la transacción
        COMMIT TRANSACTION UpdateEstudiante;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateEstudiante;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Estudiante_Delete
    @IdEstudiante INT
AS
BEGIN
    DECLARE @TieneInscripciones INT;

    BEGIN TRY
        BEGIN TRANSACTION DeleteEstudiante;

        -- Verificar si el estudiante tiene inscripciones asociadas
        SELECT @TieneInscripciones = COUNT(1)
        FROM Inscripcion
        WHERE Id_Estudiante = @IdEstudiante;

        IF @TieneInscripciones > 0
        BEGIN
            RAISERROR('No se puede eliminar el estudiante porque tiene inscripciones asociadas.', 16, 1);
            ROLLBACK TRANSACTION DeleteEstudiante;
            RETURN;
        END

        -- Eliminar el estudiante
        DELETE FROM Estudiante
        WHERE Id_Estudiante = @IdEstudiante;

        -- Confirmar la transacción
        COMMIT TRANSACTION DeleteEstudiante;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION DeleteEstudiante;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Inscripcion
CREATE PROCEDURE SP_Inscripcion_Insert
    @IdEstudiante INT,
    @IdCurso INT,
    @Estado VARCHAR(20)
AS
BEGIN
    DECLARE @FechaActual DATE;
    SET @FechaActual = GETDATE();

    IF EXISTS (SELECT 1 
               FROM Inscripcion
               WHERE Id_Curso = @IdCurso AND Id_Estudiante = @IdEstudiante)
    BEGIN
        RAISERROR('El estudiante ya está inscrito en este curso.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar la nueva inscripción
        INSERT INTO Inscripcion (Fecha_inscripcion, Estado, Id_Curso, Id_Estudiante)
        VALUES (@FechaActual, @Estado, @IdCurso, @IdEstudiante);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si hay un error, revertir la transacción
        ROLLBACK TRANSACTION;

        -- Mostrar mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Inscripcion_Update
    @IdInscripcion INT,
    @NuevoEstado VARCHAR(20)
AS
BEGIN
    DECLARE @ExisteInscripcion INT;

    BEGIN TRY
        BEGIN TRANSACTION UpdateInscripcion;

        -- Verificar si la inscripción existe
        SELECT @ExisteInscripcion = COUNT(1)
        FROM Inscripcion
        WHERE Id_Inscripcion = @IdInscripcion;

        IF @ExisteInscripcion = 0
        BEGIN
            RAISERROR('La inscripción no existe.', 16, 1);
            ROLLBACK TRANSACTION UpdateInscripcion;
            RETURN;
        END

        -- Actualizar el estado de la inscripción
        UPDATE Inscripcion
        SET Estado = @NuevoEstado
        WHERE Id_Inscripcion = @IdInscripcion;

        -- Confirmar la transacción
        COMMIT TRANSACTION UpdateInscripcion;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateInscripcion;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Inscripcion_Delete
    @IdInscripcion INT
AS
BEGIN
    DECLARE @ExisteInscripcion INT;

    BEGIN TRY
        BEGIN TRANSACTION DeleteInscripcion;

        -- Verificar si la inscripción existe
        SELECT @ExisteInscripcion = COUNT(1)
        FROM Inscripcion
        WHERE Id_Inscripcion = @IdInscripcion;

        IF @ExisteInscripcion = 0
        BEGIN
            RAISERROR('La inscripción no existe.', 16, 1);
            ROLLBACK TRANSACTION DeleteInscripcion;
            RETURN;
        END

        -- Eliminar la inscripción
        DELETE FROM Inscripcion
        WHERE Id_Inscripcion = @IdInscripcion;

        -- Confirmar la transacción
        COMMIT TRANSACTION DeleteInscripcion;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION DeleteInscripcion;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Historial_Academico
CREATE PROCEDURE SP_HistorialAcademico_Insert
    @IdCurso INT,
    @IdEstudiante INT,
    @Nota DECIMAL(5,2)
AS
BEGIN
    -- Variables locales
    DECLARE @FechaCalificacion DATE = GETDATE();
    DECLARE @ExisteHistorial INT;

    -- Etiqueta de inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION InsertHistorial;

        -- Verificar si ya existe una calificación para el estudiante en el curso
        SELECT @ExisteHistorial = COUNT(1)
        FROM Historial_Academico
        WHERE Id_Curso = @IdCurso AND Id_Estudiante = @IdEstudiante;

        -- Si ya existe, lanzamos un error
        IF @ExisteHistorial > 0
        BEGIN
            RAISERROR('Ya existe una calificación para este estudiante en este curso.', 16, 1);
            ROLLBACK TRANSACTION InsertHistorial;
            RETURN;
        END

        -- Si no existe, insertamos el nuevo registro en el historial académico
        INSERT INTO Historial_Academico (Nota, Fecha_Calificacion, Id_Curso, Id_Estudiante)
        VALUES (@Nota, @FechaCalificacion, @IdCurso, @IdEstudiante);

        -- Confirmar la transacción
        COMMIT TRANSACTION InsertHistorial;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revertimos la transacción
        ROLLBACK TRANSACTION InsertHistorial;

        -- Capturar y mostrar el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_HistorialAcademico_Update
    @IdHistorial INT,
    @Nota DECIMAL(5,2),
    @FechaCalificacion DATE
AS
BEGIN
    DECLARE @ExisteHistorial INT;

    BEGIN TRY
        BEGIN TRANSACTION UpdateHistorial;

        -- Verificar si el registro del historial académico existe
        SELECT @ExisteHistorial = COUNT(1)
        FROM Historial_Academico
        WHERE Id_Historial_Academico = @IdHistorial;

        IF @ExisteHistorial = 0
        BEGIN
            RAISERROR('El historial académico no existe.', 16, 1);
            ROLLBACK TRANSACTION UpdateHistorial;
            RETURN;
        END

        -- Actualizar el historial académico
        UPDATE Historial_Academico
        SET Nota = @Nota, Fecha_Calificacion = @FechaCalificacion
        WHERE Id_Historial_Academico = @IdHistorial;

        -- Confirmar la transacción
        COMMIT TRANSACTION UpdateHistorial;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateHistorial;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_HistorialAcademico_Delete
    @IdHistorial INT
AS
BEGIN
    DECLARE @ExisteHistorial INT;

    BEGIN TRY
        BEGIN TRANSACTION DeleteHistorial;

        -- Verificar si el registro del historial académico existe
        SELECT @ExisteHistorial = COUNT(1)
        FROM Historial_Academico
        WHERE Id_Historial_Academico = @IdHistorial;

        IF @ExisteHistorial = 0
        BEGIN
            RAISERROR('El historial académico no existe.', 16, 1);
            ROLLBACK TRANSACTION DeleteHistorial;
            RETURN;
        END

        -- Eliminar el historial académico
        DELETE FROM Historial_Academico
        WHERE Id_Historial_Academico = @IdHistorial;

        -- Confirmar la transacción
        COMMIT TRANSACTION DeleteHistorial;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION DeleteHistorial;

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Procedimientos almacenados para Docente
CREATE PROCEDURE SP_Docente_Insert
    @IdDocente INT,
    @Nombre VARCHAR(100),
    @Apellido1 VARCHAR(100),
    @Apellido2 VARCHAR(100),
    @Email VARCHAR(150),
    @Especialidad VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        RAISERROR('El campo Nombre no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el docente ya existe
        IF EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El docente con Id %d ya existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo docente
        INSERT INTO Docente (Id_Docente, Nombre, Apellido1, Apellido2, Email, Especialidad, Telefono)
        VALUES (@IdDocente, @Nombre, @Apellido1, @Apellido2, @Email, @Especialidad, @Telefono);

        COMMIT TRANSACTION;
        PRINT 'El docente ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Docente_Update
    @IdDocente INT,
    @Nombre VARCHAR(100),
    @Apellido1 VARCHAR(100),
    @Apellido2 VARCHAR(100),
    @Email VARCHAR(150),
    @Especialidad VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el docente
        UPDATE Docente
        SET Nombre = @Nombre,
            Apellido1 = @Apellido1,
            Apellido2 = @Apellido2,
            Email = @Email,
            Especialidad = @Especialidad,
            Telefono = @Telefono
        WHERE Id_Docente = @IdDocente;

        COMMIT TRANSACTION;
        PRINT 'El docente ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE SP_Docente_Delete
    @IdDocente INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdDocente IS NULL
    BEGIN
        RAISERROR('El campo IdDocente no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el docente existe
        IF NOT EXISTS (SELECT 1 FROM Docente WHERE Id_Docente = @IdDocente)
        BEGIN
            RAISERROR('El docente con Id %d no existe.', 16, 1, @IdDocente);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar el docente
        DELETE FROM Docente WHERE Id_Docente = @IdDocente;

        COMMIT TRANSACTION;
        PRINT 'El docente ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwCurso AS
SELECT
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    c.Codigo_Curso,
    c.Creditos,
    c.Horas_Semana,
    pa.Id_Prog_Academico,
    pa.Nombre AS NombrePrograma,
    na.Id_Nivel_Academico,
    na.Nombre AS NivelAcademico,
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Curso c
    INNER JOIN Programa_Academico pa ON c.Id_Prog_Academico = pa.Id_Prog_Academico
    INNER JOIN Nivel_Academico na ON pa.Id_Nivel_Academico = na.Id_Nivel_Academico
    INNER JOIN Facultad f ON pa.Id_Facultad = f.Id_Facultad;
GO

CREATE VIEW dbo.vwHorario AS
SELECT
    h.Id_Horario,
    h.FechaInicio,
    h.FechaFin,
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    d.Id_Docente,
    CONCAT(d.Nombre, ' ', d.Apellido1, ' ', d.Apellido2) AS NombreCompletoDocente,
    pa.Id_Prog_Academico,
    pa.Nombre AS NombrePrograma,
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Horario h
    INNER JOIN Curso c ON h.Id_Curso = c.Id_Curso
    INNER JOIN Docente d ON h.Id_Docente = d.Id_Docente
    INNER JOIN Programa_Academico pa ON c.Id_Prog_Academico = pa.Id_Prog_Academico
    INNER JOIN Facultad f ON pa.Id_Facultad = f.Id_Facultad;
GO

CREATE VIEW dbo.vwDocenteCurso AS
SELECT
    dc.Id_Docente_Curso,
    d.Id_Docente,
    CONCAT(d.Nombre, ' ', d.Apellido1, ' ', d.Apellido2) AS NombreCompletoDocente,
    d.Email AS EmailDocente,
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    c.Codigo_Curso,
    pa.Id_Prog_Academico,
    pa.Nombre AS NombrePrograma,
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Docente_Curso dc
    INNER JOIN Docente d ON dc.Id_Docente = d.Id_Docente
    INNER JOIN Curso c ON dc.Id_Curso = c.Id_Curso
    INNER JOIN Programa_Academico pa ON c.Id_Prog_Academico = pa.Id_Prog_Academico
    INNER JOIN Facultad f ON pa.Id_Facultad = f.Id_Facultad;
GO

CREATE VIEW dbo.vwAuditoriaAccion AS
SELECT
    aa.Id_Accion,
    aa.Accion_Realizada
FROM
    Auditoria_Accion aa;
GO

-- Vista para la tabla Historial_Cambio con información detallada
CREATE VIEW dbo.vwHistorialCambio AS
SELECT
    hc.Id_Historial_Cambio,
    hc.Usuario,
    hc.Fecha,
    hc.Tabla,
    hc.Id_Registro,
    aa.Accion_Realizada,
    hc.Datos_Anteriores,
    hc.Datos_Nuevos
FROM
    Historial_Cambio hc
    INNER JOIN Auditoria_Accion aa ON hc.Id_Accion = aa.Id_Accion;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE VIEW dbo.vwFacultad AS
SELECT
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Facultad f;
GO

USE Universidad_InnovacionConocimiento;
GO
CREATE VIEW dbo.vwNivelAcademico AS
SELECT
    na.Id_Nivel_Academico,
    na.Nombre AS NombreNivelAcademico
FROM
    Nivel_Academico na;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwProgramaAcademico AS
SELECT
    pa.Id_Prog_Academico,
    pa.Nombre AS NombrePrograma,
    pa.Duracion,
    na.Id_Nivel_Academico,
    na.Nombre AS NivelAcademico,
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Programa_Academico pa
    INNER JOIN Nivel_Academico na ON pa.Id_Nivel_Academico = na.Id_Nivel_Academico
    INNER JOIN Facultad f ON pa.Id_Facultad = f.Id_Facultad;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwCursoRecursoAcademico AS
SELECT
    cra.Id_Curso_Rec_Academico,
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    ra.Id_Recurso_Academico,
    ra.Tipo AS TipoRecurso,
    ra.Estado AS EstadoRecurso
FROM
    Curso_Recurso_Academico cra
    INNER JOIN Curso c ON cra.Id_Curso = c.Id_Curso
    INNER JOIN Recurso_Academico ra ON cra.Id_Recurso_Academico = ra.Id_Recurso_Academico;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwAulasDisponibles AS
SELECT
    a.Id_Aula,
    a.Codigo_aula,
    a.Ubicacion,
    a.Capacidad,
    a.Equipamiento
FROM
    Aula a
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Curso_Aula ca
        INNER JOIN Horario h ON ca.Id_Curso = h.Id_Curso
        WHERE ca.Id_Aula = a.Id_Aula
        AND GETDATE() BETWEEN h.FechaInicio AND h.FechaFin
    );
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwCursoAula AS
SELECT
    ca.Id_Curso_Aula,
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    a.Id_Aula,
    a.Codigo_aula,
    a.Ubicacion,
    a.Capacidad,
    ca.Horario_clase
FROM
    Curso_Aula ca
    INNER JOIN Aula a ON ca.Id_Aula = a.Id_Aula
    INNER JOIN Curso c ON ca.Id_Curso = c.Id_Curso;
GO

USE Universidad_InnovacionConocimiento;
GO

CREATE VIEW dbo.vwasigCursoAula AS
SELECT
    ca.Id_Curso_Aula,
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    a.Id_Aula,
    a.Codigo_aula,
    a.Ubicacion,
    a.Capacidad,
    ca.Horario_clase
FROM
    Curso_Aula ca
    INNER JOIN Aula a ON ca.Id_Aula = a.Id_Aula
    INNER JOIN Curso c ON ca.Id_Curso = c.Id_Curso;
GO

CREATE VIEW dbo.vwResumenCurso AS
SELECT
    c.Id_Curso,
    c.Nombre AS NombreCurso,
    c.Codigo_Curso,
    a.Id_Aula,
    a.Codigo_aula,
    a.Ubicacion,
    a.Capacidad,
    ca.Horario_clase,
    ra.Id_Recurso_Academico,
    ra.Tipo AS TipoRecurso,
    ra.Estado AS EstadoRecurso
FROM
    Curso c
     JOIN Curso_Aula ca ON c.Id_Curso = ca.Id_Curso
     JOIN Aula a ON ca.Id_Aula = a.Id_Aula
     JOIN Curso_Recurso_Academico cra ON c.Id_Curso = cra.Id_Curso
     JOIN Recurso_Academico ra ON cra.Id_Recurso_Academico = ra.Id_Recurso_Academico;
GO

CREATE VIEW dbo.vwDocente AS
SELECT
    d.Id_Docente,
    CONCAT(d.Nombre, ' ', d.Apellido1, ' ', d.Apellido2) AS NombreCompletoDocente,
    d.Email,
    d.Especialidad,
    d.Telefono
FROM
    Docente d;
GO

CREATE VIEW vw_EstudiantesActivos
AS
SELECT e.*
FROM Estudiante e
INNER JOIN Inscripcion i ON e.Id_Estudiante = i.Id_Estudiante
WHERE i.Estado = 'Activo';
GO

CREATE VIEW vwInscripcionesActivas
AS
SELECT i.*
FROM Inscripcion i
WHERE i.Estado = 'Activo';
GO

INSERT INTO Auditoria_Accion (Accion_Realizada) VALUES ('INSERT');
INSERT INTO Auditoria_Accion (Accion_Realizada) VALUES ('UPDATE');
INSERT INTO Auditoria_Accion (Accion_Realizada) VALUES ('DELETE');

-- 1. FACULTAD
EXEC SP_Facultad_Insert 1, 'Facultad de Ingeniería'
EXEC SP_Facultad_Insert 2, 'Facultad de Ciencias'
EXEC SP_Facultad_Insert 3, 'Facultad de Humanidades'
EXEC SP_Facultad_Insert 4, 'Facultad de Medicina'
EXEC SP_Facultad_Insert 5, 'Facultad de Derecho'

-- Actualización de Facultad
EXEC SP_Facultad_Update 1, 'Facultad de Ingeniería y Tecnología'

-- 2. NIVEL ACADÉMICO
EXEC SP_NivelAcademico_Insert 1, 'Pregrado'
EXEC SP_NivelAcademico_Insert 2, 'Maestría'
EXEC SP_NivelAcademico_Insert 3, 'Doctorado'
EXEC SP_NivelAcademico_Insert 4, 'Técnico'
EXEC SP_NivelAcademico_Insert 5, 'Especialización'

-- Actualización de Nivel Académico
EXEC SP_NivelAcademico_Update 1, 'Pregrado Universitario'

-- 3. PROGRAMA ACADÉMICO
EXEC SP_ProgramaAcademico_Insert 1, 'Ingeniería de Sistemas', 10, 1, 1
EXEC SP_ProgramaAcademico_Insert 2, 'Ingeniería Civil', 10, 1, 1
EXEC SP_ProgramaAcademico_Insert 3, 'Biología', 8, 1, 2
EXEC SP_ProgramaAcademico_Insert 4, 'Maestría en Física', 4, 2, 2
EXEC SP_ProgramaAcademico_Insert 5, 'Psicología', 10, 1, 3

-- Actualización de Programa Académico
EXEC SP_ProgramaAcademico_Update 1, 'Ingeniería de Software', 10, 1, 1

-- 4. RECURSO ACADÉMICO
EXEC SP_RecursoAcademico_Insert 'Proyector', 'Activo'
EXEC SP_RecursoAcademico_Insert 'Computadora', 'Activo'
EXEC SP_RecursoAcademico_Insert 'Pizarra Digital', 'Activo'
EXEC SP_RecursoAcademico_Insert 'Laboratorio', 'Activo'
EXEC SP_RecursoAcademico_Insert 'Equipo de Audio', 'Activo'

-- Actualización de Recurso Académico
EXEC SP_RecursoAcademico_Update 1, 'Proyector HD', 'Activo'

-- 5. AULA
EXEC SP_Aula_Insert '101A', 30, 'Primer piso', 'Proyector, PC'
EXEC SP_Aula_Insert '102B', 25, 'Primer piso', 'Proyector'
EXEC SP_Aula_Insert '201A', 35, 'Segundo piso', 'Smart TV'
EXEC SP_Aula_Insert '202B', 40, 'Segundo piso', 'Proyector, Audio'
EXEC SP_Aula_Insert '301A', 45, 'Tercer piso', 'Laboratorio Completo'

-- Actualización de Aula
EXEC SP_Aula_Update 1, '101A-Plus', 35, 'Primer piso', 'Proyector HD, PC, Audio'

-- 6. DOCENTE
EXEC SP_Docente_Insert 1, 'Juan', 'Pérez', 'López', 'juan.perez@univ.edu', 'Sistemas', '555-1111'
EXEC SP_Docente_Insert 2, 'María', 'González', 'Ruiz', 'maria.gon@univ.edu', 'Matemáticas', '555-2222'
EXEC SP_Docente_Insert 3, 'Carlos', 'Rodríguez', 'Silva', 'carlos.rod@univ.edu', 'Física', '555-3333'
EXEC SP_Docente_Insert 4, 'Ana', 'Martínez', 'Soto', 'ana.mar@univ.edu', 'Biología', '555-4444'
EXEC SP_Docente_Insert 5, 'Pedro', 'Sánchez', 'Vega', 'pedro.san@univ.edu', 'Química', '555-5555'

-- Actualización de Docente
EXEC SP_Docente_Update 1, 'Juan Alberto', 'Pérez', 'López', 'juan.perez@univ.edu', 'Sistemas Avanzados', '555-1111'

-- 7. CURSO
EXEC SP_Curso_Insert 1, 'Programación I', 'PRG101', 4, 6, 1
EXEC SP_Curso_Insert 2, 'Base de Datos', 'BD101', 4, 6, 1
EXEC SP_Curso_Insert 3, 'Estructuras', 'EST101', 4, 6, 2
EXEC SP_Curso_Insert 4, 'Biología Celular', 'BIO101', 4, 6, 3
EXEC SP_Curso_Insert 5, 'Psicología General', 'PSI101', 4, 6, 5

-- Actualización de Curso
EXEC SP_Curso_Update 1, 'Programación Avanzada', 'PRG102', 4, 6, 1

-- 8. HORARIO
EXEC SP_Horario_Insert  '2024-01-15', '2024-06-15', 1, 1
EXEC SP_Horario_Insert  '2024-01-15', '2024-06-15', 2, 2
EXEC SP_Horario_Insert  '2024-01-15', '2024-06-15', 3, 3
EXEC SP_Horario_Insert  '2024-01-15', '2024-06-15', 4, 4
EXEC SP_Horario_Insert  '2024-01-15', '2024-06-15', 5, 5

-- Actualización de Horario
EXEC SP_Horario_Update 1, '2024-01-22', '2024-06-22', 1, 1

-- 9. CURSO-RECURSO ACADÉMICO
EXEC SP_CursoRecursoAcademico_Insert 1, 1
EXEC SP_CursoRecursoAcademico_Insert 1, 2
EXEC SP_CursoRecursoAcademico_Insert 2, 2
EXEC SP_CursoRecursoAcademico_Insert 3, 3
EXEC SP_CursoRecursoAcademico_Insert 4, 4

-- Actualización de Curso-Recurso Académico
EXEC SP_CursoRecursoAcademico_Update 1, 1, 2

-- 10. CURSO-AULA
EXEC SP_CursoAula_Insert 1, 1, '2024-01-15 08:00:00'
EXEC SP_CursoAula_Insert 2, 2, '2024-01-15 10:00:00'
EXEC SP_CursoAula_Insert 3, 3, '2024-01-15 14:00:00'
EXEC SP_CursoAula_Insert 4, 4, '2024-01-15 16:00:00'
EXEC SP_CursoAula_Insert 5, 5, '2024-01-15 18:00:00'

-- Actualización de Curso-Aula
EXEC SP_CursoAula_Update 1, 1, 2, '2024-01-15 09:00:00'

-- 11. CURSO-DOCENTE
EXEC SP_CursoDocente_Insert  1, 1
EXEC SP_CursoDocente_Insert  2, 2
EXEC SP_CursoDocente_Insert  3, 3
EXEC SP_CursoDocente_Insert  4, 4
EXEC SP_CursoDocente_Insert  5, 5

-- Actualización de Curso-Docente
EXEC SP_CursoDocente_Update 1, 2, 1

-- 12. ESTUDIANTE
EXEC SP_Estudiante_Insert 'Ana', 'López', 'García', 'ana.lopez@univ.edu', '555-6666', 'Calle 123'
EXEC SP_Estudiante_Insert 'Luis', 'García', 'Pérez', 'luis.garcia@univ.edu', '555-7777', 'Av. Principal 456'
EXEC SP_Estudiante_Insert 'Carmen', 'Torres', 'Ruiz', 'carmen.torres@univ.edu', '555-8888', 'Plaza Mayor 789'
EXEC SP_Estudiante_Insert 'Diego', 'Ruiz', 'Soto', 'diego.ruiz@univ.edu', '555-9999', 'Calle Norte 321'
EXEC SP_Estudiante_Insert 'Elena', 'Castro', 'Vega', 'elena.castro@univ.edu', '555-0000', 'Av. Sur 654'

-- Actualización de Estudiante
EXEC SP_Estudiante_Update 1, 'Ana María', 'López', 'García', 'ana.lopez@univ.edu', '555-6666', 'Calle 123'

-- 13. INSCRIPCIÓN
EXEC SP_Inscripcion_Insert 1, 1, 'Activa'
EXEC SP_Inscripcion_Insert 2, 1, 'Activa'
EXEC SP_Inscripcion_Insert 3, 2, 'Activa'
EXEC SP_Inscripcion_Insert 4, 3, 'Activa'
EXEC SP_Inscripcion_Insert 5, 4, 'Activa'

-- Actualización de Inscripción
EXEC SP_Inscripcion_Update 1, 'Completada'

-- 14. HISTORIAL ACADÉMICO
EXEC SP_HistorialAcademico_Insert 1, 1, 85.5
EXEC SP_HistorialAcademico_Insert 2, 1, 90.0
EXEC SP_HistorialAcademico_Insert 3, 2, 78.5
EXEC SP_HistorialAcademico_Insert 4, 3, 88.0
EXEC SP_HistorialAcademico_Insert 5, 4, 92.5

-- Actualización de Historial Académico
EXEC SP_HistorialAcademico_Update 1, 87.5, '2024-01-15'

-- ELIMINACIONES (En orden inverso para mantener integridad referencial)
EXEC SP_HistorialAcademico_Delete 5
EXEC SP_Inscripcion_Delete 5
EXEC SP_Estudiante_Delete 5
EXEC SP_CursoDocente_Delete 5
EXEC SP_CursoAula_Delete 5
EXEC SP_CursoRecursoAcademico_Delete 5
EXEC SP_Horario_Delete 5
EXEC SP_Curso_Delete 5
EXEC SP_Docente_Delete 5
EXEC SP_Aula_Delete 5
EXEC SP_RecursoAcademico_Delete 5
EXEC SP_ProgramaAcademico_Delete 5
EXEC SP_NivelAcademico_Delete 5
EXEC SP_Facultad_Delete 5