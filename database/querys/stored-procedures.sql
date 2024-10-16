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


USE Universidad_InnovacionConocimiento;
GO
--Procedimiento almacenado para insertar Facultad
CREATE PROCEDURE uspInsertFacultad
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
--Procedimiento almacenado para actualizar Facultad
CREATE PROCEDURE uspUpdateFacultad
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
--Procedimiento almacenado para eliminar Facultad
CREATE PROCEDURE uspDeleteFacultad
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
--Procedimiento almacenado para insertar nivel académico
CREATE PROCEDURE uspInsertNivelAcademico
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
--Procedimiento almacenado para actualizar nivel académico
CREATE PROCEDURE uspUpdateNivelAcademico
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
--Procedimiento almacenado para eliminar nivel académico
CREATE PROCEDURE uspDeleteNivelAcademico
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
--Procedimiento almacenado para insertar programa académico
CREATE PROCEDURE uspInsertProgramaAcademico
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
--Procedimiento almacenado para actualizar programa académico
CREATE PROCEDURE uspUpdateProgramaAcademico
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
--Procedimiento almacenado para eliminar programa académico
CREATE PROCEDURE uspDeleteProgramaAcademico
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

--------------------------------------------------------YOILIN-------------------------------------------------------------


--PROCEDIMIENTOS ALMACENADOS DEL AREA DE RECURSOS ACADEMICOS Y AULAS 

-------FUNCIONES CRUD EN RECURSO_ACADEMICO-----------
-----  ___________________________________ ---------

USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspInsertRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspUpdateRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspDeleteRecursoAcademico
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


-------     FUNCIONES CRUD EN AULAS       ----------
-----  ___________________________________ ---------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertAula
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


-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspUpdateAula
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


-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspDeleteAula
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

-------     FUNCIONES CRUD EN CURSO_RECURSO_ACADEMICO ---------
-----  ______________________________________________ ---------


USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertCursoRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspUpdateCursoRecursoAcademico
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspDeleteCursoRecursoAcademico
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


-----         FUNCIONES CRUD EN CURSO_ AULA           ---------
-----  ______________________________________________ ---------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE uspInsertCursoAula
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

-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE ActualizarCursoAula
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


-------------------------------------------------------

USE Universidad_InnovacionConocimiento;
GO

CREATE PROCEDURE EliminarCursoAula
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


                               -----      FUNCIONES ADICIONALES      ---------
                               -----  ______________________________ ---------


