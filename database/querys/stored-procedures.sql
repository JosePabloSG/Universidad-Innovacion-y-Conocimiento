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


--Procedimientos para Estudiantes, Inscripciones Y Historial Academico
 
 
-- Procedimiento almacenado para insertar un nuevo estudiante.
USE Universidad_InnovacionConocimiento;
GO
CREATE PROCEDURE uspInsertEstudiante
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

-- Procedimiento almacenado para actualizar la información de un estudiante existente.


CREATE PROCEDURE uspUpdateEstudiante
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

-- Procedimiento almacenado para eliminar un estudiante si no tiene inscripciones asociadas.

CREATE PROCEDURE uspDeleteEstudiante
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

-- Procedimiento almacenado para insertar una nueva inscripción en la tabla Inscripciones.

CREATE PROCEDURE uspInsertInscripcion
    @IdEstudiante INT,
    @IdCurso INT,
    @Estado VARCHAR(20)
AS
BEGIN
    DECLARE @FechaActual DATE;
    SET @FechaActual = GETDATE();

-- Verificar si el estudiante ya está inscrito en el curso
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

-- Procedimiento almacenado para actualizar el estado de una inscripción existente.

CREATE PROCEDURE uspUpdateInscripcion
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

--Procedimiento almacenado para eliminar una inscripción.

CREATE PROCEDURE uspDeleteInscripcion
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

--Procedimiento almacenado insertará un nuevo registro en la tabla Historial_Academico. 

CREATE PROCEDURE uspInsertHistorialAcademico
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

--Procedimiento almacenado para actualizar un registro en el historial académico.

CREATE PROCEDURE uspUpdateHistorialAcademico
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

--Procedimiento almacenado para eliminar un registro en el historial académico.

CREATE PROCEDURE uspDeleteHistorialAcademico
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



