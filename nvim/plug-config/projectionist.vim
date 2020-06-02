" Projectionist configuration
let g:projectionist_heuristics = {
      \   '*': {
      \     '*.c': {
      \       'alternate': '{}.h',
      \       'type': 'source'
      \     },
      \     '*.h': {
      \       'alternate': '{}.c',
      \       'type': 'header'
      \     },
      \
      \     'src/*': {
      \       'alternate': [
      \         'tests/{dirname}/test_{basename}',
      \       ],
      \       'type': 'source'
      \     },
      \     'tests/**/test_*': {
      \       'alternate': [
      \         'src/{}',
      \       ],
      \       'type': 'test'
      \     },
      \   }
      \ }
