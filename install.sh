#!/bin/sh
# 코터 설치기 — curl -fsSL https://raw.githubusercontent.com/suhjae/koter/main/install.sh | sh
set -e

REPO="https://raw.githubusercontent.com/suhjae/koter/main"
DIR="$HOME/.코터"

mkdir -p "$DIR"
# 로컬 저장소에서 실행하면 복사, 아니면 다운로드
if [ -f "$(dirname "$0")/코터.sh" ]; then
  cp "$(dirname "$0")/코터.sh" "$DIR/코터.sh"
else
  curl -fsSL "$REPO/코터.sh" -o "$DIR/코터.sh"
fi

LINE='[ -f "$HOME/.코터/코터.sh" ] && . "$HOME/.코터/코터.sh"  # 코터'
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$rc" ] && ! grep -q '코터' "$rc"; then
    printf '\n%s\n' "$LINE" >> "$rc"
  fi
done

echo "🇰🇷 코터 설치 완료! 새 터미널을 여세요."
echo "   목록: 코터 / 끄기: 영어로 / 완전 삭제: 코터그만"