USE Universidad_InnovacionConocimiento;
GO
------ Asignar un recurso académico a un curso
CREATE PROCEDURE AsignarRecursoAcademico 
    @Id_Curso INT, 
    @Id_Recurso_Academico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar parámetros
    IF 
	@Id_Curso IS NULL OR 
	@Id_Recurso_Academico IS NULL
    BEGIN
        RAISERROR('Los parámetros Id_Curso y Id_Recurso_Academico no pueden ser nulos.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la tabla Curso existe
        IF OBJECT_ID('Curso', 'U') IS NULL
        BEGIN
            RAISERROR('La tabla Curso no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el recurso académico ya está asignado al curso
        IF EXISTS (SELECT 1 FROM Curso_Recurso_Academico WHERE Id_Curso = @Id_Curso AND Id_Recurso_Academico = @Id_Recurso_Academico)
        BEGIN
            RAISERROR('El recurso académico ya está asignado al curso.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Asignar el recurso académico
        INSERT INTO Curso_Recurso_Academico (Id_Curso, Id_Recurso_Academico)
        VALUES (@Id_Curso, @Id_Recurso_Academico);

        -- Verificar si la inserción afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo asignar el recurso académico.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El recurso académico ha sido asignado exitosamente al curso.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END



USE Universidad_InnovacionConocimiento;
GO
------ Asignar un aula a un curso
CREATE PROCEDURE AsignarAulaACurso 
    @Id_Curso INT, 
    @Id_Aula INT, 
    @FechaInicio DATETIME, 
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar parámetros
    IF @Id_Curso IS NULL OR 
	@Id_Aula IS NULL OR 
	@FechaInicio IS NULL OR 
	@FechaFin IS NULL
    BEGIN
        RAISERROR('Los parámetros no pueden ser nulos.', 16, 1);
        RETURN;
    END

    -- Verificar que la FechaInicio sea anterior a la FechaFin
    IF @FechaInicio >= @FechaFin
    BEGIN
        RAISERROR('La Fecha de Inicio debe ser anterior a la Fecha de Fin.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la tabla Aula existe
        IF OBJECT_ID('Aula', 'U') IS NULL
        BEGIN
            RAISERROR('La tabla Aula no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si el aula ya está asignada en el rango de fechas
        IF EXISTS (
            SELECT 1 
            FROM Curso_Aula ca
            INNER JOIN Horario h ON ca.Id_Curso = h.Id_Curso
            WHERE ca.Id_Aula = @Id_Aula 
            AND (
                (@FechaInicio BETWEEN h.FechaInicio AND h.FechaFin)
                OR (@FechaFin BETWEEN h.FechaInicio AND h.FechaFin)
                OR (h.FechaInicio BETWEEN @FechaInicio AND @FechaFin)
                OR (h.FechaFin BETWEEN @FechaInicio AND @FechaFin)
            )
        )
        BEGIN
            RAISERROR('El aula ya está asignada a otro curso en el rango de fechas especificado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Asignar el aula al curso
        INSERT INTO Curso_Aula (Id_Curso, Id_Aula, Horario_clase)
        VALUES (@Id_Curso, @Id_Aula, @FechaInicio);

        -- Verificar si la inserción afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo asignar el aula al curso.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El aula ha sido asignada exitosamente al curso.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO --REVISAR

USE Universidad_InnovacionConocimiento;
GO
----------- Actualizar el estado de un recurso académico
CREATE PROCEDURE ActualizarEstadoRecursoAcademico 
    @Id_Recurso_Academico INT, 
    @NuevoEstado VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar parámetros
    IF @Id_Recurso_Academico IS NULL OR @NuevoEstado IS NULL OR LTRIM(RTRIM(@NuevoEstado)) = ''
    BEGIN
        RAISERROR('Los parámetros no pueden ser nulos o vacíos.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el recurso académico existe
        IF NOT EXISTS (SELECT 1 FROM Recurso_Academico WHERE Id_Recurso_Academico = @Id_Recurso_Academico)
        BEGIN
            RAISERROR('El recurso académico no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el estado
        UPDATE Recurso_Academico
        SET Estado = @NuevoEstado
        WHERE Id_Recurso_Academico = @Id_Recurso_Academico;

        -- Verificar si la actualización afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo actualizar el estado del recurso académico.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El estado del recurso académico ha sido actualizado exitosamente.';
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
-------- Consultar las aulas disponibles                VISTA MEJOR
CREATE PROCEDURE ConsultarAulasDisponibles 
    @Horario DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar parámetros
    IF @Horario IS NULL
    BEGIN
        RAISERROR('El parámetro Horario no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la tabla Aula existe
        IF OBJECT_ID('Aula', 'U') IS NULL
        BEGIN
            RAISERROR('La tabla Aula no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Consultar aulas disponibles
        SELECT * 
        FROM Aula a
        WHERE NOT EXISTS (
            SELECT 1 
            FROM Curso_Aula ca
            WHERE ca.Id_Aula = a.Id_Aula 
              AND ca.Horario_clase = @Horario
        );

        -- Confirmar la transacción
        COMMIT TRANSACTION;
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
-------- Eliminar la asignación de un recurso académico
CREATE PROCEDURE EliminarAsignacionRecursoAcademico 
    @Id_Curso_Recurso_Academico INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar parámetros
    IF @Id_Curso_Recurso_Academico IS NULL
    BEGIN
        RAISERROR('El parámetro Id_Curso_Recurso_Academico no puede ser nulo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si la asignación existe
        IF NOT EXISTS (SELECT 1 FROM Curso_Recurso_Academico WHERE Id_Curso_Rec_Academico = @Id_Curso_Recurso_Academico)
        BEGIN
            RAISERROR('La asignación no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar la asignación
        DELETE FROM Curso_Recurso_Academico
        WHERE Id_Curso_Rec_Academico = @Id_Curso_Recurso_Academico;

        -- Verificar si se afectó alguna fila
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo eliminar la asignación.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'La asignación ha sido eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO