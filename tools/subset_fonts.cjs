// Subset the Chinese fonts to the characters the game can actually draw.
// usage: node subset_fonts.cjs <projectDir>
// Reads assets/locale/zh_cn.json plus the roster data to build the character set, then rewrites each
// assets/fonts/NotoSansSC-*.ttf with only those glyphs. Latin is kept whole (ASCII + the punctuation the
// UI uses), because switching the game back to English still draws through these fallbacks.
const fs = require('fs')
const path = require('path')

async function main() {
  const subsetFont = require('subset-font')
  const root = process.argv[2]
  const fontDir = path.join(root, 'assets', 'fonts')
  const localeDir = path.join(root, 'assets', 'locale')

  let chars = new Set()
  // printable ASCII, Latin-1 punctuation the UI leans on, and CJK punctuation
  for (let c = 0x20; c <= 0x7e; c++) chars.add(String.fromCharCode(c))
  const extra = '·×—–…“”‘’《》〈〉「」『』【】（）％０１２３４５６７８９：；！？、。，　°±'
  for (const ch of extra) chars.add(ch)

  // every string the table translates, plus the English sources (they are drawn in English mode)
  const table = JSON.parse(fs.readFileSync(path.join(localeDir, 'zh_cn.json'), 'utf8'))
  const add = (s) => { for (const ch of s) chars.add(ch) }
  for (const [k, v] of Object.entries(table)) { add(k); add(v) }

  // the roster JSON, in case a name is drawn without going through a table entry
  const rosterPath = path.join(root, 'assets', 'ba', 'roster.json')
  if (fs.existsSync(rosterPath)) {
    const raw = fs.readFileSync(rosterPath, 'utf8').replace(/^\uFEFF/, '')
    add(raw)
  }

  const text = Array.from(chars).join('')
  console.log('characters kept:', text.length)

  const files = fs.readdirSync(fontDir).filter((f) => /^NotoSansSC-.*\.ttf$/.test(f))
  for (const f of files) {
    const p = path.join(fontDir, f)
    const src = fs.readFileSync(p)
    const out = await subsetFont(src, text, { targetFormat: 'truetype' })
    fs.writeFileSync(p, out)
    console.log(`  ${f}: ${(src.length / 1024 / 1024).toFixed(2)} MB -> ${(out.length / 1024).toFixed(0)} KB`)
  }
}

main().catch((e) => { console.error('FAILED:', e.message); process.exit(1) })
