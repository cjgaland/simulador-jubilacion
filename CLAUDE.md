# Simulador de Jubilación

## Qué es
App web pública para calcular **cuándo y con cuánto** se jubila uno en el Régimen General de la
Seguridad Social (ordinaria, anticipada voluntaria y demorada +1…+5 años), normativa 2026.
Pensada para compartir con compañeros (médicos del SAS). Autor: **Carlos J. Galán Doval**.

- **En vivo:** https://cjgaland.github.io/simulador-jubilacion/
- **Repo:** https://github.com/cjgaland/simulador-jubilacion (público, rama `main`, GitHub Pages desde `/`).
- **Carpeta local:** `~/Desktop/Simulador Jubilación/`

## Stack
- **Un solo fichero** `index.html` (HTML + CSS + JS vanilla), sin dependencias ni compilación.
  Solo carga fuentes de Google Fonts (Fraunces + Inter).
- Todo se calcula en el navegador; los datos del usuario solo se guardan en su `localStorage`
  (clave `simJubMisDatos`). Nada sale del dispositivo.
- PWA: `manifest.webmanifest` + iconos + `sw.js` (service worker **«primero la red»**: con conexión
  siempre sirve lo último y guarda copia; sin conexión usa la copia). `version.json` nunca se cachea.
  Si se añaden ficheros nuevos que deban ir offline, añadirlos a `CORE` en `sw.js` y subir `CACHE`.

## Funciones principales
- Escenarios: anticipada (voluntaria o **involuntaria**, selector `#segEarly`, estado `S.early`),
  ordinaria y demorada +1…+5. Involuntaria: art. 207 LGSS, tabla `COEF_INV` (48 meses × 4 tramos),
  edad legal «de haber seguido cotizando» (`ORDC`), mínimo 33 años, tope = máxima −0,5 %/trimestre.
- **Informe PDF** (`buildReport()`, `#report`): se imprime solo el informe (clase `report-mode` +
  `@media print`); también con Ctrl/Cmd+P si hay datos.
- **Compartir escenario**: enlace `…/#d=<base64url(JSON)>`; al abrirlo se aplican los datos
  (saneados en `cleanShared`), no se guardan y se limpia la URL.
- **Ejemplos**: `DEMOS` (3 perfiles ficticios que se alternan).

## Estructura de la página
Cabecera (tema, Nuevo, Restablecer, Guardar, Imprimir) → **Portada** (icono grande, título,
descripción, «Creado por Carlos J. Galán Doval – Ver. XX.YY – 2026») → **menú fijo de apartados**:
Datos (`#datos`), ¿Cuándo jubilarte? (`#mainCard`), Gráfico (`#grafico`), Desglose (`#detail`),
Requisitos (`#requisitos`), Ayuda (`#ayuda`, con pestañas: Cómo usarla, Datos que necesitas,
Instalar y actualizar, Fuentes oficiales, Versiones).

## Paleta
Fondo `#f5f2ec`, azul marino `#1f3a5f` → `#12243d`, dorado `#a8844d`, verde `#3d7a58`, rojo `#a9503a`
(variables CSS en `:root`, con modo oscuro). Icono: reloj crema con arco dorado de línea temporal
sobre degradado azul marino (`favicon.svg`; PNG generados desde él).

## Reglas
- **No cambiar los cálculos** (bloque «Normativa» y `scenario()` del JS) sin que Carlos lo pida.
- **Nunca datos reales de Carlos** en el código ni en el historial de git: el repo es público.
  (El 25/09/2026 se reescribió el historial para eliminarlos.) Los ejemplos son siempre ficticios.
- Textos en español de España.

## Versionado
- Formato **`XX.YY`** (empieza en `01.00`): cambios menores → `01.01`, cambios grandes → `02.00`.
- La versión vive en **4 sitios que deben coincidir**:
  1. `const APP_VERSION` en `index.html`.
  2. Nueva entrada **arriba** en `CHANGES` (`index.html`) → aparece en Ayuda › Versiones y en la
     ventana «Novedades de la versión…» que ven los usuarios tras actualizar.
  3. `version.json` → `{ "version": "XX.YY" }`.
  4. `CHANGELOG.md`.
- **Aviso de actualización** (como en Nuestras Cosas / Testamentaría / Abuelos): la app consulta
  `version.json` (sin caché) al abrir, cada 60 s y al volver a la pestaña. Si es mayor que
  `APP_VERSION`, sale la tarjeta «✨ Ha habido cambios · Actualizar», que recarga con `?v=XX.YY`
  para saltarse la caché. Al cargar la versión nueva se muestran sus novedades una vez
  (`localStorage` `simJubUltimaVersionVista`).

## «Despliega»
Cuando Carlos diga **«Despliega»**:
1. Sube la versión y rellena las novedades en los 4 sitios de arriba (en lenguaje sencillo, para usuarios).
2. Ejecuta `bash scripts/despliega.sh "Mensaje del commit"`: comprueba que las versiones coinciden,
   hace la **copia de seguridad** local, commit y push a `main`. GitHub Pages publica solo en 1-2 min.
3. Comprueba que `https://cjgaland.github.io/simulador-jubilacion/version.json` ya da la versión nueva.

## Copias de seguridad locales
Sistema de respaldo local con rotación (carpeta `Backup/`, ignorada en git):

- Cada copia es una carpeta `Backup/Copia_Seguridad_SimuladorJubilacion_DD_MM_YYYY-HH_MM` con el
  proyecto completo (rsync -a), excluyendo `Backup`, `.git` y datos personales/secretos (`*.csv`, `.env*`).
- Se conservan solo las **5 copias más recientes**; al crear una nueva se borra la más antigua.
- Disparadores: **«Haz una copia» / «Copia de seguridad»** →
  `bash scripts/copia_seguridad.sh --name SimuladorJubilacion`; y siempre al desplegar.
- Script: `scripts/copia_seguridad.sh` (copia de la skill personal `app-copia_seguridad`).

## Iconos
Si se cambia `favicon.svg`, regenerar los PNG (32, 180, 192, 512) con versión a sangre (sin
esquinas redondeadas) para `apple-touch-icon.png`, `icon-192.png` e `icon-512.png`. En este Mac
Chrome headless se cuelga; funciona un script Swift con `NSImage` (lee SVG nativo) → PNG.

## Ideas pendientes (propuestas a Carlos)
- (Hechas en 01.01: anticipada involuntaria, informe PDF, compartir por enlace, modo sin conexión.)
