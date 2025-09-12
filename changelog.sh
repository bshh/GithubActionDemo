#!/bin/bash

# generate_changelog.sh
# 用法示例：./generate_changelog.sh [起始Tag] [结束Tag] [输出文件]
# 例如：./generate_changelog.sh v1.0.0 v1.1.0 CHANGELOG.md

START_TAG=$1
END_TAG=$2
OUTPUT_FILE=${3:-CHANGELOG.md} # 默认输出文件为 CHANGELOG.md

if [ -z "$START_TAG" ] || [ -z "$END_TAG" ]; then
    echo "错误: 请提供起始Tag和结束Tag。"
    echo "用法: $0 [起始Tag] [结束Tag] [输出文件（可选）]"
    exit 1
fi

# 获取两个tag之间的提交，并按Conventional Commits规范类型分类
echo "正在生成 $START_TAG 到 $END_TAG 之间的变更日志..."
{
    echo "# 变更日志 (Changelog)"
    echo "从 **$START_TAG** 到 **$END_TAG** 的版本变更摘要。"
    echo ""

    # 获取当前日期
    echo "生成日期: $(date +%Y-%m-%d)"
    echo ""

    # Feat: 新功能
    if git log --oneline --grep="^feat" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 🚀 新功能 (Features)"
        git log --oneline --grep="^feat" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Fix: Bug修复
    if git log --oneline --grep="^fix" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 🐛 Bug 修复 (Fixes)"
        git log --oneline --grep="^fix" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Docs: 文档更新
    if git log --oneline --grep="^docs" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 📚 文档更新 (Documentation)"
        git log --oneline --grep="^docs" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Style: 代码风格调整
    if git log --oneline --grep="^style" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 💎 代码风格 (Style)"
        git log --oneline --grep="^style" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Refactor: 代码重构
    if git log --oneline --grep="^refactor" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 🔨 代码重构 (Refactor)"
        git log --oneline --grep="^refactor" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Test: 测试相关
    if git log --oneline --grep="^test" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## ✅ 测试 (Tests)"
        git log --oneline --grep="^test" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Chore: 构建或工具变动
    if git log --oneline --grep="^chore" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 📦 构建或工具变动 (Chore)"
        git log --oneline --grep="^chore" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Perf: 性能优化
    if git log --oneline --grep="^perf" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## ⚡ 性能优化 (Performance)"
        git log --oneline --grep="^perf" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # Ci: CI配置变动
    if git log --oneline --grep="^ci" "$START_TAG..$END_TAG" | grep -q .; then
        echo "## 🤖 CI 配置 (Continuous Integration)"
        git log --oneline --grep="^ci" "$START_TAG..$END_TAG" | sed 's/^[a-f0-9]*/ -/'
        echo ""
    fi

    # 其他提交（可选，如果需要包含所有提交）
    # echo "## 其他变更"
     git log --oneline --pretty=format:"%s" "$START_TAG..$END_TAG" | grep -vE "^(feat|fix|docs|style|refactor|test|chore|perf|ci)" | sed 's/^[a-f0-9]*/ -/'

} > "$OUTPUT_FILE"

echo "变更日志已生成至 $OUTPUT_FILE"