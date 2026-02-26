---
name: figma-create-component
description: 新規Figmaコンポーネント作成時に使用。セマンティックトークン設計、構造パターン、サイズ/状態バリアント、チェックリスト、コンポーネント一覧への自動登録を含む。コンポーネントを新規作成する際に呼び出す。
---

# Figma コンポーネント作成ガイド

> **注意**: 絶対ルール（Variable バインド必須、テキストスタイル必須、ローカルコンポーネントのみ等）は CLAUDE.md に記載済み。ここでは省略。

---

## Design Thinking — 作成前に考えること

- **目的**: このコンポーネントはどの問題を解決するか？ユーザーフローのどこに登場するか？
- **一貫性**: 既存のトークン・パターンと整合するか？新規Variable/スタイル作成前に既存を確認する
- **状態とエッジケース**: 全インタラクション状態（default, hover, focus, error, disabled, filled）を検討
- **アクセシビリティ**: WCAG AA以上のコントラスト比、明確なフォーカスインジケーター

---

## セマンティックトークン体系

### カラートークン

```
text/
├─ primary     → color/gray/900
├─ secondary   → color/gray/600
├─ tertiary    → color/gray/400
└─ error       → color/red/500

action/
├─ primary/
│  ├─ default, hover, active → color/blue/*
│  └─ foreground → color/white
├─ secondary/
│  ├─ default, hover, active → color/gray/*
│  └─ foreground-default/hover/active → color/gray/*
├─ danger/
│  ├─ default, hover, active → color/red/*
│  └─ foreground-default/hover/active → color/white
└─ disabled/
   ├─ background → color/gray/200
   └─ foreground → color/gray/400

form/input/
├─ bg-default, bg-disabled
├─ border-default, border-focus, border-error, border-disabled
└─ ring-focus, ring-error

icon/
├─ default → color/gray/600
└─ disabled → color/gray/300

status/
├─ success/bg, success/icon → color/green/50, color/green/600
├─ warning/bg, warning/icon → color/yellow/50, color/yellow/600
├─ error/bg, error/icon → color/red/50, color/red/600
└─ info/bg, info/icon → color/gray/50, color/gray/600
```

### スペーシング・ラディウストークン

```
spacing/                    radius/
├─ 0-5 → 2px               ├─ sm   → 4px
├─ 1   → 4px               ├─ md   → 8px
├─ 1-5 → 6px               ├─ lg   → 12px
├─ 2   → 8px               └─ full → 9999px
├─ 2-5 → 10px
├─ 3   → 12px
├─ 4   → 16px
├─ 5   → 20px
└─ 6   → 24px
```

---

## コンポーネント構造パターン

### フォーム系（Input, Select, TextArea）

```
Component (VERTICAL, gap: spacing/2)
├─ Label Frame (HORIZONTAL, MIN)
│  ├─ Label (text/primary, text-sm/medium)
│  └─ Asterisk (text/error, Boolean Property)
├─ Input Frame (HORIZONTAL, CENTER)
│  ├─ Left Icon (Icon/Slot, hidden, Boolean Property)
│  ├─ Text (FILL + layoutGrow: 1)
│  └─ Right Icon (Icon/Slot, hidden, Boolean Property)
├─ Helper Text (text/secondary, text-xs/normal, Boolean Property)
└─ Error Text (text/error, text-xs/normal, Boolean Property, hidden)
```

### アクション系（Button, IconButton）

```
Component (HORIZONTAL, CENTER)
├─ Left Icon (Icon/Slot, hidden, Boolean Property)
├─ Label (action/*/foreground, text-sm/medium)
└─ Right Icon (Icon/Slot, hidden, Boolean Property)
```

### フィードバック系（Alert, Toast）

```
Component (HORIZONTAL, gap: spacing/3)
├─ Status Icon (Icon/Slot, status/*/icon)
├─ Content (VERTICAL, gap: spacing/1, FILL + layoutGrow: 1)
│  ├─ Title (text/primary, text-sm/medium, Boolean Property)
│  └─ Description (text/secondary, text-sm/normal)
└─ Close Button (hidden, Boolean Property)
```

---

## サイズバリアント

| Size | Padding | Gap | Text Style | Icon Size |
|------|---------|-----|------------|-----------|
| xs | px-2 py-1 | gap-1 | text-xs | 12px |
| sm | px-3 py-1.5 | gap-1.5 | text-sm | 16px |
| md | px-4 py-2.5 | gap-2 | text-base | 20px |
| lg | px-6 py-3 | gap-2 | text-lg | 24px |

## 状態バリアント

| State | Background | Border | Text | Ring |
|-------|-----------|--------|------|------|
| default | bg-default | border-default | text/primary | — |
| hover | bg-default | border-default (darker) | text/primary | — |
| focus | bg-default | border-focus | text/primary | ring-focus |
| error | bg-default | border-error | text/primary | ring-error |
| disabled | bg-disabled | border-disabled | text/tertiary | — |
| filled | bg-default | border-default | text/primary | — |

---

## Boolean Properties

表示/非表示の制御に使用。レイヤー名は Property key と一致させること（#suffix含む）。

```javascript
const titleProp = Object.keys(properties).find(key => key.startsWith('Title'));
titleText.name = titleProp; // レイヤー名 = Property key
```

主なプロパティ:
- `Label` (default: true)
- `Helper Text` (default: true)
- `Error Text` (default: false)
- `Left Icon` / `Right Icon` (default: false)
- `Attention` (default: false) — IconButton用
- `Close` (default: true) — Toast/Alert用
- `Required` (default: false) — アスタリスク表示

---

## レイアウトルール

