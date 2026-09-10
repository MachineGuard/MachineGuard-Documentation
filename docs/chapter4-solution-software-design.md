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


#### 4.1.1.3. Bounded Context Canvases


### 4.1.2. Context Mapping


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
