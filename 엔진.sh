# 코터.sh — 과몰입 한국어 터미널 (bash + zsh)
# 이 파일은 조립.sh가 사전/에서 자동 생성함 — 고치려면 엔진.sh와 사전/을 고치세요
# 켜기: source 코터.sh   끄기: 영어로   완전삭제: 코터그만

# 대화형 셸에서만 작동 — 스크립트는 절대 건드리지 않는다
case $- in
  *i*) ;;
  *) [ -n "$KOTER_FORCE" ] || return 0 2>/dev/null || exit 0 ;;
esac

# 두 번 source해도 안전하게 — 이미 켜져 있으면 먼저 원상복구
typeset -f 영어로 >/dev/null 2>&1 && 영어로 >/dev/null 2>&1

# 자기 위치 기억 (한국어로 재활성화용)
if [ -n "$BASH_VERSION" ]; then
  _KOTER_SELF="${BASH_SOURCE[0]}"
else
  _KOTER_SELF="${(%):-%N}"
fi

# ── 명령어 사전: 한국어 영어 (같은 영어의 첫 줄이 대표어) ──
_KOTER_CMDS='
#@명령@
'

# ── 단어 사전: 하위명령어 + 옵션 (인자 위치에서 번역) ──────
_KOTER_WORDS='
#@단어@
'

# 절대 가로채면 안 되는 것들 (셸이 죽는다)
# echo/printf 포함: 프롬프트/자동완성/셸 함수들이 다 쓴다
_KOTER_SAFE=' command builtin source eval unset unalias return exec set read echo printf '

# ── 번역 엔진 (엔진이라기엔 좀 그렇지만) ──────────────────
typeset -A _KOTER_MAP 2>/dev/null || declare -A _KOTER_MAP

while read -r _k _e; do
  [ -n "$_k" ] && _KOTER_MAP[$_k]="$_e"
done <<EOF
$_KOTER_WORDS
EOF
# 명령어 이름도 인자 위치에서 번역 (어명 장터 설치 htop → sudo apt install htop)
while read -r _k _e; do
  [ -n "$_k" ] && _KOTER_MAP[$_k]="$_e"
done <<EOF
$_KOTER_CMDS
EOF

# 역방향 사전: 영어 → 대표 한국어. 인자 자리에 영어를 몰래 끼워넣으면 잡아낸다.
# 단어 사전이 우선 (인자 자리에서는 diff가 명령이 아니라 하위명령이므로 '다른점'을 권한다)
typeset -A _KOTER_REV 2>/dev/null || declare -A _KOTER_REV
while read -r _k _e; do
  [ -n "$_k" ] && [ -z "${_KOTER_REV[$_e]-}" ] && _KOTER_REV[$_e]="$_k"
done <<EOF
$_KOTER_WORDS
$_KOTER_CMDS
EOF

_코터_말() {
  # 실제 존재하는 파일명은 건드리지 않는다 (설치.txt 같은 파일 보호)
  if [ -e "$1" ] || [ -z "${_KOTER_MAP[$1]-}" ]; then
    printf '%s' "$1"
  else
    printf '%s' "${_KOTER_MAP[$1]-}"
  fi
}

_코터_실행() {
  local _en="$1"; shift
  local _a _t
  local _args=()
  for _a in "$@"; do
    # 인자 자리에 아는 영어 단어가 나오면 전체 거절 (어명 apt install 같은 꼼수 차단)
    if [ ! -e "$_a" ] && [ -n "${_KOTER_REV[$_a]-}" ]; then
      printf "세종대왕님이 보고 계십니다. '%s' 말고 '%s'라고 하세요.\n" "$_a" "${_KOTER_REV[$_a]-}" >&2
      return 127
    fi
    _t="$(_코터_말 "$_a")"
    _args+=("$_t")
  done
  command "$_en" "${_args[@]}"
}

