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

#### 6.2.1.5. Testing Suite Evidence for Sprint Review

> Contenido pendiente.

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

#### 6.2.1.8. Software Deployment Evidence for Sprint Review

> Contenido pendiente.

#### 6.2.1.9. Team Collaboration Insights during Sprint

La integración de IAM con Traceability permitió obtener la identidad y la organización desde el JWT validado. Las rutas protegidas aplican los permisos del rol y restringen el acceso a los recursos de la organización autenticada.

## 6.3. Validation Interviews

### 6.3.1. Diseño de Entrevistas
> Contenido pendiente.

### 6.3.2. Registro de Entrevistas
> Contenido pendiente.

### 6.3.3. Evaluaciones según heurísticas
> Contenido pendiente.

## 6.4. Video About-the-Product
> Contenido pendiente.
