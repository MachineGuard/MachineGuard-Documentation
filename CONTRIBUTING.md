# Contribuir a esta documentación

## Flujo de trabajo

1. Ubica el archivo de tu capítulo en `docs/` (ej. `docs/chapter2-requirements-elicitation-analysis.md`).
2. Crea tu rama desde `develop` actualizado, con el capítulo y la sección en el nombre:
   ```bash
   git checkout develop
   git pull
   git checkout -b docs/chapter2-needfinding
   ```
3. Edita solo las secciones que te corresponden dentro del archivo del capítulo. No borres las secciones de tus compañeros aunque estén como "Contenido pendiente.".
4. Si agregas imágenes o diagramas, colócalas en `assets/img/chapter-N/` (según el capítulo que corresponda) y enlázalas con rutas relativas desde el `.md`, por ejemplo:
   ```markdown
   ![Nombre de la imagen](../assets/img/chapter-2/nombre-imagen.png)
   ```
   Las imágenes de la portada (logo UPC, capturas del README principal) van en `assets/img/introduction/`.
5. Sube tu rama y abre un Pull Request hacia `develop`.
6. Cuando se apruebe y se haga merge, borra la rama (botón "Delete branch" en GitHub y `git branch -d` en tu equipo).
7. Para cada entrega, `develop` se integra en `main`.

## Convenciones

- Cada archivo de capítulo mantiene la numeración del índice como encabezados (`##`, `###`, `####`).
- Al completar una sección, borra la línea `> Contenido pendiente.` de esa sección.
- Las secciones que se repiten (`4.2.X` por Bounded Context, `6.2.X` por Sprint) se duplican dentro del mismo archivo, renumerando correlativamente.
- Mensajes de commit: `docs(chapterN): <qué se agregó>`.
