// servidor-local.js — Servidor mínimo para la vista previa privada (lo usa scripts/vista-previa.sh).
// Sirve solo los ficheros de la app y NUNCA los datos personales (PDF, CSV, hojas de cálculo,
// carpetas Informes*/, VidasLaborales/, Backup/, .git…), porque escucha en la Wi-Fi de casa.
// Uso: node scripts/servidor-local.js [puerto]
const http = require('http'), fs = require('fs'), path = require('path');
const ROOT = path.resolve(__dirname, '..'), PORT = +process.argv[2] || 8080;
const TIPOS = {'.html':'text/html; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.json':'application/json',
  '.svg':'image/svg+xml', '.png':'image/png', '.webmanifest':'application/manifest+json', '.css':'text/css', '.md':'text/plain; charset=utf-8'};
const PROHIBIDO = /(^|\/)(\.|Backup\/|Informes|VidasLaborales\/|scripts\/)|\.(pdf|csv|xlsx?|ods|docx?|env)$/i;

http.createServer((req, res) => {
  let url;
  try{ url = decodeURIComponent(req.url.split('?')[0]); }catch(e){ res.writeHead(400); return res.end(); }
  if(url.endsWith('/')) url += 'index.html';
  const file = path.join(ROOT, path.normalize(url));
  const rel = path.relative(ROOT, file);
  if(rel.startsWith('..') || PROHIBIDO.test(rel) || !TIPOS[path.extname(file).toLowerCase()]){ res.writeHead(404); return res.end('No disponible'); }
  fs.readFile(file, (err, data) => {
    if(err){ res.writeHead(404); return res.end('No encontrado'); }
    res.writeHead(200, {'Content-Type': TIPOS[path.extname(file).toLowerCase()], 'Cache-Control': 'no-store'});
    res.end(data);
  });
}).listen(PORT, '0.0.0.0');
