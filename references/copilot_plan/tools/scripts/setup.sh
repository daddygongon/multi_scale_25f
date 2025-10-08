#!/bin/bash

# Ruby Gems 開発環境セットアップスクリプト

echo "🚀 Ruby Gems 開発環境をセットアップしています..."

# Ruby のバージョンチェック
echo "📋 Ruby バージョンを確認中..."
ruby --version

# Bundler のインストール確認
if ! command -v bundle &> /dev/null; then
    echo "📦 Bundler をインストール中..."
    gem install bundler
else
    echo "✅ Bundler は既にインストールされています"
fi

# 依存関係のインストール
if [ -f "Gemfile" ]; then
    echo "📦 依存関係をインストール中..."
    bundle install
else
    echo "⚠️  Gemfile が見つかりません"
fi

# Git フックの設定
if [ -d ".git" ]; then
    echo "🔗 Git フックを設定中..."
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "🔍 コミット前チェックを実行中..."

# RuboCop チェック
if bundle exec rubocop --format simple; then
    echo "✅ RuboCop チェック完了"
else
    echo "❌ RuboCop エラーが見つかりました"
    exit 1
fi

# テスト実行
if bundle exec rake test; then
    echo "✅ テスト完了"
else
    echo "❌ テストが失敗しました"
    exit 1
fi
EOF
    chmod +x .git/hooks/pre-commit
    echo "✅ Git フック設定完了"
fi

echo "🎉 セットアップが完了しました！"