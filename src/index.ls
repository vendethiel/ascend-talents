L = -> document.createElement it

#####

$spec-view = document.getElementById 'spec-view'
$spec-list = document.getElementById 'spec-list'

spell-list =
  * id: 1
    icon: "spell_holy_flashheal"
    name: "Flash of light"
    spec-id: 10
    cost: [2 0]
  * id: 2
    icon: "spell_holy_flashheal"
    name: "Flash of holy light"
    spec-id: 10
    cost: [2 0]
  * id: 3
    icon: "spell_holy_searinglight"
    name: "Flash of mega super light"
    spec-id: 10
    cost: [2 0]
  * id: 4
    icon: "spell_holy_righteousfury"
    name: "Attack of light"
    spec-id: 11
    cost: [2 0]
  * id: 5
    icon: "spell_holy_crusaderstrike"
    name: "Attack of holy light"
    spec-id: 11
    cost: [2 0]
  * id: 6
    icon: "spell_holy_rebuke"
    name: "Attack of mega super light"
    spec-id: 11
    cost: [2 0]

spell-list-by-spec = {}
for {spec-id}:spell in spell-list
  spell-list-by-spec[][spec-id]push spell

spec-list =
  10: 'Holy'
  11: 'Retribution'

class-list =
  Paladin:
    color: \pink
    specs:
      * 10
      * 11

state =
  selected-spec: void
  known-spells: [] # the spells the user has learned

$spec-list.appendChild render-class-spec-list(state)

filter = (fn, xs) --> # curry-friendly filter
  xs.filter fn
apply = (o, k, fn) -> # object apply to key
  o with (k): fn o[k]

function click-spell(id, {known-spells}:state)
  ->
    if id in known-spells
      render-spec apply(state, \knownSpells, filter (!= id))
    else
      render-spec apply(state, \knownSpells, (++ id))

!function render-spec({selected-spec, known-spells}:state)
  $spec-view.inner-HTML = ""
  $spec-view.appendChild L(\h3) <<< inner-HTML: spec-list[selected-spec]
  $spell-list = L(\div)
    ..id = \spell-list
  for let {id, icon, name}:spell in spell-list-by-spec[selected-spec]
    $spell = L \div
      ..class-list.add \spell
    known = id in known-spells
    $spell-icon = L \div
      ..class-list.add \spell-icon
      ..class-list.add if known then \known else \unknown
      ..style.background = "url(#{spell-icon icon})"
      ..title = "#name (click to #{if known then "unlearn" else "learn"})"
      ..onclick = click-spell id, state
        
      $spell.appendChild ..
    L \span
      ..inner-HTML = if known then "Learned" else "Unknown"
      $spell.appendChild ..
    $spell-list.appendChild $spell
  $spec-view.appendChild $spell-list
    
function spell-icon
  "//wow.zamimg.com/images/wow/icons/large/#it.jpg"

function render-class-spec-list(state)
  list = L \ul
  for name, {color, specs} of class-list
    for let spec-id in specs
      L \li
        ..inner-HTML = "#name #{spec-list[spec-id]}"
        ..style.background-color = color
        ..onclick = -> render-spec (state with selected-spec: spec-id)
        list.append-child ..
  list
