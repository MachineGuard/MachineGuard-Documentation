# Capítulo IV: Solution Software Design

## 4.1. Strategic-Level Domain-Driven Design

### 4.1.1. Design-Level EventStorming

Para identificar y delimitar los Bounded Contexts de MachineGuard, el equipo realizó una sesión de Design-Level EventStorming en la herramienta Miro. A partir del Big Picture EventStorming elaborado en el Capítulo II, se profundizó en los flujos de dominio para descubrir los contextos candidatos, modelar los flujos de mensajes entre ellos y definir sus canvases.

El proceso de Design-Level EventStorming se realizó en la herramienta Miro:

**[Ver Design-Level EventStorming en Miro](*insertar enlace de Miro aquí*)**

#### 4.1.1.1. Candidate Context Discovery

A partir del Design-Level EventStorming, el equipo identificó seis Bounded Contexts. El criterio de agrupación combinó cohesión semántica (eventos que giran en torno al mismo agregado raíz), autonomía de despliegue (Edge Processing se despliega físicamente en la red del cliente) y clasificación estratégica DDD (Core / Supporting / Generic).

---

**IAM — Identity & Access Management**

El Bounded Context IAM gestiona la identidad de los usuarios y organizaciones dentro de MachineGuard. Al ser una plataforma SaaS multi-tenant, cada empresa cliente opera como una organización aislada cuyos usuarios acceden únicamente a sus propias instalaciones monitoreadas. IAM garantiza autenticación segura, asignación de roles (administrador vs. visualizador) y el aislamiento de datos entre tenants.

Su propósito principal es proporcionar un acceso confiable y controlado a todos los Bounded Contexts operativos, que dependen del token de identidad emitido por IAM para validar a qué usuario pertenece y a qué organización está asociado.

Su clasificación es **Supporting Domain**: no contiene lógica de negocio diferenciadora del producto, pero es una dependencia transversal indispensable para los tres Core Domains.

![Design-Level EventStorming — IAM](../assets/img/chapter-4/eventstorying-iam.png)

---

**Environmental Monitoring**

El Bounded Context Environmental Monitoring es el núcleo del producto. Se encarga de configurar las zonas de monitoreo (Monitoring Zone), los puntos de monitoreo (Monitoring Point) y los umbrales (Threshold) de temperatura y humedad, así como de evaluar cada medición recibida contra el rango seguro (Safe Range) definido para esa zona.

Cuando una medición supera un umbral, este contexto publica el evento `DeviationDetected`, que desencadena la lógica de alertas en Alert & Incident Management y el registro de excursiones en Traceability & Quality. También detecta y publica `SensorNodeWentOffline` cuando un nodo sensor deja de enviar lecturas dentro del intervalo de muestreo (Sampling Interval) esperado.

Su clasificación es **Core Domain**: contiene las reglas de negocio que diferencian a MachineGuard de un simple dashboard de sensores.

![Design-Level EventStorming — Environmental Monitoring](../assets/img/chapter-4/eventstorying-environmental-monitoring.png)

---

**Alert & Incident Management**

El Bounded Context Alert & Incident Management gestiona el ciclo de vida completo de una alerta: desde su generación automática ante una desviación detectada (`AlertRaised`), pasando por el reconocimiento del operador (`AlertAcknowledged`), el escalamiento si no se reconoce a tiempo (`AlertEscalated`) y el registro de la acción correctiva tomada (`CorrectiveActionRegistered`), hasta el cierre del incidente (`IncidentResolved`).

Este contexto integra con Twilio para enviar notificaciones SMS y WhatsApp en tiempo real, garantizando que el personal responsable sea alertado incluso fuera del horario laboral — el punto crítico validado en las entrevistas del Capítulo II.

Su clasificación es **Core Domain**: la detección temprana y notificación automática sin presencia humana es la propuesta de valor central de MachineGuard.

![Design-Level EventStorming — Alert & Incident Management](../assets/img/chapter-4/eventstorying-alert-incident-management.png)

---

**Traceability & Quality**

El Bounded Context Traceability & Quality registra el historial de excursiones ambientales (períodos en que las condiciones estuvieron fuera del rango seguro) y genera los reportes de trazabilidad requeridos en auditorías de calidad (HACCP, ISO 9001).

Cuando una desviación persiste, este contexto registra su inicio (`ExcursionStarted`) y, una vez resuelta, su fin (`ExcursionEnded`). El Encargado de Control de Calidad puede solicitar un reporte de trazabilidad (`TraceabilityReportGenerated`) que consolida el historial de mediciones, la excursión y las acciones correctivas tomadas, permitiendo demostrar trazabilidad ante una auditoría.

Su clasificación es **Core Domain**: la capacidad de generar evidencia trazable para auditorías es un requisito regulatorio de alto valor para el segmento de Control de Calidad.

![Design-Level EventStorming — Traceability & Quality](../assets/img/chapter-4/eventstorying-traceability-quality.png)

---

**Edge Processing**

El Bounded Context Edge Processing se despliega físicamente en la red del cliente, sobre un gateway local (Raspberry Pi o similar) que ejecuta la Edge API (Flask + SQLite). Su responsabilidad es capturar las lecturas del nodo sensor ESP32 mediante el firmware embebido, aplicar la calibración local (Calibration Offset) y filtrar lecturas erróneas, publicando mediciones limpias hacia Environmental Monitoring.

En caso de caída de la conexión a internet, Edge Processing mantiene un buffer local (Local Buffer) con las lecturas capturadas durante la interrupción, sincronizándolas con la nube cuando la conexión se restablece. Esto garantiza la continuidad del monitoreo y la integridad del historial de mediciones (Measurement History).

Su clasificación es **Supporting Domain**: resuelve el problema técnico de continuidad offline, habilitando a los Core Domains sin contener lógica de negocio diferenciadora.

![Design-Level EventStorming — Edge Processing](../assets/img/chapter-4/eventstorying-edge-processing.png)

---

**Customer Acquisition**

El Bounded Context Customer Acquisition gestiona el proceso de adquisición de clientes potenciales a través de la landing page de MachineGuard. Permite a los visitantes conocer la propuesta de valor, estimar las pérdidas evitadas con el producto y solicitar una demostración o piloto gratuito mediante un formulario (`PilotRequestSubmitted`).

Este contexto no contiene lógica de negocio compleja: su única responsabilidad de integración es publicar la solicitud de piloto para que IAM inicie el proceso de onboarding del nuevo cliente. Al ser un dominio genérico, no se le aplica diseño táctico DDD completo.

Su clasificación es **Generic Domain**: la adquisición de clientes mediante landing page es una práctica estándar sin reglas de negocio específicas del dominio de monitoreo ambiental.

![Design-Level EventStorming — Customer Acquisition](../assets/img/chapter-4/eventstorying-customer-acquisition.png)

#### 4.1.1.2. Domain Message Flows Modeling

Se modelaron tres flujos de mensajes de dominio que representan los escenarios de negocio más críticos de MachineGuard, mostrando cómo los eventos y comandos viajan entre Bounded Contexts.

---

**Flujo 1: Detección de desviación ambiental y notificación de alerta**

Este flujo representa el escenario central del producto: un sensor detecta condiciones fuera del rango seguro y el sistema alerta automáticamente al personal responsable sin necesidad de presencia humana.

| Paso | Actor | Comando / Evento | Bounded Context destino |
|------|-------|------------------|-------------------------|
| 1 | Sensor Node (ESP32) | Captura lectura periódica del DHT22 → `ReadingCaptured` | Edge Processing |
| 2 | Edge Processing | Aplica calibración, filtra errores y publica medición limpia → `ReadingCaptured` (filtrada) | Environmental Monitoring |
| 3 | Environmental Monitoring | Registra la medición → `MeasurementRecorded` | Environmental Monitoring |
| 4 | Environmental Monitoring | Evalúa contra el umbral (Threshold); valor fuera del rango seguro → `DeviationDetected` | Alert & Incident Management / Traceability & Quality |
| 5 | Alert & Incident Management | Crea alerta con severidad asignada → `AlertRaised` | Alert & Incident Management |
| 6 | Twilio (externo) | Envía notificación SMS/WhatsApp al operador responsable | Externo |
| 7 | Traceability & Quality | Registra inicio de excursión → `ExcursionStarted` | Traceability & Quality |
| 8 | Jefe de Almacén | Reconoce la alerta en la aplicación → `AlertAcknowledged` | Alert & Incident Management |

---

**Flujo 2: Resolución de incidente y generación de reporte de trazabilidad**

Este flujo muestra cómo se cierra el ciclo de un incidente y se genera el registro de auditoría requerido por los sistemas de gestión de calidad (HACCP, ISO 9001).

| Paso | Actor | Comando / Evento | Bounded Context destino |
|------|-------|------------------|-------------------------|
| 1 | Jefe de Almacén | Registra la acción correctiva tomada → `CorrectiveActionRegistered` | Alert & Incident Management |
| 2 | Alert & Incident Management | Cierra el incidente → `IncidentResolved` | Traceability & Quality |
| 3 | Environmental Monitoring | Las lecturas vuelven dentro del rango seguro → `MeasurementRecorded` (en rango) | Environmental Monitoring |
| 4 | Traceability & Quality | Registra el fin de la excursión → `ExcursionEnded` | Traceability & Quality |
| 5 | Encargado de Control de Calidad | Solicita el reporte de trazabilidad del período | Traceability & Quality |
| 6 | Traceability & Quality | Genera y publica el reporte completo → `TraceabilityReportGenerated` | Traceability & Quality |

---

**Flujo 3: Incorporación de nuevo cliente (onboarding)**

Este flujo representa el proceso de adquisición y activación de un nuevo cliente, desde la solicitud de piloto en la landing page hasta la configuración inicial del sistema de monitoreo en sus instalaciones.

| Paso | Actor | Comando / Evento | Bounded Context destino |
|------|-------|------------------|-------------------------|
| 1 | Visitante Web | Completa el formulario de piloto gratuito → `PilotRequestSubmitted` | Customer Acquisition |
| 2 | IAM | Crea la organización del nuevo cliente → `OrganizationCreated` | IAM |
| 3 | IAM | Registra al usuario administrador de la organización → `UserRegistered` | IAM |
| 4 | IAM | Asigna el rol de administrador al usuario registrado → `RoleAssigned` | IAM |
| 5 | Jefe de Almacén (nuevo usuario) | Configura la primera zona de monitoreo y sus umbrales → `ThresholdConfigured` | Environmental Monitoring |
| 6 | Edge Processing | Recibe la configuración de umbrales para evaluación local preliminar | Edge Processing |


#### 4.1.1.3. Bounded Context Canvases

A continuación se presentan los Bounded Context Canvases para cada uno de los seis contextos identificados en MachineGuard.

---

**Canvas 1: IAM — Identity & Access Management**

