USE Universidad_InnovacionConocimiento;
GO

-- Insertar Facultades
INSERT INTO Facultad (Id_Facultad, Nombre) VALUES 
(1, 'Ingeniería y Tecnología'),
(2, 'Ciencias Sociales'),
(3, 'Artes y Humanidades');

-- Insertar Niveles Académicos
INSERT INTO Nivel_Academico (Id_Nivel_Academico, Nombre) VALUES 
(1, 'Pregrado'),
(2, 'Grado'),
(3, 'Posgrado');

-- Insertar Programas Académicos
INSERT INTO Programa_Academico (Id_Prog_Academico, Nombre, Duracion, Id_Nivel_Academico, Id_Facultad) VALUES 
(1, 'Ingeniería en Sistemas', 4, 2, 1),
(2, 'Psicología', 4, 2, 2),
(3, 'Música', 5, 2, 3);

-- Insertar Recursos Académicos
INSERT INTO Recurso_Academico (Id_Recurso_Academico, Estado, Tipo) VALUES 
(1, 'Disponible', 'Laboratorio'),
(2, 'Ocupado', 'Biblioteca'),
(3, 'Disponible', 'Sala de Conferencias');

-- Insertar Aulas
INSERT INTO Aula (Id_Aula, Codigo_Aula, Capacidad, Ubicacion, Equipamiento) VALUES 
(1, 'A101', 30, 'Edificio A', 'Proyector, Pizarra'),
(2, 'B201', 50, 'Edificio B', 'Computadoras, Pizarra'),
(3, 'C301', 20, 'Edificio C', 'Proyector, Sistema de Audio');

-- Insertar Cursos
INSERT INTO Curso (Id_Curso, Nombre, Codigo_Curso, Creditos, Horas_Semana, Id_Prog_Academico) VALUES 
(1, 'Programación Avanzada', 'CS301', 4, 6, 1),
(2, 'Psicología General', 'PS101', 3, 4, 2),
(3, 'Teoría Musical', 'MU201', 4, 5, 3),
(4, 'Análisis de Datos', 'CS302', 4, 6, 1),
(5, 'Psicología del Desarrollo', 'PS102', 3, 4, 2);

-- Insertar Estudiantes (15 registros)
INSERT INTO Estudiante (Id_Estudiante, Nombre, Apellido1, Apellido2, Email, Direccion) VALUES 
(1, 'Juan', 'Pérez', 'González', 'juan.perez@example.com', 'Calle 123'),
(2, 'María', 'López', 'Fernández', 'maria.lopez@example.com', 'Avenida 456'),
(3, 'Carlos', 'Ramírez', 'Sánchez', 'carlos.ramirez@example.com', 'Boulevard 789'),
(4, 'Ana', 'Martínez', 'García', 'ana.martinez@example.com', 'Calle 654'),
(5, 'Luis', 'Gómez', 'Vargas', 'luis.gomez@example.com', 'Avenida 321'),
(6, 'Jorge', 'Castro', 'Ruiz', 'jorge.castro@example.com', 'Boulevard 741'),
(7, 'Laura', 'Mendoza', 'Ortiz', 'laura.mendoza@example.com', 'Calle 852'),
(8, 'Andrés', 'Morales', 'Jiménez', 'andres.morales@example.com', 'Avenida 963'),
(9, 'Mónica', 'Vega', 'Rodríguez', 'monica.vega@example.com', 'Boulevard 159'),
(10, 'Natalia', 'Pacheco', 'Hernández', 'natalia.pacheco@example.com', 'Calle 753'),
(11, 'Gabriel', 'Soto', 'Flores', 'gabriel.soto@example.com', 'Avenida 258'),
(12, 'Daniel', 'Hernández', 'Campos', 'daniel.hernandez@example.com', 'Boulevard 147'),
(13, 'Jessica', 'León', 'Álvarez', 'jessica.leon@example.com', 'Calle 963'),
(14, 'David', 'Ruiz', 'Mora', 'david.ruiz@example.com', 'Avenida 753'),
(15, 'Sofía', 'Villalobos', 'Salas', 'sofia.villalobos@example.com', 'Boulevard 321');