- フォーム系: VERTICAL, gap は spacing/* Variable
- Input/Select内部: HORIZONTAL, CENTER alignment
- テキストフィールド: `layoutSizingHorizontal = 'FILL'` + `layoutGrow = 1`（**appendChild後に設定**）
- ラベルフレーム: MIN alignment（左揃え）
- 全spacing値は `setBoundVariable()` 必須

---

## Component Set 構成

**グリッドレイアウト:**
- 列: Size バリアント（xs, sm, md, lg）
- 行: State バリアント（default, hover, focus, error, disabled, filled）
- 間隔: 列幅 340px, 行高 120px（コンポーネントに応じて調整）

**命名規則:**
```
Size=md, State=default
Size=md, Color=primary, State=hover
Status=Success, Title=true
```

---

## Code Syntax（Tailwind CSS マッピング）

新規 Variable には必ず Tailwind クラスを設定:

```javascript
variable.setVariableCodeSyntax('WEB', 'text-gray-900');
```

| Variable | Code Syntax |
|----------|-------------|
| text/primary | text-gray-900 |
| text/secondary | text-gray-600 |
| text/error | text-red-500 |
| spacing/2 | gap-2 / p-2 |
| radius/md | rounded-md |
| action/primary/default | bg-blue-500 |
| form/input/border-focus | border-blue-500 |
| form/input/ring-focus | ring-blue-500/20 |

---

## Icon 統合パターン

Icon サイズはコンポーネントサイズに合わせる:

| Component Size | Icon / Slot Size |
|---------------|-----------------|
| xs | Size=xs (12px) |
| sm | Size=sm (16px) |
| md | Size=sm or md (16-20px) |
| lg | Size=md or lg (20-24px) |

アイコンカラー変更（Variable bind）:

```javascript
const setIconColor = (node, paint) => {
  if (['VECTOR','BOOLEAN_OPERATION','STAR','LINE','ELLIPSE','POLYGON'].includes(node.type)) {
    try { node.fills = [paint]; } catch(e) {}
    try { if (node.strokes?.length > 0) node.strokes = [paint]; } catch(e) {}
  }
  if ('children' in node) {
    for (const child of node.children) setIconColor(child, paint);
  }
};
```

---

## 作成ワークフロー

### 1. 調査

```
- figma_search_components で類似コンポーネント確認
- figma_get_variables で既存トークン確認
- figma_get_styles でテキストスタイル確認
```

### 2. 設計

- コンポーネントツリーを設計（parent → children）
- 設定可能プロパティを決定（Boolean, Text, Variant）
- 全バリアント組み合わせを定義（Size × State × Color）

### 3. ベースコンポーネント作成（md, default）

- AutoLayout でコンポーネント作成
- 全値を Variable で `setBoundVariable()` バインド
- テキストスタイル適用
- Boolean Properties 追加・レイヤー名バインド

### 4. Component Set 作成

- Component Set に変換
- 全 Size × State 組み合わせをクローン
- サイズ別設定（padding, gap, テキストスタイル）適用
- 状態別カラー（border, background, text）適用

### 5. 整理・仕上げ

- `figma_arrange_component_set` でグリッド配置
- 新規 Variable に Code Syntax 設定
- コンポーネントチェックリスト実行

### 6. 検証

- `figma_capture_screenshot` で視覚確認
- ハードコード値がないか確認
- 全状態が区別可能か確認

### 7. コンポーネント一覧に登録 ← 必須

作成完了後、`/figma-components` の SKILL.md を更新する:

```
1. 新コンポーネントの ID を取得:
   figma_execute → componentSet.id

2. バリアント名を取得:
   componentSet.children.map(v => v.name)

3. figma-components/SKILL.md のテーブル末尾に行を追加:
   | {次の番号} | {コンポーネント名} | `{ID}` | {バリアント一覧} |

4. ファイルパス:
   .claude/skills/figma-components/SKILL.md
```

---

## コンポーネントチェックリスト

### トークン & Variable
- [ ] 全色が Variable 使用（ハードコード hex なし）
- [ ] 全スペーシングが spacing/* Variable
- [ ] 全ラディウスが radius/* Variable
- [ ] 全 fills が `setBoundVariableForPaint()` 経由
- [ ] 新規 Variable に Code Syntax (WEB) 設定済み

### タイポグラフィ
- [ ] 全テキストノードにテキストスタイル適用済み（未スタイルなし）
- [ ] Label = /medium, Description = /normal
- [ ] テキストサイズが Size バリアントに一致

### 構造 & レイアウト
- [ ] 全フレームに AutoLayout 設定
- [ ] テキストフィールドに FILL + layoutGrow: 1
- [ ] Label フレーム = MIN, Action コンポーネント = CENTER

### プロパティ & バリアント
- [ ] Boolean Property の名前と #suffix バインド正しい
- [ ] 全 Size × State 組み合わせが存在
- [ ] Component Set がグリッド配置済み
- [ ] バリアント名が `Size=md, State=default` 形式

### 視覚品質
- [ ] 全状態が視覚的に区別可能
- [ ] Disabled 状態が明確にミュート
- [ ] Focus ring が全背景色で視認可能
- [ ] Icon サイズが Size バリアントに一致

### 登録
- [ ] `/figma-components` の一覧に追加済み

---

## Missing Variable の対処

必要な Variable が存在しない場合:

1. `figma_get_variables` で類似名を検索
2. なければ命名規則に従い作成
3. 作成直後に Code Syntax を設定
4. プリミティブトークン（例: color/gray/900）へエイリアス

### Variable 命名ルール

```
# OK
action/primary/foreground-default
form/input/border-focus
status/success/bg

# NG
action/primary/text        → "foreground" を使う
Icon/default               → 小文字: "icon/default"
btn-blue                   → セマンティック名を使う
```
