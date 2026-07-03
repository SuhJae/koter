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
뭐 ls
봐봐 ls
신상뭐 eza
이동 cd
가즈아 cd
가 cd
제거 rm
갖다버려 rm
방빼 rmdir
고양이 cat
이양고 tac
박쥐 bat
뒤져 grep
찾아내 grep
번개뒤져 rg
수색 find
빨리찾아 fd
대충찾아 fzf
방만들어 mkdir
옮겨 mv
이사 mv
베껴 cp
복붙 cp
여기어디 pwd
내위치 pwd
메아리 echo
따라해 echo
서식메아리 printf
성형 sed
어이쿠 awk
머리 head
대가리 head
꼬리 tail
덜 less
더 more
아저씨 man
설명서 man
줄세워 sort
하나씩만 uniq
세어봐 wc
싹둑 cut
풀칠 paste
합석 join
쪼개 split
접어 fold
줄번호 nl
변신 tr
로꾸거 rev
줄줄이 xargs
분신술 tee
틀린그림찾기 diff
반창고 patch
넌뭐니 file
신상털기 stat
글자만 strings
이름만 basename
폴더만 dirname
진짜경로 realpath
어디보는거니 readlink
대충하나줘 mktemp
쓰담 touch
콕 touch
노끈 ln
어디있니 which
어디어디 whereis
나무 tree
줄맞춰 column
비교 cmp
공통점 comm
파쇄기 shred
묶어 tar
압축 zip
압축풀어 unzip
쥐어짜 gzip
쥐어짠거풀어 gunzip
더쥐어짜 xz
말아 curl
긁어와 wget
주전자 http
쉿 ssh
쉿베껴 scp
쉿전송 sftp
동기화 rsync
옛날택배 ftp
옛날전화 telnet
어명 sudo
제발 sudo
옥새 pkexec
허락 chmod
주인바꿔 chown
무리바꿔 chgrp
빙의 su
암구호변경 passwd
식구추가 useradd
호적파기 userdel
나는누구 whoami
여긴어디 whoami
누구세요 who
주민등록증 id
소속 groups
방명록 last
전체방송 wall
흑역사 history
청소 clear
싹 clear
탈출 exit
퇴근 logout
환경 env
환경구경 printenv
수출 export
별명 alias
사투리설정 locale
번역기 iconv
죽여 kill
다죽여 pkill
몰살 killall
누구있니 ps
꼭대기 top
이쁜꼭대기 htop
더이쁜꼭대기 btop
알바목록 jobs
뒤에서해 bg
앞에서해 fg
끊지마 nohup
의절 disown
착하게 nice
다시착하게 renice
자 sleep
꿀잠 sleep
시간제한 timeout
감시 watch
기다려 wait
남은용량 df
용량조사 du
절단기 dd
올라타 mount
내려와 umount
블록들 lsblk
칼질 fdisk
정밀칼질 parted
공장초기화 mkfs
디스크검진 fsck
디스크주민번호 blkid
공짜 free
남은기억 free
정체 uname
문패 hostname
머리스펙 lscpu
꽂힌거뭐 lsusb
부품들 lspci
커널부품 lsmod
부품장착 modprobe
커널일기 dmesg
체온계 sensors
얼마나버텼니 uptime
맞춰 sync
꺼버려 shutdown
환생 reboot
다시태어나 reboot
영면 poweroff
급정거 halt
한도 ulimit
커널조율 sysctl
황회장님 nvidia-smi
집사 systemctl
일기장 journalctl
옛날집사 service
시간표 crontab
이따가 at
장터 apt
재래시장 apt-get
꾸러미 dpkg
찰칵 snap
납작꾸러미 flatpak
양조장 brew
계세요 ping
경로추적 traceroute
파봐 dig
호구조사 nslookup
주인장 host
누구냐넌 whois
이웃들 arp
주소 ip
검문 ss
만능칼 nc
도청 tcpdump
철벽 iptables
쉬운철벽 ufw
자물쇠공장 openssl
밀봉 gpg
뱀 python3
구렁이 python3
뱀먹이 pip
뱀간식 pipx
자외선 uv
시인 poetry
뱀시험 pytest
공책 jupyter
매듭 node
매듭가게 npm
매듭실행 npx
빠른매듭 pnpm
털실 yarn
빵 bun
공룡 deno
가라 go
가라다듬어 gofmt
녹 rustc
화물 cargo
씨언어 gcc
씨쁠쁠 g++
쨍그랑 clang
만들어 make
씨만들어 cmake
자객 ninja
커피 java
커피볶아 javac
홍옥 ruby
보석 gem
보따리 bundle
진주 perl
코끼리 php
달 lua
멍청이 git
멍텅구리 gh
부두꾼 docker
꼬투리장수 podman
조타수 kubectl
방향타 helm
천지창조 terraform
방랑자 vagrant
탈출게임 vim
신탈출게임 nvim
난쟁이 nano
조상님 ed
운영체제 emacs
부호 code
칸막이 tmux
병풍 screen
믹서기 ffmpeg
젓가락 jq
국자 yq
문지기 direnv
차림 mise
탐정 gdb
미행 strace
사생팬 ltrace
해부 objdump
이름들 nm
요정해독 readelf
기억력검사 valgrind
로봇다리 adb
줄세기 cloc
주판 bc
데이트 date
몇시야 date
달력 cal
차례로 seq
섞어 shuf
소인수분해 factor
응 yes
지문 sha256sum
옛날지문 md5sum
육십사글자 base64
뜯어봐 hexdump
십육진수 xxd
자랑 neofetch
빠른자랑 fastfetch
소가말해 cowsay
큰글씨 figlet
무지개고양이 lolcat
기차 sl
'

