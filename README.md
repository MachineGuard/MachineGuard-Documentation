![UPC Logo](assets/img/introduction/UPC.png)

# Universidad Peruana de Ciencias Aplicadas

**Carrera de Ingeniería de Software**

**Periodo:** 202620

**Nombre del Curso:** Desarrollo de Soluciones IoT

**NRC:** 8721

**Nombre del docente:** Javier Antonio Prudencio Vidal

## "Informe de Trabajo Final"

**Nombre del Startup:** MachineGuard

**Nombre del Producto:** MachineGuard

**Integrantes:**

| Código | Apellidos y Nombres |
|---|---|
| u202210167 | Seijas Vasquez, Diego |
| u20221c769 | Medina Chocce, Karito Dianeth |
| u202214572 | Espinoza Vivas, Camilla Leonor |
| u202313419 | Dinklange Arevalo, Sandro |
| u202310949 | Bautista Rivera, Jose Diego |
| u202323319 | Janampa Gutierrez, Jhoan Darner |
| u202223293 | Lecca Villalobos, Pedro Omar |

### 2026

## Registro de Versiones del Informe

| Versión | Fecha | Autor | Descripción |
|---|---|---|---|
| 1.0 | | | Estructura inicial del repositorio |

## Project Report Collaboration Insights

Repositorio del Project Report: https://github.com/MachineGuard/MachineGuard-Documentation

> Contenido pendiente — describir aquí los aportes de cada integrante en cada avance (AV1, TB1, AV2, TB2).

## Contenido

### Tabla de Contenidos
### Student Outcome

