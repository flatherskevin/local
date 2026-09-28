# Reply marker

Start every reply with `👤` followed by a space, then the reply text.

omp's reaction feature strips that leading emoji from the reply and renders it as a
badge on the user's own message block. That badge row is the only per-message marker
the transcript exposes — user message blocks are drawn as a background fill with no
border or rail — so a reply that omits the emoji leaves the block it answers unmarked
and hard to find when scrolling back. Requires `tui.reactions` (default on).
