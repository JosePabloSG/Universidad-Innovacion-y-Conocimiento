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
