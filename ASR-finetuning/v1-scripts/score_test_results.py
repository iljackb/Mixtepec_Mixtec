"""
Score the fine-tuned model's test predictions using WhIPA's OWN STIPA_METRICS
class (code/scripts/metrics.py) -- not a reimplementation, their exact PER/PFER
computation.

Run from inside whipa/code/ (needs panphon + the scripts/ package on path).

Usage:
    cd code
    python3 score_test_results.py
"""

from scripts.metrics import STIPA_METRICS

# (name, predicted, gold_normalized) -- pulled directly from the
# test_whipa.py run against lowhipa-mixtec-v1 on the 10 held-out ADJ_* files
RESULTS = [
    ("che'e",    "t͡ʃe",       "t͡ʃɛʔɛ"),
    ("vii",      "b",          "vii"),
    ("ka'nu1",   "tano",       "kaʔnũ"),
    ("ka'nu2",   "kãʔ̪n̪̪",     "kaʔnũ"),
    ("ka'nu3",   "kano",       "kaʔnũ"),
    ("xeen1",    "ʃe",         "ʃɛ̃ɛ̃"),
    ("xeen2",    "ʃe",         "ʃɛ̃ɛ̃"),
    ("nchichi1", "dʒitʃi",     "nd͡ʒit͡ʃi"),
    ("nchich2",  "ndʒitʃi",    "nd͡ʒit͡ʃi"),
    ("kochi1",   "koçi",       "kot͡ʃi"),
    ("kochi2",   "koʔçi",      "kot͡ʃi"),
    ("vee1",     "vee",        "vee"),
    ("vee2",     "be",         "vee"),
    ("vee3",     "beː",        "vee"),
    ("nani1",    "nani",       "nani"),
    ("nani2",    "nani",       "nani"),
    ("nani3",    "nani",       "nani"),
    ("kani1",    "kani",       "kani"),
    ("kani2",    "kani",       "kani"),
    ("kani3",    "kani",       "kani"),
]

eval_metrics = STIPA_METRICS()

per_list = []
pfer_list = []

print(f"{'token':12} {'PER%':>8} {'PFER%':>8}")
for name, pred, gold in RESULTS:
    m = eval_metrics.compute_all(pred=pred, gold=gold, char_based=False)
    per_list.append(m["per"])
    pfer_list.append(m["pfer"])
    print(f"{name:12} {m['per']:8.1f} {m['pfer']:8.1f}")

mean_per = sum(per_list) / len(per_list)
mean_pfer = sum(pfer_list) / len(pfer_list)

print(f"\nMean PER:  {mean_per:.1f}%")
print(f"Mean PFER: {mean_pfer:.1f}%")
