---
name: figma-create-screen
description: Figma画面の新規作成時に使用。画面テンプレート、共通構造、命名規則、フィードバック表示ルールを参照する。新規画面作成・状態バリエーション追加時に呼び出す。
---

# Figma 画面作成ガイド

## 作業フロー

1. 参考デザインの構造確認（`get_metadata`）
2. 使用コンポーネントのバリアント名確認（`figma_execute` で `children.map(v => v.name)`）
3. フレーム作成 → コンポーネント配置 → Variable バインド
4. テキスト設定（テキストスタイル経由）
5. セルフレビュー（`/figma-review` を実行）

## 画面フレーム設定

- 幅: 1440px 固定
- 高さ: 1024px 基本。コンテンツが超える場合は Hug contents
- 参考デザインとX座標が被らない位置に配置

### 一覧系画面（Header付き）の共通構造

```
Frame (1440×1024)
├── Header (x:0, y:0, 1440×64)
└── Contents (x:0, y:64, 1440×960)
    ├── Tabs / Nav (x:40, y:24, 1360×44)  ← Contents内に配置
    └── 以降の要素は左右 padding 40px（x:40, 幅:1360）
```

### 認証系画面（Header無し）の共通構造

```
Frame (1440×1024)
└── Contents (x:464, y:160, 512×可変)  ← 中央配置
    ├── Logo (x:176, 160×50)            ← Contents内で中央
    └── Form (x:0, y:98, 512×可変)
```

### Contents内のレイアウト間隔

| 位置 | 値 |
|---|---|
| Contents左右パディング | 40px |
| Contents上パディング（最初の要素まで） | 24px |
| コンテンツ幅 | 1360px (1440 - 40×2) |
| フォーム幅 | 512px |
| フィルター要素間の垂直gap | 16px |
| Table → Pagination | 0px（直結） |

### 一覧画面の共通構成

```
Contents
├── Tabs / Nav (x:40, y:24, 1360×44)
├── アクションボタン (x:40, y:92, h:40〜48)
├── [フィルターセクション] ※画面による
├── [ステータスフィルター (Pill)] ※画面による
├── Table
└── Pagination (Tableの直下、gap:0)
```

### フォーム画面の共通構成

```
Contents
├── Tabs / Nav (x:40, y:24, 1360×44)
├── IconButton / 戻る (40×40, x:40, y:92)
├── ページタイトル (x:40)
├── [Alert] ※エラー時のみ。タイトルとの gap: 16px
└── フォーム (x:40, 幅:512px)
    ├── Input群 (gap: 16px)
    └── Button / Submit (幅:512, 最下部)
```

## 状態バリエーションの命名規則

```
{画面名}           → デフォルト状態
{画面名}_Empty     → データなし
{画面名}_Loading   → ローディング中（Skeleton表示）
{画面名}_Filled    → 入力済み
{画面名}_Error     → バリデーションエラー
{画面名}_Feedback  → 完了フィードバック（Toast表示）
```

## フィードバック表示ルール

| 種類 | コンポーネント | 配置 |
|---|---|---|
| 成功通知 | Toast (success) | 画面右下、Absolute |
| エラー通知（軽度） | Toast (error) | 画面右下、Absolute |
| エラー通知（重度） | Alert (error) | フォーム上部、Inline |
| フィールドエラー | Input (State=error) | 該当フィールド直下 |
