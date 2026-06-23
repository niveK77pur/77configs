\include "global.ly"

\consistToContexts #edition-engraver Score.PianoStaff.Staff.Voice
\consistToContexts #edition-engraver Score.PianoStaff.Dynamics

\addEdition tweaks
\addEdition fingering
\addEdition dynamics

% #(primitive-load "pedal.scm")
% sustainTrailStart = { \once\override Dynamics.PianoPedalBracket.stencil = #(pedal-split-dash 60/100 'left) }
% sustainTrailEnd   = { \once\override Dynamics.PianoPedalBracket.stencil = #(pedal-split-dash 60/100 'right) }
% sustainRaise = \sustainOff\sustainOn

\editionMod dynamics 1 0/8 music.Dynamics -"Editions"
\editionMod tweaks 1 0/8 music.Voice.A -"Editions"
