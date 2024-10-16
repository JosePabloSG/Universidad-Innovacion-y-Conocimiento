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

---------------------------------------------------YOILIN-----------------------------------------------------


--Triggers del area de Recursos Académicos y Aulas

-------Triggers PARA RECURSOS ACADEMICOS     ----------
-----  ___________________________________   ---------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRInsertRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRUpdateRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TREliminarRecursoAcademico
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

-----      Triggers PARA AULAS      ----------
-----  ____________________________ ---------

USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TRInsertAula
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRUpdateAula
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


-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TREliminarAula
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

-------  Triggers EN CURSO_RECURSO_ACADEMICO ---------
-----  _________________________________________---------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRInsertCursoRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRUpdateCursoRecursoAcademico
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

-------------------------------------------------------
USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TREliminarCursoRecursoAcademico
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


-----         Triggers EN CURSO_ AULA        ---------
-----  ______________________________________---------

USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRInsertCursoAula
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


-------------------------------------------------------
USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TRUpdateCursoAula
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


-------------------------------------------------------
USE Universidad_InnovacionConocimiento;
GO

CREATE TRIGGER TREliminarCursoAula
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
