# Conclusiones

## Conclusiones y recomendaciones

### Conclusiones

El avance del proyecto hasta el AV1 confirma que la problemática que originó MachineGuard tiene un primer respaldo en evidencia de campo, no solo en supuestos de equipo; la validación sigue abierta, con dos entrevistas por segmento. En las entrevistas al segmento Jefe de Almacén, el 100% de los dos entrevistados del segmento reportó pérdida efectiva de mercadería por detección tardía de desviaciones ambientales, y el 50% opera con termohigrómetros averiados o sin calibrar. Esto sostiene la decisión de diseño central del producto: el valor no está en medir temperatura y humedad, sino en detectar y notificar una desviación sin necesidad de presencia humana, que es exactamente el problema que ninguna ronda manual resuelve.

El Capítulo III tradujo esa validación en compromisos medibles. Los cuatro Business Goals —atención de alertas en menos de cinco minutos (BG01), reducción del 70% en el tiempo de preparación de trazabilidad (BG02), reducción del 20% en mermas por desviaciones (BG03) y cinco solicitudes de piloto en ocho semanas (BG04)— dan al equipo una vara concreta contra la cual evaluar el producto en el AV2, en vez de descripciones cualitativas de "mejorar el monitoreo". Ninguno de los cuatro objetivos se ha medido a la fecha de cierre de este informe.

El Capítulo IV mostró que el diseño estratégico no puede darse por cerrado solo porque el Big Picture EventStorming del Capítulo II ya identificó los flujos del dominio. El Bounded Context IAM no apareció en el diseño inicial, y solo se hizo visible al preguntar explícitamente quién era dueño de la decisión de negocio de acceso multi-tenant, una pregunta distinta a "qué eventos ocurren en el dominio". Esa misma lógica —revisar decisiones de negocio sin dueño, no solo eventos sin agrupar— es la que debe aplicarse antes de dar por cerrado el diseño táctico de cada contexto en las siguientes entregas.

Mantener el mismo Ubiquitous Language desde el glosario del Capítulo II hasta los diagramas de clases del Capítulo IV fue determinante para que el informe se lea como un solo sistema documentado por siete personas, y no como siete documentos independientes. Los BC Canvases funcionaron como fuente de verdad: escribirlos antes del tablero de EventStorming en Miro evitó que el tablero visual y el texto del informe divergieran en el nombre de un evento o un comando.

#### Avance AV2

Al cierre del Sprint 3, el recorrido central del producto funciona de extremo a extremo con datos sintéticos: una lectura fuera de rango genera un incidente con su alerta, el operador la reconoce desde la Web o desde la aplicación móvil, registra una acción correctiva y solo puede resolverla cuando la lectura vuelve al rango. Esto respalda la parte del Problem Statement referida a detectar y atender una desviación sin rondas manuales. La Hipótesis 3 (respuesta en menos de cinco minutos) todavía no puede evaluarse: la notificación al celular por SMS o WhatsApp y el escalamiento quedaron fuera de AV2, y sin ellos el tiempo de atención depende de que alguien tenga abierta la aplicación.

Las cuatro entrevistas de validación, dos por segmento, confirman los User Assumptions principales. Los dos Jefes de Almacén identificaron de inmediato la zona fuera de rango y ambos pidieron que la alerta llegue al celular o a otras personas, lo que coincide con su preferencia por notificaciones automáticas frente a la revisión manual. Uno prefiere revisar desde la computadora y otro desde el celular, lo que justifica mantener la Web y la aplicación móvil sobre la misma API. Los dos Encargados de Control de Calidad consideraron que el historial y las acciones correctivas servirían como evidencia ante una auditoría y estimaron un ahorro de un día al mes y de varias horas a la semana, respectivamente, en la preparación de registros. Ese ahorro apoya la dirección de BG02, aunque la reducción del 70% aún no se ha medido.

Las entrevistas también corrigieron supuestos del equipo. La evidencia de auditoría no basta con registrar la acción: los entrevistados pidieron ver quién la registró y a qué hora, el nombre de quien aprueba una liberación y reportes por lote. El término "excursión", tomado del modelo de dominio, confundió a un usuario que en su trabajo dice "desviación", lo que muestra que el Ubiquitous Language debe contrastarse con el vocabulario del usuario y no solo con el del equipo. Ningún entrevistado mencionó la integración con un ERP, por lo que el supuesto de que la API pública es el diferenciador clave (Hipótesis 4) sigue sin evidencia.

