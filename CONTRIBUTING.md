# Contribuir a esta documentación

## Flujo de trabajo

1. Ubica el archivo de tu capítulo en `docs/` (ej. `docs/chapter2-requirements-elicitation-analysis.md`).
2. Párate sobre la rama `docs/chapterN` correspondiente y crea tu propia rama para la sección que te toca:
   ```bash
   git checkout docs/chapter2
   git pull
   git checkout -b docs/chapter2/2.3-needfinding
   ```
3. Edita solo las secciones que te corresponden dentro del archivo del capítulo. No borres las secciones de tus compañeros aunque estén como "Contenido pendiente.".
4. Si agregas imágenes o diagramas, colócalas en `docs/assets/chapterN/` y enlázalas con rutas relativas.
5. Abre un Pull Request hacia `docs/chapterN` (no directo a `develop` ni a `main`).
6. Cuando el capítulo esté completo, se mergea `docs/chapterN` → `develop`, y luego `develop` → `main`.

## Convenciones

- Cada archivo de capítulo mantiene la numeración del índice como encabezados (`##`, `###`, `####`).
- Al completar una sección, borra la línea `> Contenido pendiente.` de esa sección.
- Las secciones que se repiten (`4.2.X` por Bounded Context, `6.2.X` por Sprint) se duplican dentro del mismo archivo, renumerando correlativamente.
- Mensajes de commit: `docs(chapterN): <qué se agregó>`.
