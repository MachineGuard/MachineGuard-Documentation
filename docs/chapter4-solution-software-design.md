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
| **Eventos publicados** | `UserRegistered`, `UserLoggedIn`, `UserLoggedOut`, `OrganizationCreated`, `RoleAssigned` |
| **Eventos consumidos** | `PilotRequestSubmitted` (de Customer Acquisition) |
| **Agregados clave** | `User`, `Organization`, `Role` |
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

Los diagramas de arquitectura de software se presentan siguiendo el modelo C4 (System Landscape, Context, Container y Deployment), expresados como Diagram-as-Code en PlantUML con la librería C4-PlantUML. Para renderizarlos, utilizar PlantUML Online Server (https://www.plantuml.com/plantuml) o la extensión PlantUML para VS Code.

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

En esta sección, el equipo presenta las clases identificadas y las detalla a manera de diccionario, explicando para cada una su nombre, propósito y la documentación de atributos y métodos considerados, junto con las relaciones entre ellas.

#### 4.2.1.1. Domain Layer

Esta capa contiene el núcleo del negocio del contexto IAM, incluyendo los agregados y objetos de valor que definen la identidad de los usuarios y el aislamiento multi-tenant entre organizaciones clientes. A diferencia del Bounded Context Canvas del diseño estratégico, `Role` no se modela como un Aggregate Root independiente sino como un **Value Object** embebido en `User`: los roles del sistema (`ADMIN`, `VIEWER`) son fijos y no tienen ciclo de vida ni identidad propia, por lo que no justifican un agregado separado. Los repositorios se implementan como interfaces de Spring Data JPA (`extends JpaRepository`) sin una capa intermedia de puertos (`IXRepository`); la capa de dominio depende directamente de estas interfaces.

**Organization — Aggregate Root**

* **Propósito:** representa a la empresa cliente dentro del modelo SaaS multi-tenant de MachineGuard; agrupa a sus usuarios y define su plan de suscripción.
* **Atributos:** `name`, `subscriptionPlan` (`SubscriptionPlan`: `FREE` / `BASIC` / `PREMIUM`), `status` (`ACTIVE` / `SUSPENDED`), `createdAt`.
* **Métodos principales:** `create`, `updateSubscriptionPlan`, `suspend`, `reactivate`, `isActive`.
* **Eventos:** `OrganizationCreated` (emitido al crearse; consumido hoy por el flujo de onboarding para registrar al usuario administrador).
* **Relaciones:** es referenciada por `User` (mediante `organizationId`, dentro del mismo BC) y por los agregados de Environmental Monitoring, Alert & Incident Management y Traceability & Quality como dato de contexto (sin ACL, mismo Ubiquitous Language). Administrado a través de `OrganizationRepository`.

**User — Aggregate Root**

* **Propósito:** representa la cuenta individual de un usuario dentro de una organización; gestiona su autenticación y el rol que determina sus permisos.
* **Atributos:** `email`, `passwordHash`, `fullName`, `organizationId`, `role` (`Role`), `status` (`ACTIVE` / `INACTIVE`), `lastLoginAt`.
* **Métodos principales:** `register`, `login`, `logout`, `resetPassword`, `assignRole`, `activate`, `deactivate`, `isActive`.
* **Eventos:** `UserRegistered`, `UserLoggedIn`, `UserLoggedOut`, `RoleAssigned`.
* **Relaciones:** referencia a `Organization` (mismo BC, vía `organizationId`). Administrado a través de `UserRepository`.

**Role — Value Object**

* **Propósito:** encapsula el rol de un usuario dentro de su organización y las capacidades asociadas (`ADMIN` configura zonas y umbrales; `VIEWER` solo consulta información).
* **Atributos:** `name` (`ADMIN` / `VIEWER`).
* **Métodos principales:** `canConfigure`, `canOnlyView`.
* **Relaciones:** embebido en `User`; no tiene identidad ni repositorio propio.

<!-- #### 4.2.1.2. Interface Layer
> 

#### 4.2.1.3. Application Layer
>

#### 4.2.1.4. Infrastructure Layer
> 

#### 4.2.1.5. Bounded Context Software Architecture Component Level Diagrams
> 

#### 4.2.1.6. Bounded Context Software Architecture Code Level Diagrams

##### 4.2.1.6.1. Bounded Context Domain Layer Class Diagrams
> 

##### 4.2.1.6.2. Bounded Context Database Design Diagram -->
>

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

![Bounded Context Software Architecture Component Level Diagram - Alert & Incident Management](<Component Diagram - Alert & Incident Management.png>)

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

##### 4.2.5.6. Bounded Context Software Architecture Code Level Diagrams

En esta sección se presentan los diagramas a nivel de código del Bounded Context **Alert & Incident Management**, incluyendo tanto el diagrama de clases del dominio como el diagrama de diseño de base de datos correspondiente.

###### 4.2.5.6.1. Bounded Context Domain Layer Class Diagrams

El siguiente diagrama debe representar las clases del dominio identificadas en este Bounded Context, así como sus atributos, operaciones y relaciones principales.

<!-- Insertar aquí el Domain Layer Class Diagram de Alert & Incident Management -->

![Bounded Context Domain Layer Class Diagram - Alert & Incident Management](<Domain Layer - Alert & Incident Management.png>)

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

###### 4.2.5.6.2. Bounded Context Database Design Diagram

El siguiente diagrama debe representar el diseño lógico de base de datos asociado a este Bounded Context, mostrando las tablas, claves primarias, claves foráneas y relaciones principales entre ellas.

<!-- Insertar aquí el Database Design Diagram de Alert & Incident Management -->

![Bounded Context Database Design Diagram - Alert & Incident Management](<Database Design Diagram - Alert & Incident Management.png>)

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

#### 4.2.6. Bounded Context: Environmental Monitoring
##### 4.2.6.1. Domain Layer
##### 4.2.6.2. Interface Layer
##### 4.2.6.3. Application Layer
##### 4.2.6.4. Infrastructure Layer
##### 4.2.6.5. Bounded Context Software Architecture Component Level Diagrams
##### 4.2.6.6. Bounded Context Software Architecture Code Level Diagrams
###### 4.2.6.6.1. Bounded Context Domain Layer Class Diagrams
###### 4.2.6.6.2. Bounded Context Database Design Diagram
