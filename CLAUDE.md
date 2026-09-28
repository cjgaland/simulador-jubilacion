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
  Voluntaria: hasta 24 meses, 35 años, tabla `COEF` (art. 208.2 LGSS; **corregida en 03.00**, la original
  era errónea salvo en 24 meses; verificada valor a valor contra el BOE). Involuntaria: hasta 48 meses, 33 años, tabla
  `COEF_INV`, tope = máxima −0,5 %/trimestre.
- **DT 34.ª LGSS** (tope de la anticipada voluntaria cuando la pensión supera la máxima): `coefTope` = interpolación
  lineal 2024-2033 entre 0,5 %/trimestre y los coeficientes completos, redondeada a 2 decimales; coincide con los
  960 valores de las tablas del BOE (±0,01). El INSS la suspendió el 1-1-2026 y la restableció el 24-3-2026.
  `DT34_CONF = 2026` = último año confirmado: por defecto (criterio prudente) solo se aplica hasta ese año y después
  coeficientes completos; la opción «Aplicar la DT 34.ª hasta 2033» (`fDT34` / `S.dt34`, pareja `PS[k].dt34`)
  la aplica todo el periodo. `dt34Txt()` explica en el desglose qué regla se aplicó. **Revisar `DT34_CONF` cada año**
  según el criterio del INSS. (Aportación de Paco, 27/09/2026.)
- **Base de cotización** (28/09/2026): campo visible en «Tus datos» (`#baseField`, antes en «Ajustes avanzados»),
  **vacío por defecto**. Vacío → se calcula con `BASE_MAX` (5.101,20 €, base máxima 2026; **actualizar cada año**)
  y `S.baseDef = true` (pareja: `personIn` → `baseDef`), con avisos bien visibles: `#baseWarnF` bajo el campo,
  `#oBaseWarn` en la tarjeta principal (botón «Introducir mi base»), «⚠️ base máx.» en la minibarra
  (`body.base-def`), `[data-basewarn]` en cada ficha de pareja y `#pBaseWarn` en el plan (`pairBaseWarn()`); el
  informe PDF lo indica. Selector renombrado: «Base de cotización» / «Base reguladora oficial» (`S.brMode` 'est'|'man').
  Motivo: la app ya no es solo para médicos; con la máxima por defecto la pensión salía inflada.
  **La simulación oficial en PDF rellena la base** (`baseSim()`): tabla «BASES DE COTIZACIÓN», fila «BI» del año de
  la «Fecha del cálculo», mes de esa fecha (los siguientes son estimaciones de la SS; si falta el año, el anterior).
  Simulador oficial: https://prestaciones.seg-social.es/simulador-servicio/simulador-pension-jubilacion.html
  (informe v1.11, 9 páginas). Probado el 28/09/2026 con una simulación real de Carlos (resultado idéntico al oficial).
- **Orden de preferencia de los PDF**: 1.º simulación de jubilación, 2.º vida laboral (solo si no se puede obtener la
  simulación); no hace falta subir los dos. `IND_FUENTE` / `PS[k].fuente` = 'sim' tras cargar una simulación: una vida
  laboral posterior de la **misma persona** (misma fecha de nacimiento) no cambia nada y avisa; «Nuevo» lo desbloquea.
  Se guarda en el snapshot / `cleanPair`.
- **Validación oficial (25/09/2026):** contrastado con un informe real de «Tu Seguridad Social»
  (datos de Carlos, que NO se guardan en ningún fichero del repo): la ordinaria coincide exactamente
  (fecha, edad, días computables, base reguladora y pensión con tope de la máxima 2031). El Informe de
  Vida Laboral no incluye la bonificación por cuidado de hijos (art. 236), que sí cuenta la SS.
