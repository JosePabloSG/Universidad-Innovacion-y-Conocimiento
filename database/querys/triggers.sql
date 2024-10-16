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

--ESTUDIANTES, INSCRIPCIONES Y HISTORIAL ACADEMICO.

--Triggers para Estudiantes

--TR_insertEstudiante
USE Universidad_InnovacionConocimiento;
GO
CREATE TRIGGER TR_InsertEstudiante
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

--TR_updateEstudiante
CREATE TRIGGER TR_UpdateEstudiante
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

--TR_deleteEstudiante
CREATE TRIGGER TR_DeleteEstudiante
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


--TRIGGERS PARA INSCRIPCIONES

--TR_insertInscripcion
CREATE TRIGGER TR_InsertInscripcion
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

--TR_updateInscripcion
CREATE TRIGGER TR_UpdateInscripcion
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

--TR_deleteInscripcion
CREATE TRIGGER TR_DeleteInscripcion
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


--TRIGGERS PARA HISTORIAL ACADEMICO

--TR_insertHistorial
CREATE TRIGGER TR_InsertHistorialAcademico
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


--TR_updateHistorial
CREATE TRIGGER TR_UpdateHistorialAcademico
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


--TR_deleteHistorial
CREATE TRIGGER TR_DeleteHistorialAcademico
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


