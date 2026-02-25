# shizai-pro

## Project Overview
Rails 8.1 + Tailwind CSS 4 project, targeting AWS Amplify deployment.

## Tech Stack
- Ruby 3.3.10 (rbenv)
- Rails 8.1.2
- Tailwind CSS 4 (via tailwindcss-rails)
- SQLite3
- Importmap for JS
- Hotwire (Turbo + Stimulus)

## Figma Integration
- Figma MCP is configured for design-to-code workflows
- Source design: https://www.figma.com/design/tnxuN8LS2uMJEw2lYnvx69/shizai-pro

## Development
- `bin/dev` to start development server (Puma + Tailwind watcher)
- `bin/rails tailwindcss:build` to build Tailwind CSS

## Deployment
- AWS Amplify (see amplify.yml)

---

## Component Catalog ルール（必須）

### 基本原則
UI を構築する際は、必ず Component Catalog のコードをそのまま使うこと。
独自のスタイルやクラスを新たに作らない。

- カタログ場所: `/Users/skrt/Claude/component-catalog/previews/`
- 公開URL: https://skrt.github.io/component-catalog/
- カタログは静的 HTML + TailwindCSS CDN で構成されている

### ワークフロー

1. **ページ構築時**: カタログの該当 preview ファイルを `Read` で読み、HTML/CSS クラスをそのまま Rails ビューにコピーする
2. **カタログにないコンポーネントが必要な場合**: 勝手に作らず、ユーザーに「カタログに追加しますか？」と確認する
3. **デザイン変更時**: Figma → Catalog → Rails の順で反映する（Railsだけ変えない）

### コンポーネント一覧と対応ファイル

| カタログ | preview ファイル | 用途 |
|---|---|---|
| Alert | alert.html | アラート・通知バナー |
| Approval Flow | approval-flow.html | 承認フロー表示 |
| Attachment | attachment.html | ファイル添付 |
| Badge | badge.html | ステータスバッジ（rounded-full, h-5, px-2） |
| Button | button.html | ボタン（primary/sub/alert × xs/sm/md/lg） |
| Calc | calc.html | 計算・集計表示 |
| Card | card.html | カード |
| Checkbox | checkbox.html | チェックボックス |
| Colors | colors.html | カラーパレット参照 |
| Combobox | combobox.html | コンボボックス（検索付きセレクト） |
| Datepicker | datepicker.html | 日付選択・日付範囲選択 |
| Detail Row | detail-row.html | 詳細行（キー・バリュー表示） |
| Header | header.html | ページヘッダー |
| Icon Button | icon-button.html | アイコンボタン（xs/sm/md/lg） |
| Input | input.html | テキスト入力 |
| Modal | modal.html | モーダルダイアログ |
| Pagination | pagination.html | ページネーション（テーブル内配置） |
| PO Preview | po-preview.html | 発注書プレビュー |
| Popover | popover.html | ポップオーバー |
| Radio Button | radio-button.html | ラジオボタン |
| Select | select.html | セレクトボックス |
| Switch | switch.html | トグルスイッチ |
| Table | table.html | テーブル（border なし, radius なし, header border-b なし） |
| Tabs | tabs.html | タブ（Underline / Pill） |
| Text Area | text-area.html | テキストエリア |
| Title | title.html | タイトル・見出し |
| Toast | toast.html | トースト通知 |
| Tooltip | tooltip.html | ツールチップ |
| Typography | typography.html | タイポグラフィ参照 |

### Rails 側の対応パーシャル（現在）

| Rails パーシャル | カタログ |
|---|---|
| `layouts/application.html.erb` | header.html, tabs.html (Underline) |
| `shared/_nav_tab.html.erb` | tabs.html (Underline: p-3) |
| `purchase_orders/index.html.erb` | button.html, table.html |
| `purchase_orders/_filter.html.erb` | datepicker.html, combobox.html, input.html |
| `purchase_orders/_status_tabs.html.erb` | tabs.html (Pill) |
| `purchase_orders/_pagination.html.erb` | pagination.html |

### コード参照の手順

```
1. カタログの preview ファイルを Read で開く
2. 該当セクションの HTML をコピー
3. Rails テンプレートに埋め込む（ERB タグで動的部分を置換）
4. Tailwind クラスはカタログのものをそのまま使う
5. カスタムカラー（btn-primary 等）は application.css の @theme で定義済み
```

### font-family
- Rails: `ui-sans-serif, system-ui, sans-serif`（application.css の --font-sans）
- Catalog: Tailwind CDN デフォルト（同等）
- Google Fonts は使わない