# ── 단어 사전: 하위명령어 + 옵션 (인자 위치에서 번역) ──────
_KOTER_WORDS='
설치 install
깔아 install
삭제 remove
지워 uninstall
뿌리뽑아 purge
갱신 update
승급 upgrade
업글 upgrade
검색 search
감사 audit
돈줘 fund
밀어 push
당겨 pull
저질러 commit
상태 status
별일없니 status
탓해 blame
누구야 blame
역사왜곡 rebase
합쳐 merge
복제 clone
갈아타 checkout
환승 switch
가지 branch
일지 log
은닉 stash
짱박아 stash
추가 add
담아 add
가져와 fetch
개업 init
꼬리표 tag
먼곳 remote
무효 reset
무르기 revert
물러 revert
체리따기 cherry-pick
반갈죽 bisect
다른점 diff
보여줘 show
설정 config
대청소 clean
복원 restore
하청 submodule
실행 run
돌려 run
조립 build
빚어 build
시험 test
시작 start
멈춰 stop
그만 stop
재시작 restart
새로고침 reload
활성화 enable
켜둬 enable
비활성화 disable
꺼둬 disable
목록 list
대접 serve
출격 deploy
출판 publish
개발 dev
보풀제거 lint
각잡아 format
몇판 version
살려줘 help
침투 exec
통나무 logs
초상화 images
작곡 compose
창고 volume
인맥 network
가지치기 prune
--길게 -l
-길게 -l
--전부 -a
-전부 -a
--재귀 -r
-재귀 -r
--강제 -f
-강제 -f
--닥치고 -f
--사람답게 -h
--수다 -v
--조용히 -q
--응 -y
--넵 -y
--부모까지 -p
--메시지 -m
-메시지 -m
--한마디 -m
--출력 -o
--물어봐 -i
--전세계 -g
--새가지 -b
--몰래 -d
--살려줘 --help
--도움 --help
--몇판 --version
--버전 --version
--전부다 --all
--싹다 --all
--전지구 --global
--강제로 --force
--빡세게 --hard
--살살 --soft
--찜한거 --cached
--시늉만 --dry-run
--양심없이 --no-verify
--주저리주저리 --verbose
--재귀적으로 --recursive
--대화로 --interactive
--도자기 --porcelain
--정정보도 --amend
--짜부 --squash
--폭파 --delete
--유체이탈 --detach
--졸졸 --follow
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
