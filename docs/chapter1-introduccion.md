# Capítulo I: Introducción

## 1.1. StartUp Profile

### 1.1.1. Descripción de la StartUp

MachineGuard es una startup tecnológica peruana orientada al desarrollo de soluciones de Internet de las Cosas (IoT) y transformación digital bajo un modelo SaaS (Software as a Service) más hardware por suscripción. La empresa resuelve las pérdidas por condiciones ambientales no controladas en el sector de manufactura y almacenaje en Lima y la región, ofreciendo un sistema de monitoreo continuo de bajo costo e integración accesible para PyMEs industriales que no cuentan con presupuesto para sistemas SCADA tradicionales.

La solución MachineGuard se compone de una arquitectura distribuida que abarca:
- **Landing Page:** Sitio web de marketing para la atracción y captación de clientes (HTML5, CSS3, JS).
- **Web App:** Dashboard de monitoreo en tiempo real para la visualización del estado de plantas/almacenes, alertas e historial (Angular + Angular Material).
- **RESTful API:** Núcleo del sistema que gestiona usuarios, plantas, alertas e historial, además de exponer un endpoint público para la integración con el ERP que ya utiliza el cliente (Spring Boot + Spring Data JPA).
- **Mobile App:** Aplicación para la recepción de alertas push y monitoreo remoto desde dispositivos móviles (Kotlin / Flutter).
- **Edge API:** Servicio intermedio encargado de recibir, calibrar y filtrar localmente los datos emitidos por la red de sensores (Flask + Peewee + SQLite).
- **Embedded App:** Firmware cargado en los dispositivos sensores de bajo costo para la toma de mediciones en punto (C++ / MicroPython sobre ESP32 + DHT11/DHT22).
- **Servicio Externo Integrado:** Conexión con servicios de terceros (como OpenWeatherMap o Twilio) para enriquecer la toma de decisiones o la transmisión de notificaciones.

**Misión**  
Proveer a las PyMEs industriales y de almacenaje una solución IoT de monitoreo ambiental accesible, de rápida implementación y con alertas en tiempo real, garantizando la trazabilidad de sus insumos y reduciendo pérdidas operativas sin requerir hardware industrial costoso.

**Visión**  
Ser la plataforma SaaS + IoT de monitoreo ambiental de referencia en el mercado peruano y latinoamericano para la mediana y pequeña industria, destacando por su facilidad de integración con sistemas ERP existentes y su alto impacto en el control de calidad.

**Propuesta de Valor**
- **Accesibilidad Económica:** Puntos de monitoreo de bajo costo (S/ 35-50 por punto con ESP32+DHT22) combinados con un modelo de suscripción mensual al servicio.
- **Integración Abierta:** Exposición de una API pública que permite al ERP del cliente consumir los datos de mediciones y alertas sin necesidad de reemplazar sus sistemas internos.
- **Reacción Inmediata y Trazabilidad:** Alertas en tiempo real (web + móvil) ante variaciones fuera de rango e historial completo para auditorías de calidad.

---

### 1.1.2. Perfiles de Integrantes del equipo

