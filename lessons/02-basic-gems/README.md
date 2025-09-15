# Lesson 02: 基本的なgem開発

## 🎯 学習目標

- gem の基本構造を理解する
- 新しいgem を一から作成する
- gem の基本的な機能を実装する
- bundler gem コマンドの使用方法を習得する

## 📚 学習内容

### 1. gem の基本構造

典型的なgem のディレクトリ構造：

```
my_gem/
├── lib/
│   ├── my_gem/
│   │   └── version.rb
│   └── my_gem.rb
├── test/ または spec/
├── bin/
├── Gemfile
├── my_gem.gemspec
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### 2. gem の作成手順

#### Step 1: bundler gem コマンドを使用

```bash
bundle gem my_awesome_gem
cd my_awesome_gem
```

このコマンドにより、以下が自動生成されます：
- 基本的なディレクトリ構造
- gemspec ファイル
- README.md
- Git リポジトリ

#### Step 2: gemspec ファイルの編集

```ruby
# my_awesome_gem.gemspec
require_relative 'lib/my_awesome_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "my_awesome_gem"
  spec.version       = MyAwesomeGem::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "短い説明"
  spec.description   = "詳細な説明"
  spec.homepage      = "https://github.com/username/my_awesome_gem"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # 依存関係の指定
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
```

#### Step 3: メインファイルの実装

```ruby
# lib/my_awesome_gem.rb
require "my_awesome_gem/version"

module MyAwesomeGem
  class Error < StandardError; end
  
  def self.hello(name = "World")
    "Hello, #{name}!"
  end
end
```

```ruby
# lib/my_awesome_gem/version.rb
module MyAwesomeGem
  VERSION = "0.1.0"
end
```

## 🛠️ 実習: 簡単な計算機gem を作成

### 実習の目標

四則演算ができる簡単な計算機gem `simple_calculator` を作成します。

### Step 1: gem の作成

```bash
bundle gem simple_calculator
cd simple_calculator
```

### Step 2: 機能の実装

```ruby
# lib/simple_calculator.rb
require "simple_calculator/version"

module SimpleCalculator
  class Error < StandardError; end
  
  class Calculator
    def self.add(a, b)
      a + b
    end
    
    def self.subtract(a, b)
      a - b
    end
    
    def self.multiply(a, b)
      a * b
    end
    
    def self.divide(a, b)
      raise Error, "Division by zero" if b == 0
      a.to_f / b
    end
  end
end
```

### Step 3: テストの作成

```ruby
# test/test_simple_calculator.rb
require "test_helper"

class TestSimpleCalculator < Minitest::Test
  def test_addition
    assert_equal 5, SimpleCalculator::Calculator.add(2, 3)
  end
  
  def test_subtraction
    assert_equal 1, SimpleCalculator::Calculator.subtract(3, 2)
  end
  
  def test_multiplication
    assert_equal 6, SimpleCalculator::Calculator.multiply(2, 3)
  end
  
  def test_division
    assert_equal 2.0, SimpleCalculator::Calculator.divide(6, 3)
  end
  
  def test_division_by_zero
    assert_raises SimpleCalculator::Error do
      SimpleCalculator::Calculator.divide(5, 0)
    end
  end
end
```

### Step 4: テストの実行

```bash
bundle exec rake test
```

## 🤖 Copilot の活用方法

### 1. メソッドの自動生成

コメントを書くとCopilot がメソッドを提案：

```ruby
# Calculate the power of a number
def self.power(base, exponent)
  # Copilot が実装を提案
```

### 2. テストケースの生成

```ruby
# Test edge cases for calculator methods
def test_edge_cases
  # Copilot がテストケースを提案
```

### 3. エラーハンドリングの改善

```ruby
# Add error handling for invalid inputs
def self.add(a, b)
  # Copilot が適切なバリデーションを提案
```

## 📝 演習問題

### 問題1: 機能拡張

simple_calculator gem に以下の機能を追加してください：

1. 平方根計算 (`sqrt`)
2. 累乗計算 (`power`)
3. 平均値計算 (`average`) - 配列を受け取る

### 問題2: CLI インターフェース

gem にコマンドラインインターフェースを追加してください：

```bash
simple_calculator add 5 3
# => 8

simple_calculator divide 10 2
# => 5.0
```

### 問題3: エラーハンドリング

以下のエラーケースを適切に処理してください：

- 数値以外の入力
- 無効な演算子
- 不正な引数の数

## 🔧 開発のベストプラクティス

### 1. バージョン管理

```ruby
# セマンティックバージョニングを使用
# MAJOR.MINOR.PATCH
VERSION = "1.2.3"
```

### 2. ドキュメント

```ruby
# YARD形式でドキュメントを記述
# @param [Numeric] a 第一引数
# @param [Numeric] b 第二引数
# @return [Numeric] 計算結果
def self.add(a, b)
  a + b
end
```

### 3. 例外処理

```ruby
class Calculator
  class InvalidInputError < StandardError; end
  
  def self.add(a, b)
    validate_numeric(a, b)
    a + b
  end
  
  private
  
  def self.validate_numeric(*args)
    args.each do |arg|
      raise InvalidInputError unless arg.is_a?(Numeric)
    end
  end
end
```

## 📋 チェックリスト

- [ ] bundler gem コマンドでgem を作成できた
- [ ] gemspec ファイルを適切に設定できた
- [ ] 基本的な機能を実装できた
- [ ] テストを作成して実行できた
- [ ] Copilot を活用してコードを書けた
- [ ] 演習問題を完了した

## ➡️ 次のレッスン

[Lesson 03: gem構造の理解](../03-gem-structure/) に進みましょう。