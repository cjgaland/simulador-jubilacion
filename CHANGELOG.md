# Historial de versiones

Todas las novedades del Simulador de Jubilación, de la más reciente a la más antigua.
Formato de versión `XX.YY` (cambios menores `01.01`, cambios grandes `02.00`).

> Al publicar una versión nueva, actualiza también `APP_VERSION` y `CHANGES` en `index.html`
> y `version.json`. Los usuarios verán el aviso «Ha habido cambios» y, al actualizar, las novedades.

## [04.06] - 2026-09-29

- **Guardar y abrir informes**: `#fNombre` (nombre y apellidos, desde el titular del PDF oficial con `nombreBonito()`); el PDF incrusta los datos en «Keywords» (`REP_TAG` 'SIMJUB1:' + base64url); `nombreInforme()` → NOMBRE_APELLIDOS_DDMMAAAA_HHMM.pdf; «Guardar informe» con `showSaveFilePicker` (Chrome/Edge) o descarga; «Abrir un informe guardado» (`abrirInforme` / `aplicarInforme`), también arrastrando el PDF.
- Ayuda: paso 7, botones del menú, ficha de pareja y privacidad de los informes.

## [04.05] - 2026-09-29

- **Ajuste mes a mes en toda la barra** (individual): `S.demK` (0-11 meses) en la ordinaria y +1…+4 con el mismo `#antTune` (`demDate`, `demMax` con tope de 70). `REF` = ordinaria exacta para las comparaciones. Se guarda y comparte.
- Pareja: `gap` en meses de calendario (antes días/30,44 redondeados: «1 mes» con las dos fechas en el mismo mes).
- Revisión de regresiones de 01.00 a 04.04 tras el rediseño: todo operativo.

## [04.04] - 2026-09-28

- **Jubilación parcial**: sueldo de un mes normal con `PAR.pagas` (14 | 12, selector `#segPP`). Resultado con «Un mes normal», meses con paga extra (pensión: junio y noviembre; sueldo: junio y diciembre) y total anual con las pagas reales (antes se multiplicaba por 12).

## [04.03] - 2026-09-28

- **Sueldo de un mes normal y pagas extra** en pareja: `PS[k].pagas` ('14' | '12'; datos antiguos con sueldo → '12'). Cálculo mes a mes en `renderHogar` (`salMes`, `penMes`: extras de pensión en junio y noviembre en SS, junio y diciembre en CP).
- `hInspect`: «Un mes normal», «Meses con paga extra» y tira mensual `.hmeses`; etapas con «+ 2 extras». Individual: «+ 2 pagas extra … en junio y noviembre» bajo la pensión. Informe PDF de pareja con las pagas.

## [04.02] - 2026-09-28

- **Base de cotización visible y vacía por defecto** (`#baseField` en «Tus datos»; en pareja, en la ficha). Vacía → `BASE_MAX` (5.101,20 €) con `S.baseDef` y avisos: `#baseWarnF`, `#oBaseWarn` (botón «Introducir mi base»), «⚠️ base máx.» en la minibarra, `[data-basewarn]` y `#pBaseWarn` en pareja, e informe PDF. Selector «Base de cotización / Base reguladora oficial». Paso 3 en la lista del inicio y en «Datos que necesitas».
- **La simulación oficial en PDF rellena la base de cotización** (`baseSim()`: fila «BI» del año y mes de la fecha del cálculo). Enlace al simulador oficial de prestaciones.seg-social.es.
- **Orden de preferencia de los PDF** (simulación > vida laboral): `IND_FUENTE` / `PS[k].fuente`; una vida laboral posterior de la misma persona no sustituye la simulación.

## [04.01] - 2026-09-27

- **DT 34.ª LGSS** (tope de la anticipada voluntaria cuando la pensión supera la máxima): `coefTope` redondeado a 2 decimales (coincide con los 960 valores de las tablas del BOE, ±0,01). Nueva constante `DT34_CONF = 2026` (último año confirmado: el INSS la suspendió el 1-1-2026 y la restableció el 24-3-2026). Por defecto solo se aplica hasta ese año; la opción «Aplicar la DT 34.ª hasta 2033» (`fDT34` / `S.dt34`, pareja `PS[k].dt34`) la aplica todo el periodo.
- Desglose (individual y pareja), aviso de la tarjeta principal e informe PDF indican la regla aplicada (`dt34Txt`). Nuevo apartado en la Ayuda. Aportación de Paco.

