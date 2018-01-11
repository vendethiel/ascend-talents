L = -> document.createElement it

#####

$spec-view = document.getElementById 'spec-view'
$spec-list = document.getElementById 'spec-list'

spell-list =
  * id: 1
    icon: "spell_holy_flashheal"
    name: "Flash of light"
    spec-id: 10
  * id: 2
    icon: "spell_holy_flashheal"
    name: "Flash of holy light"
    spec-id: 10
  * id: 3
    icon: "spell_holy_searinglight"
    name: "Flash of mega super light"
    spec-id: 10
  * id: 4
    icon: "spell_holy_righteousfury"
    name: "Attack of light"
    spec-id: 11
  * id: 5
    icon: "spell_holy_crusaderstrike"
    name: "Attack of holy light"
    spec-id: 11
  * id: 6
    icon: "spell_holy_rebuke"
    name: "Attack of mega super light"
    spec-id: 11

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

known-spells = [] # the spells the user has learned

$spec-list.appendChild render-class-spec-list!

function click-spell id, spec-id
  console.log "bind #id"
  ->
    console.log known-spells
    if id in known-spells
      remove-item known-spells, id
    else
      known-spells.push id
    render-spec spec-id

!function render-spec spec-id
  $spec-view.inner-HTML = ""
  $spec-view.appendChild L(\h3) <<< inner-HTML: spec-list[spec-id]
  $spell-list = L(\div)
    ..id = \spell-list
  for let {id, icon, name}:spell in spell-list-by-spec[spec-id]
    $spell = L \div
      ..class-list.add \spell
    known = id in known-spells
    $spell-icon = L \div
      ..class-list.add \spell-icon
      ..class-list.add if known then \known else \unknown
      ..style.background = "url(#{spell-icon icon})"
      ..title = "#name (click to #{if known then "unlearn" else "learn"})"
      ..onclick = click-spell id, spec-id
        
      $spell.appendChild ..
    L \span
      ..inner-HTML = if known then "Learned" else "Unknown"
      $spell.appendChild ..
    $spell-list.appendChild $spell
  $spec-view.appendChild $spell-list
    
function spell-icon
  "//wow.zamimg.com/images/wow/icons/large/#it.jpg"

function render-class-spec-list
  list = L \ul
  for name, {color, specs} of class-list
    for let spec-id in specs
      L \li
        ..inner-HTML = "#name #{spec-list[spec-id]}"
        ..style.background-color = color
        ..onclick = -> render-spec spec-id
        list.append-child ..
  list

!function remove-item xs, x
  idx = xs.indexOf x
  if idx isnt -1
    xs.splice idx, 1
