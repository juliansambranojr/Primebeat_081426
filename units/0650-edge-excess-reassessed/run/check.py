"""The results this unit reports are copied in as produced; this checks each copy against the file in the tree."""
import hashlib, json
pairs = {"O102_edge_excess_frozen_phase.json": "../../../results/O102_edge_excess_frozen_phase.json",
         "O102_edge_excess_frozen_phase_power.json": "../../../results/O102_edge_excess_frozen_phase_power.json",
         "O101_edge_correlation_power.json": "../../../results/O101_edge_correlation_power.json",
         "O102_designs.json": "../../../analysis/2026-11-28/o102_designs/o102_designs_output.json"}
h = lambda p: hashlib.sha256(open(p, 'rb').read()).hexdigest()
out = {k: h(k) == h(v) for k, v in pairs.items()}
json.dump({"copies_match": out, "all_match": all(out.values())}, open("copies.json", "w"), indent=1); print(out)