## [04.00] - 2026-09-27

- **Navegación por páginas** (hash `#inicio`, `#sim`, `#comparar`, `#desglose`, `#parcial`, `#requisitos`, `#ayuda`): menú lateral (>900 px) y cajón con hamburguesa en móvil; botones de la antigua cabecera al pie del menú. Todas las secciones siguen en el DOM (`data-pg`, `showPage()`); se quitan la cabecera y el menú de apartados con `IntersectionObserver`.
- «Mi simulación» = datos + «¿Cuándo…?» (pareja: datos + plan); tarjeta «Primero, tus datos» en las páginas que los necesitan; aviso en «Jubilación parcial» para funcionarios y Clases Pasivas; fechas clave en «Desglose».
- **Minibarra** fija con el resultado elegido (individual) o el plan del hogar (pareja).
- **Borrador de la pestaña** en `sessionStorage`: Safari en iPhone recargaba la página y se perdían los datos no guardados.
- **Gráfico de ingresos del hogar interactivo**: selección de año con desglose por persona (sueldo y pensión al mes y al año), marcas de jubilación, barras animadas, etapas con desglose por persona y clicables.
- Aviso «sin validez oficial» genérico (organismo gestor: Seguridad Social o Clases Pasivas), en pie, Ayuda, informes PDF y README. Corregida una frase cortada en el texto de viudedad. El botón PDF en pareja ya no depende de los datos individuales.
- Vista previa privada con `scripts/servidor-local.js` (Node), que no sirve PDF ni datos personales.

## [03.00] - 2026-09-27

- **Clases Pasivas del Estado** (RDLeg 670/1987): selector «Régimen de tu pensión» (Seguridad Social / Clases Pasivas) en el modo individual y en cada ficha del modo pareja.
- Carrera por grupos (A1, A2, B, C1, C2, E; hasta 4 tramos) + años en otros regímenes (cómputo recíproco, asignados al grupo de menor haber regulador, art. 32.2.e).
- Cálculo: haberes reguladores 2026 (RDL 3/2026, anexo III, +2 %/año en adelante), porcentajes del art. 31.1, fórmula P = R1·C1 + (R2−R1)·C2 + … (art. 31.2), 14 pagas y tope de pensión máxima.
- Escenarios: voluntaria desde los 60 con 30 años (art. 28.2.b, sin coeficientes reductores), forzosa a los 65 (con prórroga hasta 15 años si procede), prolongación +1…+5 con el porcentaje adicional por demora (DA 17.ª TRLCP → art. 210.2 LGSS; tope: haber regulador A1).
- **Lectura del Modelo C.S.** (certificación de servicios efectivos a efectos de derechos pasivos, PDF rellenable del Ministerio): se leen las casillas del formulario por su nombre (`cboGrupoN`, `aaN/mmN/ddN`, `PosesionN`, `CeseN`, `cbosGrupoN`, `saaN…`, `FechaNacimiento`, `Nombre_Solicitante`). Grupos antiguos traducidos (A→A1, B→A2, C→C1, D→C2, AP→E); tramos consecutivos del mismo grupo se unen; el destino actual (sin cese) se cuenta desde la toma de posesión hasta hoy. Escaneos: aviso para introducir a mano.
- El tipo de PDF cargado elige el régimen (vida laboral/simulación → Seguridad Social; Modelo C.S. → Clases Pasivas). El botón «Cargar un PDF oficial» se ve en los dos regímenes.
- Complemento por hijos solo en forzosa/prolongación, no en voluntaria (DA 18.ª). Viudedad en Clases Pasivas: 50 % de la pensión del fallecido.
- **Tipo de personal** (régimen de Seguridad Social): laboral/privado, estatutario o funcionario, en el modo individual y en cada ficha de pareja. Estatutario (art. 26 Ley 55/2003) y funcionario: forzosa a los 65, prolongación hasta los 70 → se desactivan los escenarios posteriores a los 70 (también en Clases Pasivas) y se avisa de que hace falta solicitar la prolongación si la edad ordinaria supera los 65. Laboral: sin edad forzosa. Incluido en avisos, consejos de pareja, informe PDF y Ayuda.
- **Fechas clave** (`plazosLista/plazosHTML`) en el modo individual y en el desglose de cada persona del modo pareja: solicitud de la pensión (hasta 3 meses antes; en la misma cita del informativo si faltan menos de 3 meses), prolongación (estatutario/funcionario/Clases Pasivas: pedirla ≥2 meses antes de los 65; terminarla con 3 meses), comunicación a la empresa (laboral) e IRPF de la última nómina y del premio. Incluidas en el informe PDF.
- **Jubilación parcial** (`renderParcial/updParcial`, tarjeta `#parcial`, laboral y estatutario): art. 215.2 LGSS tras el RDL 11/2024 (la DT 10.ª está suprimida desde el 1-4-2025): hasta 3 años antes de la edad legal «de haber seguido cotizando», 33 años cotizados, reducción del 25-75 % (20-33 % el primer año si se adelanta más de 2 años), pensión parcial = pensión sin coeficientes × reducción, ingresos con sueldo opcional y lista de requisitos.
- **Art. 208.3 LGSS**: opción «Cobro el subsidio por desempleo desde hace 3 meses o más» (individual y pareja) → la anticipada voluntaria usa `COEF_INV` (solo cambia con 22-24 meses de adelanto).
- **Ayuda**: premio de jubilación de la Junta (funcionarios, laborales, 30 % exento de IRPF, recálculo de la pensión), jubilación anticipada por discapacidad (RD 1539/2003 y RD 1851/2009), jubilación parcial, fechas clave. Nuevas fuentes: RDL 11/2024, Ley 55/2003, RD 1539/2003, RD 1851/2009 y el «Manual práctico de jubilación».
- **Corregida la tabla de coeficientes reductores de la anticipada voluntaria** (`COEF`): la heredada del simulador original solo acertaba con 24 meses. Sustituida por la del art. 208.2 LGSS (Ley 21/2021), comprobada valor a valor (96) contra el texto del BOE. Detectado gracias al «Manual práctico de jubilación» de la Consejería de Salud y Consumo (Junta de Andalucía).
- Ayuda, Requisitos y Fuentes oficiales (BOE, RDL 3/2026, Simul@ de Hacienda). Ejemplo ficticio de funcionaria docente; en la pareja de ejemplo, Lucía pasa a Clases Pasivas.

