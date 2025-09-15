# Simple Gem Example

このディレクトリには、最もシンプルなRuby gem の例が含まれています。

## 📁 ファイル構成

```
simple-gem/
├── lib/
│   ├── simple_gem/
│   │   └── version.rb
│   └── simple_gem.rb
├── test/
│   ├── test_helper.rb
│   └── test_simple_gem.rb
├── Gemfile
├── simple_gem.gemspec
└── README.md
```

## 🎯 学習ポイント

- 最小限のgem 構造
- 基本的なモジュール定義
- シンプルなテスト
- gemspec の基本設定

## 🚀 使用方法

### インストール

```bash
cd simple-gem
bundle install
```

### テスト実行

```bash
bundle exec rake test
```

### 使用例

```ruby
require 'simple_gem'

puts SimpleGem.hello
# => "Hello from SimpleGem!"

puts SimpleGem.hello("Ruby")
# => "Hello, Ruby!"
```

## 📚 コード詳解

### メインモジュール

```ruby
# lib/simple_gem.rb
module SimpleGem
  # 簡単な挨拶メソッド
  def self.hello(name = nil)
    if name
      "Hello, #{name}!"
    else
      "Hello from SimpleGem!"
    end
  end
end
```

### テスト

```ruby
# test/test_simple_gem.rb
require "test_helper"

class TestSimpleGem < Minitest::Test
  def test_hello_without_name
    assert_equal "Hello from SimpleGem!", SimpleGem.hello
  end
  
  def test_hello_with_name
    assert_equal "Hello, Ruby!", SimpleGem.hello("Ruby")
  end
end
```

## 🤖 Copilot Challenge

このgem を拡張するためのCopilot 活用チャレンジ：

1. **多言語対応**: 複数の言語で挨拶できる機能を追加
2. **時刻対応**: 時間に応じて挨拶を変える機能
3. **カスタマイズ**: ユーザー設定を保存する機能

コメントを書いてCopilot に実装を提案してもらいましょう！