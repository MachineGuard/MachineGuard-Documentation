# Bibliografía y Anexos

## Bibliografía

### Metodologías y marcos de referencia

- Adzic, G. (2012). *Impact mapping: Making a big impact with software products and projects*. Provoking Thoughts.
- Brandolini, A. (2021). *Introducing EventStorming: An act of deliberate collective learning*. Leanpub. https://leanpub.com/introducing_eventstorming
- Brown, S. (2024). *The C4 model for visualising software architecture*. https://c4model.com
- Evans, E. (2003). *Domain-driven design: Tackling complexity in the heart of software*. Addison-Wesley.
- Gothelf, J., & Seiden, J. (2016). *Lean UX: Designing great products with agile teams* (2nd ed.). O'Reilly Media.
- North, D. (2006). *Introducing BDD*. https://dannorth.net/introducing-bdd/
- Schwaber, K., & Sutherland, J. (2020). *The Scrum guide*. https://scrumguides.org
- Vernon, V. (2013). *Implementing domain-driven design*. Addison-Wesley.

### Competidores analizados (Capítulo II)

- Monnit Corporation. (s. f.). *iMonnit wireless sensor platform*. https://www.monnit.com
- Testo SE & Co. KGaA. (s. f.). *Testo Saveris monitoring system*. https://www.testo.com/en/saveris
- UbiBot Ltd. (s. f.). *UbiBot IoT platform*. https://www.ubibot.com

### Documentación técnica y herramientas

- Angular Team. (s. f.). *Angular documentation*. https://angular.dev
- Aosong Electronics. (s. f.). *AM2302 (DHT22) product manual*. Hoja de datos del sensor utilizado en el prototipo.
- Cucumber. (s. f.). *Cucumber documentation*. https://cucumber.io/docs
- Espressif Systems. (s. f.). *ESP32 technical reference*. https://docs.espressif.com
- Flyway. (s. f.). *Flyway documentation*. https://flywaydb.org/documentation/
- MathWorks. (s. f.). *ThingSpeak documentation*. https://www.mathworks.com/help/thingspeak/
- Miro. (s. f.). *Miro help center*. https://help.miro.com
- OpenWeatherMap. (s. f.). *OpenWeatherMap API documentation*. https://openweathermap.org/api *(integración prevista, no implementada)*
- Pallets Projects. (s. f.). *Flask documentation*. https://flask.palletsprojects.com
- Peewee. (s. f.). *Peewee documentation*. https://docs.peewee-orm.com
- PlantUML. (s. f.). *PlantUML language reference guide*. https://plantuml.com
- PostgreSQL Global Development Group. (s. f.). *PostgreSQL documentation*. https://www.postgresql.org/docs/
- Spring. (s. f.). *Spring Boot reference documentation*. https://docs.spring.io/spring-boot/
- Springdoc. (s. f.). *springdoc-openapi documentation*. https://springdoc.org
- Twilio. (s. f.). *Twilio docs*. https://www.twilio.com/docs *(servicio considerado para la notificación externa)*
- Wokwi. (s. f.). *Wokwi documentation*. https://docs.wokwi.com

### Seguridad y estándares

- Jones, M., Bradley, J., & Sakimura, N. (2015). *JSON Web Token (JWT)* (RFC 7519). https://www.rfc-editor.org/rfc/rfc7519
- Provos, N., & Mazières, D. (1999). A future-adaptable password scheme. En *USENIX Annual Technical Conference*.

### Fuentes institucionales y estadísticas

- Cámara de Comercio de Lima. (s. f.). https://www.camaralima.org.pe
- Sociedad Nacional de Industrias. (s. f.). https://www.sni.org.pe

## Anexos


### Anexo A. Repositorios