En cuanto al hardware, el núcleo de un nodo (ESP32 DevKit V1 y DHT22) costó S/ 42,50, dentro del rango de S/ 35 a 50 por punto que asumía el modelo de negocio; el resto de la compra corresponde a componentes de montaje del prototipo. El firmware está probado en simulación y Edge conserva y reenvía las lecturas sin duplicarlas cuando se pierde la confirmación de Core, lo que sostiene la Hipótesis 2 en software. La calibración y la confiabilidad con el sensor físico siguen pendientes de la prueba con el hardware, que llegó el 11 de noviembre de 2026.

En el proceso de trabajo, los Sprints 2 y 3 mostraron el mismo patrón: las entregas paralelas solo encajaron después de acordar los contratos. En el Sprint 2, las entregas de alertas e incidentes tenían modelos duplicados y no arrancaban juntas; en el Sprint 3, la capa de datos de Mobile publicó primero sus interfaces y las pantallas se integraron sobre ellas, aunque algunas llegaron con datos simulados que hubo que reemplazar.

### Recomendaciones para el Trabajo Final

- **Implementar la notificación al celular y el escalamiento** de alertas no atendidas, y medir el tiempo entre la alerta y su reconocimiento para evaluar la Hipótesis 3 y BG01.
- **Desplegar la API central y la Web en un entorno público**, de modo que las solicitudes de piloto del Landing Page lleguen al sistema y BG04 pueda medirse.
- **Validar el Sensor Node con el hardware físico** (TS10 y TS11): lecturas reales, calibración en Edge y registro del nodo con su credencial.
- **Atender los hallazgos de la evaluación heurística**: mostrar en cada acción correctiva su autor y su hora, usar "desviación" como etiqueta visible, agregar un ejemplo del código del sensor y ofrecer acciones correctivas frecuentes para elegir. Dos hallazgos ya se atendieron en el Sprint 3: el detalle del incidente muestra el tiempo transcurrido y el motivo por el que aún no se puede resolver.
- **Completar la validación** con un tercer usuario por segmento y con tareas sobre la aplicación móvil.
- **Grabar los videos About-the-Product y About-the-Team**, y publicar el primero en el Landing Page.
- **Preguntar explícitamente por la integración con ERP** en las siguientes entrevistas antes de invertir más en la API pública.

### Recomendaciones del AV1

Las recomendaciones siguientes corresponden a la versión AV1 y se mantienen como referencia histórica; la primera ya se refleja en el Capítulo II.

- **Cerrar el segmento 2 de entrevistas** (Encargados de Control de Calidad) en el Capítulo II antes de avanzar más contenido de diseño que dependa de ese segmento, ya que hoy solo el segmento Jefe de Almacén tiene entrevistas registradas y analizadas.
- **Completar los perfiles de integrantes pendientes** en el Capítulo I con la información de conocimientos y habilidades de cada miembro.
- **Iniciar el Capítulo V (Solution UI/UX Design)** partiendo de los BC Canvases y Read Models ya definidos en el Capítulo IV, ya que estos ya identifican qué necesita ver cada actor antes de ejecutar un comando, insumo directo para las pantallas.
- **Validar BG04 (adquisición de pilotos) tempranamente**, dado que depende del Landing Page y no del desarrollo del producto de monitoreo, por lo que puede publicarse y empezar a medirse en paralelo al resto del trabajo técnico.
- **Auditar la sección 4.2 (diseño táctico)** contra los Bounded Context Canvases de la sección 4.1 antes del TB1, verificando que los comandos y eventos usados en las cuatro capas de cada contexto coincidan exactamente con los definidos en el canvas correspondiente.

**Pendientes vigentes.** Los videos About-the-Product (sección 6.4) y About-the-Team siguen pendientes. La notificación dirigida y el escalamiento de alertas quedaron planificados para el Trabajo Final.

## Video About-the-Team

> Contenido pendiente. El video aún no se ha grabado.
