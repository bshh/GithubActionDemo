#!/usr/bin/env bash
set -euo pipefail

# --- 计算范围 ---
PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
if [ -n "$PREV_TAG" ]; then
  RANGE="$PREV_TAG..HEAD"
else
  RANGE="$(git rev-list --max-parents=0 HEAD)..HEAD"
fi

echo "PREV_TAG=$PREV_TAG"
echo "RANGE=$RANGE"

OUT_FILE="release_notes.md"
: > "$OUT_FILE"

# --- 标题 ---
feat_title="## ✨ Features"
fix_title="## 🐛 Bug Fixes"
docs_title="## 📖 Documentation"
refactor_title="## ♻️ Refactoring"
perf_title="## ⚡ Performance"
test_title="## ✅ Tests"
chore_title="## 🔧 Chores"
others_title="## 🔹 Others"

# --- 初始化 ---
feat_entries=""
fix_entries=""
docs_entries=""
refactor_entries=""
perf_entries=""
test_entries=""
chore_entries=""
others_entries=""

# --- 读取 commit（保留 hash + subject） ---
 git log $RANGE --pretty=format:"%h %s" > 1.txt
           echo "" >> 1.txt
 while IFS= read -r line; do
  echo "DEBUG line=$line"   # 调试用，可删除

  msg="${line#* }"   # 去掉 hash，只留 message

  case "$msg" in
    feat:*|feat\(*\):*)
       echo "feat_entries"
      feat_entries="${feat_entries}- $line"
      #echo ${feat_entries}
      ;;
    fix:*|fix\(*\):*)
    echo "fix_entries"
      fix_entries="${fix_entries}- $line"$'\n'
      ;;
    docs:*|docs\(*\):*)
    echo "docs_entries"
      docs_entries="${docs_entries}- $line"$'\n'
      ;;
    refactor:*|refactor\(*\):*)
    echo "refactor_entries"
      refactor_entries="${refactor_entries}- $line"$'\n'
      ;;
    perf:*|perf\(*\):*)
    echo "perf"
      perf_entries="${perf_entries}- $line"$'\n'
      ;;
    test:*|test\(*\):*)
    echo "test"
      test_entries="${test_entries}- $line"$'\n'
      ;;
    chore:*|chore\(*\):*)
    echo "chore_entries"
      chore_entries="${chore_entries}- $line"
      #echo ${chore_entries}
      ;;
    *)
      echo "others_entries"
      others_entries="${others_entries}- $line"$'\n'
      ;;
  esac
done < 1.txt
#done < <(git log $RANGE --pretty=format:"%h %s")

# --- 写入文件 ---
write_section() {
  local title="$1"
  local content="$2"
  if [ -n "$content" ]; then
    printf '%s\n\n' "$title" >> "$OUT_FILE"
    printf '%s\n' "$content" >> "$OUT_FILE"
    printf '\n' >> "$OUT_FILE"
  fi
}
echo "111"
echo $feat_entries
echo $chore_entries
echo "2222"
write_section "$feat_title" "$feat_entries"
write_section "$fix_title" "$fix_entries"
write_section "$docs_title" "$docs_entries"
write_section "$refactor_title" "$refactor_entries"
write_section "$perf_title" "$perf_entries"
write_section "$test_title" "$test_entries"
write_section "$chore_title" "$chore_entries"
write_section "$others_title" "$others_entries"

echo "✅ Changelog generated in $OUT_FILE"
