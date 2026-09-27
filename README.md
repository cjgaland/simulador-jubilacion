# Simulador de Jubilación

**👉 Abrir la app: https://cjgaland.github.io/simulador-jubilacion/**

Aplicación web para calcular **cuándo y con qué pensión** te podrás jubilar en España, tanto en la **Seguridad Social** como en **Clases Pasivas** (funcionarios de MUFACE, ISFAS o MUGEJU anteriores a 2011), comparando todas las opciones: anticipada, ordinaria, demorada o parcial, y también en pareja.

Introduces tus datos (fecha de nacimiento, días cotizados según tu Informe de Vida Laboral y, si quieres, número de hijos y los ajustes avanzados de base de cotización e IRPF) y la app muestra al momento:

- Tu **fecha de jubilación ordinaria** y la edad a la que la alcanzas.
- Tu **pensión bruta mensual** (14 pagas) y una estimación del neto tras la retención de IRPF.
- Las alternativas de **jubilación anticipada** (voluntaria o involuntaria) y **demorada** (de +1 a +5 años), con sus coeficientes reductores o porcentajes adicionales.
- Un **informe en PDF** listo para guardar o imprimir, y un enlace para **compartir** la simulación.
- Funciona también **sin conexión** una vez abierta.
- **Clases Pasivas** 🏛️: funcionarios de MUFACE, ISFAS o MUGEJU ingresados antes de 2011 (voluntaria desde los 60 sin reducción, forzosa a los 65 y prolongación).
- **Modo pareja** 👥: planificad la jubilación de los dos (fecha común, equilibrio, máximo a largo plazo…), con la pensión del hogar, los ingresos año a año, el desglose de cada uno y la pensión de viudedad si falta uno.
- Una **línea temporal**, un gráfico comparativo de todas las opciones y el **desglose** completo del cálculo.

Incluye la normativa vigente en 2026 (Ley 27/2011, RDL 2/2023, Ley 21/2021): pensión máxima, complemento por demora, complemento de brecha de género por hijos, etc.

## Privacidad

Todo se calcula en tu navegador. **Tus datos no salen de tu dispositivo**: si pulsas «Guardar», se almacenan solo en ese navegador (`localStorage`).

## Instalar en el móvil

- **iPhone (Safari):** abre el enlace → botón Compartir → «Añadir a pantalla de inicio».
- **Android (Chrome):** abre el enlace → menú ⋮ → «Instalar aplicación» o «Añadir a pantalla de inicio».

## Aviso

Es una simulación **orientativa y sin validez oficial**. Para una cifra definitiva, solicita tu simulación oficial al organismo que gestiona tu pensión ([Seguridad Social](https://sede.seg-social.gob.es) o Clases Pasivas) o consulta con un profesional de tu confianza.

## Actualizaciones

Cuando se publica una mejora, la app muestra el aviso **«Ha habido cambios»** con el botón **«Actualizar»**. El historial completo está en *Ayuda › Versiones* y en [`CHANGELOG.md`](CHANGELOG.md).

---

Creado por **Carlos J. Galán Doval** · 2026

## Para desarrolladores

App autocontenida en un solo fichero (`index.html`, HTML + CSS + JS, sin dependencias ni compilación). Para publicar una versión nueva:

1. Sube `APP_VERSION` (formato `XX.YY`) y añade la entrada en `CHANGES` dentro de `index.html`.
2. Pon la misma versión en `version.json` y en [`CHANGELOG.md`](CHANGELOG.md).
3. Ejecuta `bash scripts/despliega.sh "Mensaje"`: comprueba las versiones, hace copia de seguridad local, commit y push. GitHub Pages se actualiza en uno o dos minutos.
