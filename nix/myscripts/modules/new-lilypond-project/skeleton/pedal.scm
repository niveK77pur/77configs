; [THIS WAS WRITTEN WITH HELP, GUIDANCE, AND ASSISTANCE OF AI]
;
; This function creates a custom PianoPedalBracket stencil which uses a dashed
; line at the beginning (side='left) or end (side='right) to indicate that
; pedalling should continue the same pattern, without having to be explicitly
; annotated. The `frac` (i.e. 2/3, 60/100, ...) determines how much of the
; PianoPedalBracket should be dashed.
;
; This was implemented by modifying the grob in-place to achieve the desired
; effect, and by re-using as much as possible the existing PianoPedalBracket
; mechanisms. First, we remove the corresponding vertical edge of the bracket,
; and turn the entire bracket dashed. Then we combine it with a second version
; of the bracket where we use a solid line again but shorten the bracket.
;
; The end result is a solid line that turns dashed when the `side` is `'right`,
; or the opposite when the `side` is `'left`.
;
; See also: https://music.stackexchange.com/questions/113927/how-to-remove-piano-pedal-bracket-edges-on-both-sides
;
; Example usage:
;    \once\override Staff.PianoPedalBracket.stencil = #(pedal-split-dash 6/10 'left)
(define ((pedal-split-dash frac side) grob)
  (let* ((side-left (eq? side 'left))
         (side-right (eq? side 'right))
         (edge-height (cons (if side-left 0 1)
                            (if side-right 0 1))))
    (ly:grob-set-property! grob 'edge-height edge-height)
    (ly:grob-set-property! grob 'style 'dashed-line)
    (let* ((dashed (ly:piano-pedal-bracket::print grob))
           (width (- (cdr (ly:stencil-extent dashed X))
                     (car (ly:stencil-extent dashed X))))
           (shorten-by (* frac width)))
      (ly:grob-set-property! grob 'style 'solid)
      (ly:grob-set-property! grob 'shorten-pair (cons (if side-left shorten-by 0)
                                                      (if side-right shorten-by 0)))
      (ly:stencil-add dashed (ly:piano-pedal-bracket::print grob)))))
