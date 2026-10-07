# Capítulo VI: Product Implementation, Validation & Deployment

## 6.1. Software Configuration Management

### 6.1.1. Software Development Environment Configuration

El servicio central se desarrolla con Java 21, Spring Boot 3.5 y Maven. PostgreSQL 16 persiste los datos; Spring Data JPA y Flyway gestionan el acceso y las migraciones. Spring Security valida JWT en las rutas protegidas y Springdoc OpenAPI publica Swagger UI.

### 6.1.2. Source Code Management

El repositorio del servicio es [MachineGuard/machineguard-core-api](https://github.com/MachineGuard/machineguard-core-api). Para el incremento IAM se utilizó la rama `develop`, integrada con `main` como rama estable. La convención GitFlow define ramas `feature/<contexto>-<tarea>`, `release/<versión>` y `hotfix/<versión>-<incidencia>`. Los mensajes siguen Conventional Commits (`feat(iam):`, `fix(iam):`, `test(iam):`, `docs(iam):`) y las versiones de publicación siguen Semantic Versioning (`MAJOR.MINOR.PATCH`).

### 6.1.3. Source Code Style Guide & Conventions

El código Java mantiene los identificadores en inglés, paquetes en minúsculas, tipos en `PascalCase` y métodos y atributos en `camelCase`. La implementación separa dominio, aplicación, interfaces REST e infraestructura. Los controladores validan los DTO de entrada; `IamService` coordina los casos de uso y los adaptadores de infraestructura implementan persistencia, hashing BCrypt y firma JWT.

### 6.1.4. Software Deployment Configuration

> Contenido pendiente.

## 6.2. Landing Page, Services & Applications Implementation

### 6.2.1. Sprint 1

#### 6.2.1.1. Sprint Planning 1

El Sprint 1 figura en [Jira](https://leccapedro8.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog) del 2 al 16 de octubre de 2026. La asignación de trabajo se comunicó el 2 de octubre; no se realizó una reunión formal de Sprint Planning.

| Campo | Registro |
|---|---|
| Sprint | Sprint 1 |
| Fecha de asignación | 2026-10-02 |
| Hora y lugar | No aplica; no se celebró reunión formal. |
| Preparado por | Pedro Omar Lecca Villalobos |
| Asistentes | No aplica; no se celebró reunión formal. |
| Revisión del Sprint anterior | Sin fecha ni acuerdos documentados. |
| Retrospectiva del Sprint anterior | Sin fecha ni acuerdos documentados. |
| Objetivo registrado en Jira | Entregar el primer incremento verificable de MachineGuard: procesamiento Edge, trazabilidad e identidad para la API central, con contratos documentados y ejecución local. |
| Capacidad planificada | 60 Story Points |
| Suma de Story Points | 60 |

El alcance del Sprint comprende siete historias de Edge Processing y Traceability y tres historias IAM. Jira muestra las diez historias con estado “Por hacer”.

#### 6.2.1.2. Aspect Leaders and Collaborators

| Aspecto | Responsable | Usuario GitHub | Rol | Trabajo registrado |
|---|---|---|---|---|
| Backend Edge Processing y Traceability & Quality | Diego Seijas Vasquez | No documentado | Colaborador | Implementación y documentación técnica de ambos contextos. |
| Backend IAM/Auth | Pedro Omar Lecca Villalobos | `leccapedro` | Líder de aspecto | IAM, seguridad de Traceability y Swagger. |
| Sprint Backlog 1 y documentación de servicios IAM | Pedro Omar Lecca Villalobos | `leccapedro` | Líder de aspecto | Backlog en Jira y documentación IAM. |
| Frontend Core / Dashboard y Environmental Monitoring | Camilla Espinoza | No documentado | Líder de aspecto | Implementación del Environmental Monitoring en Core API, publicación de eventos de dominio, desarrollo del Environmental Dashboard e integración con servicios REST. |

#### 6.2.1.3. Sprint Backlog 1

| Historia | Alcance del Sprint | Responsable técnico | Puntos | Estado en Jira |
|---|---|---|---:|---|
| [SCRUM-24 (TS02)](https://leccapedro8.atlassian.net/browse/SCRUM-24) | Calibrar y filtrar lecturas en Edge | Diego Seijas | 5 | Por hacer |
| [SCRUM-25 (TS03)](https://leccapedro8.atlassian.net/browse/SCRUM-25) | Mantener lecturas ante interrupciones de conectividad | Diego Seijas | 8 | Por hacer |
| [SCRUM-13 (US03)](https://leccapedro8.atlassian.net/browse/SCRUM-13) | Consultar estado de los puntos de monitoreo | Diego Seijas | 3 | Por hacer |
| [SCRUM-12 (US02)](https://leccapedro8.atlassian.net/browse/SCRUM-12) | Consultar historial de mediciones | Diego Seijas | 5 | Por hacer |
| [SCRUM-20 (US10)](https://leccapedro8.atlassian.net/browse/SCRUM-20) | Consultar excursiones ambientales | Diego Seijas | 5 | Por hacer |
| [SCRUM-21 (US11)](https://leccapedro8.atlassian.net/browse/SCRUM-21) | Consultar trazabilidad de incidentes | Diego Seijas | 5 | Por hacer |
| [SCRUM-22 (US12)](https://leccapedro8.atlassian.net/browse/SCRUM-22) | Generar reporte de trazabilidad | Diego Seijas | 8 | Por hacer |
| [SCRUM-32 (TS06)](https://leccapedro8.atlassian.net/browse/SCRUM-32) | Gestionar organizaciones, usuarios y roles IAM | Pedro Omar Lecca Villalobos | 8 | Por hacer |
| [SCRUM-33 (TS07)](https://leccapedro8.atlassian.net/browse/SCRUM-33) | Autenticar usuarios y gestionar sesiones JWT | Pedro Omar Lecca Villalobos | 8 | Por hacer |
| [SCRUM-34 (TS08)](https://leccapedro8.atlassian.net/browse/SCRUM-34) | Proteger la API con JWT y documentar IAM | Pedro Omar Lecca Villalobos | 5 | Por hacer |
| **Total** | **10 historias** | | **60** | |

Las historias IAM pertenecen a la [épica SCRUM-31](https://leccapedro8.atlassian.net/browse/SCRUM-31). La atribución técnica de Edge Processing y Traceability se basa en los commits de Diego Seijas; esas historias no tienen una persona asignada en Jira.

La siguiente descomposición y sus horas son propuestas de planificación para las historias IAM. Las tareas no están creadas en Jira; el identificador y el estado del registro se indican como tales.

| Historia | ID de tarea Jira | Tarea propuesta | Descripción | Horas estimadas | Responsable | Estado del registro |
|---|---|---|---|---:|---|---|
| SCRUM-32 | No creado | Modelar entidades IAM y persistencia | Definir organizaciones, usuarios, sesiones, invitaciones, repositorios y restricciones de base de datos. | 5 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-32 | No creado | Administrar usuarios y roles por tenant | Implementar operaciones de alta, consulta, cambio de rol y estado, limitadas a la organización autenticada. | 5 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-32 | No creado | Validar aislamiento y administración | Verificar aislamiento entre organizaciones, unicidad de correo y protección del último administrador activo. | 3 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-33 | No creado | Implementar inicio de sesión | Validar credenciales con BCrypt y emitir JWT y refresh token. | 4 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-33 | No creado | Gestionar sesiones y credenciales | Implementar rotación y revocación de refresh tokens, detección de reutilización, cierre de sesión y cambio de contraseña. | 5 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-33 | No creado | Implementar invitación y bootstrap inicial | Crear el flujo de invitación de administrador y el bootstrap local de un solo uso. | 4 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-34 | No creado | Proteger endpoints con identidad JWT | Validar el token y aplicar límites de organización y rol, incluidos los endpoints de Traceability. | 4 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-34 | No creado | Documentar contratos OpenAPI | Publicar operaciones IAM, esquemas, respuestas y seguridad Bearer en Swagger UI. | 2 | Pedro Omar Lecca Villalobos | No registrada |
| SCRUM-34 | No creado | Verificar funcionamiento de la API | Comprobar autenticación, permisos y respuestas HTTP; capturar evidencia Swagger. | 4 | Pedro Omar Lecca Villalobos | No registrada |
| **Total propuesto** | | | | **36** | | |

#### 6.2.1.4. Development Evidence for Sprint Review

##### Diego Seijas — Backend Core: Edge Processing y Traceability & Quality

En este Sprint se implementaron los endpoints core de los dos Bounded Contexts a cargo de Diego Seijas, siguiendo el diseño del Capítulo IV (secciones 4.2.3 y 4.2.4) y organizando el código en las capas Domain, Application, Interface e Infrastructure.

| Bounded Context | Repositorio | Tecnología | Historias cubiertas |
|---|---|---|---|
| Edge Processing | `machineguard-edge-api` | Flask, Peewee ORM, SQLite | TS02, TS03, US03 |
| Traceability & Quality | `machineguard-core-api` | Spring Boot, Spring Data JPA, Flyway, PostgreSQL, OpenAPI | US02, US10, US11, US12 |

**Edge Processing (Edge API)**

* **Domain Layer:** agregados `SensorReading`, `CalibrationProfile`, `LocalBuffer` y `OfflineNode`; Value Objects `RawReading`, `CalibrationOffset`, `PlausibilityRange` y `SamplingInterval`; servicios `ReadingCalibrationService`, `BufferSynchronizationService` y `NodeAvailabilityService`.
* **Application Layer:** `CaptureSensorReadingCommandService`, `ApplyCalibrationCommandService`, `SyncLocalBufferCommandService`, `RegisterSensorNodeCommandService`, `DetectOfflineNodesCommandService` y los query services del buffer, del Calibration Profile, de las lecturas y del estado de los nodos.
* **Interface Layer:** endpoints REST bajo `/api/v1/edge` para registrar lecturas, consultar lecturas procesadas y descartadas, administrar el Calibration Offset, consultar el Local Buffer, forzar su sincronización y registrar y consultar el estado de los Sensor Nodes.
* **Infrastructure Layer:** modelos Peewee sobre SQLite (`sensor_readings`, `calibration_profiles`, `local_buffer_entries`, `offline_nodes`), repositorios y cliente HTTP hacia la API central con la credencial de dispositivo del gateway.
* **Reglas de negocio verificadas:** descarte de lecturas implausibles antes de calibrar, conservación de la marca temporal de captura del nodo, uso del Local Buffer ante la caída del enlace con la nube, sincronización en orden cronológico e idempotente, descarte de las lecturas pendientes más antiguas al llenarse el buffer, detección y restauración de nodos fuera de línea, y efecto del Calibration Offset solo sobre lecturas posteriores al cambio.

**Traceability & Quality (RESTful API central)**

* **Domain Layer:** agregados `Excursion`, `TraceabilityReport` y `NonConformity`; Value Objects `ExcursionPeriod`, `ExcursionSeverity`, `Batch`, `ReportPeriod` y `RetentionPeriod`; servicios `ExcursionLifecycleService`, `TraceabilityReportAssemblyService` y `RetentionPolicyService`.
* **Application Layer:** `StartExcursionCommandService`, `EndExcursionCommandService`, `GenerateTraceabilityReportCommandService`, `RegisterNonConformityCommandService`, los query services de historial de excursiones, reportes y Measurement History, y los event handlers `DeviationDetectedEventHandler` e `IncidentResolvedEventHandler`.
* **Interface Layer:** `ExcursionController`, `TraceabilityReportController` y `MeasurementHistoryController` bajo `/api/v1/traceability`, con Resources, Assemblers y documentación OpenAPI/Swagger.
* **Infrastructure Layer:** migración Flyway con las tablas `excursions`, `non_conformities`, `traceability_reports` y `traceability_report_excursions`, repositorios Spring Data JPA y adaptador JDBC hacia el Measurement History de Environmental Monitoring.
* **Reglas de negocio verificadas:** una sola excursión abierta por zona y variable (garantizada también por una restricción de unicidad en la base de datos), actualización del valor pico sin duplicar registros, cierre por `SafeRangeRestored` o `IncidentResolved`, exclusión de las excursiones abiertas como evidencia cerrada, sellado del reporte con checksum SHA-256 y verificación de integridad, no conformidades asociadas a una excursión de la misma organización, liberación de lotes solo con justificación, y depuración por Retention Period sin tocar las excursiones incluidas en reportes sellados.

**Commits**

| Repositorio | Commit | Mensaje | Fecha |
|---|---|---|---|
| `machineguard-edge-api` | `fb97d0d` | chore: scaffold Edge API project with Flask, Peewee and pytest | 2026-10-02 |
| `machineguard-edge-api` | `0a0aaea` | feat(edge-processing): add domain model, commands and domain services | 2026-10-02 |
| `machineguard-edge-api` | `7062637` | feat(edge-processing): add Peewee/SQLite persistence and cloud client | 2026-10-02 |
| `machineguard-edge-api` | `0dc73e9` | feat(edge-processing): add command and query services | 2026-10-02 |
| `machineguard-edge-api` | `dc3e5c3` | feat(edge-processing): expose Edge API REST endpoints | 2026-10-02 |
| `machineguard-edge-api` | `7b9c6df` | test(edge-processing): cover calibration, local buffer sync and offline node detection | 2026-10-02 |
| `machineguard-edge-api` | `c0b30f8` | docs: add README with configuration, endpoints and cloud contract | 2026-10-02 |
| `machineguard-core-api` | `76eef40` | chore: scaffold Spring Boot core API with Flyway, JPA and OpenAPI | 2026-10-02 |
| `machineguard-core-api` | `fe186e5` | feat(db): add Traceability and Quality migration | 2026-10-02 |
| `machineguard-core-api` | `3b0d298` | feat(traceability): add domain model, events, repositories and domain services | 2026-10-02 |
| `machineguard-core-api` | `e9a6cd1` | feat(traceability): add command and query services and event handlers | 2026-10-02 |
| `machineguard-core-api` | `85a5210` | feat(traceability): add measurement history adapter and configuration | 2026-10-02 |
| `machineguard-core-api` | `3e05e47` | feat(traceability): expose REST controllers with OpenAPI annotations | 2026-10-02 |
| `machineguard-core-api` | `2695724` | test(traceability): cover domain rules and REST API end to end | 2026-10-02 |
| `machineguard-core-api` | `4048152` | docs: add README with endpoints, integration contracts and rules | 2026-10-02 |

**Ajustes respecto al diseño del Capítulo IV**

Durante la implementación se añadieron elementos que el diseño de la sección 4.2.4 no detallaba y que deberán reflejarse en el Database Design Diagram de Traceability & Quality:

* `excursions.corrective_action`: acción correctiva recibida con `IncidentResolved`, necesaria para incluirla en el reporte.
* `excursions.open_key`: clave que garantiza una sola excursión abierta por zona y variable.
* `traceability_reports.content`: snapshot JSON de la evidencia (excursiones, acciones correctivas y Measurement History) que se sella junto con el checksum.
* Evento `SafeRangeRestored`, consumido desde Environmental Monitoring para cerrar la excursión cuando las mediciones vuelven al Safe Range.

##### Pedro Omar Lecca Villalobos: Backend IAM

La implementación de IAM en `machineguard-core-api` incorpora organizaciones, usuarios, roles, sesiones JWT e invitaciones de administrador. Las contraseñas se almacenan mediante BCrypt. La rotación de refresh tokens invalida el token anterior; la administración impide desactivar o degradar al último administrador activo.

Los endpoints de Traceability usan la identidad del JWT validado para resolver usuario, organización y rol. Las operaciones administrativas requieren `ADMIN`. La API publica los contratos mediante OpenAPI/Swagger.

| Repositorio | Rama | Commit | Mensaje | Cuerpo del mensaje | Fecha |
|---|---|---|---|---|---|
| `machineguard-core-api` | `develop` | `40a7ad9` | `feat(iam): add tenant authentication and local deployment` | Vacío | 2026-10-04 |
| `machineguard-core-api` | `develop` | `629dc21` | `refactor(iam): separate domain ports and persistence adapters` | Vacío | 2026-10-04 |
| `machineguard-core-api` | `develop` | `2edf223` | `docs(iam): clarify comments and local usage` | Vacío | 2026-10-04 |

##### Jose Diego Bautista Rivera: migraciones de base de datos de la API central

En este Sprint se completó el esquema de base de datos de `machineguard-core-api` para los dos Core Domains que aún no tenían persistencia, siguiendo los Database Design Diagrams del Capítulo IV (secciones 4.2.5.6.2 y 4.2.6.6.2), y se ordenó la numeración de las migraciones Flyway.

| Migración | Bounded Context | Tablas |
|---|---|---|
| `V1__environmental_monitoring.sql` | Environmental Monitoring | `monitoring_zones`, `monitoring_points`, `sensor_nodes`, `thresholds`, `measurements` |
| `V2__alert_incident.sql` | Alert & Incident Management | `incidents`, `alerts`, `corrective_actions` |
| `V4__traceability_quality.sql` | Traceability & Quality | Renombrada desde `V4_0__traceability_quality.sql`, sin cambios en su contenido |

La migración de IAM (`V5__iam.sql`) ya existía y no se modificó; la versión `V3` queda reservada.

**Convenciones aplicadas**

* Claves primarias de tipo UUID en todas las tablas, fechas como `TIMESTAMP WITH TIME ZONE` y valores controlados como `VARCHAR` con restricción `CHECK`.
* Foreign Keys físicas solo dentro del mismo Bounded Context. `organization_id`, `facility_id`, `deviation_id` y `performed_by` son referencias lógicas hacia otros contextos.
* Restricciones de unicidad para las reglas del dominio: un `Threshold` por Monitoring Zone y variable ambiental, un `device_code` por Sensor Node, un incidente por desviación y a lo sumo una alerta por incidente.

**Commits**

| Repositorio | Rama | Commit | Mensaje | Fecha |
|---|---|---|---|---|
| `machineguard-core-api` | `feat/db-environmental-monitoring-migration` | `7ac8f95` | `feat(db): add Environmental Monitoring migration` | 2026-10-05 |
| `machineguard-core-api` | `develop` | `ccbd782` | `feat(db): merge Environmental Monitoring migration into develop` | 2026-10-05 |
| `machineguard-core-api` | `feat/db-alert-incident-migration` | `5abb534` | `feat(db): add Alert and Incident Management migration` | 2026-10-05 |
| `machineguard-core-api` | `develop` | `aec8c71` | `feat(db): merge Alert and Incident Management migration into develop` | 2026-10-05 |
| `machineguard-core-api` | `chore/db-renumber-traceability-migration` | `e896320` | `chore(db): renumber Traceability migration to V4` | 2026-10-05 |
| `machineguard-core-api` | `develop` | `3bd554c` | `chore(db): merge Traceability migration renumbering into develop` | 2026-10-05 |

**Verificación**

* `mvn clean test` sobre `develop`: 34 pruebas, 0 fallos y 0 errores. Flyway aplica las migraciones en el orden `1`, `2`, `4`, `5` sobre H2 en modo PostgreSQL.
* PostgreSQL 16 en un contenedor Docker local: la aplicación arranca y Flyway informa `Successfully applied 4 migrations to schema "public", now at version v5`. La tabla `flyway_schema_history` registra las cuatro migraciones como exitosas y el esquema queda con 18 tablas de negocio.

**Ajustes respecto al diseño del Capítulo IV**

* `measurements` almacena un registro por variable ambiental (`environmental_variable`, `measured_value`, `recorded_at`) en lugar de las columnas `temperature` y `humidity` del diseño de la sección 4.2.6. Es la forma que consulta Traceability & Quality para construir el Measurement History, por lo que el Database Design Diagram de Environmental Monitoring deberá reflejarla.
* `measurements` conserva `organization_id` y `monitoring_zone_id` para filtrar por organización y zona sin recorrer los Monitoring Points.
* Quien tenga una base de datos local creada antes de estos cambios debe recrearla, porque `V1` y `V2` se ordenan antes de las migraciones que ya estaban aplicadas.

##### Camilla Espinoza — Environmental Monitoring y Frontend Core / Dashboard

Durante el Sprint se implementó el Bounded Context Environmental Monitoring en `machineguard-core-api` y la primera versión funcional del Environmental Dashboard en `machineguard-web`. El desarrollo comprendió el registro y consulta de mediciones ambientales, evaluación de Thresholds, publicación de eventos de dominio y exposición de servicios REST para el consumo del frontend. Asimismo, se desarrolló la interfaz web en Angular siguiendo una arquitectura organizada por Bounded Contexts y se incorporó la integración HTTP con la API central.

| Componente | Repositorio | Tecnología | Funcionalidad desarrollada |
|---|---|---|---|
| Environmental Monitoring | `machineguard-core-api` | Spring Boot, Spring Data JPA, PostgreSQL, Flyway, OpenAPI | Registro y consulta de Measurements, evaluación de Thresholds, eventos `DeviationDetected` y `SafeRangeRestored`, consulta de Monitoring Zones |
| Frontend Core / Environmental Dashboard | `machineguard-web` | Angular, TypeScript, SCSS, HttpClient | Dashboard ambiental, visualización de zonas y mediciones, integración con Core API, manejo de estados y soporte de autenticación JWT |

**Environmental Monitoring (RESTful API central)**

* **Domain Layer:** se implementaron los modelos `Measurement`, `Threshold`, `MonitoringZone`, `MonitoringPoint` y `SensorNode`, junto con los estados y Value Objects requeridos para representar variables ambientales, condiciones de zona y valores numéricos. Las variables ambientales se manejan mediante `EnvironmentalVariable`, diferenciando `TEMPERATURE` y `HUMIDITY`.

* **Application Layer:** se implementó `RegisterMeasurementCommandService` para registrar y evaluar nuevas mediciones, `EnvironmentalMonitoringQueryService` para atender las consultas del Bounded Context y el port `EnvironmentalMonitoringEventPublisher` para desacoplar la lógica de aplicación del mecanismo técnico de publicación de eventos.

* **Interface Layer:** se implementó `EnvironmentalMonitoringController`, sus Resources y Assemblers, además de un manejador de excepciones específico. La API expone servicios para registrar mediciones, consultar las últimas lecturas, recuperar el historial de mediciones y obtener el estado de las Monitoring Zones.

* **Infrastructure Layer:** se implementaron adapters JPA para `Measurement`, `Threshold`, `MonitoringZone`, `MonitoringPoint` y `SensorNode`, utilizando los repositorios Spring Data correspondientes. La publicación de eventos se implementó mediante `SpringEnvironmentalMonitoringEventPublisher`, mientras que `TraceabilityEventAdapter` mantiene la compatibilidad con el Bounded Context Traceability & Quality sin introducir dependencia directa desde la capa de aplicación.

* **Reglas de negocio verificadas:** cada Measurement representa una única variable ambiental; `TEMPERATURE` y `HUMIDITY` se almacenan en registros independientes. Cada nueva medición se evalúa contra el Threshold configurado para la combinación de Monitoring Zone y variable ambiental. Los límites mínimo y máximo son inclusivos. Las mediciones fuera del Safe Range generan `DeviationDetected`, mientras que el retorno de las mediciones al rango seguro genera `SafeRangeRestored`. Las mediciones sucesivas fuera de rango permiten actualizar el valor pico de una excursión sin crear una nueva excursión en Traceability & Quality.

* **Seguridad y aislamiento:** las operaciones utilizan la identidad y organización obtenidas desde el JWT. El acceso a datos se mantiene aislado por organización y no depende de los headers `X-Organization-Id` o `X-User-Id` como fuente de identidad.

Los principales endpoints implementados son:

| Método | Endpoint | Descripción |
|---|---|---|
| POST | `/api/v1/environmental-monitoring/measurements` | Registra una nueva medición ambiental |
| GET | `/api/v1/environmental-monitoring/measurements/{id}` | Obtiene una medición por identificador |
| GET | `/api/v1/environmental-monitoring/measurements/latest` | Obtiene las últimas mediciones por punto y variable |
| GET | `/api/v1/environmental-monitoring/measurements/history` | Consulta el historial de mediciones por zona, período y filtros |
| GET | `/api/v1/environmental-monitoring/zones` | Obtiene la información consolidada de las Monitoring Zones |
| GET | `/api/v1/environmental-monitoring/zones/{id}` | Obtiene el detalle de una Monitoring Zone |

**Frontend Core / Environmental Dashboard**

En `machineguard-web` se implementó la primera versión del Environmental Dashboard utilizando Angular. La solución mantiene una separación entre Domain, Application, Infrastructure y Presentation dentro del Bounded Context Environmental Monitoring.

* **Domain Layer:** se definieron los modelos utilizados por Environmental Monitoring y el contrato `MonitoringRepository`, evitando que los componentes visuales dependan directamente del mecanismo de acceso a datos.

* **Application Layer:** `EnvironmentalMonitoringService` coordina las consultas del Bounded Context y los mappers convierten los modelos recibidos en estructuras preparadas para ser utilizadas por la interfaz.

* **Infrastructure Layer:** se implementaron `MonitoringApiClient`, DTOs, mappers y `ApiMonitoringRepository` para consumir el Core API. También se mantiene un `MockMonitoringRepository` que permite ejecutar el frontend de forma desacoplada durante el desarrollo.

* **Presentation Layer:** se desarrolló `ZoneCardComponent` para representar cada Monitoring Zone y sus principales mediciones. La página `EnvironmentalDashboardComponent`, junto con `DashboardFacade`, compone la información utilizada por el dashboard y coordina los componentes de presentación.

* **Layout y componentes compartidos:** se implementaron componentes reutilizables para Sidebar, Header, Main Layout, Status Summary, Status Badge e Icon, manteniendo consistencia visual en la aplicación.

* **Integración HTTP:** el frontend se encuentra preparado para consumir `GET /api/v1/environmental-monitoring/zones`. El flujo de comunicación evita llamadas HTTP directas desde los componentes y utiliza Repository, API Client y Mappers para mantener desacoplada la capa de presentación.

El flujo implementado es:

`EnvironmentalDashboardComponent → DashboardFacade → EnvironmentalMonitoringService → MonitoringRepository → ApiMonitoringRepository → MonitoringApiClient → Core API`

* **Autenticación:** se implementó un interceptor HTTP que permite adjuntar `Authorization: Bearer <JWT>` a las solicitudes realizadas hacia el Core API. Se incluyó soporte temporal para utilizar un token real durante las pruebas de integración. El flujo definitivo de inicio de sesión con IAM se encuentra pendiente de integración con el componente desarrollado por el responsable de dicho Bounded Context.

* **Estados de interfaz:** la solución contempla estados de carga, error, ausencia de información y visualización de datos obtenidos desde Environmental Monitoring.

**Commits**

| Repositorio | Rama | Commit Id | Commit Message | Commit Message Body | Fecha |
|---|---|---|---|---|---|
| `machineguard-core-api` | `feature/environmental-monitoring` | `0ff5c86` | `feat: implement environmental monitoring measurements and domain events` | Vacío | 2026-10-06 |
| `machineguard-web` | `feature/dashboard-core` | `13ccaac` | `feat: implement environmental dashboard with bounded context architecture` | Vacío | 2026-10-06 |
| `machineguard-web` | `feature/dashboard-core` | `c94dfc9` | `feat(environmental-monitoring): integrate dashboard with Core API` | Vacío | 2026-10-06 |
| `machineguard-web` | `main` | `8f318c7` | `Merge pull request #1 from MachineGuard/feature/dashboard-core` | Vacío | 2026-10-06 |

**Verificación**

* El frontend fue compilado mediante `ng build`, completándose correctamente la generación del bundle de producción en aproximadamente 3.9 segundos.

* El bundle inicial generado tiene un tamaño de 321.83 kB y una transferencia estimada de 90.06 kB. El Environmental Dashboard se genera como un Lazy Chunk independiente de 24.77 kB.

* El resultado compilado se genera en `dist/machineguard-web`.

* La auditoría automatizada del Bounded Context Environmental Monitoring reportó 74 pruebas satisfactorias, correspondientes a 40 pruebas relacionadas con Environmental Monitoring y 34 pruebas previamente existentes en el proyecto, sin fallos ni errores.

* La repetición local de `mvn clean test` se encuentra pendiente debido a que el equipo local utilizado para la documentación aún no tiene Apache Maven configurado en el `PATH`. Esta condición corresponde al entorno local y no a un error de compilación del proyecto.

**Ajustes respecto al diseño del Capítulo IV**

* `measurements` utiliza un registro independiente por variable ambiental en lugar de almacenar temperatura y humedad como columnas en una misma fila. Cada registro contiene `environmental_variable` y `measured_value`.

* Se incorporaron `organization_id`, `monitoring_zone_id`, `monitoring_point_id`, `sensor_node_id`, `recorded_at` y `received_at` para permitir aislamiento por organización, trazabilidad del origen de la medición y diferenciación entre el momento de captura y el momento de recepción.

* La evaluación del Safe Range se centralizó mediante `Threshold`, utilizando límites inclusivos.

* Se incorporaron los eventos `DeviationDetected` y `SafeRangeRestored` para mantener la integración desacoplada entre Environmental Monitoring, Alert & Incident Management y Traceability & Quality.

* La publicación de eventos utiliza un port de aplicación (`EnvironmentalMonitoringEventPublisher`) y un adapter técnico (`SpringEnvironmentalMonitoringEventPublisher`), evitando que el Application Layer dependa directamente del consumidor de los eventos.

* En el frontend se incorporó una capa de infraestructura HTTP que reemplaza progresivamente el uso de datos simulados y permite consumir la información consolidada del endpoint `/api/v1/environmental-monitoring/zones`.

* La integración final del dashboard con datos reales y el flujo completo de autenticación mediante IAM se encuentran pendientes de validación end-to-end.


#### 6.2.1.5. Testing Suite Evidence for Sprint Review

Durante el Sprint 1 se implementaron pruebas automatizadas para verificar las principales reglas de negocio, persistencia, seguridad, publicación de eventos e integración REST del Bounded Context Environmental Monitoring.

Las pruebas se encuentran en el repositorio `MachineGuard/machineguard-core-api`, dentro de `src/test/java/com/machineguard/platform/environmentalmonitoring`.

La estrategia de testing utilizada combina Unit Tests para las reglas del dominio y Integration Tests para comprobar la interacción entre los servicios de aplicación, persistencia, seguridad, migraciones y endpoints REST.

Los archivos principales de testing son:

| Archivo de prueba | Tipo | Alcance |
|---|---|---|
| `EnvironmentalMonitoringDomainTest.java` | Unit Test | Reglas de dominio relacionadas con Thresholds, Safe Range, variables ambientales y validaciones del modelo. |
| `EnvironmentalMonitoringApiIntegrationTest.java` | Integration Test | Registro y consulta de Measurements, persistencia, seguridad JWT, aislamiento por organización, consultas de zonas, historial y publicación de eventos. |
| `SpringEnvironmentalMonitoringEventPublisherTest.java` | Unit / Integration Test | Wiring del port `EnvironmentalMonitoringEventPublisher` y publicación de los eventos `DeviationDetected` y `SafeRangeRestored`. |

**Unit Tests del dominio**

Las pruebas de dominio verifican las reglas utilizadas para determinar si una Measurement se encuentra dentro o fuera del Safe Range.

Entre los comportamientos comprobados se encuentran:

- Los límites mínimo y máximo de un Threshold son inclusivos.
- Una Measurement cuyo valor se encuentra por debajo del mínimo o por encima del máximo se considera fuera del Safe Range.
- `TEMPERATURE` y `HUMIDITY` se manejan como variables ambientales independientes.
- Los valores numéricos utilizados en Measurements y Thresholds mantienen las restricciones definidas para el dominio.
- Las entidades de Environmental Monitoring respetan las reglas definidas en el modelo implementado.

Entre las pruebas utilizadas se encuentran:

| Test | Comportamiento validado |
|---|---|
| `inclusiveRangeAndOutsideBoundaries` | Verifica los límites inclusivos y los valores fuera del Threshold. |
| `inclusiveMinimumAndMaximumDoNotPublishDeviation` | Comprueba que valores iguales al mínimo o máximo permitido no generen una desviación. |
| `independentVariablesDoNotRestoreEachOther` | Valida que `TEMPERATURE` y `HUMIDITY` sean evaluadas de manera independiente. |
| `allEnvironmentalEntitiesValidateAgainstUnmodifiedV1` | Comprueba la consistencia del modelo utilizado por Environmental Monitoring con la estructura de persistencia definida. |

**Integration Tests de Measurements y persistencia**

Las pruebas de integración comprueban el flujo completo utilizado para registrar una Measurement:

`REST Controller → Application Service → Domain → Repository Adapter → Persistence`

Se validan los campos definidos en la tabla `measurements`, incluyendo:

- `id`
- `organization_id`
- `monitoring_zone_id`
- `monitoring_point_id`
- `sensor_node_id`
- `environmental_variable`
- `measured_value`
- `recorded_at`
- `received_at`

Entre las pruebas implementadas se encuentran:

| Test | Comportamiento validado |
|---|---|
| `normalIsPersistedWithoutEventsAndPreservesBothTimes` | Registra una Measurement dentro del rango, verifica su persistencia y conserva `recordedAt` y `receivedAt`. |
| `migratedMeasurementSchemaMatchesNumericNullableAndTimestampContract` | Verifica la compatibilidad del modelo de persistencia con la migración y los tipos utilizados. |
| `missingThresholdFailsWithoutPersisting` | Comprueba que una Measurement no sea persistida cuando no existe un Threshold aplicable. |
| `httpRegistrationReturnsResourceAndLocation` | Valida el registro de una Measurement mediante el servicio REST y la respuesta generada. |

**Testing de eventos de dominio**

Environmental Monitoring publica eventos cuando cambia la condición ambiental de una zona.

Se verificaron los siguientes escenarios:

| Escenario | Resultado esperado |
|---|---|
| Measurement dentro del rango | No publica evento de desviación. |
| `NORMAL → OUT_OF_RANGE` | Publica `DeviationDetected`. |
| Lecturas sucesivas fuera de rango | Mantienen la misma excursión y permiten actualizar el valor pico. |
| `OUT_OF_RANGE → NORMAL` | Publica `SafeRangeRestored`. |
| Otra zona o punto continúa fuera de rango | Evita restaurar prematuramente la condición ambiental. |

Las principales pruebas asociadas son:

| Test | Comportamiento validado |
|---|---|
| `normalToDeviationPublishesCompleteEventAndCreatesExcursion` | Comprueba la publicación de `DeviationDetected` cuando se detecta una desviación. |
| `successiveDeviationsUpdateOneExcursionPeak` | Verifica que múltiples lecturas desviadas actualicen una única excursión sin crear registros duplicados. |
| `restorationOnlyOnTransitionClosesExcursion` | Comprueba que `SafeRangeRestored` se publique cuando la condición retorna al Safe Range. |
| `otherPointDeviationPreventsPrematureRestoration` | Evita una restauración mientras otro Monitoring Point continúe fuera del rango. |
| `backfillCannotRewindLifecycleOrLatest` | Verifica que mediciones históricas no alteren incorrectamente el estado vigente ni la última lectura. |

**Testing del Event Publisher**

La integración entre la capa Application y el mecanismo técnico de publicación de eventos se realiza mediante el port `EnvironmentalMonitoringEventPublisher`.

Las pruebas verifican que el `RegisterMeasurementCommandService` dependa del port y no directamente de un consumidor externo o mecanismo de transporte.

Se comprobaron específicamente:

- wiring del port de publicación;
- publicación de `DeviationDetected`;
- publicación de `SafeRangeRestored`;
- ausencia de dependencia directa entre Environmental Monitoring y Traceability dentro de la capa de aplicación.

La prueba principal relacionada es:

`eventPublisherPortIsWiredWithoutConsumerOrTransportDependenciesInTheCommandService`

Asimismo, `SpringEnvironmentalMonitoringEventPublisherTest` verifica el adapter encargado de publicar ambos eventos mediante Spring.

**Testing de consultas REST**

También se verificaron los endpoints utilizados por el frontend y por otros consumidores de la Core API.

Entre los comportamientos comprobados se encuentran:

- recuperación de las últimas Measurements;
- consulta consolidada de Monitoring Zones;
- separación de `TEMPERATURE` y `HUMIDITY`;
- consulta de Measurement History;
- filtros por Monitoring Point;
- paginación del historial.

Las pruebas relacionadas incluyen:

| Test | Comportamiento validado |
|---|---|
| `latestAndZonesExposeSeparateVariableReadingsAndNodeCounts` | Comprueba las últimas lecturas y la composición de información utilizada por el Dashboard. |
| `historyIsInclusiveFilteredAndPaginated` | Verifica filtros temporales y paginación del historial. |
| `historyPortAppliesPointFilterAndPageOffsetInInfrastructure` | Comprueba que los filtros y offsets se apliquen correctamente en Infrastructure. |

**Testing de seguridad y aislamiento por organización**

Los servicios de Environmental Monitoring utilizan la identidad obtenida mediante JWT para determinar la organización del usuario autenticado.

Se verificaron los siguientes escenarios:

- un tenant no puede registrar información para otra organización;
- las consultas se limitan a la organización autenticada;
- los headers `X-Organization-Id` y `X-User-Id` no permiten alterar la identidad obtenida del JWT;
- las operaciones administrativas de escritura requieren los permisos correspondientes.

Las pruebas asociadas son:

| Test | Comportamiento validado |
|---|---|
| `tenantCannotRegisterInAnotherOrganization` | Impide registrar Measurements para otra organización. |
| `tenantIsolationAppliesToAllReadsAndIgnoresForgedHeaders` | Verifica aislamiento en consultas e ignora headers utilizados para intentar modificar el tenant. |
| `authenticationAndAdminWritePermissionsAreEnforced` | Comprueba autenticación y permisos necesarios para operaciones de escritura. |

**Commits relacionados con Testing**

Las pruebas de Environmental Monitoring fueron incorporadas dentro del mismo commit utilizado para implementar el Bounded Context.

| Repository | Branch | Commit Id | Commit Message | Commit Message Body | Committed on |
|---|---|---|---|---|---|
| `machineguard-core-api` | `feature/environmental-monitoring` | `0ff5c86` | `feat: implement environmental monitoring measurements and domain events` | Vacío | 2026-10-06 |

El commit incorporó, entre otros, los archivos:

- `EnvironmentalMonitoringApiIntegrationTest.java`
- `EnvironmentalMonitoringDomainTest.java`
- `SpringEnvironmentalMonitoringEventPublisherTest.java`

En total, el commit registró 46 archivos modificados, con 1,753 líneas incorporadas y 2 líneas eliminadas.

La auditoría automatizada de la implementación reportó un total de 74 pruebas satisfactorias, sin fallos ni errores. De estas, 40 corresponden al alcance incorporado con Environmental Monitoring y 34 pertenecen a pruebas previamente existentes de IAM y Traceability.

La repetición local mediante `mvn clean test` se encuentra pendiente en el equipo utilizado para la documentación debido a que Apache Maven aún no se encuentra configurado en el `PATH`. Esta condición corresponde al entorno local y no a una falla funcional identificada en la implementación.

No se implementaron archivos BDD `.feature` durante este Sprint para Environmental Monitoring; la cobertura realizada corresponde a Unit Tests e Integration Tests automatizados.

#### 6.2.1.6. Execution Evidence for Sprint Review

##### Pedro Omar Lecca Villalobos: funcionamiento de la API

La verificación funcional de los endpoints IAM registró los siguientes resultados:

| Operación | Resultado |
|---|---|
| Inicio de sesión, validación del access token y rotación del refresh token | HTTP `200` en los tres casos. |
| Reutilización del refresh token anterior | HTTP `401`; la sesión se revoca. |
| Uso del refresh token rotado después de la revocación | HTTP `401`. |
| Swagger UI y `/v3/api-docs` | HTTP `200`; OpenAPI 3.1 con esquema `bearerAuth`. |
| `GET /api/v1/traceability/excursions` sin Bearer token | HTTP `401`. |

##### Camilla Espinoza — funcionamiento de Environmental Monitoring y Environmental Dashboard

La verificación funcional del Bounded Context Environmental Monitoring y de la primera versión del Environmental Dashboard registró los siguientes resultados:

| Operación | Resultado |
|---|---|
| Carga de Swagger UI para Environmental Monitoring | Correcta; se visualizan los seis endpoints implementados bajo `/api/v1/environmental-monitoring`. |
| Documentación OpenAPI de `POST /measurements` | Correcta; Swagger muestra el request body requerido y el esquema de `MeasurementResource`. |
| Documentación OpenAPI de `GET /zones` | Correcta; se expone el contrato consolidado de Monitoring Zones, puntos de monitoreo y sensores. |
| Documentación OpenAPI de `GET /zones/{id}` | Correcta; acepta un UUID como parámetro de ruta y documenta `ZoneResource`. |
| Documentación OpenAPI de `GET /measurements/{id}` | Correcta; acepta un UUID y devuelve el contrato de una Measurement. |
| Documentación OpenAPI de `GET /measurements/latest` | Correcta; permite filtrar opcionalmente por `monitoringZoneId`. |
| Documentación OpenAPI de `GET /measurements/history` | Correcta; permite filtrar por zona, punto, variable ambiental, intervalo temporal y paginación. |
| Compilación de `machineguard-web` | Correcta; `ng build` generó el bundle de producción sin errores. |
| Carga del Environmental Dashboard | Correcta; se visualizan los componentes de resumen, Monitoring Zones, estados ambientales y últimas alertas. |
| Integración HTTP del Dashboard con Core API | Implementada mediante Repository, API Client y Mappers para consumir `/api/v1/environmental-monitoring/zones`. |
| Interceptor JWT del frontend | Implementado; preparado para añadir `Authorization: Bearer <JWT>` a las llamadas al Core API. |
| Validación end-to-end con JWT y datos reales | Pendiente de validación final junto con el flujo de autenticación IAM. |

#### 6.2.1.7. Services Documentation Evidence for Sprint Review

Los contratos OpenAPI se consultan en Swagger UI (`/swagger-ui/index.html`) y en formato JSON (`/v3/api-docs`). El repositorio del servicio es [MachineGuard/machineguard-core-api](https://github.com/MachineGuard/machineguard-core-api), rama `develop`. Los contratos IAM se documentaron en los commits `40a7ad9`, `2edf223` y `e32605d`.

| Método y ruta | Acceso y parámetros | Ejemplo de solicitud | Respuesta exitosa |
|---|---|---|---|
| `POST /api/v1/auth/login` | Público; cuerpo `email`, `password`. | `{"email":"user@example.com","password":"<password>"}` | `200 AuthenticationResource`; emite tokens e identidad del usuario y organización. |
| `POST /api/v1/auth/refresh` | Público con refresh token; cuerpo `refreshToken`. | `{"refreshToken":"<refresh-token>"}` | `200 AuthenticationResource`; rota el refresh token y emite nuevos tokens. |
| `POST /api/v1/auth/logout` | Bearer; cuerpo `refreshToken`. | `{"refreshToken":"<refresh-token>"}` | `204`; no devuelve cuerpo y revoca la sesión. |
| `POST /api/v1/auth/password-reset` | Bearer; cuerpo `currentPassword`, `newPassword`. | `{"currentPassword":"<current>","newPassword":"<new-password>"}` | `200 MessageResource`; confirma el cambio y requiere iniciar sesión de nuevo. |
| `POST /api/v1/auth/validate` | Bearer; sin parámetros ni cuerpo. | Sin cuerpo. | `200 TokenValidationResource`; devuelve validez, usuario, organización, rol y expiración. |
| `POST /api/v1/auth/invitations/accept` | Público con invitación; cuerpo `token`, `password`. | `{"token":"<invitation-token>","password":"<new-password>"}` | `201 InvitationAcceptedResource`; confirma la aceptación de la invitación. |
| `GET /api/v1/users/me` | Bearer; sin parámetros. | Sin cuerpo. | `200 UserResource`; devuelve el perfil autenticado. |
| `POST /api/v1/organizations/{organizationId}/users` | Bearer y `ADMIN`; parámetro de ruta `organizationId`; cuerpo `email`, `password`, `fullName`, `role`. | `{"email":"user@example.com","password":"<password>","fullName":"Usuario de ejemplo","role":"VIEWER"}` | `201 UserResource`; devuelve el usuario creado en la organización autenticada. |
| `PATCH /api/v1/users/{userId}/role` | Bearer y `ADMIN`; parámetro de ruta `userId`; cuerpo `role`. | `{"role":"VIEWER"}` | `200 UserResource`; devuelve el usuario con el rol actualizado. |
| `PATCH /api/v1/users/{userId}/status` | Bearer y `ADMIN`; parámetro de ruta `userId`; cuerpo `status`. | `{"status":"INACTIVE"}` | `200 UserResource`; devuelve el usuario con el estado actualizado. |
| `GET /api/v1/organizations/{organizationId}` | Bearer; parámetro de ruta `organizationId`. | Sin cuerpo. | `200 OrganizationResource`; devuelve los datos de la organización autenticada. |

`AuthenticationResource` incluye `tokenType`, `accessToken`, `expiresIn`, `refreshToken`, `user` y `organization`. `UserResource` incluye identificadores, correo, nombre, rol, estado y marcas de tiempo; `OrganizationResource` incluye identificador, nombre, plan, estado y marcas de tiempo. Los parámetros de ruta son UUID. Las solicitudes protegidas usan `Authorization: Bearer <accessToken>`; el acceso `ADMIN` se limita a la organización del principal autenticado.

Ejemplo de respuesta de inicio de sesión:

```json
{
  "tokenType": "Bearer",
  "accessToken": "<JWT>",
  "expiresIn": 900,
  "refreshToken": "<refresh-token>",
  "user": {
    "id": "<UUID>",
    "organizationId": "<UUID>",
    "email": "user@example.com",
    "fullName": "Usuario de ejemplo",
    "role": "VIEWER",
    "status": "ACTIVE",
    "lastLoginAt": "<ISO-8601>",
    "createdAt": "<ISO-8601>"
  },
  "organization": {
    "id": "<UUID>",
    "name": "Organización de ejemplo",
    "subscriptionPlan": "FREE",
    "status": "ACTIVE",
    "createdAt": "<ISO-8601>",
    "updatedAt": "<ISO-8601>"
  }
}
```

La interacción de ejemplo con credenciales de muestra inválidas devuelve `401` y el cuerpo `{"error":"Unauthorized","message":"Invalid email or password","status":401}`.

![Contrato de solicitud y respuesta de login en Swagger UI](../assets/img/chapter-6/iam-swagger-login-contract.png)

![Respuesta HTTP 401 de login con datos de muestra](../assets/img/chapter-6/iam-swagger-login-401.png)

![Contrato para rotar el refresh token](../assets/img/chapter-6/iam-swagger-refresh-contract.png)

![Contrato para cerrar una sesión](../assets/img/chapter-6/iam-swagger-logout-contract.png)

![Contrato para aceptar una invitación](../assets/img/chapter-6/iam-swagger-accept-invitation-contract.png)

![Contrato para registrar un usuario en una organización](../assets/img/chapter-6/iam-swagger-register-user-contract.png)

El alta inicial de organizaciones usa el evento `PilotRequestSubmitted`. La API protege las rutas de Traceability con Bearer y limita las operaciones de escritura al rol `ADMIN`.

##### Environmental Monitoring

Los contratos OpenAPI del Bounded Context Environmental Monitoring se encuentran disponibles mediante Swagger UI (`/swagger-ui/index.html`) y en formato JSON a través de `/v3/api-docs`.

El servicio se encuentra implementado en el repositorio [MachineGuard/machineguard-core-api](https://github.com/MachineGuard/machineguard-core-api), rama `feature/environmental-monitoring`. La implementación principal corresponde al commit `0ff5c86` (`feat: implement environmental monitoring measurements and domain events`).

Environmental Monitoring proporciona las operaciones necesarias para registrar mediciones ambientales, consultar las últimas lecturas, recuperar el historial de Measurements y obtener el estado consolidado de las Monitoring Zones.

Los endpoints se encuentran protegidos mediante autenticación Bearer/JWT. La organización utilizada para el aislamiento de información se obtiene a partir de la identidad autenticada, evitando utilizar `X-Organization-Id` o `X-User-Id` como fuente de identidad.

![Endpoints de Environmental Monitoring documentados en Swagger UI](../assets/img/chapter-6/environmental-monitoring-swagger.png)

| Método y ruta | Acceso y parámetros | Ejemplo de solicitud | Respuesta documentada |
|---|---|---|---|
| `POST /api/v1/environmental-monitoring/measurements` | Bearer y rol `ADMIN`. Request body con `monitoringZoneId`, `monitoringPointId`, `sensorNodeId`, `environmentalVariable`, `measuredValue` y `recordedAt`. | JSON con la información de una nueva Measurement. | `200 MeasurementResource` según el contrato OpenAPI actual. |
| `GET /api/v1/environmental-monitoring/zones` | Bearer. No requiere parámetros. | Sin cuerpo. | `200`; colección de Monitoring Zones con información consolidada de puntos, sensores y estado ambiental. |
| `GET /api/v1/environmental-monitoring/zones/{id}` | Bearer. Path parameter `id` de tipo UUID. | Sin cuerpo. | `200 ZoneResource`; devuelve el detalle de una Monitoring Zone. |
| `GET /api/v1/environmental-monitoring/measurements/{id}` | Bearer. Path parameter `id` de tipo UUID. | Sin cuerpo. | `200 MeasurementResource`; devuelve una Measurement determinada. |
| `GET /api/v1/environmental-monitoring/measurements/latest` | Bearer. Query parameter opcional `monitoringZoneId` de tipo UUID. | Sin cuerpo. | `200`; colección con las últimas Measurements registradas. |
| `GET /api/v1/environmental-monitoring/measurements/history` | Bearer. `monitoringZoneId`, `from` y `to` obligatorios. `monitoringPointId` y `environmentalVariable` opcionales. También acepta `page` y `size`. | Sin cuerpo. | `200`; historial de Measurements de acuerdo con los filtros indicados. |

**Registro de Measurements**

El endpoint `POST /api/v1/environmental-monitoring/measurements` permite registrar una nueva lectura ambiental proveniente de un Monitoring Point. Cada registro representa una sola variable ambiental, por lo que `TEMPERATURE` y `HUMIDITY` son almacenadas como Measurements independientes.

El request body incluye:

- `monitoringZoneId`: identificador UUID de la Monitoring Zone.
- `monitoringPointId`: identificador UUID del Monitoring Point.
- `sensorNodeId`: identificador UUID del Sensor Node asociado.
- `environmentalVariable`: variable ambiental, actualmente `TEMPERATURE` o `HUMIDITY`.
- `measuredValue`: valor numérico registrado.
- `recordedAt`: fecha y hora en la que fue capturada la lectura.

```json
{
  "monitoringZoneId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "monitoringPointId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "sensorNodeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "environmentalVariable": "TEMPERATURE",
  "measuredValue": 11.20,
  "recordedAt": "2026-10-06T21:30:00-05:00"
}
```

La respuesta corresponde a un `MeasurementResource` y contiene:

- `id`
- `organizationId`
- `monitoringZoneId`
- `monitoringPointId`
- `sensorNodeId`
- `environmentalVariable`
- `measuredValue`
- `recordedAt`
- `receivedAt`

`recordedAt` representa el momento de captura de la medición, mientras que `receivedAt` identifica el momento en que la Core API recibió y procesó dicha información.

```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "organizationId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "monitoringZoneId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "monitoringPointId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "sensorNodeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "environmentalVariable": "TEMPERATURE",
  "measuredValue": 11.20,
  "recordedAt": "2026-10-06T21:30:00-05:00",
  "receivedAt": "2026-10-06T21:30:01-05:00"
}
```

![Contrato para registrar una Measurement en Swagger UI](../assets/img/chapter-6/environmental-monitoring-measurements-swagger.png)

**Consulta de Monitoring Zones**

El endpoint `GET /api/v1/environmental-monitoring/zones` permite recuperar las Monitoring Zones correspondientes a la organización autenticada. La respuesta consolida información necesaria para la representación del estado ambiental en el Environmental Dashboard.

Entre los datos documentados se encuentran:

- identificador de la Monitoring Zone;
- identificador de la organización;
- identificador del Facility;
- nombre y descripción;
- estado de la zona;
- condición ambiental;
- cantidad de sensores online;
- cantidad de sensores offline;
- cantidad de sensores inactivos;
- fecha de última actualización;
- Monitoring Points asociados;
- Sensor Nodes asociados.

Este endpoint constituye uno de los principales contratos utilizados para la integración con `machineguard-web`, ya que permite obtener la información consolidada requerida para representar las zonas monitoreadas dentro del Environmental Dashboard.

![Contrato para consultar Monitoring Zones](../assets/img/chapter-6/environmental-monitoring-zones-swagger.png)

**Consulta de Monitoring Zone por identificador**

El endpoint `GET /api/v1/environmental-monitoring/zones/{id}` permite obtener el detalle de una Monitoring Zone específica.

El parámetro `id` es obligatorio, se envía como parte de la ruta y corresponde a un identificador de tipo UUID.

La respuesta utiliza el modelo consolidado de la Monitoring Zone e incluye información sobre su estado, condición ambiental, Monitoring Points y Sensor Nodes asociados.

![Contrato para consultar una Monitoring Zone por ID](../assets/img/chapter-6/environmental-monitoring-zone-id-swagger.png)

**Consulta de Measurement por identificador**

El endpoint `GET /api/v1/environmental-monitoring/measurements/{id}` permite obtener una Measurement específica utilizando su identificador UUID.

La respuesta devuelve un `MeasurementResource`, permitiendo identificar la organización, Monitoring Zone, Monitoring Point, Sensor Node, variable ambiental, valor medido y las marcas temporales relacionadas con la lectura.

![Contrato para consultar una Measurement por ID](../assets/img/chapter-6/environmental-monitoring-measurements-id-swagger.png)

**Consulta de últimas Measurements**

El endpoint `GET /api/v1/environmental-monitoring/measurements/latest` permite recuperar las últimas mediciones registradas.

De manera opcional se puede proporcionar el parámetro:

- `monitoringZoneId`: identificador UUID de la Monitoring Zone utilizada para restringir la consulta.

La respuesta consiste en una colección de Measurements y mantiene una lectura independiente para cada Monitoring Point y variable ambiental.

Este endpoint permite obtener información reciente de `TEMPERATURE` y `HUMIDITY` sin necesidad de consultar el historial completo.

![Contrato para consultar las últimas Measurements](../assets/img/chapter-6/environmental-monitoring-measurements-latest-swagger.png)

**Consulta del Measurement History**

El endpoint `GET /api/v1/environmental-monitoring/measurements/history` permite consultar el historial de Measurements correspondiente a un intervalo temporal determinado.

Los parámetros disponibles son:

- `monitoringZoneId`: UUID obligatorio de la Monitoring Zone.
- `monitoringPointId`: UUID opcional del Monitoring Point.
- `environmentalVariable`: variable opcional. Los valores disponibles son `TEMPERATURE` y `HUMIDITY`.
- `from`: fecha y hora inicial obligatoria en formato `date-time`.
- `to`: fecha y hora final obligatoria en formato `date-time`.
- `page`: número de página. El valor predeterminado es `0`.
- `size`: cantidad máxima de elementos solicitados. El valor predeterminado es `100`.

Un ejemplo de llamada es:

`GET /api/v1/environmental-monitoring/measurements/history?monitoringZoneId=<UUID>&environmentalVariable=TEMPERATURE&from=2026-10-01T00:00:00Z&to=2026-10-07T23:59:59Z&page=0&size=100`

La respuesta documentada incluye la Monitoring Zone consultada, el intervalo temporal utilizado, la cantidad de Measurements encontradas y la colección de mediciones correspondientes.

```json
{
  "monitoringZoneId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "from": "2026-10-01T00:00:00Z",
  "to": "2026-10-07T23:59:59Z",
  "count": 1,
  "measurements": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "organizationId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "monitoringZoneId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "monitoringPointId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "sensorNodeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "environmentalVariable": "TEMPERATURE",
      "measuredValue": 11.20,
      "recordedAt": "2026-10-06T21:30:00-05:00",
      "receivedAt": "2026-10-06T21:30:01-05:00"
    }
  ]
}
```

![Contrato para consultar el Measurement History](../assets/img/chapter-6/environmental-monitoring-measurements-history-swagger.png)

**Reglas de negocio e integración asociadas**

Cada Measurement registrada representa una única variable ambiental y es evaluada contra el `Threshold` correspondiente a la combinación de Monitoring Zone y `EnvironmentalVariable`.

Los valores mínimo y máximo del Threshold son considerados límites inclusivos para determinar si una medición se encuentra dentro del Safe Range.

Cuando una Measurement se encuentra fuera del rango permitido, Environmental Monitoring publica el evento `DeviationDetected`. Este evento permite informar a otros Bounded Contexts sobre la existencia de una condición ambiental fuera de los parámetros configurados.

Cuando las mediciones retornan nuevamente al Safe Range, Environmental Monitoring publica el evento `SafeRangeRestored`.

La publicación de estos eventos se realiza mediante el port `EnvironmentalMonitoringEventPublisher`, cuya implementación técnica se encuentra desacoplada de la capa de aplicación mediante `SpringEnvironmentalMonitoringEventPublisher`.

De esta manera, otros Bounded Contexts como Traceability & Quality y Alert & Incident Management pueden reaccionar a los cambios ambientales sin introducir dependencias directas entre sus modelos internos.

**Integración con el Environmental Dashboard**

El endpoint `GET /api/v1/environmental-monitoring/zones` constituye el principal contrato utilizado por la primera versión del Environmental Dashboard desarrollada en `machineguard-web`.

El frontend mantiene el siguiente flujo de integración:

`EnvironmentalDashboardComponent → DashboardFacade → EnvironmentalMonitoringService → MonitoringRepository → ApiMonitoringRepository → MonitoringApiClient → Core API`

Esta organización permite mantener desacoplada la capa de presentación respecto de los detalles de comunicación HTTP y de los DTO recibidos desde la API.

La comunicación con los endpoints protegidos se encuentra preparada mediante un interceptor HTTP que añade el header `Authorization: Bearer <JWT>` a las solicitudes dirigidas al Core API.

La validación final end-to-end con información real y el flujo completo de autenticación mediante IAM se encuentra pendiente de integración y ejecución.


#### 6.2.1.8. Software Deployment Evidence for Sprint Review

> Contenido pendiente.

#### 6.2.1.9. Team Collaboration Insights during Sprint

La integración de IAM con Traceability permitió obtener la identidad y la organización desde el JWT validado. Las rutas protegidas aplican los permisos del rol y restringen el acceso a los recursos de la organización autenticada.

El esquema de base de datos de `machineguard-core-api` se coordinó entre cuatro Bounded Contexts que migraban en paralelo. Traceability & Quality necesitaba la tabla `measurements` de Environmental Monitoring, que aún no existía, y la migración de IAM ya estaba numerada como `V5`. Por ello Jose Diego Bautista Rivera completó las migraciones de Environmental Monitoring (`V1`) y de Alert & Incident Management (`V2`), renumeró la de Traceability & Quality a `V4` y reservó `V3`, de modo que Flyway aplica las cinco migraciones en un orden coherente con sus dependencias. Cada migración se integró a `develop` desde su propia rama de funcionalidad, y se avisó al equipo de que las bases de datos locales creadas antes de estos cambios debían recrearse.

## 6.3. Validation Interviews

### 6.3.1. Diseño de Entrevistas
> Contenido pendiente.

### 6.3.2. Registro de Entrevistas
> Contenido pendiente.

### 6.3.3. Evaluaciones según heurísticas
> Contenido pendiente.

## 6.4. Video About-the-Product
> Contenido pendiente.
