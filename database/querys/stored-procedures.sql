USE Universidad_InnovacionConocimiento;
GO

-- Procedimiento almacenado para insertar un nuevo Curso con validaciones y mejoras
CREATE PROCEDURE uspInsertCurso
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

-- Procedimiento almacenado para actualizar un Curso existente con validaciones y mejoras
CREATE PROCEDURE uspUpdateCurso
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
        UPDATE Curso
        SET
            Nombre = @Nombre,
            Codigo_Curso = @CodigoCurso,
            Creditos = @Creditos,
            Horas_Semana = @HorasSemana,
            Id_Prog_Academico = @IdProgAcademico
        WHERE Id_Curso = @IdCurso;

        -- Verificar si se afectó alguna fila
        IF @@ROWCOUNT = 0
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

-- Procedimiento almacenado para eliminar un Curso con validaciones y mejoras
CREATE PROCEDURE uspDeleteCurso
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

-- Procedimiento almacenado para insertar un nuevo Horario con validaciones y mejoras
CREATE PROCEDURE uspInsertHorario
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

        -- Verificar si el Horario ya existe
        IF EXISTS (SELECT 1 FROM Horario WHERE Id_Horario = @IdHorario)
        BEGIN
            RAISERROR('El Horario con Id %d ya existe.', 16, 1, @IdHorario);
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

        -- Insertar el nuevo Horario
        INSERT INTO Horario (Id_Horario, FechaInicio, FechaFin, Id_Docente, Id_Curso)
        VALUES (@IdHorario, @FechaInicio, @FechaFin, @IdDocente, @IdCurso);

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

-- Procedimiento almacenado para actualizar un Horario existente con validaciones y mejoras
CREATE PROCEDURE uspUpdateHorario
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

-- Procedimiento almacenado para eliminar un Horario con validaciones y mejoras
CREATE PROCEDURE uspDeleteHorario
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

-- Procedimiento almacenado para insertar una nueva asignación Docente_Curso con validaciones y mejoras
CREATE PROCEDURE uspInsertDocenteCurso
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

        -- Verificar si la asignación ya existe
        IF EXISTS (SELECT 1 FROM Docente_Curso WHERE Id_Docente_Curso = @IdDocenteCurso)
        BEGIN
            RAISERROR('La asignación Docente_Curso con Id %d ya existe.', 16, 1, @IdDocenteCurso);
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

        -- Insertar la nueva asignación
        INSERT INTO Docente_Curso (Id_Docente_Curso, Id_Docente, Id_Curso)
        VALUES (@IdDocenteCurso, @IdDocente, @IdCurso);

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

-- Procedimiento almacenado para actualizar una asignación Docente_Curso existente con validaciones y mejoras
CREATE PROCEDURE uspUpdateDocenteCurso
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

-- Procedimiento almacenado para eliminar una asignación Docente_Curso con validaciones y mejoras
CREATE PROCEDURE uspDeleteDocenteCurso
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


----------------------------------------
------------------------DOCENTE---------
----------------------------------------


-------------------------INSERTAR
USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertDocente
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


-------------------------ACTUALIZAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspUpdateDocente
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

--------------------------ELIMINAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspDeleteDocente
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


------------------------------------------
------------------------HISTORIAL_CAMBIO--
------------------------------------------