| Nombre Completo | Código | Descripción de Carrera | Fotografía | Conocimientos y Habilidades |
| :--- | :--- | :--- | :--- | :--- |
| **Diego Seijas Vasquez** | u202210167 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/diego.jpg" alt="Diego Seijas" width="100"/> | Completar aqui |
| **Karito Dianeth Medina Chocce** | u20221c769 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/karito.png" alt="Karito Medina" width="100"/> | Dominio en desarrollo web y móvil (TypeScript, Kotlin, C++, C#). Experiencia en análisis de documentación técnica, prototipado UI/UX con Figma y organización ágil en Trello. Destaca por su trabajo en equipo, constante disposición para aprender nuevas tecnologías y compromiso con la excelencia del proyecto. |
| **Camilla Leonor Espinoza Vivas** | u202214572 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/camilla.jpg" alt="Camilla Espinoza" width="100"/> | Completar aqui |
| **Sandro Dinklange Arevalo** | u202313419 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/sandro.jpg" alt="Sandro Dinklange" width="100"/> | Completar aqui |
| **Jose Diego Bautista Rivera** | u202310949 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/jose.jpg" alt="Jose Bautista" width="100"/> | Completar aqui |
| **Jhoan Darner Janampa Gutierrez** | u202323319 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/Jhoan.jpeg" alt="Jhoan Janampa" width="100"/> | Completar aqui |
| **Pedro Omar Lecca Villalobos** | u202223293 | Ingeniería de Software<br>Universidad Peruana de Ciencias Aplicadas | <img src="assets/img/chapter-1/TeamMember/pedro.jpg" alt="Pedro Lecca" width="100"/> | Desarrollador orientado al desarrollo full-stack de aplicaciones web y soluciones de software. Cuenta con experiencia práctica en Java y Spring Boot para backend, así como Angular, Vue.js, Vite, TypeScript y JavaScript para frontend, además de conocimientos en Python y Node.js. Ha desarrollado proyectos propios y soluciones para terceros que incluyen APIs REST, bases de datos, integración con GitHub, automatización, bots y sistemas de despliegue de aplicaciones. Maneja Git/GitHub, PostgreSQL, Docker y tecnologías relacionadas con despliegue y operación de servicios web. Destaca por su capacidad para diseñar soluciones de extremo a extremo, resolver problemas técnicos y aprender e integrar nuevas tecnologías. |

---

## 1.2. Solution Profile

### 1.2.1 Antecedentes y Problemática

El análisis del problema y contexto de la solución se estructura mediante la técnica de las 5 'W's y 2 'H's:

* **Who (¿Quiénes están involucrados?):** PyMEs de manufactura y almacenaje en Lima que no disponen de presupuesto para implementar sistemas SCADA industriales costosos.
* **What (¿Qué ocurre?):** Pérdidas económicas por condiciones ambientales fuera de rango, principalmente humedad que daña insumos y temperatura que afecta los procesos de producción o la conservación de bienes.
* **Where (¿Dónde ocurre el problema?):** En almacenes de insumos, centros de acopio y plantas de producción de la pequeña y mediana industria en Lima.
* **When (¿Cuándo ocurre?):** Se presenta de forma continua durante la operación diaria, con picos de mayor riesgo en cambios estacionales de clima o ante fallas del sistema de climatización local.
* **Why (¿Por qué ocurre el problema?):** Porque el control actual se realiza mediante rondas manuales de inspección (usando termohigrómetros portátiles), un proceso lento, impreciso y que carece de registros históricos continuos para análisis o auditorías.
* **How (¿Cómo actúa la solución?):** A través de sensores IoT de bajo costo (ESP32 + DHT11/DHT22) desplegados en puntos clave, los cuales envían datos calibrados por un Edge Service hacia un API central que procesa la información y emite alertas en tiempo real hacia una Web App y una Mobile App, ofreciendo además un endpoint público para consultar el historial desde el ERP del cliente.
* **How Much (¿Cuál es la cuantificación de costo/impacto?):** Un costo accesible de S/ 35 a S/ 50 por punto de monitoreo (sensor ESP32 + DHT22) complementado por una suscripción mensual al servicio SaaS.

**Objetivos de la Solución:**
* Automatizar el monitoreo ambiental continuo de temperatura y humedad en almacenes de PyMEs industriales en Lima.
* Emitir notificaciones de alerta en tiempo real en un lapso menor a 5 segundos tras detectarse una anomalía.
* Exponer una API pública RESTful que permita la integración de lecturas históricas con el sistema ERP utilizado por el cliente.

**Restricciones del Proyecto:**
* **Presupuesto:** Utilización exclusiva de hardware de bajo costo (ESP32 y sensores DHT11/DHT22) sin depender de PLCs o controladores industriales de alto valor.
* **Conectividad:** Los nodos dependen de una red Wi-Fi o red local para transmitir datos al Edge Service.
* **Entorno:** La solución está acotada al monitoreo de variables de humedad y temperatura en interiores de almacenes o plantas.

---

