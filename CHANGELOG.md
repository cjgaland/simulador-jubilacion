# Historial de versiones

Todas las novedades del Simulador de Jubilación, de la más reciente a la más antigua.
Formato de versión `XX.YY` (cambios menores `01.01`, cambios grandes `02.00`).

> Al publicar una versión nueva, actualiza también `APP_VERSION` y `CHANGES` en `index.html`
> y `version.json`. Los usuarios verán el aviso «Ha habido cambios» y, al actualizar, las novedades.

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