| Categoría | Aspecto | MachineGuard | UbiBot | Monnit (iMonnit) | Testo Saveris |
|---|---|---|---|---|---|
| **Perfil** | Overview | Plataforma SaaS + IoT peruana para monitoreo continuo de temperatura y humedad en almacenes y plantas de PyMEs.<br><br>Nodos ESP32 + DHT22 de bajo costo, un Edge Service que calibra y filtra localmente, una API REST central que evalúa umbrales y una Web App y Mobile App para alertas e historial.<br><br>Expone además una API pública para que el ERP del cliente consuma mediciones y alertas sin reemplazar sus sistemas. | Sensores inalámbricos autónomos con WiFi, 4G vinculados a la plataforma en la nube UbiBot.<br><br>El usuario configura el dispositivo desde la app y comienza a medir en minutos, sin instalador.<br><br>Cobertura funcional amplia con reportes y exportación de datos. | Ecosistema de sensores inalámbricos de largo alcance que reportan a un gateway propietario y de allí a la plataforma iMonnit.<br><br>Orientado a monitoreo remoto de instalaciones, equipos e infraestructura crítica en el mercado norteamericano.<br><br>Sensores con certificado de calibración y reglas de notificación configurables. | Sistema profesional de monitoreo y documentación de temperatura y humedad para industria alimentaria, farmacéutica y laboratorios.<br><br>Se entrega como proyecto llave en mano con instalación, calibración certificada y mantenimiento. |
| **Perfil de Marketing** | Ventaja competitiva: ¿Qué valor ofrece a los clientes? | Monitoreo continuo a un costo de entrada que la PyME puede aprobar.<br><br>Continuidad de la medición gracias al buffer del Edge Service.<br><br>Integración abierta: el dato llega al ERP que el cliente ya usa, en lugar de obligarlo a mirar un sistema más. | Precio bajo por dispositivo y ausencia de suscripción obligatoria para volúmenes pequeños.<br><br>Autonomía total del usuario: compra en línea, configura y opera sin intervención de terceros. | Confiabilidad y alcance: cobertura de naves e instalaciones amplias sin depender del WiFi del cliente.<br><br>Trazabilidad respaldada por certificados de calibración y un catálogo de sensores muy extenso. | Precisión metrológica certificada y evidencia documental aceptada por auditores y entes reguladores.<br><br>Respaldo de marca, servicio técnico y recalibración periódica. |
| **Perfil de Marketing** | Mercado objetivo | PyMEs de manufactura y almacenaje de Lima. Almacenes de insumos, centros de acopio y plantas de producción de pequeña y mediana escala. | Mercado global de consumo y pequeña empresa: hogares, invernaderos, servidores, tiendas, laboratorios pequeños.<br><br>Compra individual o por lotes reducidos, sin segmentación vertical fuerte. | Mediana y gran empresa de Norteamérica y Europa: facilities, retail, agricultura, salud e industria.<br><br>Clientes con equipo de TI o mantenimiento propio capaz de desplegar gateways. | Empresas reguladas de alimentos, farmacia, salud y logística de frío que deben demostrar cumplimiento (HACCP, buenas prácticas de almacenamiento, cadena de frío).<br><br>Predominantemente mediana y gran empresa. |
| **Perfil de Marketing** | Estrategias de marketing | Landing Page con calculadora de pérdidas evitadas y llamados a la acción diferenciados por segmento.<br><br>Marketing de contenidos en LinkedIn y grupos de logística y calidad del Perú.<br><br>Alianzas con asociaciones de PyMEs, cámaras de comercio y proveedores locales. | Venta en línea directa y a través de marketplaces internacionales.<br><br>Posicionamiento SEO por palabras clave de producto y comparativas.<br><br>Reseñas de usuarios y demostraciones en video. | Venta consultiva y red de distribuidores e integradores.<br><br>Casos de éxito por industria, webinars y material técnico descargable.<br><br>Presencia en ferias sectoriales. | Venta técnica mediante distribuidores autorizados.<br><br>Contenido de cumplimiento normativo, guías HACCP y capacitaciones.<br><br>Participación en ferias de alimentos, farmacéutica y metrología. |
| **Perfil de Producto** | Productos y servicios | Edge API que calibra, filtra y almacena localmente las lecturas.<br>RESTful API central de usuarios, plantas, zonas, umbrales, alertas e historial.<br>Web App de dashboard en tiempo real e historial.<br>Mobile App con alertas push.<br>Landing Page informativa. | Sensores multivariable con pantalla y batería.<br>Plataforma cloud con dashboard, alertas, exportación y reportes.<br>Apps iOS y Android.<br>API y automatizaciones tipo IFTTT. | Catálogo amplio de sensores inalámbricos ALTA.<br>Gateways ethernet y celulares.<br>Plataforma iMonnit con reglas, notificaciones y reportes.<br>API para integración y servicios de calibración NIST. | Sondas de temperatura y humedad radio y Ethernet.<br>Base de datos y software de análisis y documentación.<br>Servicios de instalación, mapeo térmico, calibración y validación.<br>Alarmas por correo, SMS y relé. |
| **Perfil de Producto** | Precios y costos | S/ 35–50 por punto de monitoreo como costo de hardware.<br><br>Suscripción mensual al servicio.<br><br>Instalación realizada por el propio personal del cliente con guía asistida. | Costo medio-bajo por dispositivo, con compra única.<br><br>Plan de plataforma gratuito con cuotas de almacenamiento y tráfico; planes de pago para mayor volumen y retención.<br><br>Costos adicionales de importación, flete y garantía internacional para el comprador peruano. | Costo por sensor superior al de la gama de consumo, más la inversión obligatoria en gateway.<br><br>Suscripción a iMonnit por niveles de servicio.<br><br>Sin presencia comercial directa en Perú: importación, aranceles y soporte remoto. | Inversión de sistema significativamente alta: sondas, base, software y servicio de puesta en marcha.<br><br>Costos recurrentes de recalibración y mantenimiento.<br><br>Fuera del alcance presupuestal de la PyME objetivo. |
| **Perfil de Producto** | Canales de distribución (Web y/o Móvil) | Landing Page propia.<br>Web App responsiva.<br>Mobile App Android/iOS.<br>Venta directa y alianzas locales. | Sitio web propio y tienda en línea.<br>Marketplaces internacionales.<br>Apps iOS y Android. | Sitio web propio.<br>Red de distribuidores e integradores.<br>Portal web iMonnit y app móvil. | Sitio web corporativo y distribuidores autorizados en Perú.<br>Software de escritorio y acceso web.<br>Fuerza de venta técnica presencial. |
| **Análisis FODA** | Fortalezas | Costo de entrada por punto sensiblemente menor al de cualquier alternativa importada.<br>Edge Computing propio: calibra, filtra y conserva las lecturas ante caídas de conexión.<br>API pública pensada desde el inicio para integrarse al ERP del cliente.<br>Equipo local: soporte en español, en horario de Perú y con visita presencial posible. | Precio de hardware muy competitivo.<br>Plataforma madura y probada, con app móvil consolidada.<br>Instalación inmediata sin técnico.<br>Multivariable en un solo dispositivo. | Alcance de radio superior al WiFi convencional.<br>Certificación NIST que respalda la medición.<br>Catálogo de sensores muy amplio.<br>Plataforma escalable con API documentada. | Precisión certificada y prestigio de marca.<br>Evidencia documental aceptada en auditorías reguladas.<br>Servicio integral: instalación, calibración y mantenimiento.<br>Distribución establecida en Perú. |
| **Análisis FODA** | Debilidades | Marca nueva y sin historial, lo que genera desconfianza inicial frente a fabricantes establecidos.<br>Sin certificado de calibración trazable en la primera versión.<br>Equipo reducido: capacidad limitada de soporte y de despliegue simultáneo.<br>Dependencia de servicios de terceros para notificaciones. | Si se cae la conexión, el histórico depende del almacenamiento del propio dispositivo.<br>Soporte y garantía desde el exterior; tiempos de reposición largos para el cliente peruano.<br>Integración con ERP no guiada. | Costo por punto elevado para la PyME peruana.<br>Dependencia de un gateway propietario que encarece el despliegue mínimo.<br>Sin canal ni soporte local en Perú.<br>Interfaz y documentación centradas en el mercado anglosajón. | Ciclo de venta e implementación largo.<br>Rigidez: sobredimensionado para un almacén de insumos pequeño. |
| **Análisis FODA** | Oportunidades | Segmento PyME desatendido y numeroso en Lima y provincias.<br>Presión creciente de clientes y auditores por evidencia de condiciones de almacenamiento.<br>Alianzas con proveedores de ERP locales para ofrecer el monitoreo como módulo complementario.<br>Expansión regional a mercados latinoamericanos con la misma brecha de precio. | Crecimiento del mercado de monitoreo doméstico y de pequeña empresa.<br>Entrada a verticales específicas mediante integradores locales. | Expansión hacia mercados emergentes vía distribuidores.<br>Crecimiento del monitoreo de infraestructura crítica y mantenimiento predictivo. | Endurecimiento de la regulación sanitaria y de cadena de frío.<br>Crecimiento de la agroexportación peruana, que exige trazabilidad certificada. |
| **Análisis FODA** | Amenazas | Un competidor establecido puede lanzar una línea de bajo costo con soporte local.<br>Volatilidad del tipo de cambio y de los precios de componentes importados.<br>Fuga de clientes hacia un fabricante certificado apenas la empresa entre a un mercado regulado. | Presión de fabricantes que ofrecen hardware equivalente aún más barato.<br>Cambios en las condiciones del plan gratuito que erosionen su propuesta. | Competencia de plataformas cloud generalistas con hardware genérico.<br>Barreras arancelarias y logísticas en mercados fuera de su red. | Aparición de alternativas de bajo costo que alcancen precisión suficiente para cumplir la norma.<br>Presión de precio en licitaciones de mediana empresa. |

