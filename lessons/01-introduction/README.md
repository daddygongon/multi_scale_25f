# Lesson 01: Ruby gems入門

## 🎯 学習目標

- Ruby gemsとは何かを理解する
- gem の基本的な使い方を学ぶ
- 開発環境の構築方法を習得する
- GitHub + VSCode + Copilot の連携を理解する

## 📋 前提知識

- Ruby の基本文法
- コマンドラインの基本操作
- Git の基本コマンド

## 📚 学習内容

### 1. Ruby gemsとは

Ruby gemsは、Rubyプログラムやライブラリを配布するためのパッケージングシステムです。

**主な特徴:**
- 依存関係の管理
- バージョン管理
- 簡単なインストール・アンインストール
- RubyGems.orgでの配布

### 2. gem の基本コマンド

```bash
# gem の検索
gem search gem名

# gem のインストール
gem install gem名

# インストール済みgem の一覧
gem list

# gem の詳細情報
gem info gem名

# gem のアンインストール
gem uninstall gem名
```

### 3. Bundler の使用

```bash
# Bundler のインストール
gem install bundler

# Gemfile の作成
bundle init

# 依存関係のインストール
bundle install

# Gemfile.lock の更新
bundle update
```

### 4. 開発環境の設定

#### VSCode の設定

1. **必要な拡張機能**
   - Ruby
   - GitHub Copilot
   - GitLens
   - Ruby Solargraph

2. **settings.json の設定**
```json
{
  "ruby.intellisense": "rubyLanguageServer",
  "ruby.format": "rubocop",
  "editor.formatOnSave": true
}
```

## 🛠️ 実習

### 実習1: 基本的なgem操作

1. `colorize` gem をインストールしてみましょう
```bash
gem install colorize
```

2. 簡単なRubyスクリプトを作成して動作確認
```ruby
# test_colorize.rb
require 'colorize'

puts "Hello, World!".red
puts "Ruby gems".green.bold
puts "Learning is fun!".blue.underline
```

### 実習2: Bundler を使ったプロジェクト作成

1. 新しいディレクトリを作成
```bash
mkdir my_first_gem_project
cd my_first_gem_project
```

2. Bundler でプロジェクトを初期化
```bash
bundle init
```

3. Gemfile を編集
```ruby
source 'https://rubygems.org'

gem 'colorize'
gem 'faker'
```

4. 依存関係をインストール
```bash
bundle install
```

## 🤖 Copilot の活用

### Copilot で効率的にコードを書く

1. **コメントからコード生成**
```ruby
# Generate a random colorized greeting message using faker and colorize gems
```

2. **関数の自動補完**
```ruby
def generate_greeting
  # Copilot が続きを提案してくれます
```

3. **テストコードの生成**
```ruby
# Write a test for the greeting function
```

## 📝 演習問題

### 問題1: gem 情報の調査

以下のgem について調べて、表形式でまとめてください：
- `rails`
- `sinatra`
- `nokogiri`
- `rspec`

### 問題2: Gemfile の作成

Webアプリケーション開発用のGemfile を作成してください。以下のgem を含めること：
- Rails フレームワーク
- データベース（PostgreSQL）
- テストフレームワーク
- 開発用ツール

### 問題3: Copilot との協働

Copilot を使って、ランダムな名言を表示するプログラムを作成してください。colorize gem を使って文字を装飾すること。

## 🔗 参考リンク

- [RubyGems.org](https://rubygems.org/)
- [Bundler 公式サイト](https://bundler.io/)
- [Ruby gems ガイド](https://guides.rubygems.org/)
- [VSCode Ruby 拡張機能](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)

## 📋 チェックリスト

- [ ] Ruby gems の概念を理解した
- [ ] 基本的なgem コマンドを実行できた
- [ ] Bundler を使ってプロジェクトを作成できた
- [ ] VSCode + Copilot の環境を構築できた
- [ ] 演習問題を完了した

## ➡️ 次のレッスン

[Lesson 02: 基本的なgem開発](../02-basic-gems/) に進みましょう。