#!/usr/bin/env python3
"""Validate static pack files. No third-party dependencies or repo modifications."""
import re
from pathlib import Path
root=Path(__file__).resolve().parent.parent
expected={'flutter-ui-fidelity','flutter-architecture-guard','flutter-feature-implementer','codex-efficient-workflow'}
found={p.parent.name for p in (root/'.agents/skills').glob('*/SKILL.md')}
assert expected==found,(expected,found)
for slug in expected:
    data=(root/'.agents/skills'/slug/'SKILL.md').read_text(encoding='utf-8')
    assert re.search(r'\A---\nname: '+re.escape(slug)+r'\ndescription: .+\n---\n',data),slug
prompts=sorted((root/'prompts').glob('*.md'))
assert len(prompts)==10,len(prompts)
for name in ('START_HERE.md','AGENTS_APPEND.md','templates/TASK_CARD.md','templates/UI_EVIDENCE.md','templates/PR_CHECKLIST.md','scripts/install-local.ps1','scripts/install-official.ps1','scripts/capture-android.ps1','scripts/compare_screenshots.py'):
    assert (root/name).is_file(),name
print(f'PASS: {len(expected)} complete Codex skill directories, {len(prompts)} prompts, safety/setup tools and templates present')
