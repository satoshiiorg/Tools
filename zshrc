if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export GITLAB_HOME=~/gitlab

PROMPT="%# %. "
# RPROMPT="%*"

# 参考: https://qiita.com/ko1nksm/items/095bdb8f0eca6d327233
ESC=$(printf '\033')
RESET="${ESC}[0m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
BLUE="${ESC}[34m"
MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"

function preexec() {
  start_seconds=`date +%s`
}

function precmd() {
  # 空打ちした時は何もしない
  if [ -z "$start_seconds" ]; then
    return 0
  fi
  
  end_seconds=`date +%s`
  end_time=`date +%T`
  run_seconds=$((end_seconds - start_seconds))
  start_seconds=""
  
  # エスケープも文字数にカウントされるのでその分除外する
  printf "%$((${COLUMNS} + ${#GREEN} + ${#RESET} + ${#CYAN} + ${#RESET}))s\n" "(${GREEN}${run_seconds}s${RESET}) ${CYAN}${end_time}${RESET}"
  # 簡易版
  # printf "${CYAN}%${COLUMNS}s${RESET}\n" "(${run_seconds}s) ${end_time} "

  # 一定時間以上かかってたら通知
  if [ "$run_seconds" -gt 5 ]; then
    if [ "$run_seconds" -gt 60 ]; then
      runtime="$((${run_seconds} / 60))分$((${run_seconds} % 60))秒"
    else
      runtime="${run_seconds}秒"
    fi
    osascript -e "display notification \"${end_time} (${runtime})\" with title \"実行完了\""
    say "実行完了: ${runtime}"
#  else
#    # そうでなければベルだけ鳴らす
#    echo "\007"
  fi
}
