# mail

The mailbox between this repo and the repos it works with. Julian,
2026-10-03: "the mailbox system we have been doing between the cloud
instance works". `lab init --mail` or `lab mail --enable` wrote this
folder; no hook reads it, and the lab-orient skill's first step does.

## The rule

1. **One file per message**, `mail/<repo>/<YYYY-MM-DD>-<slug>.md`, under
   the repo it is addressed to. The sender keeps a copy at the same path,
   so a path names one message on either side.
2. **The header.** A fenced JSON block in the form the context-doc
   carries, prose_parser's `header_schema`: `provenance` (the sender, a
   repo at its HEAD sha; the recipient; the relationship),
   `illocutionary_intent`, `reader_role`, and on a reply `in_reply_to`,
   the path of the message it answers. The body is prose below it; a
   quoted line carries its path and line.
3. **Open until a receipt names it.** A receipt is a message whose
   header's `in_reply_to` is its path, or a ticked box of the plan whose
   text cites its path. Until then the message is open, and an open
   message is a promise still owed.
4. **Moved and never deleted.** `lab mail --archive` moves each closed
   message to `archive/mail/<repo>/` under the same name, and refuses,
   naming it, to move an open one. Deletion is the user's.

## The commands

    python3 -m lab mail send <repo> <slug> --intent TEXT --body FILE
    python3 -m lab mail send <repo> <slug> --reply-to mail/<repo>/<file>
    python3 -m lab mail read [<repo>]     the open mail addressed here
    python3 -m lab mail status            per repo: open, closed, archived
    python3 -m lab mail --archive         move the closed, refuse the open