| Atributo | Detalle |
|---|---|
| **Nombre** | IAM — Identity & Access Management |
| **Clasificación estratégica** | Supporting Domain |
| **Propósito** | Gestionar identidades, autenticación, roles y aislamiento multi-tenant de las organizaciones clientes |
| **Roles de dominio** | Usuario no registrado (Visitante Web), Usuario registrado (Jefe de Almacén, Encargado de Control de Calidad), Administrador de organización |
| **Decisiones de negocio** | ¿Quién puede acceder al sistema? ¿A qué organización pertenece cada usuario? ¿Qué rol tiene dentro de su organización? |
| **Comandos** | `RegisterUser`, `LoginUser`, `LogoutUser`, `AssignRole`, `CreateOrganization`, `ResetPassword` |
| **Consultas** | `GetUserProfile`, `GetOrganizationById`, `ValidateToken` |
| **Eventos publicados** | `UserRegistered`, `UserLoggedIn`, `UserLoggedOut`, `PasswordReset`, `OrganizationCreated`, `OrganizationStatusChanged`, `RoleAssigned`, `UserStatusChanged` |
| **Eventos consumidos** | `PilotRequestSubmitted` (de Customer Acquisition) |
| **Agregados clave** | `User`, `Organization`; entidad de soporte `AuthenticationSession`; Value Object `Role` |
| **Upstream (proveedores)** | Customer Acquisition (publica `PilotRequestSubmitted`) |
| **Downstream (consumidores)** | Environmental Monitoring, Alert & Incident Management, Traceability & Quality (consumen JWT de IAM) |
| **Sistemas externos** | — |
| **Lenguaje ubicuo relevante** | Subscription Plan, Monitored Facility |

---

**Canvas 2: Environmental Monitoring**

| Atributo | Detalle |
|---|---|
| **Nombre** | Environmental Monitoring |
| **Clasificación estratégica** | Core Domain |
| **Propósito** | Configurar zonas de monitoreo y umbrales, recibir mediciones ambientales y detectar desviaciones respecto al rango seguro |
| **Roles de dominio** | Jefe de Almacén (configura zonas y umbrales), Sensor Node ESP32 (genera lecturas), Sistema (evalúa mediciones automáticamente) |
| **Decisiones de negocio** | ¿Qué zonas y puntos de monitoreo existen? ¿Qué rangos seguros aplican a cada zona? ¿Cuándo una medición constituye una desviación? |
| **Comandos** | `ConfigureThreshold`, `RegisterSensorNode`, `EvaluateMeasurement`, `UpdateSamplingInterval` |
| **Consultas** | `GetLatestMeasurements`, `GetSensorNodeStatus`, `GetThresholdsByZone` |
| **Eventos publicados** | `ThresholdConfigured`, `MeasurementRecorded`, `DeviationDetected`, `SensorNodeWentOffline` |
| **Eventos consumidos** | `ReadingCaptured` (de Edge Processing) |
| **Agregados clave** | `MonitoringZone`, `MonitoringPoint`, `SensorNode`, `Threshold` |
| **Upstream (proveedores)** | Edge Processing (publica `ReadingCaptured`), IAM (proporciona identidad y contexto de organización) |
| **Downstream (consumidores)** | Alert & Incident Management, Traceability & Quality, ERP del cliente (API pública) |
| **Sistemas externos** | OpenWeatherMap (condiciones climáticas de referencia) |
| **Lenguaje ubicuo relevante** | Reading, Measurement, Sampling Interval, Safe Range, Deviation, Calibration Offset, Threshold, Monitored Facility, Monitoring Zone, Monitoring Point, Sensor Node |

---

**Canvas 3: Alert & Incident Management**

| Atributo | Detalle |
|---|---|
| **Nombre** | Alert & Incident Management |
| **Clasificación estratégica** | Core Domain |
| **Propósito** | Gestionar el ciclo de vida de alertas e incidentes: notificación automática, reconocimiento, escalamiento y registro de acciones correctivas |
| **Roles de dominio** | Jefe de Almacén (reconoce alertas, registra acciones correctivas), Sistema (genera y escala alertas automáticamente) |
| **Decisiones de negocio** | ¿Cuándo escalar una alerta no reconocida? ¿Qué severidad asignar a cada alerta? ¿Cuándo un incidente se considera resuelto? |
| **Comandos** | `RaiseAlert`, `AcknowledgeAlert`, `EscalateAlert`, `RegisterCorrectiveAction`, `ResolveIncident` |
| **Consultas** | `GetActiveAlerts`, `GetIncidentHistory`, `GetAlertById` |
| **Eventos publicados** | `AlertRaised`, `AlertAcknowledged`, `AlertEscalated`, `CorrectiveActionRegistered`, `IncidentResolved` |
| **Eventos consumidos** | `DeviationDetected` (de Environmental Monitoring) |
| **Agregados clave** | `Alert`, `Incident`, `CorrectiveAction` |
| **Upstream (proveedores)** | Environmental Monitoring (publica `DeviationDetected`), IAM (proporciona identidad) |
| **Downstream (consumidores)** | Traceability & Quality (consume `IncidentResolved`) |
| **Sistemas externos** | Twilio (notificaciones SMS y WhatsApp) |
| **Lenguaje ubicuo relevante** | Alert, Alert Severity, Acknowledgement, Escalation, Corrective Action, Incident |

---

**Canvas 4: Traceability & Quality**

| Atributo | Detalle |
|---|---|
| **Nombre** | Traceability & Quality |
| **Clasificación estratégica** | Core Domain |
| **Propósito** | Registrar excursiones ambientales y generar reportes de trazabilidad para auditorías de calidad (HACCP, ISO 9001) |
| **Roles de dominio** | Encargado de Control de Calidad (solicita reportes, registra no conformidades), Sistema (detecta inicio y fin de excursiones) |
| **Decisiones de negocio** | ¿Cuándo una desviación acumulada constituye una excursión? ¿Qué datos debe contener un reporte de trazabilidad? ¿Qué período de retención aplica al historial? |
| **Comandos** | `StartExcursion`, `EndExcursion`, `GenerateTraceabilityReport`, `RegisterNonConformity` |
| **Consultas** | `GetExcursionHistory`, `GetTraceabilityReport`, `GetMeasurementHistory` |
| **Eventos publicados** | `ExcursionStarted`, `ExcursionEnded`, `TraceabilityReportGenerated` |
| **Eventos consumidos** | `DeviationDetected` (de Environmental Monitoring), `IncidentResolved` (de Alert & Incident Management) |
| **Agregados clave** | `Excursion`, `TraceabilityReport`, `NonConformity` |
| **Upstream (proveedores)** | Environmental Monitoring (publica `DeviationDetected`), Alert & Incident Management (publica `IncidentResolved`), IAM (proporciona identidad) |
| **Downstream (consumidores)** | ERP del cliente (API pública de reportes) |
| **Sistemas externos** | — |
| **Lenguaje ubicuo relevante** | Excursion, Shrinkage, Non-conforming Product, Batch, Traceability, Measurement History, Traceability Report, Audit, Non-conformity, Retention Period, Cold Chain |

---

**Canvas 5: Edge Processing**

| Atributo | Detalle |
|---|---|
| **Nombre** | Edge Processing |
| **Clasificación estratégica** | Supporting Domain |
| **Propósito** | Capturar lecturas de los nodos sensor ESP32, aplicar calibración local y mantener un buffer offline ante caídas de conectividad |
| **Roles de dominio** | Sensor Node ESP32 (fuente de lecturas), Gateway local (ejecuta la Edge API), Sistema (sincroniza buffer cuando la conexión se restablece) |
| **Decisiones de negocio** | ¿Cómo aplicar el Calibration Offset? ¿Qué lecturas descartar como erróneas? ¿Cuándo sincronizar el buffer local con la nube? |
| **Comandos** | `CaptureSensorReading`, `ApplyCalibration`, `SyncLocalBuffer`, `RegisterSensorNode` |
| **Consultas** | `GetLocalBuffer`, `GetCalibrationProfile` |
| **Eventos publicados** | `ReadingCaptured`, `SensorNodeWentOffline`, `BufferSynced` |
| **Eventos consumidos** | `ThresholdConfigured` (de Environmental Monitoring, para evaluación local preliminar) |
| **Agregados clave** | `SensorReading`, `CalibrationProfile`, `LocalBuffer`, `OfflineNode` |
| **Upstream (proveedores)** | Environmental Monitoring (publica `ThresholdConfigured`) |
| **Downstream (consumidores)** | Environmental Monitoring (consume `ReadingCaptured`) |
| **Sistemas externos** | — |
| **Lenguaje ubicuo relevante** | Reading, Calibration, Calibration Offset, Sampling Interval, Offline Node, Cold Chain |

---

**Canvas 6: Customer Acquisition**

| Atributo | Detalle |
|---|---|
| **Nombre** | Customer Acquisition |
| **Clasificación estratégica** | Generic Domain |
| **Propósito** | Atraer y capturar clientes potenciales mediante la landing page y el formulario de solicitud de piloto |
| **Roles de dominio** | Visitante Web (descubre el producto y solicita un piloto gratuito) |
| **Decisiones de negocio** | ¿Qué información recopilar en la solicitud de piloto? |
| **Comandos** | `SubmitPilotRequest` |
| **Consultas** | — |
| **Eventos publicados** | `PilotRequestSubmitted` |
| **Eventos consumidos** | — |
| **Agregados clave** | `PilotRequest` |
| **Upstream (proveedores)** | — |
| **Downstream (consumidores)** | IAM (consume `PilotRequestSubmitted` para crear la organización del nuevo cliente) |
| **Sistemas externos** | — |
| **Lenguaje ubicuo relevante** | Subscription Plan |
| **Nota** | Al ser un dominio genérico sin reglas de negocio complejas, no se le aplica diseño táctico DDD completo (4 capas). |


### 4.1.2. Context Mapping

El Context Mapping de MachineGuard describe las relaciones y patrones de integración entre los seis Bounded Contexts identificados. La decisión de diseño central es que no se aplica Anti-Corruption Layer (ACL) entre contextos internos, dado que todos pertenecen al mismo equipo y comparten el mismo Ubiquitous Language; el ACL se reserva como evaluación futura si se integra un ERP de terceros con modelo de datos heterogéneo.

**Patrones aplicados:**

| Relación | Patrón | Justificación |
|---|---|---|
| Customer Acquisition → IAM | Customer/Supplier | IAM (downstream) reacciona al evento `PilotRequestSubmitted` publicado por Customer Acquisition (upstream); CA define cuándo emite el evento sin depender de IAM |
| IAM → Environmental Monitoring / Alert & Incident Management / Traceability & Quality | Open Host Service + Published Language | IAM expone una API REST estándar de validación de tokens JWT; los Core BCs consumen esta API sin necesidad de traducción ni ACL |
| Edge Processing → Environmental Monitoring | Customer/Supplier | Environmental Monitoring (upstream/proveedor) define el contrato de las mediciones que acepta; Edge Processing (downstream/cliente) adapta su output a ese contrato |
| Environmental Monitoring → Alert & Incident Management | Published Language / Conformist | Mismo equipo y mismo Ubiquitous Language; Alert & Incident Management consume `DeviationDetected` directamente sin traducción |
| Environmental Monitoring → Traceability & Quality | Published Language / Conformist | Mismo equipo y mismo Ubiquitous Language; Traceability & Quality consume `DeviationDetected` directamente sin traducción |
| Alert & Incident Management → Traceability & Quality | Published Language / Conformist | Traceability & Quality consume `IncidentResolved` directamente sin necesidad de ACL |
| Environmental Monitoring / Traceability & Quality → ERP del cliente | Open Host Service + Published Language | MachineGuard expone una API REST pública documentada con OpenAPI/Swagger para que el ERP del cliente consuma mediciones y reportes |
| Alert & Incident Management → Twilio | Conformist | MachineGuard se adapta a la API de Twilio sin imponer condiciones sobre el proveedor externo |
| Environmental Monitoring → OpenWeatherMap | Conformist | MachineGuard consume la API de OpenWeatherMap adaptándose a su contrato sin traducción propia |
| Customer Acquisition con BCs operativos | Separate Ways | Customer Acquisition no tiene integración directa con Environmental Monitoring, Alert & Incident Management ni Traceability & Quality |

