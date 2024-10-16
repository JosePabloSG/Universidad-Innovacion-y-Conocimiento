USE Universidad_InnovacionConocimiento;
GO

-- Vista para la tabla Curso con información relevante
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

-- Vista para la tabla Horario con información del curso y docente
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

-- Vista para la tabla Docente_Curso con información detallada
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

-- Vista para la tabla Auditoria_Accion
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

SELECT * FROM vwCurso
SELECT * FROM vwHorario
SELECT * FROM vwAuditoriaAccion
SELECT * FROM vwHistorialCambio


USE Universidad_InnovacionConocimiento;
GO
-- Vista para la tabla Facultad 
CREATE VIEW dbo.vwFacultad AS
SELECT
    f.Id_Facultad,
    f.Nombre AS NombreFacultad
FROM
    Facultad f;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Vista para la tabla Nivel Académico 
CREATE VIEW dbo.vwNivelAcademico AS
SELECT
    na.Id_Nivel_Academico,
    na.Nombre AS NombreNivelAcademico
FROM
    Nivel_Academico na;
GO

USE Universidad_InnovacionConocimiento;
GO
-- Vista para la tabla Programa Académico 
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

-- Consultas para probar las vistas
SELECT * FROM vwFacultad;
SELECT * FROM vwNivelAcademico;
SELECT * FROM vwProgramaAcademico;
