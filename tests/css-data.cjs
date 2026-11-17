const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { createRequire } = require('node:module');
const { homedir } = require('node:os');
const { join } = require('node:path');

const serverRequire = createRequire(join(
  process.env.XDG_DATA_HOME || join(homedir(), '.local/share'),
  'nvim/mason/packages/css-lsp/node_modules/vscode-langservers-extracted/lib/css-language-server/cssServer.js',
));
const { getCSSLanguageService, newCSSDataProvider } = serverRequire('vscode-css-languageservice');
const { TextDocument } = serverRequire('vscode-languageserver-textdocument');
const data = JSON.parse(readFileSync(join(__dirname, '../css/tailwind.json'), 'utf8'));
const service = getCSSLanguageService();
service.setDataProviders(true, [newCSSDataProvider(data)]);
const document = TextDocument.create('file:///tailwind-test.css', 'css', 1,
  `${data.atDirectives.map(({ name }) => `${name} test;`).join('\n')}\n@not-a-real-rule test;`);
const diagnostics = service.doValidation(document, service.parseStylesheet(document));
assert.deepEqual(diagnostics.map(({ code, range }) => [code, range.start.line]), [
  ['unknownAtRules', data.atDirectives.length],
]);
console.log('Tailwind directives recognized; unknown at-rules still reported.');
