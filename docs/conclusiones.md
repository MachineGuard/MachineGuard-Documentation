# Conclusiones

## Conclusiones y recomendaciones

### Conclusiones

El avance del proyecto hasta el AV1 confirma que la problemática que originó MachineGuard está validada con evidencia de campo, no solo con supuestos de equipo. En las entrevistas al segmento Jefe de Almacén, el 100% de los entrevistados reportó pérdida efectiva de mercadería por detección tardía de desviaciones ambientales, y el 50% opera con termohigrómetros averiados o sin calibrar. Esto sostiene la decisión de diseño central del producto: el valor no está en medir temperatura y humedad, sino en detectar y notificar una desviación sin necesidad de presencia humana, que es exactamente el problema que ninguna ronda manual resuelve.

El Capítulo III tradujo esa validación en compromisos medibles. Los cuatro Business Goals —atención de alertas en menos de cinco minutos (BG01), reducción del 70% en el tiempo de preparación de trazabilidad (BG02), reducción del 20% en mermas por desviaciones (BG03) y cinco solicitudes de piloto en ocho semanas (BG04)— dan al equipo una vara concreta contra la cual evaluar el producto en el AV2, en vez de descripciones cualitativas de "mejorar el monitoreo".

El Capítulo IV mostró que el diseño estratégico no puede darse por cerrado solo porque el Big Picture EventStorming del Capítulo II ya identificó los flujos del dominio. El Bounded Context IAM no apareció en el diseño inicial, y solo se hizo visible al preguntar explícitamente quién era dueño de la decisión de negocio de acceso multi-tenant, una pregunta distinta a "qué eventos ocurren en el dominio". Esa misma lógica —revisar decisiones de negocio sin dueño, no solo eventos sin agrupar— es la que debe aplicarse antes de dar por cerrado el diseño táctico de cada contexto en las siguientes entregas.

Mantener el mismo Ubiquitous Language desde el glosario del Capítulo II hasta los diagramas de clases del Capítulo IV fue determinante para que el informe se lea como un solo sistema documentado por siete personas, y no como siete documentos independientes. Los BC Canvases funcionaron como fuente de verdad: escribirlos antes del tablero de EventStorming en Miro evitó que el tablero visual y el texto del informe divergieran en el nombre de un evento o un comando.

### Recomendaciones para el AV2

- **Cerrar el segmento 2 de entrevistas** (Encargados de Control de Calidad) en el Capítulo II antes de avanzar más contenido de diseño que dependa de ese segmento, ya que hoy solo el segmento Jefe de Almacén tiene entrevistas registradas y analizadas.
- **Completar los perfiles de integrantes pendientes** en el Capítulo I con la información de conocimientos y habilidades de cada miembro.
- **Iniciar el Capítulo V (Solution UI/UX Design)** partiendo de los BC Canvases y Read Models ya definidos en el Capítulo IV, ya que estos ya identifican qué necesita ver cada actor antes de ejecutar un comando, insumo directo para las pantallas.
- **Validar BG04 (adquisición de pilotos) tempranamente**, dado que depende del Landing Page y no del desarrollo del producto de monitoreo, por lo que puede publicarse y empezar a medirse en paralelo al resto del trabajo técnico.
- **Auditar la sección 4.2 (diseño táctico)** contra los Bounded Context Canvases de la sección 4.1 antes del TB1, verificando que los comandos y eventos usados en las cuatro capas de cada contexto coincidan exactamente con los definidos en el canvas correspondiente.

## Video About-the-Team

> Contenido pendiente — corresponde a la entrega TB1 (semana 7), junto con el resto de la evidencia de Sprints y despliegue del Capítulo VI. Aún no se ha grabado.
