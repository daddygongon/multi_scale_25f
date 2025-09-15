# Ruby Gems 開発教材 - 情報工学大学院課程

このリポジトリは、GitHub + VSCode + Copilot を活用したRuby gems開発を学ぶための教材集です。

## 📁 ディレクトリ構成

```
multi_scale_25f/
├── lessons/           # 段階的な学習レッスン
├── examples/          # 実践的なgem例
├── exercises/         # 演習問題
├── projects/          # 学生プロジェクト
├── resources/         # 参考資料
└── tools/            # 開発ツール設定
```

## 🎯 学習目標

- Ruby gemsの基本概念と構造の理解
- GitHub を活用した協働開発のワークフロー
- VSCode + Copilot による効率的な開発体験
- テスト駆動開発（TDD）の実践
- gem の公開とメンテナンス

## 🚀 始め方

1. **環境設定**
   ```bash
   git clone https://github.com/daddygongon/multi_scale_25f.git
   cd multi_scale_25f
   ```

2. **VSCode拡張機能の設定**
   - `tools/vscode-settings/` の設定を適用
   - GitHub Copilot 拡張機能をインストール

3. **学習の開始**
   - `lessons/01-introduction/` から順番に進める

## 📚 カリキュラム

### 基礎編
- [Lesson 01: Ruby gems入門](lessons/01-introduction/)
- [Lesson 02: 基本的なgem開発](lessons/02-basic-gems/)
- [Lesson 03: gem構造の理解](lessons/03-gem-structure/)

### 実践編
- [Lesson 04: テスト駆動開発](lessons/04-testing/)
- [Lesson 05: gem の公開](lessons/05-publishing/)
- [Lesson 06: 高度なトピック](lessons/06-advanced-topics/)

## 💎 サンプルgem

- [Simple Gem](examples/simple-gem/) - 最小限のgem例
- [Calculator Gem](examples/calculator-gem/) - 計算機gem
- [Web Scraper Gem](examples/web-scraper-gem/) - Webスクレイピング
- [CLI Tool Gem](examples/cli-tool-gem/) - コマンドラインツール

## 🔧 開発ツール

- **VSCode設定**: エディタの最適化設定
- **GitHub Actions**: CI/CDワークフロー
- **開発スクリプト**: よく使うコマンドの自動化

## 📖 参考資料

- [Ruby gems公式ガイド](resources/documentation/)
- [開発チートシート](resources/cheatsheets/)
- [外部リファレンス](resources/references/)

## 🤝 貢献方法

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📝 ライセンス

このプロジェクトはMITライセンスのもとで公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 👨‍🏫 講師情報

**担当講師**: [Your Name]  
**連絡先**: [your.email@university.edu]  
**オフィスアワー**: [曜日・時間]

---

**Note**: このリポジトリは教育目的で作成されています。実際のプロダクション環境での使用前には、適切なセキュリティレビューを実施してください。
