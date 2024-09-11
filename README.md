# Proyecto Final - Administración de bases de datos


## Descripción del proyecto

El proyecto consiste en el diseño e implementación de una base de datos para una universidad ficticia llamada "Universidad Innovación y Conocimiento". La base de datos tiene como objetivo gestionar la información académica y administrativa de la universidad, incluyendo datos de estudiantes, cursos, inscripciones, calificaciones, recursos académicos, y reportes estadísticos.


## Autores

- [@JosePabloSG](https://github.com/JosePabloSG)
- [@Yoilin](https://github.com/YoilinCastrillo)
- [@EmmanuelPineda](https://github.com/PinedaCR10)
- [@Sofia](https://github.com/SofiaSJ09)
- [@Aaron](https://github.com/ItsChavesCR)
- [@Genesis](https://github.com/AlexaGenar)

# Caso de Estudio: Universidad "Innovación y Conocimiento"

## Descripción de la Organización

La "Universidad Innovación y Conocimiento" es una institución de educación superior con múltiples facultades y programas académicos. Ofrece una amplia gama de carreras universitarias, desde ciencias e ingeniería hasta humanidades y artes. La universidad tiene un compromiso con la excelencia académica, la investigación, y el desarrollo profesional de sus estudiantes. Con un campus principal y varios centros de extensión, la universidad busca mejorar su gestión administrativa y académica para ofrecer una mejor experiencia educativa a sus alumnos y facilitar la toma de decisiones institucionales.

## Situación Actual

Actualmente, la universidad utiliza sistemas independientes para la gestión académica, administrativa y de recursos. Estos sistemas incluyen registros manuales para estudiantes, docentes, y programas académicos, así como hojas de cálculo para el seguimiento de cursos y calificaciones. Los desafíos actuales incluyen:

- **Registro Manual de Estudiantes y Cursos:** La información sobre los estudiantes, sus inscripciones, y las calificaciones se maneja manualmente, lo que puede llevar a errores y dificultades para acceder a datos históricos.
- **Gestión Ineficiente de Recursos:** La universidad tiene dificultades para gestionar el uso de aulas, equipos y recursos académicos debido a la falta de un sistema integrado.
- **Falta de Información para la Toma de Decisiones:** La ausencia de una plataforma unificada dificulta el análisis de datos sobre el rendimiento académico, la carga de trabajo del personal docente, y la eficiencia de los recursos.
- **Dificultades en la Planificación Académica y Administrativa:** La falta de datos precisos complica la planificación de horarios, la asignación de profesores, y la gestión de inscripciones.

## Objetivos del Proyecto

El Comité Ejecutivo de la "Universidad Innovación y Conocimiento" ha decidido implementar una solución integral para mejorar la gestión académica y administrativa. Los objetivos principales son:

1. **Registrar y Gestionar Información Académica:** Desarrollar una aplicación para gestionar la información de estudiantes, cursos, inscripciones, y calificaciones de manera eficiente.
2. **Optimizar la Gestión de Recursos Académicos:** Implementar un sistema para controlar la asignación y uso de aulas, equipos y otros recursos académicos.
3. **Analizar el Desempeño Académico y Administrativo:** Crear un sistema que genere reportes sobre el rendimiento académico de los estudiantes, la carga de trabajo del personal docente, y la eficiencia en la gestión de recursos.
4. **Facilitar la Planificación Académica y Administrativa:** Utilizar datos para planificar de manera efectiva los horarios de clases, la asignación de profesores, y la gestión de inscripciones.
5. **Integración con un Data Warehouse:** Conectar la base de datos con un Data Warehouse para realizar análisis avanzados y generar reportes detallados sobre el funcionamiento de la universidad.

## Beneficios Esperados

- **Mejora en la Gestión Académica:** Un sistema integrado permitirá un manejo más eficiente de la información académica, reduciendo errores y mejorando la experiencia del estudiante.
- **Optimización de Recursos Académicos:** Un mejor control del uso de aulas y equipos ayudará a maximizar la eficiencia y disponibilidad de recursos.
- **Datos Precisos para la Toma de Decisiones:** Acceso a información detallada permitirá tomar decisiones más informadas sobre la gestión académica y administrativa.
- **Planificación Efectiva:** La planificación basada en datos ayudará a mejorar la programación de horarios, la asignación de profesores, y la gestión de inscripciones.

## Enfoque del Proyecto

El proyecto se dividirá en dos componentes principales:

1. **Desarrollo de la Aplicación:** Para gestionar la información académica, los recursos, y para generar reportes estadísticos.
2. **Desarrollo de la Base de Datos:** Para almacenar la información de manera segura y eficiente, con integración al Data Warehouse para análisis avanzado.

## Requisitos del Proyecto

### Requisitos Funcionales

- **R1: Gestión de Información Académica**
  - **Descripción:** Registro y actualización de la información de estudiantes, cursos e inscripciones.
  - **Datos Requeridos:** ID del estudiante, nombre, contacto, historial académico, cursos inscritos, calificaciones, horario de clases.
  - **Objetivo:** Facilitar la gestión de datos académicos y el seguimiento del rendimiento estudiantil.

- **R2: Gestión de Recursos Académicos**
  - **Descripción:** Control del uso y asignación de aulas, equipos y otros recursos académicos.
  - **Datos Requeridos:** ID del recurso, tipo de aula/equipo, horario de uso, disponibilidad, estado.
  - **Objetivo:** Mejorar la eficiencia en la utilización de recursos académicos.

- **R3: Análisis del Desempeño Académico y Administrativo**
  - **Descripción:** Generación de reportes sobre el desempeño académico de los estudiantes y la carga de trabajo del personal docente.
  - **Datos Requeridos:** Desempeño académico por curso, carga de trabajo del personal docente, uso de recursos, inscripciones.
  - **Objetivo:** Evaluar el rendimiento y la eficiencia en la gestión académica y administrativa.

- **R4: Planificación Académica y Administrativa**
  - **Descripción:** Utilización de datos para planificar horarios de clases, asignación de profesores, y gestión de inscripciones.
  - **Datos Requeridos:** Horarios de clases, disponibilidad de profesores, número de inscripciones, asignación de aulas.
  - **Objetivo:** Mejorar la planificación y gestión académica.

- **R5: Integración con un Data Warehouse**
  - **Descripción:** La base de datos debe permitir la transferencia de datos a un Data Warehouse para análisis avanzado.
  - **Mecanismo:** Usar herramientas de transferencia de datos como ETL (Extract, Transform, Load).
  - **Objetivo:** Facilitar el análisis de datos y la generación de reportes detallados sobre el funcionamiento de la universidad.

- **R6: Gestión del Registro de Acciones**
  - **Descripción:** Registro de las acciones realizadas por los usuarios en el sistema.
  - **Objetivo:** Permitir auditorías y seguimiento de cambios en el sistema.

- **R7: Mecanismos para el Testeo de la Base de Datos**
  - **Descripción:** Implementar pruebas para asegurar que la base de datos funcione correctamente.
  - **Objetivo:** Verificar que la base de datos cumpla con los requisitos y funcione adecuadamente.

- **R8: Plan de Mantenimiento de Bases de Datos**
  - **Descripción:** Establecer procedimientos para el mantenimiento y actualización de la base de datos.
  - **Objetivo:** Garantizar la continuidad operativa y la integridad de los datos.

## Historial y Reportes Estadísticos de Interés

La Dirección General de la "Universidad Innovación y Conocimiento" desea mantener un historial completo de la información para generar reportes que faciliten la toma de decisiones. Entre los reportes y consultas de interés se incluyen:

- **Desempeño Académico de Estudiantes:** Identificar el rendimiento académico de los estudiantes para ajustar los programas y la planificación de clases.
- **Carga de Trabajo del Personal Docente:** Evaluar la carga de trabajo de cada docente para balancear la asignación de cursos y mejorar la eficiencia en la enseñanza.
- **Uso de Recursos Académicos:** Analizar el uso de aulas y equipos para optimizar su asignación y disponibilidad.
- **Número de Inscripciones y Gestión de Clases:** Revisar las tendencias en inscripciones para ajustar la oferta académica y mejorar la planificación de horarios.
- **Satisfacción de los Estudiantes:** Medir la satisfacción de los estudiantes con la calidad de la enseñanza y los servicios ofrecidos por la universidad.
- **Y otras consultas relacionadas con la gestión universitaria:** Generar otros reportes específicos según las necesidades y objetivos de la universidad.