-----------------------INSERTAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertHistorialCambio
    @Usuario VARCHAR(100),
    @IdRegistro INT,
    @Tabla VARCHAR(50),
    @IdAccion INT,
    @DatosAnteriores NVARCHAR(MAX),
    @DatosNuevos NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @Usuario IS NULL OR LTRIM(RTRIM(@Usuario)) = ''
    BEGIN
        RAISERROR('El campo Usuario no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    IF @Tabla IS NULL OR LTRIM(RTRIM(@Tabla)) = ''
    BEGIN
        RAISERROR('El campo Tabla no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    -- Insertar nuevo historial de cambios
    BEGIN TRY
        INSERT INTO Historial_Cambio (Usuario, Id_Registro, Tabla, Id_Accion, Datos_Anteriores, Datos_Nuevos)
        VALUES (@Usuario, @IdRegistro, @Tabla, @IdAccion, @DatosAnteriores, @DatosNuevos);

        PRINT 'El historial de cambios ha sido insertado exitosamente.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

--------------------------------ACTUALIZAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspUpdateHistorialCambio
    @IdHistorialCambio INT,
    @Usuario VARCHAR(100),
    @IdRegistro INT,
    @Tabla VARCHAR(50),
    @IdAccion INT,
    @DatosAnteriores NVARCHAR(MAX),
    @DatosNuevos NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdHistorialCambio IS NULL
    BEGIN
        RAISERROR('El campo IdHistorialCambio no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @Usuario IS NULL OR LTRIM(RTRIM(@Usuario)) = ''
    BEGIN
        RAISERROR('El campo Usuario no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el historial de cambio existe
        IF NOT EXISTS (SELECT 1 FROM Historial_Cambio WHERE Id_Historial_Cambio = @IdHistorialCambio)
        BEGIN
            RAISERROR('El historial de cambio con Id %d no existe.', 16, 1, @IdHistorialCambio);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el historial de cambio
        UPDATE Historial_Cambio
        SET Usuario = @Usuario,
            Id_Registro = @IdRegistro,
            Tabla = @Tabla,
            Id_Accion = @IdAccion,
            Datos_Anteriores = @DatosAnteriores,
            Datos_Nuevos = @DatosNuevos
        WHERE Id_Historial_Cambio = @IdHistorialCambio;

        COMMIT TRANSACTION;
        PRINT 'El historial de cambio ha sido actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

---------------------------------ELIMINAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspDeleteHistorialCambio
    @IdHistorialCambio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdHistorialCambio IS NULL
    BEGIN
        RAISERROR('El campo IdHistorialCambio no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el historial de cambio existe
        IF NOT EXISTS (SELECT 1 FROM Historial_Cambio WHERE Id_Historial_Cambio = @IdHistorialCambio)
        BEGIN
            RAISERROR('El historial de cambio con Id %d no existe.', 16, 1, @IdHistorialCambio);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar el historial de cambio
        DELETE FROM Historial_Cambio WHERE Id_Historial_Cambio = @IdHistorialCambio;

        COMMIT TRANSACTION;
        PRINT 'El historial de cambio ha sido eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO








-----------------------------------------
-------------------------AUDITORIA_ACCION
-----------------------------------------

--------------------------------INSERTAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertAuditoriaAccion
    @AccionRealizada VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @AccionRealizada IS NULL OR LTRIM(RTRIM(@AccionRealizada)) = ''
    BEGIN
        RAISERROR('El campo AccionRealizada no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    -- Insertar nueva acción en Auditoria_Accion
    BEGIN TRY
        INSERT INTO Auditoria_Accion (Accion_Realizada)
        VALUES (@AccionRealizada);

        PRINT 'La acción ha sido insertada exitosamente.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

--------------------------------ACTUALIZAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspUpdateAuditoriaAccion
    @IdAccion INT,
    @AccionRealizada VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones de parámetros
    IF @IdAccion IS NULL
    BEGIN
        RAISERROR('El campo IdAccion no puede ser nulo.', 16, 1);
        RETURN;
    END

    IF @AccionRealizada IS NULL OR LTRIM(RTRIM(@AccionRealizada)) = ''
    BEGIN
        RAISERROR('El campo AccionRealizada no puede ser nulo o vacío.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la acción existe
        IF NOT EXISTS (SELECT 1 FROM Auditoria_Accion WHERE Id_Accion = @IdAccion)
        BEGIN
            RAISERROR('La acción con Id %d no existe.', 16, 1, @IdAccion);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar la acción
        UPDATE Auditoria_Accion
        SET Accion_Realizada = @AccionRealizada
        WHERE Id_Accion = @IdAccion;

        COMMIT TRANSACTION;
        PRINT 'La acción ha sido actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--------------------------ELIMINAR

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspDeleteAuditoriaAccion
    @IdAccion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del parámetro
    IF @IdAccion IS NULL
    BEGIN
        RAISERROR('El campo IdAccion no puede ser nulo.', 16, 1);
        RETURN;
    END

    -- Inicio de la transacción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la acción existe
        IF NOT EXISTS (SELECT 1 FROM Auditoria_Accion WHERE Id_Accion = @IdAccion)
        BEGIN
            RAISERROR('La acción con Id %d no existe.', 16, 1, @IdAccion);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar la acción
        DELETE FROM Auditoria_Accion WHERE Id_Accion = @IdAccion;

        COMMIT TRANSACTION;
        PRINT 'La acción ha sido eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