**Diagrama de Context Mapping:**

 ![Context Mapping](/assets/img/chapter-4/Context_Mapping/Context_Mapping_MachineGuard.png)

### 4.1.3. Software Architecture

Los siguientes diagramas presentan la arquitectura de MachineGuard en distintos niveles de detalle, desde la visión general del sistema hasta la organización interna de sus componentes.

#### 4.1.3.1. Software Architecture System Landscape Diagram

El System Landscape muestra MachineGuard en relación con los usuarios finales, los sistemas externos con los que se integra y los nodos físicos de hardware desplegados en las instalaciones del cliente.

![System Landscape Diagram](/assets/img/chapter-4/Software_Architecture/System_Landscape_MachineGuard.png)

#### 4.1.3.2. Software Architecture Context Level Diagrams

El Context Level muestra las interacciones de los actores y sistemas externos directamente con MachineGuard como caja negra, sin entrar en sus componentes internos.

![Context Level Diagram](/assets/img/chapter-4/Software_Architecture_Context_Level_Diagrams/Context_Level_MachineGuard.png)

#### 4.1.3.3. Software Architecture Container Level Diagrams

El Container Level detalla los contenedores de software que componen MachineGuard: las aplicaciones cliente, la API central, la base de datos, la Edge API y el firmware embebido.

![Container Level Diagram](/assets/img/chapter-4/Software_Architecture_Container_Level_Diagrams/Container_Level_MachineGuard.png)

#### 4.1.3.4. Software Architecture Deployment Diagrams

El Deployment Diagram muestra los tres entornos de despliegue de MachineGuard: la nube (cloud hosting), las instalaciones físicas del cliente (edge layer con gateway y nodos sensor) y el dispositivo móvil del usuario.

![Deployment Diagram](/assets/img/chapter-4/Software_Architecture_Deployment_Diagrams/Deployment_MachineGuard.png)

## 4.2. Tactical-Level Domain-Driven Design

El diseño táctico traduce el modelo estratégico en estructuras concretas de código dentro de cada contexto delimitado. En esta sección se detallan las capas de cada contexto de MachineGuard, sus entidades, agregados, servicios de dominio y repositorios, así como los diagramas de componentes y de base de datos que guían la implementación del sistema de monitoreo IoT. Cada subsección corresponde a un contexto delimitado identificado durante el diseño estratégico.

### 4.2.1. Bounded Context: IAM — Identity & Access Management

El Bounded Context **IAM (Identity & Access Management)** implementa la identidad, autenticación y autorización transversal de MachineGuard. Su límite funcional comprende la creación de organizaciones cliente, el registro de sus usuarios, la asignación de roles y la emisión y revocación de sesiones. Los demás contextos reciben una identidad verificable compuesta por `userId`, `organizationId` y `role`, pero no acceden a las credenciales ni modifican el modelo interno de IAM.

El diseño conserva el aislamiento multi-tenant definido en el nivel estratégico: una identidad pertenece a una sola organización y toda operación protegida obtiene `organizationId` desde un JWT validado, nunca desde un identificador de organización enviado libremente por el cliente. IAM se clasifica como **Supporting Domain**, pues habilita los Core Domains sin contener las reglas diferenciadoras del monitoreo ambiental.

#### 4.2.1.1. Domain Layer

La Domain Layer contiene los agregados, entidades, objetos de valor, políticas e interfaces de repositorio que expresan las reglas de identidad y aislamiento organizacional. Esta capa no depende de Spring Security, Spring Data JPA, PostgreSQL ni de la representación HTTP. Las interfaces `OrganizationRepository`, `UserRepository` y `AuthenticationSessionRepository` son puertos del dominio; sus adaptadores tecnológicos se ubican en Infrastructure Layer.

**Organization — Aggregate Root**

* **Propósito:** representa a la empresa cliente dentro del modelo SaaS multi-tenant de MachineGuard; agrupa a sus usuarios y define su plan de suscripción.
* **Atributos:** `id`, `name`, `subscriptionPlan` (`FREE`, `BASIC` o `PREMIUM`), `status` (`ACTIVE` o `SUSPENDED`), `createdAt` y `updatedAt`.
* **Métodos principales:** `create`, `changeSubscriptionPlan`, `suspend`, `reactivate` y `canAcceptUsers`.
* **Eventos:** `OrganizationCreated` y `OrganizationStatusChanged`.
* **Relaciones:** una organización contiene cero o más identidades `User`. Otros Bounded Contexts conservan su `organizationId` como referencia lógica, pero no forman una relación de persistencia con este agregado.

**User — Aggregate Root**

* **Propósito:** representa la cuenta individual de un usuario dentro de una organización; gestiona su autenticación y el rol que determina sus permisos.
* **Atributos:** `id`, `organizationId`, `email` (`EmailAddress`), `passwordHash` (`PasswordHash`), `fullName`, `role` (`Role`), `status` (`ACTIVE` o `INACTIVE`), `lastLoginAt`, `createdAt` y `updatedAt`.
* **Métodos principales:** `register`, `recordSuccessfulLogin`, `resetPassword`, `assignRole`, `activate`, `deactivate` e `isActive`.
* **Eventos:** `UserRegistered`, `UserLoggedIn`, `PasswordReset`, `RoleAssigned` y `UserStatusChanged`.
* **Relaciones:** pertenece a una única `Organization` mediante `organizationId` y abre cero o más `AuthenticationSession`. La asociación por identificador evita cargar el agregado `Organization` dentro de cada operación sobre `User`.

**AuthenticationSession — Entity**

* **Propósito:** representa una sesión renovable de un usuario y permite revocar el acceso durante un cierre de sesión o un cambio de contraseña. El JWT de acceso permanece de corta duración y el sistema persiste únicamente el hash del refresh token.
* **Atributos:** `id`, `userId`, `refreshTokenHash`, `issuedAt`, `expiresAt` y `revokedAt`.
* **Métodos principales:** `open`, `revoke` e `isActive`.
* **Eventos:** `UserLoggedOut` cuando una sesión activa es revocada explícitamente.
* **Relaciones:** pertenece a un solo `User`; un usuario puede mantener varias sesiones para Web App y Mobile App.

**Role — Value Object**

* **Propósito:** encapsula el rol de un usuario dentro de su organización y las capacidades asociadas (`ADMIN` configura zonas y umbrales; `VIEWER` solo consulta información).
* **Valores:** `ADMIN` y `VIEWER`.
* **Métodos principales:** `canManageUsers`, `canConfigureMonitoring` y `canViewOperationalData`.
* **Relaciones:** está embebido en `User`. Al ser un catálogo fijo, no tiene identidad, ciclo de vida ni repositorio propio.

**EmailAddress y PasswordHash — Value Objects**

* `EmailAddress` normaliza el correo a minúsculas y valida su formato antes de que una identidad pueda registrarse.
* `PasswordHash` encapsula el resultado irreversible generado por el puerto `PasswordHasher`; el dominio nunca conserva ni expone la contraseña en texto plano.

**UserRegistrationPolicy — Domain Service**

* **Propósito:** verifica que la organización se encuentre activa y que el correo normalizado no esté registrado antes de crear una identidad.
* **Método principal:** `ensureRegistrationAllowed(organization, email, emailInUse)`.

**RoleAssignmentPolicy — Domain Service**

* **Propósito:** valida que quien asigna el rol sea un `ADMIN` activo, que el usuario objetivo pertenezca a la misma organización y que la organización no quede sin administradores activos.
* **Método principal:** `ensureCanAssign(actor, target, requestedRole, activeAdminCount)`.

**Repository Interfaces**

* `OrganizationRepository`: define `save` y `findById` para el agregado `Organization`.
* `UserRepository`: define `save`, `findById`, `findByEmail`, `existsByEmail` y `countActiveAdminsByOrganizationId`.
* `AuthenticationSessionRepository`: define `save`, `findByRefreshTokenHash` y `revokeAllByUserId`.

**Business Rules**

* Cada `User` pertenece exactamente a una `Organization` y su identidad no puede trasladarse entre organizaciones.
* El correo se compara de forma normalizada y es único dentro de la plataforma, lo que permite identificar la organización durante el inicio de sesión sin solicitar un tenant adicional.
* Solo los usuarios y organizaciones en estado `ACTIVE` pueden iniciar una sesión.
* Salvo la creación de la identidad administradora inicial durante el onboarding, solo un `ADMIN` activo puede registrar usuarios o asignar roles dentro de su propia organización.
* El último administrador activo de una organización no puede ser degradado ni desactivado.
* Un refresh token revocado o vencido no puede utilizarse para emitir un nuevo JWT de acceso.
* Al restablecer una contraseña se revocan todas las sesiones renovables del usuario.
* Todo contexto downstream debe filtrar sus datos mediante el `organizationId` incluido en el token validado.

#### 4.2.1.2. Interface Layer

La Interface Layer expone los recursos REST de autenticación, perfil, usuarios y organizaciones, además del consumidor del evento de onboarding. Recibe datos, aplica validaciones sintácticas, construye Commands o Queries y devuelve Resources JSON; las reglas de autorización y de negocio se delegan a las capas Application y Domain.

**AuthController**

* **Propósito:** gestiona el inicio y cierre de sesión, el restablecimiento de contraseña y la validación interna de tokens.
* **Endpoints principales:**
  * `POST /api/v1/auth/login`;
  * `POST /api/v1/auth/logout`;
  * `POST /api/v1/auth/password-reset`;
  * `POST /api/v1/auth/validate`.

**UserController**

* **Propósito:** permite consultar el perfil autenticado y administrar identidades de la organización.
* **Endpoints principales:**
  * `GET /api/v1/users/me`;
  * `POST /api/v1/organizations/{organizationId}/users`;
  * `PATCH /api/v1/users/{userId}/role`;
  * `PATCH /api/v1/users/{userId}/status`.

**OrganizationController**

* **Propósito:** expone la creación y consulta de organizaciones para el flujo de onboarding y para la administración del tenant.
* **Endpoints principales:**
  * `POST /api/v1/organizations`;
  * `GET /api/v1/organizations/{organizationId}`.

**PilotRequestEventHandler**

* **Propósito:** consume `PilotRequestSubmitted` desde Customer Acquisition e inicia `CreateOrganizationCommand`, evitando que ese contexto conozca el modelo interno de IAM.

**Security Filters**

