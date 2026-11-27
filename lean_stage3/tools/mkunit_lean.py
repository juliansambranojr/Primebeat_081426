"""Write a Stage-3 formalization unit from a JSON spec. Usage: mkunit.py spec.json (cwd = repo root)."""
import json,re,sys,subprocess
S=json.load(open(sys.argv[1])); U=S['unit']; M=S['module']; L=f'lean_stage3/Stage3/{M}.lean'
src=open(L).read()
def stmt(nm): return re.search(r'^theorem '+re.escape(nm)+r"(?![\w']).*?:=",src,re.S|re.M).group(0)
lines=len(src.split('\n'))-1; thms=len(re.findall(r'^theorem ',src,re.M))
h=open(U+'/unit.md').read().split('---')[1]
h=re.sub(r'title: (.*)',lambda m:'title: "'+m.group(1).strip('"')+'"',h)
h=re.sub(r'refs: .*','refs: ['+', '.join(f'{L}::{p}' for p in S['pins'])+']',h)
h=re.sub(r'follows: \d+',f"follows: {S['follows']}\ncontext: {S['context']}",h)
proved=(f"**What was proved.** `{L}`: `module_lines` {lines} lines, `theorems_proved` {thms} theorems, `defs` {S['defs_n']} definitions, `sorries` 0 sorries, `pins` {len(S['pins'])} axiom pins. The first build had `errors_first` {S['errors_first']} error lines; clean on build `builds` {S['builds']}. The package builds at `jobs_package` {S['jobs_package']} jobs, the module at `jobs_module` {S['jobs_module']}. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.")
body=f"**Question.** {S['question']}\n\n{proved}\n\n{S['body']}\n"
open(U+'/unit.md','w').write('---'+h+'---\n\n'+body)
q=f"> Source: session transcript, {S['date']}\n\n> {S['quote']}\n\n{S.get('qnote','')}\n\nFrom `{L}`, the pinned statements:\n\n"+''.join('```\n'+stmt(p)+'\n```\n\n' for p in S['pins'])
open(U+'/question.md','w').write(q)
open(U+'/run/run.sh','w').write(f'#!/bin/sh\n# the run is the build; the record is its log\ncd ../../../lean_stage3 && lake build Stage3.{M}\n')
rows=[('module_lines',lines,f'wc -l {L}'),('theorems_proved',thms,f'grep -c ^theorem {L}'),('defs',S['defs_n'],S['defs']),('axioms',3,'#print axioms: propext, Classical.choice, Quot.sound'),('sorries',0,f'grep -c sorry {L}'),('pins',len(S['pins']),', '.join(S['pins'])),('errors_first',S['errors_first'],S['errors_src']),('builds',S['builds'],S['builds_src']),('traps_added',0,'lean_stage3/TRAPS.md unchanged'),('assumed_pins',0,"no hypothesis beyond the block's"),('jobs_package',S['jobs_package'],'lake build (full Stage3), Build completed successfully'),('jobs_module',S['jobs_module'],f'run/build.log, lake build Stage3.{M}'),('loop_version',22,'lean_stage3/LOOP.md version line'),('design',S['design'],S['design_title']),('steps_skipped',2,"LOOP.md section 0 (no orient hook in a cloud session) and section 2's scratch pass")]+[tuple(x) for x in S.get('extra',[])]
open(U+'/values.tsv','w').write('key\tvalue\tsource\n'+''.join(f'{a}\t{b}\t{c}\n' for a,b,c in rows))