### 1.2.2. Lean UX Process

#### 1.2.2.1 Problem Statement

El estado actual del monitoreo de condiciones ambientales en plantas de manufactura y almacenes se ha centrado principalmente en rondas manuales periódicas mediante termohigrómetros portátiles o en la instalación de complejos sistemas SCADA diseñados para grandes corporaciones industriales.

Lo que los productos y servicios existentes no logran resolver es la provisión de un ecosistema IoT de bajo costo, fácil instalación y alcance continuo que emita alertas en tiempo real y que además permita integrar libremente sus datos con el ERP interno de la empresa sin requerir cambios de software administrativo.

Nuestro producto abordará esta brecha mediante un sistema SaaS + Hardware por suscripción respaldado por una arquitectura distribuida (Embedded App en ESP32, Edge API local, RESTful API en Spring Boot, Web App y Mobile App), ofreciendo un endpoint público para la consulta de métricas.

Nuestro foco inicial serán los Jefes de Almacén, Gerentes de Operaciones y Encargados de Control de Calidad en PyMEs industriales de manufactura y almacenaje ubicadas en Lima.

Sabremos que hemos tenido éxito cuando observemos que los clientes reducen su tiempo de respuesta ante variaciones ambientales anormales actuando sobre las alertas recibidas en menos de 5 minutos y renuevan de manera continua su suscripción mensual al servicio SaaS.

---

#### 1.2.2.2 Lean UX Assumptions

**Business Assumptions**
* Creemos que las PyMEs de manufactura y almacenaje en Lima necesitan evitar pérdidas de inventario por variaciones climáticas, pero no cuentan con el presupuesto para adquirir sistemas SCADA industriales.
* Creemos que ofrecer un modelo híbrido de suscripción mensual al servicio SaaS junto con hardware de monitoreo de bajo costo (S/ 35-50 por punto) elimina la barrera financiera de entrada.
* Creemos que la posibilidad de integrar nuestra solución con el ERP existente del cliente mediante una API pública será el factor diferenciador clave para acelerar la venta y renovación del servicio.
* Creemos que el valor principal percibido estará en la recepción instantánea de alertas móviles y la automatización del historial para auditorías.

**Business Outcome Assumptions**
* Creemos que se logrará una adopción continua del servicio SaaS en almacenes de insumos en Lima.
* Creemos que los clientes experimentarán una reducción significativa en la tasa de mermas de insumos sensibles dentro del primer mes de uso.
* Creemos que obtendremos una alta tasa de retención y renovación de suscripciones mensuales impulsada por la facilidad de uso e integración con sus ERPs.

**User Assumptions**
* Creemos que el Jefe de Almacén / Gerente de Operaciones necesita visibilidad en tiempo real de las condiciones del almacén desde su dispositivo móvil o PC.
* Creemos que el Jefe de Almacén prefiere notificaciones push automáticas antes que depender de revisiones manuales en papel.
* Creemos que el Encargado de Control de Calidad necesita disponer de un registro histórico digitalizado, confiable y continuo para responder a auditorías sin margen de error humano.

**User Outcome and Benefit Assumptions**
* Creemos que el Jefe de Almacén / Gerente de Operaciones obtendrá la capacidad de respuesta inmediata ante anomalías ambientales, erradicando pérdidas financieras sin realizar grandes inversiones.
* Creemos que el Encargado de Control de Calidad obtendrá una agilización drástica en la preparación de reportes de trazabilidad para inspecciones internas y externas.

**Feature Assumptions**
* **Feature 1 (Nodos IoT ESP32 + DHT22):** Captura continua de variables de temperatura y humedad en puntos estratégicos del almacén.
* **Feature 2 (Edge Processing):** Filtrado y calibración local de lecturas para garantizar datos limpios antes de enviarlos a la nube.
* **Feature 3 (Alertas Push y Dashboard Web):** Notificación instantánea en la App Móvil y Dashboard Web cuando una variable supere los umbrales seguros configurados.
* **Feature 4 (API Pública RESTful):** Endpoint expuesto que facilita la consulta de métricas e historial de mediciones directamente desde el sistema ERP del cliente.