* `JwtAuthenticationFilter` valida la firma y expiración del access token antes de que la solicitud alcance un controller protegido.
* `TenantContextResolver` deriva `userId`, `organizationId` y `role` de los claims validados. Si un endpoint incluye `organizationId`, comprueba que coincida con el tenant autenticado.

**Resources, DTOs y Assemblers**

* Requests: `LoginResource`, `RegisterUserResource`, `AssignRoleResource` y `ResetPasswordResource`.
* Responses: `AuthenticationResource`, `UserResource`, `OrganizationResource` y `TokenValidationResource`.
* Assemblers: `AuthenticationResourceAssembler`, `UserResourceAssembler` y `OrganizationResourceAssembler`.

La capa no devuelve `passwordHash` ni `refreshTokenHash`. Los errores se representan con códigos HTTP consistentes: `400` para datos inválidos, `401` para credenciales o tokens no válidos, `403` para permisos insuficientes, `404` para recursos inexistentes y `409` para correos duplicados o transiciones de estado inválidas.

#### 4.2.1.3. Application Layer

La Application Layer orquesta los casos de uso de IAM sin incorporar reglas de negocio. Los Command Services cargan los agregados, invocan sus métodos y políticas, coordinan los puertos de seguridad y persistencia y publican los eventos resultantes. Los Query Services recuperan vistas de lectura sin exponer datos sensibles.

**Command Services / Handlers**

**CreateOrganizationCommandService**

* **Propósito:** crear el tenant cuando se inicia el onboarding desde una solicitud de piloto.
* **Flujo principal:** recibe `CreateOrganizationCommand`, crea `Organization`, la persiste y publica `OrganizationCreated`.

**RegisterUserCommandService**

* **Propósito:** registrar un usuario en una organización activa.
* **Flujo principal:** obtiene la organización y, excepto durante el alta inicial del onboarding, al actor autenticado; aplica `UserRegistrationPolicy`, transforma la contraseña mediante `PasswordHasher`, crea `User`, lo persiste y publica `UserRegistered`.

**LoginUserCommandService**

* **Propósito:** autenticar credenciales y emitir un access token JWT junto con un refresh token rotatorio.
* **Flujo principal:** localiza al usuario por `EmailAddress`, comprueba la contraseña, el estado del usuario y el de su organización, registra el acceso, abre `AuthenticationSession`, persiste el hash del refresh token y publica `UserLoggedIn`.

**LogoutUserCommandService**

* **Propósito:** cerrar una sesión renovable.
* **Flujo principal:** localiza la sesión a partir del hash del refresh token, verifica que pertenezca al usuario autenticado, la revoca y publica `UserLoggedOut`.

**AssignRoleCommandService**

* **Propósito:** modificar el rol de una identidad sin romper el aislamiento organizacional.
* **Flujo principal:** carga al actor y al usuario objetivo, ejecuta `RoleAssignmentPolicy`, aplica `assignRole`, persiste el agregado y publica `RoleAssigned`.

**ResetPasswordCommandService**

* **Propósito:** sustituir la credencial de un usuario autenticado.
* **Flujo principal:** verifica la contraseña actual, genera el nuevo `PasswordHash`, actualiza `User`, revoca todas sus sesiones renovables y publica `PasswordReset`.

**Query Services / Handlers**

* `GetUserProfileQueryService`: devuelve el perfil del usuario autenticado, su rol y la organización a la que pertenece.
* `GetOrganizationByIdQueryService`: recupera los datos no sensibles de la organización después de validar el tenant.
* `ValidateTokenQueryService`: verifica firma, expiración, sesión y estado de usuario y organización; devuelve `userId`, `organizationId` y `role` a los consumidores autorizados.

**Security Ports**

* `PasswordHasher`: define las operaciones para generar y verificar hashes de contraseña.
* `TokenProvider`: define la emisión, rotación y validación de access y refresh tokens sin acoplar los casos de uso a una librería criptográfica concreta.

**Flujo principal 1: inicio de sesión**

1. `AuthController` recibe correo y contraseña mediante HTTPS.
2. `LoginUserCommandService` normaliza el correo y recupera `User`.
3. `PasswordHasher` verifica la credencial sin exponer el hash fuera de IAM.
4. El servicio confirma que `User` y `Organization` estén activos.
5. `JwtTokenProvider` emite un access token de corta duración con `sub`, `organizationId` y `role`.
6. Se crea una `AuthenticationSession` que conserva solamente el hash del refresh token.
7. Se publica `UserLoggedIn` y se devuelve `AuthenticationResource`.

**Flujo principal 2: autorización multi-tenant**

1. Una Web App o Mobile App envía el JWT en el encabezado `Authorization`.
2. `JwtAuthenticationFilter` valida su firma y expiración.
3. `TenantContextResolver` construye el contexto autenticado a partir de los claims.
4. El controller delega el caso de uso con el `organizationId` verificado.
5. El Bounded Context operativo consulta únicamente registros pertenecientes a ese tenant.

**Flujo principal 3: incorporación de organización**

1. Customer Acquisition publica `PilotRequestSubmitted`.
2. `PilotRequestEventHandler` traduce el evento a `CreateOrganizationCommand`.
3. `CreateOrganizationCommandService` crea la organización y publica `OrganizationCreated`.
4. IAM registra la identidad administradora inicial a partir del contacto incluido en la solicitud de piloto.
5. IAM publica `UserRegistered` y `RoleAssigned`; el nuevo administrador puede configurar su primera Monitoring Zone.

#### 4.2.1.4. Infrastructure Layer

La Infrastructure Layer proporciona las implementaciones técnicas de los puertos definidos por las capas internas. IAM se ejecuta dentro de la **RESTful API central de MachineGuard**, implementada con Spring Boot, Spring Security y Spring Data JPA, y utiliza PostgreSQL como almacenamiento persistente.

**Persistence Adapters**

* `JpaOrganizationRepositoryAdapter` implementa `OrganizationRepository` y mapea `Organization` a `organizations`.
* `JpaUserRepositoryAdapter` implementa `UserRepository` y mapea `User`, `Role`, `EmailAddress` y `PasswordHash` a `users`.
* `JpaAuthenticationSessionRepositoryAdapter` implementa `AuthenticationSessionRepository` y mapea las sesiones a `authentication_sessions`.

Las interfaces auxiliares `SpringDataOrganizationRepository`, `SpringDataUserRepository` y `SpringDataAuthenticationSessionRepository` extienden `JpaRepository`; permanecen en infraestructura y no son referenciadas por el dominio.

**Security Adapters**

**BCryptPasswordHasher**

* **Propósito:** implementa el puerto `PasswordHasher` usando `BCryptPasswordEncoder`, con salt individual y factor de costo configurable.

**JwtTokenProvider**

* **Propósito:** firma y valida JWT, genera refresh tokens aleatorios y expone los claims mínimos requeridos por los contextos downstream.
* **Claims de acceso:** `sub` (`userId`), `organizationId`, `role`, `sid` (sesión), `iat`, `exp` y `jti`.
* **Restricciones:** la clave de firma se obtiene de secretos del entorno; no se almacena en el repositorio ni en la base de datos.

**IamEventPublisher**

* **Propósito:** publica `OrganizationCreated`, `OrganizationStatusChanged`, `UserRegistered`, `UserLoggedIn`, `UserLoggedOut`, `PasswordReset`, `RoleAssigned` y `UserStatusChanged` mediante el mecanismo de mensajería definido para la API central.

**Configuración técnica**

* API central: Spring Boot y Spring Security.
* Persistencia: Spring Data JPA y PostgreSQL.
* Comunicación síncrona: REST/JSON sobre HTTPS.
* Documentación: OpenAPI / Swagger.
* Contraseña: BCrypt; nunca se registra en logs ni se persiste en texto plano.
* Sesión: JWT de acceso de corta duración y refresh token rotatorio almacenado únicamente como hash.

**Integración con otros Bounded Contexts**

* Consume `PilotRequestSubmitted` desde **Customer Acquisition** para iniciar el onboarding.
* Proporciona JWT firmado y contexto de organización a **Environmental Monitoring**, **Alert & Incident Management** y **Traceability & Quality** mediante Open Host Service + Published Language.
* Los identificadores de IAM conservados por otros contextos son referencias lógicas; no se crean foreign keys entre sus tablas y las tablas de IAM.

**Limitaciones y decisiones de seguridad**

* La revocación inmediata afecta al refresh token; un access token ya emitido puede conservar validez hasta su corta fecha de expiración.
* Suspender una organización impide nuevos inicios y renovaciones de sesión para todos sus usuarios.
* La autorización funcional final permanece en cada contexto downstream, utilizando `role` y `organizationId` ya verificados por IAM.
* Los intentos de autenticación fallidos deben registrarse como telemetría técnica sin incluir contraseñas ni tokens.

#### 4.2.1.5. Bounded Context Software Architecture Component Level Diagrams

El siguiente diagrama muestra cómo se organiza el Bounded Context IAM dentro de la **RESTful API de MachineGuard**. Se distinguen los puntos de entrada REST y de eventos, los servicios de aplicación, el modelo y las políticas de dominio, los repositorios y los componentes encargados de la persistencia y la seguridad.

![Bounded Context Software Architecture Component Level Diagram - IAM](../assets/img/chapter-4/BC%20IAM/Component%20Diagram%20-%20IAM.png)

*Figura. Diagrama de componentes del Bounded Context IAM.*

**Componentes principales del diagrama**

* Interface: `AuthController`, `UserController`, `OrganizationController`, `JwtAuthenticationFilter`, `TenantContextResolver` y `PilotRequestEventHandler`.
* Application: Command Services de organización, registro, login, logout, rol y contraseña; Query Services de perfil, organización y validación de tokens; puertos `PasswordHasher` y `TokenProvider`.
* Domain: `Organization`, `User`, `AuthenticationSession`, `Role`, las políticas de registro y asignación de roles y los tres Repository Ports.
* Infrastructure: adaptadores JPA, `JwtTokenProvider`, `BCryptPasswordHasher` e `IamEventPublisher`.

El flujo de dependencias apunta hacia el dominio: los controllers dependen de los casos de uso, los casos de uso dependen de abstracciones del dominio y los adaptadores de infraestructura implementan esas abstracciones. Customer Acquisition es upstream mediante `PilotRequestSubmitted`; los contextos operativos son downstream de la identidad publicada por IAM.

#### 4.2.1.6. Bounded Context Software Architecture Code Level Diagrams

Esta sección presenta la estructura interna del contexto mediante el diagrama de clases del dominio y el diseño lógico de su persistencia. Ambos diagramas mantienen la misma terminología, cardinalidades y decisiones descritas en las capas anteriores.

##### 4.2.1.6.1. Bounded Context Domain Layer Class Diagrams

El diagrama UML incluye los atributos, métodos y niveles de acceso de los agregados `Organization` y `User`, la entidad `AuthenticationSession`, los Value Objects y enumeraciones, los Domain Services y las interfaces Repository. Las relaciones y cardinalidades muestran que una organización contiene múltiples identidades y que cada usuario puede abrir varias sesiones.

![Bounded Context Domain Layer Class Diagram - IAM](../assets/img/chapter-4/BC%20IAM/Domain%20Layer%20-%20IAM.png)

*Figura. Diagrama de clases del dominio del Bounded Context IAM.*

