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


#### 4.1.3.1. Software Architecture System Landscape Diagram


#### 4.1.3.2. Software Architecture Context Level Diagrams


#### 4.1.3.3. Software Architecture Container Level Diagrams


#### 4.1.3.4. Software Architecture Deployment Diagrams



## 4.2. Tactical-Level Domain-Driven Design

> Nota: duplica el bloque `4.2.X` por cada Bounded Context que definan (renumerando 4.2.1, 4.2.2, ...).

### 4.2.X. Bounded Context: `<Nombre del Bounded Context>`

#### 4.2.X.1. Domain Layer
> Contenido pendiente.

#### 4.2.X.2. Interface Layer
> Contenido pendiente.

#### 4.2.X.3. Application Layer
> Contenido pendiente.

#### 4.2.X.4. Infrastructure Layer
> Contenido pendiente.

#### 4.2.X.5. Bounded Context Software Architecture Component Level Diagrams
> Contenido pendiente.

#### 4.2.X.6. Bounded Context Software Architecture Code Level Diagrams

##### 4.2.X.6.1. Bounded Context Domain Layer Class Diagrams
> Contenido pendiente.

##### 4.2.X.6.2. Bounded Context Database Design Diagram
> Contenido pendiente.
