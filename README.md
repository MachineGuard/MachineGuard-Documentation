# Documentación del Proyecto — Solución IoT de Monitoreo Ambiental

Documentación funcional y técnica del proyecto del curso **1ASI0572 — Desarrollo de Soluciones IoT** (UPC): una startup que ofrece monitoreo ambiental (temperatura/humedad) como servicio para plantas y almacenes industriales, mediante un dispositivo físico (ESP32 + DHT11/DHT22), landing page, aplicación web, aplicación móvil, API RESTful, Edge API y aplicación embebida.

## Estructura

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
```

Un `.md` por capítulo con las secciones ya tituladas (marcadas con `> Contenido pendiente.`). Se completan directamente ahí.

## Flujo de trabajo con ramas

- **`main`** — rama base, contiene el esqueleto de todos los capítulos.
- **`develop`** — rama de integración, sale de `main`.
- **`docs/chapterN`** (N = 1 a 6) — una por capítulo, salen de `develop`. Cada integrante crea su propia rama a partir de `docs/chapterN` para la sección que le toca (ej. `docs/chapter1/1.2-solution-profile`), y hace PR hacia `docs/chapterN`.
- **`docs/conclusiones`** — igual que las anteriores, sale de `develop`.
- **`entregable`** — sale de `main`, se usa para preparar la versión final que se entrega.

Cuando un capítulo está completo, se mergea `docs/chapterN` → `develop`, y periódicamente `develop` → `main`.

## Convención de commits

- `docs(chapterN): <qué se agregó>` — ej. `docs(chapter2): agregar needfinding y user personas`

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para más detalle.