- **Informe PDF** (`buildReport()` → `makePdf()`, `#report`): el PDF se genera en el dispositivo con
  **jsPDF 2.5.1 + html2canvas 1.4.1** (cdnjs, con SRI, cargados solo al pulsar; el SW los cachea).
  Ordenador: descarga directa. Móvil: ventana `#dlgPdf` con «Guardar o compartir» (Web Share con
  fichero; necesita un toque nuevo, por eso va en ventana) y «Descargar». **No usar `window.print()`**:
  en iPhone con la app instalada en pantalla de inicio no hace nada. Ctrl/Cmd+P sigue imprimiendo
  solo el informe (clase `report-mode` + `@media print`). El botón «PDF» (`#btnPrint`) está al pie del menú
  lateral; también hay uno en la tarjeta principal.
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
- **También lee el Informe de Simulación de Jubilación** (02.01, misma función `leerVidaLaboral()`,
  `tipo:'sim'`): «F. Nacimiento», «Fecha jubilación», «Fecha del cálculo», «Durante toda la vida laboral
  N días» (días a la jubilación, ya con bonificación art. 236), «Base Reguladora X €», «Titular». Días hoy =
  N − días(cálculo→jubilación) + días(cálculo→hoy). `prepararInforme()` normaliza la BR a la fecha
  ordinaria (`brMan = BR / 1,02^años(ORD→fJub)`). Es la vía exacta: el Informe de Vida Laboral se queda
  corto (no trae la bonificación por hijos). Validado 27/09/2026 con dos simulaciones oficiales reales.
- `nombrePila()` saca el nombre de pila (todo menos los dos apellidos) para la ficha del modo pareja.
- Carpeta `VidasLaborales/` (PDF reales de Carlos y de su pareja) ignorada en git. No escribir nombres,
  fechas ni cifras de esos informes en ningún fichero del repo (ni en comentarios).
- No es posible conectar con la Seguridad Social con certificado digital desde la app (sin API pública,
  requiere su sede); por eso se sube el PDF.
- **Modo pareja (02.00)**: selector `.mode-sel` en la portada (`MODE` 'ind'|'par', `body.par`, guardado en
  `localStorage` `simJubModo`). UI en `#pairApp` (construida por `buildPairUI()`), estado `PS`
  (`simJubPareja` al pulsar Guardar; enlace `#p=`; `cleanPair` sanea). **No duplica fórmulas**:
  `withPerson(P, fn)` carga los datos de una persona en `S`/`ORD`/`EARLY`/`ORDC`, llama al motor
  individual y lo restaura. `personPlan()` = todas sus fechas mes a mes (anticipada → +5 años);
  `evalPair()` = resultado conjunto (complemento hijos: comunes al de menor pensión si `asig:'auto'`,
  máx. 4 por persona; importes del hogar en € de hoy); `computePresets()` prueba todas las
  combinaciones (ref, juntos = mismo mes con máx. total a 85, equilibrio = mínima distancia con total
  a 85 ≥ ref, largo, antes). Ingresos del hogar año a año con sueldo neto opcional (constante en € de
  hoy). Viudedad = 52 % BR del fallecido limitada a máxima − pensión propia.
- **Gráfico de ingresos del hogar** (`renderHogar`, rehecho en 04.00): barras-botón interactivas; al tocar o pasar
  el ratón, `hInspect(i)` muestra en `#hSel` el año con sueldo y pensión de cada uno. `HSEL` = año elegido
  (se conserva entre planes); las barras se animan desde su altura anterior; marcas `.hmk` en la fecha de
  jubilación de cada uno; las tarjetas de etapas (`.phases [data-y]`) desglosan por persona y seleccionan
  su primer año completo. En el Informe PDF se oculta `#hSel`.
- **Sueldo real y pagas extra** (28/09/2026): el sueldo de la pareja es el de **un mes normal, sin paga extra**, con
  `PS[k].pagas` '14' (extras en junio y diciembre) | '12' (prorrateadas); datos guardados antes con sueldo → '12'
  (así estaban introducidos). Helpers `sal()`, `pagas()`, `salMes()`, `penMes()` (pensión 14 pagas: extras en junio y
  noviembre en SS, junio y diciembre en CP), `extrasTxt()`. `renderHogar` calcula mes a mes (`v.m`, `r.ex`); `hInspect`
  muestra «Un mes normal», «Meses con paga extra» y la tira mensual `.hmeses`. En individual, bajo la pensión:
  «+ 2 pagas extra … en junio y noviembre». La jubilación parcial sigue pidiendo el sueldo prorrateado en 12.
