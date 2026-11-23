# Changelog

Every version of Untangle and every bug I found and had fixed. Nothing here worked perfectly out of the box: I used each build on my own messages, found what was wrong, worked out what it should do instead, and had it fixed. Each fix lists what I noticed, why it happened, and what changed.

Dates are when the change went live. Commit IDs link each entry to the code.

---

## v1.4 · 22 Nov 2026 · Teach, and back to the cheaper model
`5fdd4e7`

### Added
- **Teach.** After I correct Untangle's result by hand, I right-click or hold the squiggle and pick "Teach". Untangle compares its own result with my version and keeps each difference as a lesson that is sent with later requests. The typed and wanted words get extra weight in my personal word list.
- **Safety net.** Known typos (seen twice or taught) are also applied to the model's answer, so a slip by the model does not undo something it already learned.

### Fixed
- **The better model was too expensive.** Sonnet (v1.3) fixed more, but cost about 20 times as much per message. Switched back to Claude Haiku and made up the quality gap with the stronger instructions, Teach and the safety net.

## v1.3 · 22 Nov 2026 · Decoding badly garbled words
`a81e6bc`, `424a565`

### Fixed
- **Results were "super off" on my fast typing.**
  Noticed: heavily garbled words were left standing in my WhatsApp messages.
  Cause: the log showed the round trip worked; the model itself left words like "supe nhaeette" uncorrected.
  Fix: stronger instructions: decode garbled, split and fused words, always write German umlauts for ae/oe/ue, keep my all-lowercase style fully (no added capitals or commas), never expand abbreviations. Model switched to Claude Sonnet for this round.
- **My own names got "corrected".** A personal names list is now never touched.
- **Pasting back could land in the wrong place** when the text was grabbed with select-all. Paste now selects all again first.
- **Real words were being learned as typos.** A typo is only learned when the correction is a real word.

## v1.2 · 22 Nov 2026 · "When I click the button nothing happens"
`ad5c814`

### Fixed
- **Clicking the Untangle button seemed to do nothing.**
  Cause: the app gave no sign of what it was doing, so "nothing to fix", "still working" and a real failure all looked the same. In Chrome it could not see the text box at all.
  Fix: every click now answers with a small note ("Fixed 3 things", "Nothing to fix", "Still working…"). A diary log records each step (never the text itself) so silent cases can be traced. Chrome and other Chrome-based browsers are asked to expose their text boxes, and the request is retried instead of tried once.

### Added
- **It learns my recurring typos.** One-word typos that are not real English or German words are saved with what I meant, sent to the model as hints and applied offline once seen twice. Real words like their/there are never learned.

## v1.1 · 22 Nov 2026 · Ownership
`82235ae`, `a7ccd82`

- Ownership notice added to the code and shown at the bottom of the panel.

## v1.0 · 22 Nov 2026 · First release
`74d7e23`

This first public version already carried a round of fixes from testing it during the day:

- **Untangle was missing from the right-click Services menu**, although macOS had it registered.
  Cause: a service without a required context is switched off by default.
  Fix: added the missing setting. Confirmed: Untangle then showed under Services.
- **The Accessibility prompt kept asking.**
  Cause: the switch in System Settings belonged to an older build, so macOS ignored it, and turning it off and on did not refresh it.
  Fix: the main way in (select text, then Shift+Command+U or right-click > Services) needs no permission at all. For the floating button, the app shows its own "one step left" window with a button that clears the stale entry, registers the current copy and opens Settings, so only one switch is needed.
- **"Right-click > Services" was too many steps.** Added a button that sits inside the end of whichever text box I am typing in: click it and the text is fixed.
- **It stopped correcting after a rebuild.** Cause: the rebuild dropped the Accessibility permission. The app now restarts itself once the permission is given again.
- **Hard dictionary corrections broke my mixed German and English.** With a key present, Untangle never falls back to the plain dictionary; the AI judges, and mixing languages in one sentence is treated as deliberate. If the AI fails, nothing is changed and it says so.
- **The plain menu looked basic.** Replaced with a dark panel with mode, fix counter and settings.
