#!/usr/bin/env bash
# 조립.sh — 사전/ + 엔진.sh → 코터.sh 생성
set -eu
cd "$(dirname "$0")"

# "영어 한국어1 한국어2..." → "한국어 영어" 줄들로 전개 (순서 유지: 첫 동의어 = 대표어)
# (변수명이 영어인 이유: bash가 한국어 변수를 거부함. 함수명은 되면서. 편파적이다.)
전개() {
  awk '$1 !~ /^#/ && NF >= 2 { for (i = 2; i <= NF; i++) print $i, $1 }' "$1"
}

CMDS=$(전개 사전/명령.txt)
WORDS=$(전개 사전/단어.txt)

# 한국어 중복 검사 — 같은 한국어가 두 영어를 가리키면 조용히 하나가 이기므로 여기서 잡는다
DUPS=$(printf '%s\n%s\n' "$CMDS" "$WORDS" | awk '{print $1}' | sort | uniq -d)
if [ -n "$DUPS" ]; then
  echo "중복된 한국어 발견:" >&2
  echo "$DUPS" >&2
  exit 1
fi

awk -v cmds="$CMDS" -v words="$WORDS" '
  /^#@명령@$/ { print cmds; next }
  /^#@단어@$/ { print words; next }
  { print }
' 엔진.sh > 코터.sh

echo "코터.sh 생성 완료 — 번역 $(( $(echo "$CMDS" | wc -l) + $(echo "$WORDS" | wc -l) ))개 (명령 $(echo "$CMDS" | wc -l), 단어/옵션 $(echo "$WORDS" | wc -l))"