# 영어 명령은 사용자가 "직접 친" 경우에만 거절한다.
# 파이프/명령치환/다른 함수 내부에서 불리면 조용히 통과 —
# 안 그러면 프롬프트(PS1의 git), 자동완성, source한 스크립트가 다 죽는다.
# ponytail: 파이프 속 ls도 통과됨. 더 하드코어하게 잡으려면 PROMPT_COMMAND 훅으로 승격.
_코터_영어() {
  local _en="$1" _ko="$2"; shift 2
  local _direct=0
  if [ -n "${BASH_VERSION:-}" ]; then
    [ "${#FUNCNAME[@]}" -le 2 ] && [ "${BASH_SUBSHELL:-0}" -eq 0 ] && _direct=1
  else
    [ "${#funcstack[@]}" -le 2 ] && [ "${ZSH_SUBSHELL:-0}" -eq 0 ] && _direct=1
  fi
  [ -n "${KOTER_TEST_DIRECT:-}" ] && _direct=1  # 테스트용
  if [ "$_direct" = 1 ]; then
    printf "세종대왕님이 보고 계십니다. '%s'라고 하세요.\n" "$_ko" >&2
    return 127
  fi
  command "$_en" "$@"
}

# ── 함수 생성 ─────────────────────────────────────────────
# 사용자가 이미 만든 함수(cd 래퍼 등)는 저장해 뒀다가 영어로/코터그만 때 복원한다.
# 봐준다고 안 가리면 그게 구멍이다 (하드코어 모드니까).
_KOTER_SAVED=""
_KOTER_DONE=""
while read -r _k _e; do
  [ -z "$_k" ] && continue
  # 기존 별칭(ls='ls --color=auto' 등)이 함수 정의를 망가뜨리므로 먼저 제거
  unalias "$_k" "$_e" 2>/dev/null
  eval "function ${_k} { _코터_실행 ${_e} \"\$@\"; }"
  # 같은 영어는 한 번만 (동의어 둘째 줄부터 건너뜀 → 거절 메시지는 대표어)
  case " $_KOTER_DONE " in
    *" $_e "*) ;;
    *)
      _KOTER_DONE="$_KOTER_DONE $_e"
      case "$_KOTER_SAFE" in
        *" $_e "*) ;;
        *)
          if typeset -f "$_e" >/dev/null 2>&1; then
            _KOTER_SAVED="$_KOTER_SAVED
$(typeset -f "$_e")"
          fi
          eval "function ${_e} { _코터_영어 ${_e} '${_k}' \"\$@\"; }"
          ;;
      esac
      ;;
  esac
done <<EOF
$_KOTER_CMDS
EOF
unset _k _e

# ── 조작 명령 ─────────────────────────────────────────────
영어로() {
  local _k _e
  while read -r _k _e; do
    [ -z "$_k" ] && continue
    unset -f "$_k" "$_e" 2>/dev/null
  done <<EOF
$_KOTER_CMDS
EOF
  # 덮어썼던 사용자 함수(cd 래퍼 등) 복원
  [ -n "${_KOTER_SAVED:-}" ] && eval "$_KOTER_SAVED"
  _KOTER_SAVED=""
  echo "영어 모드로 전환. 재미없게 사시네요."
}

한국어로() { source "$_KOTER_SELF"; }

코터그만() {
  영어로 >/dev/null
  local _rc
  for _rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$_rc" ] && command sed -i '/코터/d' "$_rc"
  done
  command rm -rf "$HOME/.코터"
  unset -f 영어로 한국어로 코터그만 코터 _코터_말 _코터_실행 _코터_영어 2>/dev/null
  echo "코터 삭제 완료. 안녕히 가세요. 🇰🇷"
}

코터() {
  echo "코터 — 과몰입 한국어 터미널"
  echo ""
  echo "  끄기(이번 세션): 영어로     다시 켜기: 한국어로     완전 삭제: 코터그만"
  echo ""
  echo "$_KOTER_CMDS" | command sort -k2 | command column -t | command sed 's/^/  /'
  echo ""
  echo "  하위명령어/옵션도 됩니다: 멍청이 저질러 -메시지 \"버그 수정\" && 멍청이 밀어"
}

echo "🇰🇷 코터 활성화! 오늘부터 터미널은 한국어입니다. (목록: 코터, 끄기: 영어로)"
