# CLAUDE.md - Figma画面デザイン作成ルール

## プロジェクト概要

**shizai pro** — shizaiの資材流通事業と一体運用される発注・資材管理SaaS。ユーザーはデマンド（発注者側ブランド企業）とオペレーター（shizai社内）。主要エンティティ: 発注書、アイテム、仕入先、納品先。

このプロジェクトでは shizai pro のFigmaデザインファイルで画面デザインを作成・修正する。
`figma-console` MCP ツール群（figma_execute, figma_get_selection 等）を使ってFigma APIを直接操作する。

## 絶対ルール（違反厳禁）

### Variable バインド必須

gap / padding / color / radius はすべて `setBoundVariable()` で Variable 参照すること。数値・Hex直書き禁止。

```js
// OK
frame.setBoundVariable('itemSpacing', spacingVar);
frame.setBoundVariable('paddingTop', spacingVar);
frame.fills = [figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:0,g:0,b:0}},'color',colorVar)];

// NG
frame.itemSpacing = 16;
frame.fills = [{type:'SOLID',color:{r:0.96,g:0.96,b:0.96}}];
```

### 登録済みコンポーネントのみ使用

**使用可能なコンポーネントは `/figma-components` に登録済みのもののみ。** ファイル内に存在しても未登録のコンポーネント（参考セクション内のもの等）は使用禁止。

コンポーネント使用時の必須手順:
1. **使用前に `/figma-components` の一覧で ID を確認する**
2. `getNodeByIdAsync(ComponentSetID)` でローカル取得する（`importComponentByKeyAsync` 禁止）
3. 一覧にないコンポーネントが必要な場合 → **ユーザーに確認**（正規コンポーネント化 or 手動構築）

```js
// OK: /figma-components に登録済みの ID を使用
const set = await figma.getNodeByIdAsync('1625:1268');
const variant = set.children.find(v => v.name === 'Size=md, Color=primary, State=default');
const instance = variant.createInstance();

// NG: 参考セクション等から見つけた未登録コンポーネントを使用
const unknown = await figma.getNodeByIdAsync('xxxx:xxxx'); // /figma-components に未登録
```

### バリアント名は推測禁止

`ghost`, `outline` 等の推測名を使わない。必ず事前確認する。

```js
const names = componentSet.children.map(v => v.name);
```

### テキストスタイル必須

`fontSize` / `fontName` 直接指定禁止。`setTextStyleIdAsync()` でローカルスタイル適用。

```js
// OK
await figma.loadFontAsync({family:"Inter",style:"Medium"});
const styles = await figma.getLocalTextStylesAsync();
const style = styles.find(s => s.name === 'text-sm/normal');
await text.setTextStyleIdAsync(style.id);

// NG
text.fontSize = 14;
text.fontName = {family:"Inter",style:"Medium"};
```

### フレーム名・レイヤー名

`Frame 162`, `Rectangle 1` 等の汎用名禁止。用途がわかる名前をつける（例: `希望納品日ナビ`, `フィルター行`, `空メッセージ`）。

## コンポーネント別ルール

### Toast

- 位置: 画面右下16px（`x = frameW - toastW - 16`, `y = frameH - toastH - 16`）
- 配置: Absolute（AutoLayout外）
- Description不要なら `visible = false`

### Alert

- 使用パターンは2種のみ: 「Titleのみ」「Title + Description」
- Description のみの表示は存在しない
- Titleのみにする場合: Descriptionテキストノードを `visible = false`
- Title と Description に同じテキストを入れない

### IconButton / 戻るボタン

- Color: **tertiary**, Size: **md** を使用する

### Button サイズルール

- 画面の主要導線ボタン（新規作成・登録など）: Size: **lg**

### Input State変更

`swapComponent()` 後はラベル・プレースホルダーテキストがリセットされるので再設定すること。

### Icon / Slot 必須

すべてのアイコンは `Icon / Slot`（`1625:10308`）のインスタンスを使用すること。テキスト文字（✓, ✕ 等）での代用、ベクター直描き、外部SVG貼り付けは禁止。

```js
// OK: Icon / Slot → swapComponent でアイコン差し替え
const iconSlotSet = await figma.getNodeByIdAsync('1625:10308');
const smVariant = iconSlotSet.children.find(c => c.name === 'Size=sm');
const iconInstance = smVariant.createInstance();
const targetIcon = await figma.getNodeByIdAsync('1634:5114'); // 例: "x" icon
iconInstance.children.find(c => c.type === 'INSTANCE').swapComponent(targetIcon);
```

## UIテキストルール

### 語尾

- 「〜してください」ではなく「〜しましょう」を使用する
  - OK: `入力しましょう` / NG: `入力してください`

### ボタンラベル

- 「する」をつけない。文脈的に名詞と区別がつかない場合にのみ「する」の付与を検討する
  - OK: `承認` `却下` `キャンセル` `削除` / NG: `承認する` `削除する`

### 句点「。」

- 1文で意味が伝わるもの、改行で文章が切れるUIテキストは「。」をつけない
- なるべく1文に収めることを前提に、どうしても1文に収まらない場合は「。」をつけて文章にする
  - OK（1文）: `以下の内容でアクセスを許可します`
  - OK（複数文やむなし）: `項目Aを削除します。関連する項目Bも削除されます。`
  - NG: `以下の内容でアクセスを許可します。`（1文なのに。あり）
  - NG: `この申請を却下します。申請者に通知されます。`（1文にまとめられる → `この申請を却下し、申請者に通知します`）

## 推奨テキストスタイル

| 用途 | スタイル |
|------|---------|
| ラベル / タイトル / ボタンラベル | text-sm/semi-bold |
| 本文 / 説明文 | text-sm/normal |
| ヘルパー / エラー文 | text-xs/normal |
| ページタイトル | text-lg/bold |

## よく使う Variable ID

**spacing**: spacing/2 = `VariableID:309:1157`(8px), spacing/4 = `VariableID:309:1159`(16px)
**color**: text/tertiary = `VariableID:1628:250`

その他のIDは `figma_get_variables` で取得。

## スキル一覧

詳細な手順・参照データは以下のスキルに分離。必要時に呼び出すこと。

| スキル | 用途 |
|--------|------|
| `/figma-create-screen` | 新規画面作成時のテンプレート・構造・命名規則 |
| `/figma-create-component` | 新規コンポーネント作成（トークン設計・構造パターン・チェックリスト） |
| `/figma-components` | 全コンポーネント一覧（ID + バリアント） |
| `/figma-review` | セルフレビューチェックリスト |
| `/figma-debug` | よくあるエラーと対処法 |
| `/shizai-pro-design` | プロダクト知識（画面構成・UIパターン・機能仕様・ユーザーフロー） |
