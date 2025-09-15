# 開発スクリプト

このディレクトリには、Ruby gems 開発を効率化するスクリプトが含まれています。

## 📁 スクリプト一覧

- `setup.sh` - 開発環境の初期設定
- `test.sh` - テスト実行
- `lint.sh` - コード品質チェック
- `build.sh` - gem のビルド
- `publish.sh` - gem の公開

## 🚀 使用方法

各スクリプトに実行権限を付与してから使用してください：

```bash
chmod +x tools/scripts/*.sh
```

### 開発環境の設定

```bash
./tools/scripts/setup.sh
```

### テストの実行

```bash
./tools/scripts/test.sh
```

### コード品質チェック

```bash
./tools/scripts/lint.sh
```

### gem のビルド

```bash
./tools/scripts/build.sh
```

## 🔧 カスタマイズ

プロジェクトに応じてスクリプトをカスタマイズしてください。