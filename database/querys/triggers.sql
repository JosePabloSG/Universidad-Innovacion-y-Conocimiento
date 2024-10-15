USE Universidad_InnovacionConocimiento;
GO

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