## [02.02] - 2026-09-27

- Modo pareja: selector «Bruto / Neto» (sincronizado en el plan y en el gráfico del hogar, con etiqueta de IRPF de cada uno) que afecta a la pensión del hogar, aportación de cada uno, planes sugeridos, pensiones hasta los 85, consejos, gráfico de ingresos y sus etapas, e informe PDF.
- Nuevo campo opcional «Sueldo bruto al mes» por persona (el gráfico en bruto usa sueldo bruto + pensión bruta; en neto, sueldo neto + pensión neta).

## [02.01] - 2026-09-27

- Lectura del **Informe de Simulación de Jubilación** (PDF de «Tu Seguridad Social»): nacimiento, titular, fecha de jubilación, días a la jubilación (con bonificación por hijos), base reguladora y fecha del cálculo → días de hoy y base reguladora «La conozco» normalizada a la fecha ordinaria. Validado con dos simulaciones oficiales reales: coinciden fecha, edad, días, base reguladora y pensión.
- Nombre de pila leído del PDF (vida laboral o simulación) en el modo pareja, si la ficha no tiene nombre.
- Asignación automática del complemento por hijos en común comparando las pensiones en euros de hoy.

## [02.00] - 2026-09-27

- **Modo pareja**: selector «Solo yo / En pareja» en la portada. Ficha por persona (nombre, nacimiento, días, vida laboral en PDF por botón o arrastrando sobre su ficha, sueldo neto, IRPF, complemento por hijos, cotización, tipo de anticipada, base de cotización o base reguladora).
- Hijos en común / propios de cada uno; complemento por hijos en común asignado automáticamente al de pensión más baja (art. 60 LGSS), modificable.
- Planificador: fechas mes a mes de cada uno (anticipada → +5 años), opción de moverlas a la vez, y planes sugeridos (cada uno a su edad, jubilarnos juntos, equilibrio, máximo a largo plazo, lo antes posible) calculados probando todas las combinaciones.
- Resultado conjunto en euros de hoy: pensión del hogar y aportación de cada uno, pensiones cobradas hasta los 85, ingresos netos del hogar año a año (sueldos + pensiones) con sus tres etapas, consejos personalizados y desglose por persona.
- Viudedad: pensión que quedaría a cada uno (52 % de la base reguladora del fallecido, con el límite de la pensión máxima).
- Informe PDF, enlace para compartir (`#p=`), guardar y restablecer en modo pareja.
- Ayuda: regímenes cubiertos (Clases Pasivas/MUFACE, mutualidades, cómputo recíproco) y viudedad.
- «Requisitos» y «Ayuda» pasan a ocupar todo el ancho, comunes a los dos modos.