Todos los repositorios de la organización [MachineGuard](https://github.com/MachineGuard) son públicos. `main` y `develop` están protegidas contra force push y borrado.

| Repositorio | Contenido | Versión publicada |
|---|---|---|
| [MachineGuard-Documentation](https://github.com/MachineGuard/MachineGuard-Documentation) | Informe | `v0.3.1` |
| [MachineGuard-LandingPage](https://github.com/MachineGuard/MachineGuard-LandingPage) | Landing Page | `v0.3.0` |
| [machineguard-web](https://github.com/MachineGuard/machineguard-web) | Web Application (Angular) | `v0.3.0` |
| [machineguard-core-api](https://github.com/MachineGuard/machineguard-core-api) | Core API (Spring Boot) | `v0.3.0` |
| [machineguard-edge-api](https://github.com/MachineGuard/machineguard-edge-api) | Edge API (Flask) | `v0.3.0` |
| [machineguard-embedded](https://github.com/MachineGuard/machineguard-embedded) | Firmware ESP32 | `v0.3.0` |
| [machineguard-mobile](https://github.com/MachineGuard/machineguard-mobile) | Mobile Application (Kotlin) | `v0.3.0` |

**Cuentas de GitHub del equipo**

| Integrante | Cuenta |
|---|---|
| Lecca Villalobos, Pedro Omar | [leccapedro](https://github.com/leccapedro) |
| Bautista Rivera, Jose Diego | [Gogotes17](https://github.com/Gogotes17) |
| Espinoza Vivas, Camilla Leonor | [C7leo](https://github.com/C7leo) |
| Seijas Vasquez, Diego | [NotSeijas](https://github.com/NotSeijas) |
| Medina Chocce, Karito Dianeth | [Karito07](https://github.com/Karito07) |
| Dinklange Arevalo, Sandro | [Sandro0406](https://github.com/Sandro0406) |
| Janampa Gutierrez, Jhoan Darner | [orraiAKBDFSK](https://github.com/orraiAKBDFSK) |

La cuenta `kisohi` tiene un solo commit (`9c8d93e`, esqueleto inicial del informe, 02/09/2026), hecho por error desde otra cuenta por uno de los dos integrantes llamados Diego.

### Anexo B. Productos desplegados

| Producto | URL | Evidencia de publicación |
|---|---|---|
| Landing Page | https://machineguard.github.io/MachineGuard-LandingPage/ | [Publicación en Actions](https://github.com/MachineGuard/MachineGuard-LandingPage/actions/runs/44440640183). La Landing enlaza a la Web y al APK. |
| Web Application | https://machineguard.github.io/machineguard-web/ | [Publicación en Actions](https://github.com/MachineGuard/machineguard-web/actions/runs/44436362381). Se verificó el funcionamiento desde la URL pública con la API de Core en Render. |
| Core API | https://machineguard-core-api.onrender.com | [Configuración de despliegue](https://github.com/MachineGuard/machineguard-core-api/blob/main/render.yaml). El servicio se suspende por inactividad. |
| APK Android | https://github.com/MachineGuard/machineguard-mobile/releases/tag/v0.3.0 | Release con el archivo `machineguard-v0.3.0.apk` descargable. |

### Anexo C. Videos

| Video | Enlace |
|---|---|
| Entrevistas de Needfinding (Capítulo II) | [Ver video](https://drive.google.com/file/d/13Pha_spQWC_6IIfaZfrd7LD-2FS-f7rX/view?usp=sharing) |
| Navegación del prototipo (Capítulo V) | [Ver video](https://upcedupe-my.sharepoint.com/:v:/g/personal/u20221c769_upc_edu_pe/IQC6PViuipT0TrUXiLQH_pu6AUBNrSC7YTR562kBo-MqL_M?e=Y3tVcr) |
| Entrevistas de validación (Capítulo VI) | [Ver video](https://drive.google.com/file/d/1EYZ_WXwRtM_y5QOnGHrQimO58jXzuP0h/view?usp=sharing) |
| About-the-Product | Pendiente |
| About-the-Team | Pendiente |
| Exposiciones | Pendiente |

### Anexo D. Consentimientos

Esta versión del informe aún no incorpora los consentimientos para grabar las entrevistas y utilizar las respuestas.

### Anexo E. Evidencia de simulación del Sensor Node

En Wokwi se comprobó el arranque del firmware, la sincronización horaria por NTP y la persistencia del contador en NVS tras reiniciar. Durante la prueba de comunicación, Edge no recibió lecturas del nodo simulado. La validación física requiere fotografías del prototipo, lecturas del sensor, evidencia de calibración y el registro del nodo en Edge (TS10 y TS11). [Circuito de Wokwi](https://github.com/MachineGuard/machineguard-embedded/blob/main/simulation/diagram.json) · [Guía de simulación](https://github.com/MachineGuard/machineguard-embedded/blob/main/docs/simulacion-wokwi.md)