- Bruto/neto en pareja (02.02): `PS.net` ('bruto'|'neto'), helpers `pv()` (persona), `hv()` (hogar),
  `t85()` y `bn()`; dos selectores `.pnet` sincronizados (plan y gráfico) + `.pchip`. Sueldos: `sueldoB`
  (bruto) y `sueldo` (neto), ambos opcionales, 12 pagas. Los planes sugeridos se ordenan siempre en bruto.
- **Tipo de personal (03.00)**: `IND_TIPO` / `PS[k].tipo` → `S.tipo` 'lab'|'est'|'fun' (solo régimen SS; en CP se
  trata como funcionario). No toca la pensión. `tope70()`: estatutario (art. 26 Ley 55/2003), funcionario y
  Clases Pasivas → sin escenarios después de los 70 (individual: `disabled`; pareja: `personPlan` corta las
  fechas). Avisos en `renderAlert` y `renderAdvice`.
- `#requisitos` y `#ayuda` están en `.common` (fuera de `.grid`), visibles en los dos modos.
- **html2canvas no entiende `color-mix()`**: no usarlo en nada que salga en el Informe PDF.
- **Clases Pasivas (03.00)**: `S.reg` 'ss'|'cp' (individual: `IND_REG`/`IND_CP`, `body.ind-cp`; pareja:
  `PS[k].reg`/`PS[k].cp`, `.pcard.reg-cp`; CSS `.ss-only`/`.cp-only`). Carrera `cp = {t:[{g,a,m}], ssA, ssM}`
  (`cleanCP`, componente `mountCP`). Motor: `findOrdinary/findEarly/scenario` delegan en `cpOrd/cpEarly/
  scenarioCP` si `S.reg==='cp'`. `HR2026` (RDL 3/2026 anexo III; **actualizar cada año**), `PCT_CP` (art. 31.1),
  `cpPension` (art. 31.2; SS → grupo de menor haber, art. 32.2.e). Tipos: 'Voluntaria' (sin coef., sin
  complemento hijos), 'Forzosa', 'Prolongación' (demora DA 17.ª = art. 210.2 LGSS, tope HR A1/14).
  Viudedad CP: 50 % de la pensión del fallecido. Validado con cálculos a mano; **pendiente contrastar con un
  caso real** (Simul@ de Hacienda o resolución de pensión).
- **Modelo C.S.** (`leerCS(fo)`, dentro de `leerVidaLaboral()`): el PDF oficial es un formulario rellenable
  y **cifrado**; se leen las casillas con `pdfjs getFieldObjects()` (318 campos: `cboGrupo1-10`, `aa/mm/dd1-10`,
  `Posesion/Cese1-10`, `cbosGrupo1-7`, `saa/smm/sdd1-7`, `FechaNacimiento`, `Nombre_Solicitante`). La casilla
  oculta `Today` guarda la fecha de la **plantilla** (31-03-2020): no usarla. Destino sin cese → desde la
  toma de posesión hasta hoy. Probado con un C.S. rellenado con datos ficticios (pdf.js `annotationStorage`
  + `saveDocument()`; pdf-lib no abre el PDF porque está cifrado). Pendiente probar con un C.S. real.

## Estructura de la página (04.00: navegación por páginas)
- **Menú lateral** `aside.sidebar` (ordenador/tablet >900 px; en móvil es un cajón que abre la hamburguesa
  `#btnNav`, clase `body.nav-open`, velo `#veil`): marca, selector de modo compacto (`.mode-sel.sb-mode`),
  páginas (`#sbNav [data-page]`) y abajo los botones Nuevo, Restablecer, Tema, PDF y Guardar (mismos ids
  de siempre: `#btnClear`, `#btnReset`, `#btnTheme`, `#btnPrint`, `#btnSave`).
- `.content` > `.topbar` (en móvil `.appbar` con título `#abTitle` y guardar `#btnSaveM`, que llama a
  `#btnSave`) + **minibarra** `#minibar` (`updMini()`: escenario elegido o plan del hogar; oculta en Inicio
  y sin datos) > `.wrap` con título de página `#pgH`.
