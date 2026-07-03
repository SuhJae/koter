#!/usr/bin/env bash
# 코터 자가진단 — bash test.sh
set -u
cd "$(dirname "$0")"
./조립.sh || exit 1
cd() { builtin cd "$@" && echo 래퍼있음; }   # 사용자 cd 래퍼 흉내 (bashrc 플러그인 등)
KOTER_FORCE=1 source ./코터.sh >/dev/null

fail=0
chk() { # chk "설명" 기대값 실제값
  if [ "$2" = "$3" ]; then echo "  ✓ $1"; else echo "  ✗ $1 (기대: $2, 실제: $3)"; fail=1; fi
}

t=$(mktemp -d); 쓰담 "$t/파일.txt"

chk "뭐 = ls"            "파일.txt"  "$(뭐 "$t")"
chk "옵션 번역 --전부"     "$(command ls -a "$t")" "$(뭐 --전부 "$t")"
chk "메아리 = echo"       "안녕"      "$(메아리 안녕)"
chk "고양이 = cat"        ""          "$(고양이 "$t/파일.txt")"
chk "이동 = cd (셸 상태)"  "$t"        "$(이동 "$t" && 여기어디)"
chk "동의어 가즈아 = cd"    "$t"        "$(가즈아 "$t" && 내위치)"
chk "동의어 가 = cd"       "$t"        "$(가 "$t" && 여기어디)"
chk "cd 래퍼 있어도 거절"   "127"       "$(KOTER_TEST_DIRECT=1 cd /tmp >/dev/null 2>&1; echo $?)"
chk "중첩 번역 (환경 뒤 뒤져)" "ok"    "$(KOTER_TEST=ok 환경 | 뒤져 --출력 ok | 머리 -1)"
chk "멍청이 = git"        "$(command git --version)" "$(멍청이 --버전)"
chk "영어 거절 (직접 입력)" "127"      "$(KOTER_TEST_DIRECT=1 ls >/dev/null 2>&1; echo $?)"
chk "거절 메시지"         "세종대왕님이 보고 계십니다. '뭐'라고 하세요." "$(KOTER_TEST_DIRECT=1 ls 2>&1 >/dev/null)"
chk "파이프 속 영어는 통과" "0"        "$(ls "$t" >/dev/null 2>&1; echo $?)"
chk "실제 파일명은 보호"    ""          "$(쓰담 "$t/설치"; 고양이 "$t/설치")"
chk "인자 속 영어 거절 (어명 apt)" "세종대왕님이 보고 계십니다. 'apt' 말고 '장터'라고 하세요." "$(어명 apt install 2>&1 >/dev/null)"
chk "인자 속 영어 → 실행 안 됨" "127"   "$(멍청이 status >/dev/null 2>&1; echo $?)"
chk "영어 옵션도 거절 (뭐 -l)" "세종대왕님이 보고 계십니다. '-l' 말고 '--길게'라고 하세요." "$(뭐 -l 2>&1 >/dev/null)"
영어로 >/dev/null
chk "영어로 → ls 복구"     "0"         "$(ls "$t" >/dev/null 2>&1; echo $?)"
chk "영어로 → 뭐 사라짐"   "127"       "$(뭐 >/dev/null 2>&1; echo $?)"
chk "영어로 → cd 래퍼 복원" "래퍼있음"  "$(cd /tmp)"

command rm -rf "$t"
[ "$fail" = 0 ] && echo "전부 통과 🇰🇷" || { echo "실패 있음"; exit 1; }