-- Insertar Docentes (5 registros)
INSERT INTO Docente (Id_Docente, Nombre, Apellido1, Apellido2, Email, Especialidad, Telefono) VALUES 
(1, 'Dr. José', 'Martínez', 'Rojas', 'jose.martinez@example.com', 'Ingeniería de Software', '123456789'),
(2, 'Dra. Ana', 'Gómez', 'Torres', 'ana.gomez@example.com', 'Psicología Educativa', '987654321'),
(3, 'Mtro. Pedro', 'Díaz', 'Jiménez', 'pedro.diaz@example.com', 'Teoría Musical', '456123789'),
(4, 'Dr. Luis', 'García', 'Fuentes', 'luis.garcia@example.com', 'Ingeniería de Datos', '321456789'),
(5, 'Mtra. Carmen', 'Hernández', 'Ortiz', 'carmen.hernandez@example.com', 'Psicología Clínica', '654789321');

-- Insertar Inscripciones (Estudiantes en Cursos)
INSERT INTO Inscripcion (Id_Inscripcion, Fecha_Inscripcion, Estado, Id_Curso, Id_Estudiante) VALUES 
(1, '2024-01-15', 'Inscrito', 1, 1),
(2, '2024-01-16', 'Inscrito', 2, 2),
(3, '2024-01-17', 'Inscrito', 3, 3),
(4, '2024-01-18', 'Inscrito', 4, 4),
(5, '2024-01-19', 'Inscrito', 5, 5),
(6, '2024-01-20', 'Inscrito', 1, 6),
(7, '2024-01-21', 'Inscrito', 2, 7),
(8, '2024-01-22', 'Inscrito', 3, 8),
(9, '2024-01-23', 'Inscrito', 4, 9),
(10, '2024-01-24', 'Inscrito', 5, 10),
(11, '2024-01-25', 'Inscrito', 1, 11),
(12, '2024-01-26', 'Inscrito', 2, 12),
(13, '2024-01-27', 'Inscrito', 3, 13),
(14, '2024-01-28', 'Inscrito', 4, 14),
(15, '2024-01-29', 'Inscrito', 5, 15);

-- Insertar Horarios (relacionados con los cursos)
INSERT INTO Horario (Id_Horario, FechaInicio, FechaFin, Id_Docente, Id_Curso) VALUES 
(1, '2024-01-20', '2024-06-20', 1, 1),
(2, '2024-01-20', '2024-06-20', 2, 2),
(3, '2024-01-20', '2024-06-20', 3, 3),
(4, '2024-01-20', '2024-06-20', 4, 4),
(5, '2024-01-20', '2024-06-20', 5, 5);

-- Insertar Docente_Curso (Relación entre Docentes y Cursos)
INSERT INTO Docente_Curso (Id_Docente_Curso, Id_Curso, Id_Docente) VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- Insertar Curso_Recurso_Academico (Relación entre Cursos y Recursos Académicos)
INSERT INTO Curso_Recurso_Academico (Id_Curso_Rec_Academico, Id_Recurso_Academico, Id_Curso) VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 1, 4),
(5, 2, 5);

-- Insertar Curso_Aula (Relación entre Cursos y Aulas)
INSERT INTO Curso_Aula (Id_Curso_Aula, Horario_clase, Id_Curso, Id_Aula) VALUES 
(1, '2024-01-20 08:00:00', 1, 1),
(2, '2024-01-20 10:00:00', 2, 2),
(3, '2024-01-20 14:00:00', 3, 3),
(4, '2024-01-21 08:00:00', 4, 1),
(5, '2024-01-21 10:00:00', 5, 2);

-- Insertar Historial_Academico con notas ajustadas a DECIMAL(3,2)
INSERT INTO Historial_Academico (Id_Historial_Academico, Nota, Fecha_Calificacion, Id_Curso, Id_Estudiante) VALUES 
(1, 9.50, '2024-06-20', 1, 1),
(2, 8.80, '2024-06-20', 2, 2),
(3, 9.20, '2024-06-20', 3, 3),
(4, 8.50, '2024-06-20', 4, 4),
(5, 8.95, '2024-06-20', 5, 5),
(6, 9.00, '2024-06-20', 1, 6),
(7, 8.75, '2024-06-20', 2, 7),
(8, 9.10, '2024-06-20', 3, 8),
(9, 9.25, '2024-06-20', 4, 9),
(10, 9.30, '2024-06-20', 5, 10),
(11, 8.95, '2024-06-20', 1, 11),
(12, 8.85, '2024-06-20', 2, 12),
(13, 9.00, '2024-06-20', 3, 13),
(14, 9.10, '2024-06-20', 4, 14),
(15, 9.20, '2024-06-20', 5, 15);
GO