- **Páginas** (hash `#inicio`, `#sim`, `#comparar`, `#desglose`, `#parcial`, `#requisitos`, `#ayuda`;
  `PAGES`/`PAGES_PAR`, `showPage()`, `go()`): todas las secciones siguen en el DOM y llevan `data-pg="…"`;
  `showPage` marca `.pg-on` y el CSS oculta el resto. Inicio = portada; Mi simulación = `#datos` +
  `#mainCard` (pareja: `#pDatos` + `#pPlan`); Comparar = `#grafico` (pareja `#pHogar`); Desglose =
  `#detail` + `#plazosCard` con `#oPlazos` (pareja `#pDetalle`); Parcial = `#parcial` o `.parcial-no`
  (oculta en pareja). `.need-card` sustituye a las páginas que necesitan datos cuando no los hay.
  Textos que cambian con el modo: `.t-ind` / `.t-par`.
- **Borrador de la pestaña** (`sessionStorage` `simJubBorrador` / `simJubBorradorPareja`, `ssSet`/`ssJSON`):
  Safari en iPhone recarga a veces la página al cambiar de página; sin esto se perdían los datos no guardados
  (p. ej. el ejemplo). Al arrancar: enlace compartido → borrador → datos guardados → vacío.
- Al mostrar «sim» se redibuja la línea temporal (se mide con su ancho real). Página inicial: la del
  hash; si no, `sim` con datos e `inicio` sin ellos. Los enlaces `#d=`/`#p=` se leen antes del router.
- Ayuda con pestañas: Cómo usarla, Datos que necesitas, Instalar y actualizar, Fuentes oficiales, Versiones.

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

## Rediseño 04.00 (en curso, rama `rediseno-04`)
- **Foto fija**: etiqueta git `v03.00` (en GitHub) = versión publicada antes del rediseño. Para volver:
  `git checkout main && git reset --hard v03.00` (**destructivo: pedir confirmación a Carlos**) o, sin riesgo,
  `git checkout v03.00` para mirarla. También hay copias en `Backup/`.
- Se trabaja en la rama `rediseno-04`; `main` (lo que ven los usuarios) no se toca hasta que Carlos dé el visto
  bueno. `despliega.sh` se niega a publicar fuera de `main`.
- **Vista previa privada**: `bash scripts/vista-previa.sh` (localhost:8080 y la IP del Mac en la Wi-Fi para el móvil).
  Usa `scripts/servidor-local.js` (Node), que no sirve PDF, CSV, hojas de cálculo ni las carpetas personales.
- Estado (27/09/2026): **publicado como 04.00** (rama integrada en `main`). Para volver a la versión anterior
  sigue existiendo la etiqueta `v03.00`.
- Plan acordado: navegación por páginas (hash routing, todas las secciones siguen en el DOM y solo se muestra
  una), menú lateral en ordenador/tablet y hamburguesa en móvil; «Tus datos» + «¿Cuándo te quieres jubilar?»
  juntos en «Mi simulación»; mini barra fija con fecha y pensión. Redibujar línea temporal/gráficos al mostrar
  su página. Empezar por una maqueta visual para que Carlos la apruebe.
- **Al publicar el rediseño**: integrar `rediseno-04` en `main`, subir a 04.00 y «Despliega» desde `main`.

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
- (Hecho en 03.00, del «Manual práctico de jubilación» de la Junta: fechas clave, jubilación parcial, art. 208.3,
  premio de jubilación y discapacidad en la Ayuda.) Pendiente: confirmar si el premio aplica a estatutarios del
  SAS; calcular la anticipada por discapacidad; jubilación parcial en el modo pareja.
- Jubilación parcial: `PAR` (estado en memoria, no se guarda), `PARCTX`; solo modo individual. Oculta para
  funcionarios (`body.no-parcial`) y Clases Pasivas (`.ss-only`).
- (Hechas en 01.01: anticipada involuntaria, informe PDF, compartir por enlace, modo sin conexión.)
- (Hecho en 02.00: modo pareja con viudedad y sueldos.)
- Clases Pasivas (haberes reguladores por grupo + % por años de servicio, LPGE de cada año).