**Relaciones principales**

* `Organization` contiene de cero a muchos `User`; cada `User` pertenece a una sola organización.
* `User` compone `EmailAddress`, `PasswordHash` y `Role`, y mantiene de cero a muchas `AuthenticationSession`.
* `UserRegistrationPolicy` valida el estado de `Organization` y la unicidad de `EmailAddress`.
* `RoleAssignmentPolicy` valida al actor, el usuario objetivo, el tenant y la transición de `Role`.
* Las interfaces Repository dependen de los agregados, pero no de clases JPA.

##### 4.2.1.6.2. Bounded Context Database Design Diagram

El Database Design Diagram representa las tablas lógicas propiedad de IAM, sus columnas, restricciones y cardinalidades. `Role` y los estados se almacenan como valores controlados dentro de las tablas correspondientes, por lo que no se introduce una tabla genérica de roles.

![Bounded Context Database Design Diagram - IAM](../assets/img/chapter-4/BC%20IAM/Database%20Design%20Diagram%20-%20IAM.png)

*Figura. Diagrama de base de datos del Bounded Context IAM.*

**Tablas y restricciones principales**

* `organizations`: conserva el tenant, su plan y estado; restringe `subscription_plan` a `FREE`, `BASIC` o `PREMIUM` y `status` a `ACTIVE` o `SUSPENDED`.
* `users`: contiene una foreign key obligatoria a `organizations`, un índice para búsquedas por tenant y estado, correo único case-insensitive y restricciones para `role` y `status`.
* `authentication_sessions`: contiene una foreign key a `users`, hash único del refresh token, fechas de emisión y expiración y una fecha de revocación opcional.
* Una organización posee cero o muchos usuarios y un usuario posee cero o muchas sesiones; al eliminar una identidad, sus sesiones se eliminan en cascada.

### 4.2.2. Bounded Context: Customer Acquisition

En esta sección, el equipo presenta las clases identificadas y las detalla a manera de diccionario, explicando para cada una su nombre, propósito y la documentación de atributos y métodos considerados, junto con las relaciones entre ellas.

#### 4.2.2.1. Domain Layer

Al ser un **Generic Domain**, Customer Acquisition no requiere un modelo táctico complejo: un único agregado es suficiente para representar la solicitud de piloto capturada en la landing page, sin reglas de negocio diferenciadoras ni objetos de valor adicionales. Los repositorios se implementan igualmente como interfaces de Spring Data JPA (`extends JpaRepository`).

**PilotRequest — Aggregate Root**

* **Propósito:** representa la solicitud de demostración o piloto gratuito enviada por un visitante desde la landing page, incluyendo la estimación de pérdidas evitadas que motivó el contacto.
* **Atributos:** `companyName`, `contactName`, `contactEmail`, `contactPhone`, `industry`, `estimatedMonthlyLoss` (opcional, calculado por la calculadora de la landing page), `status` (`PENDING` / `CONTACTED` / `CONVERTED`), `submittedAt`.
* **Métodos principales:** `submit`, `markAsContacted`, `convert`, `isPending`.
* **Eventos:** `PilotRequestSubmitted` (emitido al enviarse el formulario; consumido por IAM para iniciar el onboarding de la organización).
* **Relaciones:** es el único agregado del contexto; no referencia otros agregados internos. Es consumido por IAM (patrón Customer/Supplier, ver Context Mapping en 4.1.2) para crear la `Organization` y el `User` administrador del nuevo cliente. Administrado a través de `PilotRequestRepository`.

<!-- #### 4.2.2.2. Interface Layer

#### 4.2.2.3. Application Layer
> 

#### 4.2.2.4. Infrastructure Layer
> 

#### 4.2.2.5. Bounded Context Software Architecture Component Level Diagrams
> 

#### 4.2.2.6. Bounded Context Software Architecture Code Level Diagrams

##### 4.2.2.6.1. Bounded Context Domain Layer Class Diagrams
> 

##### 4.2.2.6.2. Bounded Context Database Design Diagram -->
> 

### 4.2.5. Bounded Context: Alert & Incident Management

En esta sección, el equipo presenta las clases identificadas para el Bounded Context **Alert & Incident Management**, detallándolas a manera de diccionario de clases y explicando para cada una su propósito, atributos, métodos y relaciones principales. Este contexto se encarga de gestionar el ciclo de vida completo de una alerta ambiental, desde su generación automática ante una desviación detectada hasta el cierre del incidente asociado, incluyendo su reconocimiento, escalamiento y el registro de acciones correctivas.

##### 4.2.5.1. Domain Layer

Esta capa contiene el núcleo del negocio del contexto **Alert & Incident Management**. Su responsabilidad es modelar las reglas de negocio relacionadas con la gestión de alertas e incidentes operativos originados por desviaciones ambientales detectadas en las zonas monitoreadas. El contexto consume el evento `DeviationDetected` publicado por **Environmental Monitoring** y, a partir de él, inicia el ciclo de vida de la alerta y del incidente correspondiente.

A diferencia de un modelo centrado únicamente en notificaciones, este contexto no solo registra la existencia de una alerta, sino que también conserva la trazabilidad de su atención mediante el reconocimiento del responsable, la posible escalación y la acción correctiva aplicada.

Los repositorios se implementan como interfaces de **Spring Data JPA** (`extends JpaRepository`), siguiendo el mismo criterio usado en los otros Bounded Contexts tácticos de MachineGuard.

**Incident — Aggregate Root**

* **Propósito:** representa el incidente operativo generado a partir de una desviación ambiental. Actúa como agregado raíz porque concentra el estado general del caso y coordina el ciclo de vida de la alerta, su reconocimiento, el escalamiento y la acción correctiva.
* **Atributos:** `deviationId`, `organizationId`, `monitoringZoneId`, `status` (`OPEN`, `ACKNOWLEDGED`, `ESCALATED`, `RESOLVED`), `openedAt`, `resolvedAt`.
* **Métodos principales:** `open`, `acknowledge`, `escalate`, `registerCorrectiveAction`, `resolve`, `isResolved`.
* **Eventos:** `AlertRaised`, `AlertAcknowledged`, `AlertEscalated`, `CorrectiveActionRegistered`, `IncidentResolved`.
* **Relaciones:** contiene o referencia a `Alert` y `CorrectiveAction`; es administrado mediante `IncidentRepository`.

**Alert — Entity**

* **Propósito:** representa la alerta emitida automáticamente cuando el sistema detecta que una medición se encuentra fuera del rango seguro definido.
* **Atributos:** `incidentId`, `severity` (`LOW`, `MEDIUM`, `HIGH`, `CRITICAL`), `message`, `status` (`PENDING`, `ACKNOWLEDGED`, `ESCALATED`, `CLOSED`), `raisedAt`, `acknowledgedAt`, `escalatedAt`.
* **Métodos principales:** `raise`, `acknowledge`, `escalate`, `close`.
* **Relaciones:** pertenece a un `Incident`; utiliza `AlertSeverity` como Value Object o enumeración; es persistida como parte del agregado.

**CorrectiveAction — Entity**

* **Propósito:** representa la acción correctiva ejecutada por el responsable para atender la condición anómala detectada.
* **Atributos:** `incidentId`, `description`, `performedBy`, `performedAt`, `notes`.
* **Métodos principales:** `register`, `updateNotes`.
* **Relaciones:** pertenece a un `Incident`; administrada dentro del agregado raíz.

**AlertSeverity — Value Object**

* **Propósito:** encapsula el nivel de severidad de la alerta generado según la criticidad de la desviación.
* **Atributos:** `value` (`LOW`, `MEDIUM`, `HIGH`, `CRITICAL`).
* **Métodos principales:** `isCritical`, `isHigh`.
* **Relaciones:** embebido en `Alert`; no posee identidad propia.

**Acknowledgement — Value Object**

* **Propósito:** encapsula la información del reconocimiento de la alerta por parte de un responsable.
* **Atributos:** `acknowledgedBy`, `acknowledgedAt`.
* **Métodos principales:** `record`.
* **Relaciones:** puede estar embebido en `Alert` o `Incident` según la implementación.

**Escalation — Value Object**

* **Propósito:** encapsula la información del escalamiento automático de una alerta no atendida dentro del tiempo definido.
* **Atributos:** `escalatedTo`, `reason`, `escalatedAt`.
* **Métodos principales:** `register`.
* **Relaciones:** puede estar embebido en `Alert` o `Incident` según la implementación.

**Commands**

* `RaiseAlert`
* `AcknowledgeAlert`
* `EscalateAlert`
* `RegisterCorrectiveAction`
* `ResolveIncident`

**Queries**

* `GetActiveAlerts`
* `GetAlertById`
* `GetIncidentHistory`

**Domain Services**

**AlertPolicyService**

* **Propósito:** encapsula las reglas de negocio para determinar la severidad de una alerta y las condiciones bajo las cuales debe generarse un escalamiento.
* **Responsabilidades principales:** asignar severidad, validar tiempos máximos de atención, decidir si una alerta pendiente debe escalarse.

**IncidentResolutionService**

* **Propósito:** encapsula las reglas que validan cuándo un incidente puede considerarse resuelto.
* **Responsabilidades principales:** verificar si existe acción correctiva registrada y permitir el cierre formal del incidente.

**Repositories**

* `IncidentRepository`
* `AlertRepository`
* `CorrectiveActionRepository`

**Business Rules**

* Toda `DeviationDetected` válida genera un `Incident` y una `Alert` asociada.
* Una alerta solo puede pasar a estado `ACKNOWLEDGED` si aún no ha sido cerrada.
* Una alerta puede escalarse únicamente si permanece sin reconocimiento dentro del tiempo máximo configurado.
* Un incidente no debe pasar a `RESOLVED` si no existe al menos una `CorrectiveAction` registrada.
* Toda acción correctiva debe quedar asociada al incidente que la originó para fines de trazabilidad.
* El contexto debe publicar `IncidentResolved` para que sea consumido por **Traceability & Quality**.

##### 4.2.5.2. Interface Layer

La capa de interfaz expone los recursos REST necesarios para interactuar con las alertas e incidentes generados por el sistema. Esta capa permite que los usuarios responsables consulten alertas activas, reconozcan alertas pendientes, registren acciones correctivas y consulten el historial de incidentes. Asimismo, permite que sistemas externos autorizados consuman información operativa mediante la API pública de MachineGuard.

**AlertController**

* **Propósito:** expone operaciones relacionadas con la consulta y gestión de alertas activas.
* **Endpoints principales:**
  * `GET /api/v1/alerts`
  * `GET /api/v1/alerts/{alertId}`
  * `POST /api/v1/alerts/{alertId}/acknowledgements`

**IncidentController**

* **Propósito:** expone operaciones relacionadas con la consulta y gestión de incidentes.
* **Endpoints principales:**
  * `GET /api/v1/incidents`
  * `GET /api/v1/incidents/{incidentId}`
  * `POST /api/v1/incidents/{incidentId}/corrective-actions`
  * `POST /api/v1/incidents/{incidentId}/resolve`

**Resources / DTOs**

* `AlertResource`
* `IncidentResource`
* `CorrectiveActionResource`
* `AcknowledgeAlertResource`
* `ResolveIncidentResource`

