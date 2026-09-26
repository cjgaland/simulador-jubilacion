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
  ordinaria y demorada +1…+5. En **ambas** anticipadas la edad legal de referencia es la «de haber
  seguido cotizando» (`ORDC`, arts. 207.2 y 208.2 LGSS; corregido en 01.03 con permiso de Carlos).
  Voluntaria: hasta 24 meses, 35 años, tabla `COEF`. Involuntaria: hasta 48 meses, 33 años, tabla
  `COEF_INV`, tope = máxima −0,5 %/trimestre.
- **Validación oficial (25/09/2026):** contrastado con un informe real de «Tu Seguridad Social»
  (datos de Carlos, que NO se guardan en ningún fichero del repo): la ordinaria coincide exactamente
  (fecha, edad, días computables, base reguladora y pensión con tope de la máxima 2031). El Informe de
  Vida Laboral no incluye la bonificación por cuidado de hijos (art. 236), que sí cuenta la SS.
- **Informe PDF** (`buildReport()` → `makePdf()`, `#report`): el PDF se genera en el dispositivo con
  **jsPDF 2.5.1 + html2canvas 1.4.1** (cdnjs, con SRI, cargados solo al pulsar; el SW los cachea).
  Ordenador: descarga directa. Móvil: ventana `#dlgPdf` con «Guardar o compartir» (Web Share con
  fichero; necesita un toque nuevo, por eso va en ventana) y «Descargar». **No usar `window.print()`**:
  en iPhone con la app instalada en pantalla de inicio no hace nada. Ctrl/Cmd+P sigue imprimiendo
  solo el informe (clase `report-mode` + `@media print`). El botón de la cabecera (`#btnPrint`) se
  oculta a ≤420 px por espacio; en móvil se usa el de la tarjeta principal.
- **Compartir escenario**: enlace `…/#d=<base64url(JSON)>`; al abrirlo se aplican los datos
  (saneados en `cleanShared`), no se guardan y se limpia la URL.
- **Ejemplos**: `DEMOS` (3 perfiles ficticios que se alternan).
- **Ajuste fino de la anticipada** (`#antTune`, `S.antK` = meses que se retrasa desde `EARLY`,
  `antDate()`): mes a mes hasta justo antes de la ordinaria; los meses de adelanto y el coeficiente
  salen de `scenario()`.
- **Cargar Informe de Vida Laboral (PDF)** (`cargarVL(file)` desde el botón o arrastrando el PDF a
  la ventana —eventos `drag*`/`drop` en `window`, clase `body.dragging` para el aviso—; `leerVidaLaboral()`): pdf.js 3.11.174 (cdnjs, SRI; el
  worker se descarga con `fetch` + integrity y se lanza desde un blob). Lee del texto de la 1.ª página:
  «al día …» (fecha del informe), «nacido/a el …» y el mayor «N días» tras «efectivamente computables»
  (o tras «durante un total de» si no hay pluriempleo). Si el informe es anterior a hoy y hay alguna
  situación sin fecha de baja, suma los días hasta hoy. **Nunca guardar PDFs de vida laboral en el repo**
  (para pruebas, copiarlos al scratchpad y servirlos desde allí).
- No es posible conectar con la Seguridad Social con certificado digital desde la app (sin API pública,
  requiere su sede); por eso se sube el PDF.

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
- Carlos guarda sus informes personales en `Informes Carlos/` dentro del proyecto: ignorado en git
  (`Informes*/` y `*.pdf` en `.gitignore`), y `despliega.sh` aborta si va a subir cualquier
  PDF/CSV/Excel/Word. No quitar esas protecciones.
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
4. **Dale a Carlos un breve report** (siempre que haya commit y/o copia de seguridad): versión,
   mensaje y hash del commit, nombre de la copia creada y lista actual de `Backup/`, y si la web
   ya está publicada.

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