---

#### 1.2.2.3 Lean UX Hypothesis Statements

* **Hipótesis 1 (Asociada a Feature 1 - Nodos IoT):**  
  We believe we will achieve a reduction in inventory loss caused by climate variations  
  If Jefes de Almacén / Gerentes de Operaciones  
  Attain continuous, automated environmental data collection  
  With low-cost IoT Monitoring Nodes (ESP32 + DHT22).

* **Hipótesis 2 (Asociada a Feature 2 - Edge Processing):**  
  We believe we will achieve high data reliability and reduced false alarm rates  
  If Encargados de Control de Calidad  
  Attain accurately calibrated and filtered environmental measurements  
  With Edge Processing Service for local data calibration.

* **Hipótesis 3 (Asociada a Feature 3 - Alertas Push y Dashboard):**  
  We believe we will achieve a response time of less than 5 minutes during climate anomalies  
  If Jefes de Almacén and Operations Personnel  
  Attain instant hazard notifications on their mobile devices and Web Dashboard  
  With Real-Time Push Alerts and Monitoring Dashboard.

* **Hipótesis 4 (Asociada a Feature 4 - API Pública RESTful):**  
  We believe we will achieve high monthly subscription renewal rates  
  If Operations Managers  
  Attain seamless integration between MachineGuard metrics and their current ERP software  
  With a Public RESTful API for external ERP data consumption.

---

#### 1.2.2.4. Lean UX Canvas

Mediante la realización del Lean UX Canvas consolidamos la problemática del negocio, las soluciones propuestas, los segmentos de usuarios, las hipótesis planteadas y las métricas de aprendizaje en una matriz visual accesible y sintética:

![Lean UX Canvas](assets/img/chapter-1/LeanUxCanvas/leanuxcanvas.png)

---

## 1.3. Segmentos Objetivo

El producto MachineGuard está diseñado para responder a dos perfiles clave dentro de las PyMEs industriales y de almacenaje en Lima:

### 1.3.1 Jefe de Almacén / Gerente de Operaciones
* **Perfil Demográfico y Profesional:** Profesional responsable de la gestión de inventarios, custodia de insumos y productos terminados, además de velar por la rentabilidad y eficiencia operativa de la planta o centro de distribución.
* **Información Estadística de Sustento:** Según estudios de la Sociedad Nacional de Industrias (SNI) y la Cámara de Comercio de Lima (CCL), cerca del 70% de las PyMEs industriales en Lima no cuentan con automatización en sus almacenes. Asimismo, la falta de control ambiental origina mermas que representan entre el 8% y el 15% del valor de los insumos almacenados en sectores como alimentos, farma y químicos.
* **Necesidades Principales:** Detectar inmediatamente cuando la temperatura o humedad salgan de los rangos permitidos para actuar antes de que la mercancía se degrade, protegiendo el capital de trabajo sin incurrir en costos de sistemas SCADA.
* **Beneficios Esperados:** Recepción de alertas push instantáneas en móvil o web, erradicación de pérdidas por clima y consulta de métricas centralizadas desde su propio ERP.

### 1.3.2 Encargado de Control de Calidad
* **Perfil Demográfico y Profesional:** Especialista encargado de asegurar el cumplimiento de las normas de calidad, conservación y seguridad de los productos, así como de responder ante certificaciones e inspecciones internas o externas.
* **Información Estadística de Sustento:** En el Perú, más del 60% de los hallazgos o faltas menores en auditorías de calidad (HACCP, ISO 9001) en PyMEs se deben a inconsistencias, vacíos o manipulación en las hojas de registro manuales de temperatura y humedad.
* **Necesidades Principales:** Contar con un historial de mediciones ambiental continuo, exacto y digitalizado que elimine el sesgo de la toma de datos manual con termohigrómetros y garantice trazabilidad total.
* **Beneficios Esperados:** Un registro automatizado en la nube para generar reportes auditables rápidamente y acelerar la preparación de expedientes para auditorías de calidad.
