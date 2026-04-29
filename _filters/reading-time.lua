-- Words per minute by language (ISO 639-1 codes)
local WPM = {
  en = 238,
  fr = 195,
  de = 179,
  it = 188,
  es = 218,
  pt = 181,
  nl = 202,
  ru = 184,
  zh = 158,  -- characters per minute, not words
  ja = 193,
  ko = 200,
  ar = 138,
  pl = 166,
  sv = 199,
  tr = 166,
  el = 180,
}

-- "X min read" label by language
local LABELS = {
  en = function(m) return m .. " min read" end,
  fr = function(m) return m .. " min de lecture" end,
  de = function(m) return m .. " Min. Lesezeit" end,
  it = function(m) return m .. " min di lettura" end,
  es = function(m) return m .. " min de lectura" end,
  pt = function(m) return m .. " min de leitura" end,
  nl = function(m) return m .. " min lezen" end,
  ru = function(m) return m .. " мин чтения" end,
  zh = function(m) return m .. " 分钟阅读" end,
  ja = function(m) return m .. " 分で読めます" end,
  ko = function(m) return m .. " 분 읽기" end,
  ar = function(m) return m .. " دقيقة للقراءة" end,
  pl = function(m) return m .. " min czytania" end,
  sv = function(m) return m .. " min läsning" end,
  tr = function(m) return m .. " dk okuma" end,
  el = function(m) return m .. " λεπτά ανάγνωσης" end,
}

-- Fallback for unknown languages
local function get_wpm(lang)
  return WPM[lang] or 200
end

local function get_label(lang, minutes)
  local fn = LABELS[lang] or LABELS["en"]
  return fn(minutes)
end

-- Extract base language code from e.g. "en-US", "pt-BR", "zh-Hant"
local function parse_lang(meta)
  local lang = meta.lang
  if not lang then return "en" end
  local str = pandoc.utils.stringify(lang)
  return str:match("^(%a+)"):lower()
end

function Pandoc(doc)
  local words = 0
  local lang = parse_lang(doc.meta)
  local wpm = get_wpm(lang)

  doc:walk({
    Str = function(el)
      words = words + 1
    end,
    CodeBlock = function(el)
      return {}
    end,
    Code = function(el)
      return {}
    end
  })

  local minutes = math.max(1, math.ceil(words / wpm))
  local label = get_label(lang, minutes)

  doc.meta["reading-time"] = pandoc.MetaInlines(
    pandoc.utils.blocks_to_inlines({pandoc.Plain({pandoc.Str(label)})})
  )

  return doc
end