// build.js — génère config.js à partir des variables d'environnement.
// Utilisé par Vercel (via "npm run build") et en local si besoin.
//
// Variables requises :
//   SUPABASE_URL       → URL de ton projet Supabase
//   SUPABASE_ANON_KEY  → clé anon/public de ton projet Supabase

const fs = require('fs');
const path = require('path');

const url = process.env.SUPABASE_URL || '';
const key = process.env.SUPABASE_ANON_KEY || '';

if (!url || !key) {
  console.warn(
    '[build] ⚠️  SUPABASE_URL ou SUPABASE_ANON_KEY manquant — ' +
    'config.js sera généré avec des valeurs vides (mode localStorage).'
  );
}

const content =
`// Généré automatiquement par build.js — ne pas éditer manuellement.
// Pour le dev local, modifie config.js directement (il est gitignored).
window.CAPEO_SUPABASE_URL = '${url}';
window.CAPEO_SUPABASE_ANON_KEY = '${key}';
`;

const dest = path.join(__dirname, 'config.js');
fs.writeFileSync(dest, content, 'utf8');
console.log('[build] config.js généré avec succès.');