**Assemblers**

* `AlertResourceAssembler`
* `IncidentResourceAssembler`
* `CorrectiveActionResourceAssembler`

**Responsabilidad de la capa**

La Interface Layer se encarga de recibir las solicitudes HTTP, validarlas, transformarlas en comandos o consultas del dominio y devolver respuestas estructuradas en formato JSON. Esta capa no contiene reglas de negocio; únicamente coordina la interacción entre el cliente y la Application Layer.

##### 4.2.5.3. Application Layer

La capa de aplicación orquesta la ejecución de los casos de uso del Bounded Context **Alert & Incident Management**. Recibe comandos y consultas provenientes de la Interface Layer, invoca los servicios de dominio cuando corresponde y coordina la persistencia a través de los repositorios.

**Command Services / Handlers**

**RaiseAlertCommandService**

* **Propósito:** crear una alerta y el incidente asociado a partir de una desviación detectada.
* **Flujo principal:** recibe el evento `DeviationDetected`, crea el `Incident`, crea la `Alert`, persiste ambas entidades y dispara la integración con el adaptador de notificaciones.

**AcknowledgeAlertCommandService**

* **Propósito:** registrar el reconocimiento de una alerta por parte de un responsable.
* **Flujo principal:** localiza la alerta, valida que no esté cerrada, registra el `Acknowledgement` y actualiza el estado del incidente.

**EscalateAlertCommandService**

* **Propósito:** ejecutar el escalamiento automático de alertas no atendidas.
* **Flujo principal:** identifica alertas pendientes fuera del tiempo de tolerancia, registra el `Escalation` y actualiza el estado correspondiente.

**RegisterCorrectiveActionCommandService**

* **Propósito:** registrar la acción correctiva aplicada ante una desviación.
* **Flujo principal:** ubica el incidente, agrega la acción correctiva y actualiza la información del caso.

**ResolveIncidentCommandService**

* **Propósito:** cerrar formalmente un incidente cuando la condición ya fue atendida.
* **Flujo principal:** valida la existencia de acción correctiva, actualiza el estado a `RESOLVED`, registra la fecha de resolución y publica `IncidentResolved`.

**Query Services / Handlers**

* `GetActiveAlertsQueryService`
* `GetAlertByIdQueryService`
* `GetIncidentHistoryQueryService`

**Flujo principal 1: generación automática de alerta**

1. El contexto **Environmental Monitoring** publica `DeviationDetected`.
2. `RaiseAlertCommandService` procesa el evento.
3. Se crea un `Incident` en estado `OPEN`.
4. Se crea una `Alert` en estado `PENDING`.
5. Se determina la severidad de la alerta.
6. Se persiste la información.
7. Se invoca el adaptador de Twilio para notificar al responsable.
8. Se publica `AlertRaised`.

**Flujo principal 2: reconocimiento de alerta**

1. Un responsable consulta las alertas activas.
2. Selecciona una alerta pendiente.
3. `AcknowledgeAlertCommandService` valida el estado.
4. Se registra el reconocimiento.
5. Se actualiza el estado de la alerta e incidente.
6. Se publica `AlertAcknowledged`.

**Flujo principal 3: resolución de incidente**

1. El responsable registra una `CorrectiveAction`.
2. `RegisterCorrectiveActionCommandService` asocia la acción al incidente.
3. Cuando corresponde, `ResolveIncidentCommandService` valida que el incidente pueda cerrarse.
4. El sistema cambia el estado a `RESOLVED`.
5. Se publica `IncidentResolved`.

##### 4.2.5.4. Infrastructure Layer

La capa de infraestructura contiene los componentes técnicos que permiten persistir la información del dominio y realizar la integración con servicios externos, especialmente con **Twilio** para el envío de notificaciones SMS y WhatsApp.

**Repositories**

* `JpaIncidentRepository`
* `JpaAlertRepository`
* `JpaCorrectiveActionRepository`

**Persistencia**

Las principales estructuras persistentes de este contexto son:

* `incidents`
* `alerts`
* `corrective_actions`

Opcionalmente, si la implementación lo requiere, también pueden considerarse estructuras separadas para acknowledgements y escalations; sin embargo, en un diseño simplificado esta información puede mantenerse como atributos del incidente o de la alerta.

**Diseño de persistencia**

* `incidents` almacena la información general del caso operativo.
* `alerts` almacena la alerta generada, su severidad y su estado de atención.
* `corrective_actions` conserva la evidencia de la acción tomada por el responsable.

**Integración con otros Bounded Contexts**

* Consume `DeviationDetected` desde **Environmental Monitoring**.
* Publica `IncidentResolved` para **Traceability & Quality**.
* Consume identidad/autorización desde **IAM** para determinar el usuario responsable que reconoce la alerta o registra la acción correctiva.

**Sistemas externos**

**TwilioNotificationAdapter**

* **Propósito:** adaptador encargado de conectarse con la API de Twilio para enviar mensajes SMS o WhatsApp.
* **Responsabilidades principales:** construir el mensaje de alerta, enviar la notificación y registrar el resultado técnico del envío.

**Configuración técnica**

La infraestructura de este contexto se implementa dentro de la API central de MachineGuard, desarrollada con **Spring Boot**, **Spring Data JPA** y persistencia en **PostgreSQL**. La integración con Twilio se realiza mediante un cliente HTTP o SDK oficial según la decisión técnica del equipo.

**Limitaciones**

* La disponibilidad del canal de notificación depende del servicio externo Twilio.
* El tiempo de entrega del mensaje puede variar según el proveedor y el canal utilizado.
* El historial del envío no reemplaza el estado de negocio del incidente; la trazabilidad de negocio se conserva en las entidades del dominio.

#### 4.2.5.5. Bounded Context Software Architecture Component Level Diagrams

En esta sección se presenta el diagrama de componentes del Bounded Context **Alert & Incident Management**, mostrando la interacción entre la capa de interfaz, la capa de aplicación, el modelo de dominio, la infraestructura de persistencia y los mecanismos de integración con otros Bounded Contexts y servicios externos de MachineGuard.

El contexto recibe el evento `DeviationDetected` desde **Environmental Monitoring**, utiliza la identidad proporcionada por **IAM**, publica `IncidentResolved` hacia **Traceability & Quality** y se integra con **Twilio** para el envío de notificaciones SMS y WhatsApp.

<!-- Insertar aquí el Component Level Diagram de Alert & Incident Management -->

![Bounded Context Software Architecture Component Level Diagram - Alert & Incident Management](/assets/img/chapter-4/BC%20Alert%20&%20Incident%20Management/Component%20Diagram%20-%20Alert%20&%20Incident%20Management.png)

*Figura. Component Level Diagram del Bounded Context Alert & Incident Management.*

**Componentes principales del diagrama**

El diagrama considera los siguientes componentes:

* `AlertController`
* `IncidentController`
* `RaiseAlertCommandService`
* `AcknowledgeAlertCommandService`
* `EscalateAlertCommandService`
* `RegisterCorrectiveActionCommandService`
* `ResolveIncidentCommandService`
* `GetActiveAlertsQueryService`
* `GetAlertByIdQueryService`
* `GetIncidentHistoryQueryService`
* `Incident`
* `Alert`
* `CorrectiveAction`
* `IncidentRepository`
* `AlertRepository`
* `CorrectiveActionRepository`
* `TwilioNotificationAdapter`

Asimismo, se representan las integraciones del contexto con:

* **Environmental Monitoring**, como proveedor del evento `DeviationDetected`.
* **IAM**, como proveedor de identidad y contexto del usuario autenticado.
* **Traceability & Quality**, como consumidor del evento `IncidentResolved`.
* **Twilio**, como servicio externo utilizado para el envío de notificaciones.

**Relaciones principales**

* Los controllers reciben las solicitudes desde los clientes de MachineGuard e invocan los servicios de aplicación correspondientes.
* Los command services coordinan las operaciones de escritura relacionadas con la generación, reconocimiento, escalamiento y resolución de alertas e incidentes.
* Los query services permiten consultar las alertas activas, una alerta específica y el historial de incidentes.
* Los application services interactúan con las entidades y agregados del modelo de dominio.
* Los application services coordinan la persistencia del estado mediante los repositories del contexto.
* `RaiseAlertCommandService` procesa una desviación detectada y genera la alerta e incidente correspondientes.
* `AcknowledgeAlertCommandService` registra el reconocimiento de una alerta por parte del responsable.
* `EscalateAlertCommandService` gestiona el escalamiento de las alertas que no han sido reconocidas dentro del tiempo establecido.
* `RegisterCorrectiveActionCommandService` registra las acciones realizadas para atender el incidente.
* `ResolveIncidentCommandService` finaliza el ciclo del incidente y publica el evento `IncidentResolved`.
* `TwilioNotificationAdapter` permite enviar las notificaciones generadas por el contexto mediante SMS o WhatsApp.
* Los repositories gestionan el acceso a las tablas correspondientes del Bounded Context dentro de la base de datos central PostgreSQL de MachineGuard.

#### 4.2.5.6. Bounded Context Software Architecture Code Level Diagrams

En esta sección se presentan los diagramas a nivel de código del Bounded Context **Alert & Incident Management**, incluyendo tanto el diagrama de clases del dominio como el diagrama de diseño de base de datos correspondiente.

##### 4.2.5.6.1. Bounded Context Domain Layer Class Diagrams

El siguiente diagrama debe representar las clases del dominio identificadas en este Bounded Context, así como sus atributos, operaciones y relaciones principales.

<!-- Insertar aquí el Domain Layer Class Diagram de Alert & Incident Management -->

![Bounded Context Domain Layer Class Diagram - Alert & Incident Management](/assets/img/chapter-4/BC%20Alert%20&%20Incident%20Management/Domain%20Layer%20-%20Alert%20&%20Incident%20Management.png)

*Figura. Domain Layer Class Diagram del Bounded Context Alert & Incident Management.*

**Clases esperadas en el diagrama**

* `Incident`
* `Alert`
* `CorrectiveAction`
* `AlertSeverity`
* `Acknowledgement`
* `Escalation`

**Relaciones esperadas**

* `Incident` como Aggregate Root.
* `Incident` asociado a `Alert`.
* `Incident` asociado a `CorrectiveAction`.
* `Alert` utiliza `AlertSeverity`.
* `Alert` o `Incident` incorpora `Acknowledgement` y `Escalation`.

##### 4.2.5.6.2. Bounded Context Database Design Diagram

El siguiente diagrama debe representar el diseño lógico de base de datos asociado a este Bounded Context, mostrando las tablas, claves primarias, claves foráneas y relaciones principales entre ellas.

<!-- Insertar aquí el Database Design Diagram de Alert & Incident Management -->

![Bounded Context Database Design Diagram - Alert & Incident Management](/assets/img/chapter-4/BC%20Alert%20&%20Incident%20Management/Database%20Design%20Diagram%20-%20Alert%20&%20Incident%20Management.png)

*Figura. Database Design Diagram del Bounded Context Alert & Incident Management.*

**Tablas esperadas en el diagrama**

* `incidents`
* `alerts`
* `corrective_actions`

**Relaciones esperadas**

