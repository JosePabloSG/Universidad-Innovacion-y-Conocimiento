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
    Id_Recurso_Academico INT NOT NULL PRIMARY KEY,
    Estado VARCHAR(50),
    Tipo VARCHAR(150)
);

CREATE TABLE Aula (
    Id_Aula INT NOT NULL PRIMARY KEY,
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
    Id_Estudiante INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido1 VARCHAR(100),
    Apellido2 VARCHAR(100),
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
    Id_Inscripcion INT NOT NULL PRIMARY KEY,
    Fecha_Inscripcion DATE,
    Estado VARCHAR(50),
    Id_Curso INT NOT NULL,
    Id_Estudiante INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Estudiante) REFERENCES Estudiante(Id_Estudiante)
);

CREATE TABLE Horario (
    Id_Horario INT NOT NULL PRIMARY KEY,
    FechaInicio DATE,
    FechaFin DATE,
    Id_Docente INT NOT NULL,
    Id_Curso INT NOT NULL,
    FOREIGN KEY (Id_Docente) REFERENCES Docente(Id_Docente),
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso)
);

CREATE TABLE Docente_Curso (
    Id_Docente_Curso INT NOT NULL PRIMARY KEY,
    Id_Curso INT NOT NULL,
    Id_Docente INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Docente) REFERENCES Docente(Id_Docente)
);

CREATE TABLE Curso_Recurso_Academico (
    Id_Curso_Rec_Academico INT NOT NULL PRIMARY KEY,
    Id_Recurso_Academico INT NOT NULL,
    Id_Curso INT NOT NULL,
    FOREIGN KEY (Id_Recurso_Academico) REFERENCES Recurso_Academico(Id_Recurso_Academico),
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso)
);

CREATE TABLE Curso_Aula (
    Id_Curso_Aula INT NOT NULL PRIMARY KEY,
    Horario_clase DATETIME,
    Id_Curso INT NOT NULL,
    Id_Aula INT NOT NULL,
    FOREIGN KEY (Id_Curso) REFERENCES Curso(Id_Curso),
    FOREIGN KEY (Id_Aula) REFERENCES Aula(Id_Aula)
);

CREATE TABLE Historial_Academico (
    Id_Historial_Academico INT NOT NULL PRIMARY KEY,
    Nota DECIMAL(3,2),
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
    Accion VARCHAR(50) NOT NULL,
    Datos_Anteriores NVARCHAR(MAX),
    Datos_Nuevos NVARCHAR(MAX),
    CONSTRAINT FK_Historial_Cambio_Accion FOREIGN KEY (Accion) REFERENCES Auditoria_Accion(Accion_Realizada)
);
GO