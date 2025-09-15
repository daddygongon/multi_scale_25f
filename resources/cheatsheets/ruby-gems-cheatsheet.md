# Ruby Gems 開発チートシート

## 📋 基本コマンド

### Gem 管理

```bash
# gem の検索
gem search <gem名>

# gem のインストール
gem install <gem名>

# インストール済みgem の一覧
gem list

# gem の詳細情報
gem info <gem名>

# gem のアンインストール
gem uninstall <gem名>

# gem のバージョン一覧
gem list <gem名> --remote --all
```

### Bundler

```bash
# Bundler のインストール
gem install bundler

# Gemfile の作成
bundle init

# 依存関係のインストール
bundle install

# 依存関係の更新
bundle update

# gem の追加
bundle add <gem名>

# 実行
bundle exec <コマンド>
```

### Gem 開発

```bash
# 新しいgem の作成
bundle gem <gem名>

# gem のビルド
gem build <gem名>.gemspec

# gem のローカルインストール
gem install ./<gem名>-<version>.gem

# gem の公開
gem push <gem名>-<version>.gem
```

## 🏗️ Gem 構造

### 典型的なディレクトリ構造

```
my_gem/
├── lib/
│   ├── my_gem/
│   │   └── version.rb
│   └── my_gem.rb
├── test/ または spec/
├── bin/
├── exe/
├── Gemfile
├── my_gem.gemspec
├── README.md
├── LICENSE
├── CHANGELOG.md
└── Rakefile
```

### 重要なファイル

- **gemspec**: gem の仕様を定義
- **lib/**: メインのソースコード
- **test/ or spec/**: テストファイル
- **bin/**: 開発用実行可能ファイル
- **exe/**: 本番用実行可能ファイル

## 📝 Gemspec の書き方

```ruby
Gem::Specification.new do |spec|
  spec.name          = "gem名"
  spec.version       = "0.1.0"
  spec.authors       = ["作者名"]
  spec.email         = ["email@example.com"]
  
  spec.summary       = "短い説明"
  spec.description   = "詳細な説明"
  spec.homepage      = "https://github.com/user/gem"
  spec.license       = "MIT"
  
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  # 依存関係
  spec.add_dependency "依存gem", "~> 1.0"
  spec.add_development_dependency "開発依存gem", "~> 2.0"
end
```

## 🧪 テストフレームワーク

### Minitest

```ruby
require "test_helper"

class TestMyGem < Minitest::Test
  def test_something
    assert_equal expected, actual
  end
  
  def test_raises_error
    assert_raises MyGem::Error do
      MyGem.dangerous_method
    end
  end
end
```

### RSpec

```ruby
require 'spec_helper'

RSpec.describe MyGem do
  describe '#method' do
    it 'returns expected value' do
      expect(MyGem.method).to eq(expected)
    end
    
    it 'raises error for invalid input' do
      expect { MyGem.method(invalid) }.to raise_error(MyGem::Error)
    end
  end
end
```

## 🚀 VSCode + Copilot のコツ

### 効果的なコメントの書き方

```ruby
# Calculate the factorial of a number using recursion
def factorial(n)
  # Copilot が実装を提案
end

# Generate a random password with specified length and complexity
def generate_password(length, include_symbols: true)
  # Copilot が実装を提案
end
```

### テスト生成

```ruby
# Write comprehensive tests for the Calculator class
class TestCalculator < Minitest::Test
  # Copilot がテストケースを提案
end
```

## 🔧 便利なRakeタスク

```ruby
# Rakefile
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: :test

# カスタムタスク
desc "Run RuboCop"
task :rubocop do
  sh "bundle exec rubocop"
end

desc "Generate documentation"
task :doc do
  sh "yard doc"
end
```

## 📚 バージョニング（Semantic Versioning）

```
MAJOR.MINOR.PATCH

MAJOR: 互換性のない変更
MINOR: 後方互換性のある機能追加
PATCH: 後方互換性のあるバグ修正
```

例: `1.2.3` → `2.0.0` (breaking change) → `2.1.0` (new feature) → `2.1.1` (bug fix)

## 🔒 セキュリティ

```bash
# 脆弱性チェック
bundle audit

# gem の署名
gem cert --build your_email@example.com
gem build your_gem.gemspec --sign
```

## 🌐 公開前チェックリスト

- [ ] テストが全て通る
- [ ] RuboCop が通る
- [ ] README が充実している
- [ ] CHANGELOG が更新されている
- [ ] ライセンスが設定されている
- [ ] バージョンが適切に設定されている
- [ ] 依存関係が最小限
- [ ] セキュリティチェックが完了