* Un `incident` puede tener una `alert` asociada.
* Un `incident` puede tener una o varias `corrective_actions`.
* `alerts.incident_id` referencia a `incidents.id`.
* `corrective_actions.incident_id` referencia a `incidents.id`.

### 4.2.6. Bounded Context: Environmental Monitoring

El Bounded Context **Environmental Monitoring** constituye uno de los Core Domains de MachineGuard y concentra la lógica relacionada con el monitoreo continuo de las condiciones ambientales de las instalaciones del cliente.

Su responsabilidad principal consiste en organizar las zonas y puntos de monitoreo, gestionar los Sensor Nodes asociados, configurar los Thresholds de temperatura y humedad, registrar las Measurements recibidas desde Edge Processing y evaluar dichas mediciones con respecto al Safe Range definido para cada Monitoring Zone.

Cuando una Measurement supera alguno de los Thresholds configurados, el contexto genera una Deviation y publica el evento `DeviationDetected`, permitiendo que otros Bounded Contexts, como **Alert & Incident Management** y **Traceability & Quality**, reaccionen ante la condición anómala.

Asimismo, Environmental Monitoring determina el estado operativo de los Sensor Nodes según el Sampling Interval esperado y publica `SensorNodeWentOffline` cuando un dispositivo deja de reportar mediciones dentro del período configurado.

#### 4.2.6.1. Domain Layer

La Domain Layer contiene las reglas y conceptos centrales del monitoreo ambiental de MachineGuard.

El dominio se organiza alrededor de las Monitoring Zones y Monitoring Points en los que se realizan las mediciones. Cada punto puede estar asociado a un Sensor Node, mientras que cada zona mantiene los Thresholds que determinan el Safe Range permitido para las variables ambientales monitoreadas.

Las Measurements recibidas desde Edge Processing son evaluadas automáticamente contra dichos Thresholds. Cuando una medición se encuentra fuera del rango permitido, el contexto identifica una Deviation y publica el evento `DeviationDetected`.

**MonitoringZone — Aggregate Root**

* **Propósito:** representa una zona física dentro de una instalación monitoreada y concentra la configuración ambiental aplicable a dicha zona.
* **Atributos:** `id`, `organizationId`, `facilityId`, `name`, `description`, `status`.
* **Métodos principales:** `createMonitoringPoint`, `configureThreshold`, `updateThreshold`, `activate`, `deactivate`.
* **Eventos:** `ThresholdConfigured`.
* **Relaciones:** contiene uno o varios `MonitoringPoint` y uno o varios `Threshold`.

**MonitoringPoint — Entity**

* **Propósito:** representa una ubicación específica dentro de una Monitoring Zone en la que se realizan las mediciones ambientales.
* **Atributos:** `id`, `monitoringZoneId`, `name`, `location`, `sensorNodeId`, `status`.
* **Métodos principales:** `assignSensorNode`, `removeSensorNode`, `activate`, `deactivate`.
* **Relaciones:** pertenece a una `MonitoringZone` y puede estar asociado a un `SensorNode`.

**SensorNode — Aggregate Root**

* **Propósito:** representa un nodo sensor instalado físicamente en un Monitoring Point y permite conocer su estado de conectividad.
* **Atributos:** `id`, `monitoringPointId`, `deviceCode`, `samplingInterval`, `status`, `lastMeasurementAt`.
* **Métodos principales:** `register`, `updateSamplingInterval`, `recordMeasurementTime`, `markOnline`, `markOffline`, `isOffline`.
* **Eventos:** `SensorNodeWentOffline`.
* **Relaciones:** puede estar asociado a un `MonitoringPoint` y utiliza `SamplingInterval`.

**Threshold — Entity**

* **Propósito:** representa los límites mínimo y máximo permitidos para una variable ambiental dentro de una Monitoring Zone.
* **Atributos:** `id`, `monitoringZoneId`, `environmentalVariable`, `minimumValue`, `maximumValue`.
* **Métodos principales:** `configure`, `updateRange`, `contains`.
* **Eventos:** `ThresholdConfigured`.
* **Relaciones:** pertenece a una `MonitoringZone` y utiliza `EnvironmentalVariable`.

**Measurement — Entity**

* **Propósito:** representa una medición ambiental válida recibida desde Edge Processing.
* **Atributos:** `id`, `monitoringPointId`, `sensorNodeId`, `temperature`, `humidity`, `measuredAt`, `receivedAt`.
* **Métodos principales:** `record`, `evaluateAgainst`.
* **Eventos:** `MeasurementRecorded`.
* **Relaciones:** corresponde a un `MonitoringPoint` y un `SensorNode`.

**SafeRange — Value Object**

* **Propósito:** encapsula el rango válido definido por un Threshold.
* **Atributos:** `minimumValue`, `maximumValue`.
* **Métodos principales:** `contains`, `isOutsideRange`.
* **Relaciones:** utilizado por `Threshold` durante la evaluación de una Measurement.

**EnvironmentalVariable — Value Object**

* **Propósito:** identifica la variable ambiental sobre la que se aplica un Threshold.
* **Valores conceptuales:** temperatura y humedad.
* **Relaciones:** utilizado por `Threshold`.

**SamplingInterval — Value Object**

* **Propósito:** representa el intervalo de tiempo esperado entre lecturas consecutivas de un Sensor Node.
* **Atributos:** `seconds`.
* **Métodos principales:** `isExceeded`.
* **Relaciones:** utilizado por `SensorNode` para evaluar su estado de conectividad.

**Commands**

* `ConfigureThresholdCommand`
* `RegisterSensorNodeCommand`
* `EvaluateMeasurementCommand`
* `UpdateSamplingIntervalCommand`

**Queries**

* `GetLatestMeasurementsQuery`
* `GetSensorNodeStatusQuery`
* `GetThresholdsByZoneQuery`

**Domain Services**

**MeasurementEvaluationService**

* **Propósito:** coordina la evaluación de una Measurement contra los Thresholds configurados para la Monitoring Zone correspondiente.
* **Responsabilidades principales:** determinar si una medición pertenece al Safe Range y generar `DeviationDetected` cuando corresponda.

**SensorNodeStatusService**

* **Propósito:** determina si un Sensor Node continúa operativo según su última medición y el Sampling Interval configurado.
* **Responsabilidades principales:** calcular el estado del nodo y generar `SensorNodeWentOffline` cuando deja de reportar dentro del tiempo esperado.

**Repositories**

* `MonitoringZoneRepository`
* `MonitoringPointRepository`
* `SensorNodeRepository`
* `ThresholdRepository`
* `MeasurementRepository`

**Business Rules**

* Toda Measurement válida recibida desde Edge Processing debe conservar su marca temporal original.
* Una Measurement debe evaluarse utilizando los Thresholds vigentes de la Monitoring Zone correspondiente.
* Un Threshold debe definir un valor mínimo menor que su valor máximo.
* Cada Monitoring Point pertenece a una Monitoring Zone.
* Un Monitoring Point puede estar asociado a un Sensor Node.
* Si una Measurement se encuentra fuera del Safe Range, debe publicarse `DeviationDetected`.
* Si un Sensor Node deja de reportar dentro del Sampling Interval esperado, debe considerarse Offline y publicarse `SensorNodeWentOffline`.
* La modificación de un Threshold debe afectar a las nuevas Measurements evaluadas posteriormente.

#### 4.2.6.2. Interface Layer

La Interface Layer expone las operaciones REST necesarias para consultar las condiciones ambientales actuales, revisar el historial de mediciones, administrar Monitoring Zones y Monitoring Points, configurar Thresholds y consultar el estado de los Sensor Nodes.

Esta capa también proporciona el punto de entrada utilizado por Edge Processing para entregar las Measurements procesadas antes de su evaluación en el dominio.

**MonitoringZoneController**

* **Propósito:** expone las operaciones relacionadas con la consulta y administración de Monitoring Zones.
* **Operaciones principales:**
  * consultar zonas de monitoreo;
  * consultar una zona específica;
  * registrar una Monitoring Zone;
  * gestionar los Monitoring Points asociados.

**MeasurementController**

* **Propósito:** permite registrar y consultar Measurements.
* **Operaciones principales:**
  * registrar una Measurement proveniente de Edge Processing;
  * consultar la última Measurement de un Monitoring Point;
  * consultar Measurement History dentro de un período.

**ThresholdController**

* **Propósito:** administra los Thresholds asociados a las Monitoring Zones.
* **Operaciones principales:**
  * consultar Thresholds;
  * configurar un Threshold;
  * actualizar el Safe Range.

**SensorNodeController**

* **Propósito:** permite registrar Sensor Nodes, consultar su estado y actualizar parámetros relacionados con su Sampling Interval.
* **Operaciones principales:**
  * registrar Sensor Node;
  * consultar estado de conectividad;
  * actualizar Sampling Interval.

**Resources / DTOs**

* `MonitoringZoneResource`
* `MonitoringPointResource`
* `MeasurementResource`
* `ThresholdResource`
* `SensorNodeResource`
* `ConfigureThresholdResource`
* `RegisterSensorNodeResource`

**Assemblers**

* `MonitoringZoneResourceAssembler`
* `MonitoringPointResourceAssembler`
* `MeasurementResourceAssembler`
* `ThresholdResourceAssembler`
* `SensorNodeResourceAssembler`

**Responsabilidad de la capa**

La Interface Layer recibe las solicitudes HTTP y los datos provenientes de Edge Processing, transforma los recursos REST en comandos o consultas y delega la ejecución de los casos de uso a la Application Layer. Las reglas relacionadas con Thresholds, Safe Range, Deviations y estado de los Sensor Nodes permanecen dentro del dominio.

#### 4.2.6.3. Application Layer

La Application Layer coordina los casos de uso del Bounded Context **Environmental Monitoring**.

Esta capa recibe comandos y consultas desde la Interface Layer, utiliza las entidades y servicios del dominio y coordina la persistencia mediante los repositories correspondientes.

**Command Services / Handlers**

**ConfigureThresholdCommandService**

* **Propósito:** registrar o actualizar los Thresholds correspondientes a una Monitoring Zone.
* **Flujo principal:** obtiene la Monitoring Zone, valida el rango definido, crea o actualiza el Threshold y publica `ThresholdConfigured`.

**RegisterSensorNodeCommandService**

* **Propósito:** registrar un Sensor Node y asociarlo al Monitoring Point correspondiente.
* **Flujo principal:** valida el Monitoring Point, crea el Sensor Node, configura su Sampling Interval inicial y persiste la información.

**EvaluateMeasurementCommandService**

* **Propósito:** procesar una Measurement recibida desde Edge Processing.
* **Flujo principal:** registra la Measurement, obtiene los Thresholds correspondientes, invoca `MeasurementEvaluationService` y publica `MeasurementRecorded` o `DeviationDetected` según el resultado.

**UpdateSamplingIntervalCommandService**

* **Propósito:** modificar el intervalo esperado entre lecturas de un Sensor Node.
* **Flujo principal:** obtiene el Sensor Node, actualiza el Sampling Interval y persiste el nuevo valor.

**Query Services / Handlers**

* `GetLatestMeasurementsQueryService`
* `GetSensorNodeStatusQueryService`
* `GetThresholdsByZoneQueryService`