## [01.05] - 2026-09-26

- Ayuda ampliada: dónde ver la base de cotización (nómina, Informe de bases de cotización de Import@ss, recibo de autónomos), qué es y cómo se calcula la base reguladora (RDL 2/2023, opción más favorable) y requisitos del complemento para la reducción de la brecha de género (art. 60 LGSS).
- Enlace «¿Dónde la veo?» junto al campo de base de cotización y nuevo enlace oficial en «Fuentes oficiales».

## [01.04] - 2026-09-25

- Arrastrar y soltar el Informe de Vida Laboral (PDF) en cualquier parte de la ventana, con aviso visual mientras se arrastra.

## [01.03] - 2026-09-25

- Nuevo: carga del Informe de Vida Laboral en PDF (pdf.js, lectura local en el dispositivo): rellena fecha de nacimiento y total de días efectivamente computables, sumando los días hasta hoy si el informe es anterior y sigue de alta.
- Nuevo: ajuste mes a mes de la jubilación anticipada (voluntaria e involuntaria), con su coeficiente reductor. Idea de Paco.
- Corregido: en la anticipada voluntaria, la edad legal de referencia (acceso y meses de anticipación) es la que tendría el trabajador «de haber seguido cotizando» (art. 208.2 LGSS), como ya se hacía en la involuntaria. Contrastado con un informe oficial de «Tu Seguridad Social»: coinciden fecha, edad, días, base reguladora y pensión de la ordinaria.
- Aviso: el Informe de Vida Laboral no incluye la bonificación por cuidado de hijos (art. 236 LGSS).

## [01.02] - 2026-09-25

- Arreglado «Informe PDF» en el móvil: ahora genera el PDF en el propio dispositivo (jsPDF + html2canvas) y permite guardarlo o compartirlo. Antes usaba la impresión del navegador, que no funciona en el iPhone con la app instalada en la pantalla de inicio.
- En el ordenador, «Informe PDF» descarga el fichero directamente.

## [01.01] - 2026-09-25

- Nueva jubilación anticipada involuntaria (despido, ERE, cierre…): hasta 4 años antes con 33 años cotizados, con los coeficientes oficiales del art. 207 LGSS y el tope de pensión máxima reducido un 0,5 % por trimestre. Selector «Anticipada: Voluntaria / Involuntaria».
- Nuevo «Informe PDF»: informe completo con los datos, el escenario elegido, su desglose y la comparativa de todas las opciones, listo para guardar como PDF o imprimir.
- Nuevo «Compartir escenario»: enlace que abre la misma simulación en otro dispositivo.
- Funciona sin conexión una vez abierta (service worker «primero la red»).
- «Ver un ejemplo» alterna tres perfiles ficticios.

## [01.00] - 2026-09-25

- Primera versión publicada en la web.
- Portada con descripción del simulador y menú de apartados: Datos, ¿Cuándo jubilarte?, Gráfico, Desglose, Requisitos y Ayuda.
- Cálculo de fecha y pensión de jubilación ordinaria, anticipada voluntaria y demorada (hasta +5 años), con comparativa en bruto y neto, línea temporal y desglose detallado.
- Ayuda con guía de uso, datos necesarios, instalación en el móvil, fuentes oficiales de la Seguridad Social y el BOE, e historial de versiones.
- Aviso automático cuando hay una nueva versión, con botón para actualizar.
- Instalable en el móvil como aplicación, con icono propio.