### Objetivos SMART
> Contenido pendiente.

---

## [Capítulo I: Introducción](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#capítulo-i-introducción)

* [1.1. Startup Profile](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#11-startup-profile)
  * [1.1.1. Descripción de la Startup](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#111-descripción-de-la-startup)
  * [1.1.2. Perfiles de integrantes del equipo](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#112-perfiles-de-integrantes-del-equipo)
* [1.2. Solution Profile](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#12-solution-profile)
  * [1.2.1. Antecedentes y problemática](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#121-antecedentes-y-problemática)
  * [1.2.2. Lean UX Process](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#122-lean-ux-process)
    * [1.2.2.1. Lean UX Problem Statements](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#1221-lean-ux-problem-statements)
    * [1.2.2.2. Lean UX Assumptions](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#1222-lean-ux-assumptions)
    * [1.2.2.3. Lean UX Hypothesis Statements](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#1223-lean-ux-hypothesis-statements)
    * [1.2.2.4. Lean UX Canvas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#1224-lean-ux-canvas)
* [1.3. Segmentos objetivo](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter1-introduccion.md#13-segmentos-objetivo)

---

## [Capítulo II: Requirements Elicitation & Analysis](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#capítulo-ii-requirements-elicitation--analysis)

* [2.1. Competidores](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#21-competidores)
  * [2.1.1. Análisis competitivo](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#211-análisis-competitivo)
  * [2.1.2. Estrategias y tácticas frente a competidores](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#212-estrategias-y-tácticas-frente-a-competidores)
* [2.2. Entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#22-entrevistas)
  * [2.2.1. Diseño de entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#221-diseño-de-entrevistas)
  * [2.2.2. Registro de entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#222-registro-de-entrevistas)
  * [2.2.3. Análisis de entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#223-análisis-de-entrevistas)
* [2.3. Needfinding](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#23-needfinding)
  * [2.3.1. User Personas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#231-user-personas)
  * [2.3.2. User Task Matrix](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#232-user-task-matrix)
  * [2.3.3. User Journey Mapping](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#233-user-journey-mapping)
  * [2.3.4. Empathy Mapping](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#234-empathy-mapping)
* [2.4. Big Picture EventStorming](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#24-big-picture-eventstorming)
* [2.5. Ubiquitous Language](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter2-requirements-elicitation-analysis.md#25-ubiquitous-language)

---

## [Capítulo III: Requirements Specification](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter3-requirements-specification.md#capítulo-iii-requirements-specification)

* [3.1. User Stories](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter3-requirements-specification.md#31-user-stories)
* [3.2. Impact Mapping](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter3-requirements-specification.md#32-impact-mapping)
* [3.3. Product Backlog](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter3-requirements-specification.md#33-product-backlog)

---

## [Capítulo IV: Solution Software Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#capítulo-iv-solution-software-design)

* [4.1. Strategic-Level Domain-Driven Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#41-strategic-level-domain-driven-design)
  * [4.1.1. Design-Level EventStorming](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#411-design-level-eventstorming)
    * [4.1.1.1. Candidate Context Discovery](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4111-candidate-context-discovery)
    * [4.1.1.2. Domain Message Flows Modeling](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4112-domain-message-flows-modeling)
    * [4.1.1.3. Bounded Context Canvases](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4113-bounded-context-canvases)
  * [4.1.2. Context Mapping](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#412-context-mapping)
  * [4.1.3. Software Architecture](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#413-software-architecture)
    * [4.1.3.1. Software Architecture System Landscape Diagram](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4131-software-architecture-system-landscape-diagram)
    * [4.1.3.2. Software Architecture Context Level Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4132-software-architecture-context-level-diagrams)
    * [4.1.3.3. Software Architecture Container Level Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4133-software-architecture-container-level-diagrams)
    * [4.1.3.4. Software Architecture Deployment Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#4134-software-architecture-deployment-diagrams)
* [4.2. Tactical-Level Domain-Driven Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42-tactical-level-domain-driven-design)
  * [4.2.X. Bounded Context: `<Nombre del Bounded Context>`](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x-bounded-context-nombre-del-bounded-context)
    * [4.2.X.1. Domain Layer](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x1-domain-layer)
    * [4.2.X.2. Interface Layer](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x2-interface-layer)
    * [4.2.X.3. Application Layer](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x3-application-layer)
    * [4.2.X.4. Infrastructure Layer](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x4-infrastructure-layer)
    * [4.2.X.5. Bounded Context Software Architecture Component Level Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x5-bounded-context-software-architecture-component-level-diagrams)
    * [4.2.X.6. Bounded Context Software Architecture Code Level Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x6-bounded-context-software-architecture-code-level-diagrams)
      * [4.2.X.6.1. Bounded Context Domain Layer Class Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x61-bounded-context-domain-layer-class-diagrams)
      * [4.2.X.6.2. Bounded Context Database Design Diagram](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter4-solution-software-design.md#42x62-bounded-context-database-design-diagram)

---

## [Capítulo V: Solution UI/UX Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#capítulo-v-solution-uiux-design)

* [5.1. Style Guidelines](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#51-style-guidelines)
  * [5.1.1. General Style Guidelines](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#511-general-style-guidelines)
  * [5.1.2. Web, Mobile and IoT Style Guidelines](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#512-web-mobile-and-iot-style-guidelines)
* [5.2. Information Architecture](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#52-information-architecture)
  * [5.2.1. Organization Systems](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#521-organization-systems)
  * [5.2.2. Labeling Systems](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#522-labeling-systems)
  * [5.2.3. SEO Tags and Meta Tags](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#523-seo-tags-and-meta-tags)
  * [5.2.4. Searching Systems](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#524-searching-systems)
  * [5.2.5. Navigation Systems](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#525-navigation-systems)
* [5.3. Landing Page UI Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#53-landing-page-ui-design)
  * [5.3.1. Landing Page Wireframe](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#531-landing-page-wireframe)
  * [5.3.2. Landing Page Mock-up](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#532-landing-page-mock-up)
* [5.4. Applications UX/UI Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#54-applications-uxui-design)
  * [5.4.1. Applications Wireframes](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#541-applications-wireframes)
  * [5.4.2. Applications Wireflow Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#542-applications-wireflow-diagrams)
  * [5.4.3. Applications Mock-ups](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#543-applications-mock-ups)
  * [5.4.4. Applications User Flow Diagrams](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#544-applications-user-flow-diagrams)
* [5.5. Applications Prototyping](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#55-applications-prototyping)
* [5.6. IoT Device Design](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter5-solution-ui-ux-design.md#56-iot-device-design)

---

## [Capítulo VI: Product Implementation, Validation & Deployment](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#capítulo-vi-product-implementation-validation--deployment)

* [6.1. Software Configuration Management](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#61-software-configuration-management)
  * [6.1.1. Software Development Environment Configuration](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#611-software-development-environment-configuration)
  * [6.1.2. Source Code Management](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#612-source-code-management)
  * [6.1.3. Source Code Style Guide & Conventions](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#613-source-code-style-guide--conventions)
  * [6.1.4. Software Deployment Configuration](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#614-software-deployment-configuration)
* [6.2. Landing Page, Services & Applications Implementation](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62-landing-page-services--applications-implementation)
  * [6.2.X. Sprint n](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x-sprint-n)
    * [6.2.X.1. Sprint Planning n](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x1-sprint-planning-n)
    * [6.2.X.2. Aspect Leaders and Collaborators](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x2-aspect-leaders-and-collaborators)
    * [6.2.X.3. Sprint Backlog n](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x3-sprint-backlog-n)
    * [6.2.X.4. Development Evidence for Sprint Review](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x4-development-evidence-for-sprint-review)
    * [6.2.X.5. Testing Suite Evidence for Sprint Review](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x5-testing-suite-evidence-for-sprint-review)
    * [6.2.X.6. Execution Evidence for Sprint Review](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x6-execution-evidence-for-sprint-review)
    * [6.2.X.7. Services Documentation Evidence for Sprint Review](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x7-services-documentation-evidence-for-sprint-review)
    * [6.2.X.8. Software Deployment Evidence for Sprint Review](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x8-software-deployment-evidence-for-sprint-review)
    * [6.2.X.9. Team Collaboration Insights during Sprint](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#62x9-team-collaboration-insights-during-sprint)
* [6.3. Validation Interviews](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#63-validation-interviews)
  * [6.3.1. Diseño de Entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#631-diseño-de-entrevistas)
  * [6.3.2. Registro de Entrevistas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#632-registro-de-entrevistas)
  * [6.3.3. Evaluaciones según heurísticas](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#633-evaluaciones-según-heurísticas)
* [6.4. Video About-the-Product](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/chapter6-product-implementation-validation-deployment.md#64-video-about-the-product)

---

## Conclusiones

* [Conclusiones y recomendaciones](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/conclusiones.md#conclusiones-y-recomendaciones)
* [Video About-the-Team](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/conclusiones.md#video-about-the-team)

---

## [Bibliografía y Anexos](https://github.com/MachineGuard/MachineGuard-Documentation/blob/main/docs/bibliografia-anexos.md)

---

## Estructura del repositorio

```
docs/
├── 00-portada.md
├── chapter1-introduccion.md
├── chapter2-requirements-elicitation-analysis.md
├── chapter3-requirements-specification.md
├── chapter4-solution-software-design.md
├── chapter5-solution-ui-ux-design.md
├── chapter6-product-implementation-validation-deployment.md
├── conclusiones.md
└── bibliografia-anexos.md
assets/
└── img/
    ├── introduction/   # logo UPC y capturas de la portada
    ├── chapter-1/
    ├── chapter-2/
    ├── chapter-3/
    ├── chapter-4/
    ├── chapter-5/
    └── chapter-6/
```

Cada imagen o diagrama que agregues a una sección va en `assets/img/chapter-N/` correspondiente, y se enlaza desde el `.md` del capítulo con ruta relativa, por ejemplo:

```markdown
![Nombre de la imagen](../assets/img/chapter-2/nombre-imagen.png)
```

## Flujo de trabajo con ramas

Ver [CONTRIBUTING.md](CONTRIBUTING.md).

