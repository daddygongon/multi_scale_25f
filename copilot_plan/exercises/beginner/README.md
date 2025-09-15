# 初心者向け演習問題

## 📚 演習の進め方

1. 各演習を順番に進める
2. GitHub Copilot を積極的に活用する
3. テスト駆動開発を心がける
4. コードレビューの機会を作る

## 🎯 演習1: Hello World Gem

### 目標
最初のRuby gem を作成し、基本的な構造を理解する。

### 要件
- `hello_world` という名前のgem を作成
- `HelloWorld.greet(name)` メソッドを実装
- 適切なテストを作成

### 実装手順
1. `bundle gem hello_world` でgem を作成
2. メインモジュールを実装
3. テストを書く
4. READMEを更新

### Copilot チャレンジ
コメントを書いてCopilot にコードを生成してもらいましょう：

```ruby
# Create a greeting method that accepts a name and returns a personalized message
# The method should handle nil or empty names gracefully
def self.greet(name)
  # Copilot にコードを提案してもらう
end
```

---

## 🎯 演習2: 数学計算Gem

### 目標
基本的な数学計算を行うgem を作成する。

### 要件
- `math_helper` という名前のgem を作成
- 以下のメソッドを実装：
  - `add(a, b)` - 足し算
  - `subtract(a, b)` - 引き算
  - `multiply(a, b)` - 掛け算
  - `divide(a, b)` - 割り算（ゼロ除算エラーハンドリング含む）
  - `average(numbers)` - 配列の平均値

### テストケース例
```ruby
def test_addition
  assert_equal 5, MathHelper.add(2, 3)
end

def test_division_by_zero
  assert_raises MathHelper::DivisionByZeroError do
    MathHelper.divide(5, 0)
  end
end
```

### Copilot チャレンジ
```ruby
# Implement statistical functions: median, mode, standard deviation
module Statistics
  # Copilot に統計関数を提案してもらう
end
```

---

## 🎯 演習3: 文字列処理Gem

### 目標
文字列を処理するユーティリティgem を作成する。

### 要件
- `string_utils` という名前のgem を作成
- 以下の機能を実装：
  - `reverse_words(text)` - 単語の順序を逆にする
  - `count_words(text)` - 単語数をカウント
  - `capitalize_words(text)` - 各単語の最初の文字を大文字にする
  - `remove_duplicates(text)` - 重複する単語を削除

### 使用例
```ruby
StringUtils.reverse_words("Hello World Ruby")
# => "Ruby World Hello"

StringUtils.count_words("This is a test")
# => 4

StringUtils.capitalize_words("hello world")
# => "Hello World"
```

### Copilot チャレンジ
```ruby
# Add text analysis features: sentiment analysis, keyword extraction
class TextAnalyzer
  # Copilot に自然言語処理機能を提案してもらう
end
```

---

## 🎯 演習4: 設定管理Gem

### 目標
アプリケーションの設定を管理するgem を作成する。

### 要件
- `config_manager` という名前のgem を作成
- YAML、JSON、ENV変数から設定を読み込む
- 設定値の取得、設定、デフォルト値の機能

### 実装例
```ruby
config = ConfigManager.new('config.yml')
config.get('database.host', default: 'localhost')
config.set('database.port', 5432)
config.save
```

### Copilot チャレンジ
```ruby
# Add configuration validation and environment-specific configs
class ConfigValidator
  # Copilot に設定検証機能を提案してもらう
end
```

---

## 🎯 演習5: ログ出力Gem

### 目標
簡単なログ出力機能を持つgem を作成する。

### 要件
- `simple_logger` という名前のgem を作成
- 複数のログレベル（DEBUG, INFO, WARN, ERROR）
- ファイルとコンソールへの出力
- ログフォーマットのカスタマイズ

### 使用例
```ruby
logger = SimpleLogger.new('app.log')
logger.info('Application started')
logger.error('Something went wrong')
logger.debug('Debug information')
```

## 📋 提出要件

各演習について以下を含めて提出してください：

1. **ソースコード**
   - 適切なディレクトリ構造
   - 明確なコメント
   - エラーハンドリング

2. **テストコード**
   - 主要機能のテスト
   - エッジケースのテスト
   - 適切なアサーション

3. **ドキュメント**
   - README.md
   - 使用例
   - API ドキュメント

4. **Copilot 活用記録**
   - どのような場面でCopilot を使用したか
   - 生成されたコードをどう改善したか
   - 学んだことや気づき

## 🔍 評価ポイント

- **コードの品質**: 読みやすく保守しやすいコード
- **テストの充実度**: 適切なテストカバレッジ
- **エラーハンドリング**: 適切な例外処理
- **ドキュメント**: 分かりやすい説明と使用例
- **Copilot の活用**: 効果的な活用方法

## 💡 ヒント

1. **小さく始める**: 最小限の機能から始めて段階的に拡張
2. **テストファースト**: 機能を実装する前にテストを書く
3. **Copilot と対話**: コメントで意図を明確に伝える
4. **コードレビュー**: 同級生とコードを見せ合う
5. **Git の活用**: 小さなコミットを心がける