**Flujo principal 1: procesamiento de una medición**

1. Edge Processing entrega una lectura procesada mediante `ReadingCaptured`.
2. Environmental Monitoring transforma la lectura en una `Measurement`.
3. La Measurement es persistida.
4. Se obtienen los Thresholds vigentes para la Monitoring Zone.
5. `MeasurementEvaluationService` compara los valores contra el Safe Range.
6. Se publica `MeasurementRecorded`.
7. Si algún valor está fuera del rango permitido, se publica `DeviationDetected`.
8. `DeviationDetected` puede ser consumido por **Alert & Incident Management** y **Traceability & Quality**.

**Flujo principal 2: evaluación de conectividad de un Sensor Node**

1. El sistema obtiene la última Measurement reportada por el Sensor Node.
2. Se compara su marca temporal con el Sampling Interval configurado.
3. Si el período esperado no ha sido superado, el nodo permanece activo.
4. Si el tiempo máximo es superado, el nodo pasa a estado Offline.
5. Se publica `SensorNodeWentOffline`.

**Flujo principal 3: configuración de Threshold**

1. El Jefe de Almacén selecciona una Monitoring Zone.
2. Define la variable ambiental y sus valores mínimo y máximo.
3. `ConfigureThresholdCommandService` valida los valores.
4. El Threshold es persistido.
5. Se publica `ThresholdConfigured`.
6. Las nuevas Measurements se evalúan utilizando el nuevo Safe Range.

#### 4.2.6.4. Infrastructure Layer

La Infrastructure Layer proporciona los mecanismos técnicos necesarios para la persistencia del dominio y la integración de Environmental Monitoring con los demás componentes de MachineGuard.

Este Bounded Context forma parte de la **RESTful API central de MachineGuard**, implementada con Spring Boot y Spring Data JPA, y utiliza la base de datos central PostgreSQL definida en la arquitectura de software.

**Persistence Component**

Los repositories principales del contexto son:

* `MonitoringZoneRepository`
* `MonitoringPointRepository`
* `SensorNodeRepository`
* `ThresholdRepository`
* `MeasurementRepository`

Las principales estructuras persistentes del contexto son:

* `monitoring_zones`
* `monitoring_points`
* `sensor_nodes`
* `thresholds`
* `measurements`

**Integración con Edge Processing**

Environmental Monitoring consume `ReadingCaptured`, evento generado después de que Edge Processing calibra y filtra las lecturas provenientes de los sensores.

Las Measurements recibidas conservan su marca temporal de origen para garantizar la continuidad del historial incluso cuando las lecturas han permanecido temporalmente almacenadas en el buffer local del Edge Gateway.

**Integración con IAM**

IAM proporciona la identidad del usuario y el contexto de organización mediante el mecanismo de autenticación JWT utilizado por los Bounded Contexts operativos de MachineGuard.

El identificador de organización se conserva como referencia lógica para garantizar el aislamiento multi-tenant.

**Integración con Alert & Incident Management**

Cuando una Measurement supera un Threshold, Environmental Monitoring publica `DeviationDetected`.

Alert & Incident Management consume dicho evento para iniciar el ciclo de vida correspondiente de la alerta y del incidente.

**Integración con Traceability & Quality**

Traceability & Quality también consume `DeviationDetected` para mantener el registro de las excursiones ambientales y generar posteriormente evidencia de trazabilidad.

**Integración con OpenWeatherMap**

Environmental Monitoring utiliza OpenWeatherMap como sistema externo de referencia climática.

La integración sigue el patrón Conformist: MachineGuard consume la API externa adaptándose al contrato definido por el proveedor.

**Integración con ERP del Cliente**

MachineGuard expone mediante su RESTful API información de mediciones e historial para permitir su consulta desde el ERP del cliente.

**Configuración técnica**

* API central: Spring Boot.
* Persistencia: Spring Data JPA.
* Base de datos: PostgreSQL.
* Comunicación HTTP: REST/JSON.
* Documentación de API: OpenAPI / Swagger.
* Identidad y autorización: JWT proporcionado por IAM.

**Limitaciones**

* Environmental Monitoring depende de la recepción de Measurements procesadas por Edge Processing.
* La consulta de condiciones externas depende de la disponibilidad de OpenWeatherMap.
* Una interrupción de Internet puede retrasar la llegada de Measurements, aunque Edge Processing conserva temporalmente las lecturas para su posterior sincronización.
* Los eventos entre Bounded Contexts internos comparten el mismo Ubiquitous Language y no utilizan una Anti-Corruption Layer en la arquitectura actual.

#### 4.2.6.5. Bounded Context Software Architecture Component Level Diagrams

En esta sección se presenta el diagrama de componentes del Bounded Context **Environmental Monitoring**, mostrando la interacción entre la Interface Layer, Application Layer, Domain Layer, Infrastructure Layer y los mecanismos de integración con los demás Bounded Contexts y sistemas externos de MachineGuard.

Environmental Monitoring recibe `ReadingCaptured` desde **Edge Processing**, obtiene identidad y contexto de organización desde **IAM**, publica `DeviationDetected` hacia **Alert & Incident Management** y **Traceability & Quality**, consulta información climática de **OpenWeatherMap** y pone información de mediciones a disposición del **ERP del Cliente** mediante la RESTful API pública de MachineGuard.

<!-- Insertar aquí el Component Level Diagram de Environmental Monitoring -->

![Bounded Context Software Architecture Component Level Diagram - Environmental Monitoring](/assets/img/chapter-4/BC%20Environmental%20Monitoring/Component%20Diagram%20-%20Environmental%20Monitoring.png)

*Figura. Component Level Diagram del Bounded Context Environmental Monitoring.*

**Componentes principales del diagrama**

* `MonitoringZoneController`
* `MeasurementController`
* `ThresholdController`
* `SensorNodeController`
* `ConfigureThresholdCommandService`
* `RegisterSensorNodeCommandService`
* `EvaluateMeasurementCommandService`
* `UpdateSamplingIntervalCommandService`
* `GetLatestMeasurementsQueryService`
* `GetSensorNodeStatusQueryService`
* `GetThresholdsByZoneQueryService`
* `MeasurementEvaluationService`
* `SensorNodeStatusService`
* `MonitoringZone`
* `MonitoringPoint`
* `SensorNode`
* `Threshold`
* `Measurement`
* `MonitoringZoneRepository`
* `MonitoringPointRepository`
* `SensorNodeRepository`
* `ThresholdRepository`
* `MeasurementRepository`

**Relaciones principales**

* Los controllers reciben las solicitudes de los clientes y delegan su ejecución a command/query services.
* Edge Processing entrega las Measurements procesadas al contexto.
* Los application services coordinan las operaciones sobre el modelo de dominio.
* `EvaluateMeasurementCommandService` utiliza `MeasurementEvaluationService` para comparar Measurements contra los Thresholds vigentes.
* Los repositories administran la persistencia en la base de datos central PostgreSQL.
* `DeviationDetected` se publica hacia Alert & Incident Management y Traceability & Quality.
* IAM proporciona identidad y contexto de organización.
* OpenWeatherMap proporciona información climática externa de referencia.
* La API pública permite que el ERP del Cliente consulte mediciones e historial.

#### 4.2.6.6. Bounded Context Software Architecture Code Level Diagrams

En esta sección se presentan los diagramas de nivel de código correspondientes al Bounded Context **Environmental Monitoring**, incluyendo el Domain Layer Class Diagram y el Database Design Diagram.

##### 4.2.6.6.1. Bounded Context Domain Layer Class Diagrams

El siguiente diagrama representa las clases principales identificadas dentro del dominio de Environmental Monitoring, incluyendo sus Commands, Queries, Aggregate Roots, Entities y Value Objects.

<!-- Insertar aquí el Domain Layer Class Diagram de Environmental Monitoring -->

![Bounded Context Domain Layer Class Diagram - Environmental Monitoring](/assets/img/chapter-4/BC%20Environmental%20Monitoring/Domain%20Layer%20-%20Environmental%20Monitoring.png)

*Figura. Domain Layer Class Diagram del Bounded Context Environmental Monitoring.*

**Clases principales**

* `EnvironmentalMonitoringCommandService`
* `EnvironmentalMonitoringQueryService`
* `ConfigureThresholdCommand`
* `RegisterSensorNodeCommand`
* `EvaluateMeasurementCommand`
* `UpdateSamplingIntervalCommand`
* `GetLatestMeasurementsQuery`
* `GetSensorNodeStatusQuery`
* `GetThresholdsByZoneQuery`
* `MonitoringZone`
* `MonitoringPoint`
* `SensorNode`
* `Threshold`
* `Measurement`
* `SafeRange`
* `EnvironmentalVariable`
* `SamplingInterval`

**Relaciones principales**

* `EnvironmentalMonitoringCommandService` procesa los Commands del contexto.
* `EnvironmentalMonitoringQueryService` procesa las Queries del contexto.
* `MonitoringZone` actúa como Aggregate Root para la configuración de zonas, puntos y Thresholds.
* Una `MonitoringZone` contiene uno o varios `MonitoringPoint`.
* Una `MonitoringZone` contiene uno o varios `Threshold`.
* Un `MonitoringPoint` puede estar asociado a un `SensorNode`.
* Un `Threshold` utiliza `SafeRange` y `EnvironmentalVariable`.
* Un `SensorNode` utiliza `SamplingInterval`.
* Una `Measurement` corresponde a un Monitoring Point y a un Sensor Node.

##### 4.2.6.6.2. Bounded Context Database Design Diagram

El siguiente diagrama representa el diseño lógico de persistencia del Bounded Context **Environmental Monitoring**, mostrando sus tablas principales, claves primarias, claves foráneas y relaciones.

<!-- Insertar aquí el Database Design Diagram de Environmental Monitoring -->

![Bounded Context Database Design Diagram - Environmental Monitoring](/assets/img/chapter-4/BC%20Environmental%20Monitoring/Database%20Design%20Diagram%20-%20Environmental%20Monitoring.png)

*Figura. Database Design Diagram del Bounded Context Environmental Monitoring.*

**Tablas principales**

* `monitoring_zones`
* `monitoring_points`
* `sensor_nodes`
* `thresholds`
* `measurements`

**Relaciones principales**

* Una `monitoring_zone` puede contener varios `monitoring_points`.
* Una `monitoring_zone` puede contener varios `thresholds`.
* Un `monitoring_point` puede estar asociado a un `sensor_node`.
* Un `monitoring_point` puede registrar múltiples `measurements`.
* Un `sensor_node` puede generar múltiples `measurements`.
* `monitoring_points.monitoring_zone_id` referencia a `monitoring_zones.id`.
* `thresholds.monitoring_zone_id` referencia a `monitoring_zones.id`.
* `sensor_nodes.monitoring_point_id` referencia a `monitoring_points.id`.
* `measurements.monitoring_point_id` referencia a `monitoring_points.id`.
* `measurements.sensor_node_id` referencia a `sensor_nodes.id`.

Los identificadores `organization_id` y `facility_id` se mantienen como referencias lógicas al contexto organizacional de MachineGuard y no se representan como Foreign Keys físicas hacia otros Bounded Contexts.
