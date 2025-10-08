# VSCode 設定

このディレクトリには、Ruby gems 開発に最適化されたVSCode設定が含まれています。

## 📁 ファイル構成

- `settings.json` - エディタ設定
- `extensions.json` - 推奨拡張機能
- `launch.json` - デバッグ設定
- `tasks.json` - タスク設定

## 🚀 設定の適用方法

### 1. プロジェクト単位での設定

プロジェクトルートに `.vscode` フォルダを作成し、これらのファイルをコピーしてください：

```bash
mkdir .vscode
cp tools/vscode-settings/* .vscode/
```

### 2. ユーザー設定での適用

VSCode の設定画面から、必要な設定を手動で追加してください。

## 🔧 主な設定内容

### Ruby 開発の最適化
- Solargraph による IntelliSense
- RuboCop による自動フォーマット
- 保存時の自動フォーマット

### GitHub Copilot の活用
- インライン提案の有効化
- コメントからのコード生成
- テスト生成の支援

### Git 統合
- GitLens による履歴表示
- 差分の可視化
- ブランチ管理の簡素化

## 📋 推奨拡張機能

1. **Ruby** - Ruby言語サポート
2. **Ruby Solargraph** - IntelliSense とコード補完
3. **GitHub Copilot** - AI支援コード生成
4. **GitLens** - Git 履歴と blame 情報
5. **Ruby Test Explorer** - テスト実行とデバッグ
6. **YAML** - YAML ファイルの構文強調
7. **Markdown All in One** - Markdown サポート