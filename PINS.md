# Pins

What a theorem's `#print axioms` does for a proof, this file does for a
task: it certifies what the deliverable rests on. Four lines per task,
written silently by the model when the task starts, before any work, and
read by Julian when something looks lazy. Unit 0339.

    DONE        one line: what the deliverable is, so it can be checked
    ASSUMED     ambiguities resolved the model's way, each as one sentence
    DEPENDS     what the task needs from Julian (a flag, a decision, a file)
    OUT         what the model decided is out of scope, and why

When a task looks lazy, read its pins. One of three things shows: an
ASSUMED line is wrong (misalignment, one line to fix); a DEPENDS line is
unmet (blocked, on a named thing); or DONE was narrower than intended
(scope, at a boundary drawn here). Each wrong pin, once seen, goes into
the misreads table at the end, the way a build error goes into
`lean_stage3/TRAPS.md`.

The current task's pins sit at the top. Earlier tasks move to the archive
below with their outcome.

## Current

### 2026-09-06 · probe: does the loop transfer to a weaker agent (unit 0340)

    DONE        one Opus subagent given only the repo's files and section 7,
                its report and the tree's measures recorded in unit 0340
                against predictions written before the spawn
    ASSUMED     the harness's `opus` option stands for the weaker agent
                Julian named; the orchestrator writes nothing into the
                agent's module or unit; the agent's commits are real
                commits on main; a restart counts against transfer
    DEPENDS     nothing; Julian reads the outcome and decides what the
                loop's next edit is
    OUT         fixing the agent's module if it fails (that would measure
                the orchestrator); a second agent; sharpening the
                predictions after the run

### 2026-09-06 · rung 5 from the worksheet, section 7 onward

    DONE        StmtDetect ε T L proved with L explicit, through the modules
                the worksheet lists in §7–§10, each logged and committed
    ASSUMED     the order is §7 comparison, §8 selection, §9 cluster, §10
                assembly, with the test-function (C¹) proof and the tsum
                split taken when the assembly needs them; λ = 1;
                crude-explicit constants throughout; one unit per module
    DEPENDS     nothing from Julian until a design choice changes the
                route, which becomes a decision unit first
    OUT         sharp constants; the old-window modules; porting; anything
                on the prime side beyond the probe already run

## Archive

### 2026-09-06 · the pins file itself

    DONE        this file, the loop pointing at it, one commit
    ASSUMED     one file at the repo root is easier to read than a
                directory; four lines is the whole format; the model writes
                pins without announcing them
    DEPENDS     none
    OUT         a checker for pins (nothing mechanical to check yet)
    OUTCOME     built

## Misreads

Pins that turned out wrong, with what was meant. Appended when Julian
reads the pins and finds the misalignment.

| date | task | pin | what it said | what was meant |
|---|---|---|---|---|
| 2026-09-06 | rung 5 pricing | ASSUMED | a rung costs a person's day | a rung costs 6–25 min of clock; price from the log |
| 2026-09-06 | rung 5 route (unit 0325) | DONE | the isolated case, then a window family | the general case with explicit L; the window had to change |
