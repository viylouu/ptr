syn match ptrAnything /[_a-zA-Z]\+/

syn region ptrString start="\"" skip="\\\"" end="\"" contains=NONE

syn match ptrOps /:\|=\|\/\|\*\|-\|+\|<\|>\|!/
syn match ptrPtr /\^\|&/

syn match ptrBrackets /\[\|\]\|{\|}\|(\|)/

syn match ptrNum "[0-9]"

syn keyword ptrFuncs loc string conc jmp magic byte
syn keyword ptrLib lib contained

syn match ptrLibname "lib .*" contains=ptrLib

syn keyword ptrAlloc halloc salloc

syn match ptrComment "\/\/.*"
syn region ptrMultilineComment start="\/\*" end="\*\/" contains=NONE,@Spell keepend

hi link ptrAnything            Identifier
hi link ptrComment             Comment
hi link ptrMultilineComment    Comment
hi link ptrString              String
hi link ptrOps                 Keyword
hi link ptrFuncs               Function
hi link ptrLib                 Include
hi link ptrAlloc               Type
hi link ptrNum                 Number
hi link ptrLibname             Character
hi link ptrBrackets            String
hi link ptrPtr                 Special
