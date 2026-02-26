---
name: figma-debug
description: Figma操作時のよくあるエラーと対処法。figma_executeでエラーが発生した時に参照する。
---

# Figma よくあるエラーと対処法

## 一般エラー

| エラー | 原因 | 対処 |
|--------|------|------|
| Cannot write to node with unloaded font | フォント未ロード | `loadFontAsync()` 事前実行 |
| FILL can only be set on children of auto-layout frames | 親が非AutoLayout | 親に `layoutMode` 先設定 |
| Cannot read properties of undefined (reading 'createInstance') | バリアント名誤り | `children.map(v=>v.name)` で確認 |
| The font "Inter SemiBold" could not be loaded | スペース抜け | `Semi Bold`（スペースあり）を試す |
| Cannot call with documentAccess: dynamic-page | `mainComponent` 直接参照 | `getMainComponentAsync()` を使用 |
| This property cannot be overridden in an instance | インスタンス制約変更不可 | マスターコンポーネント側で修正 |

## フォントロードのベストプラクティス

```js
// テキスト操作前に必ず実行
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
await figma.loadFontAsync({ family: "Inter", style: "Medium" });
await figma.loadFontAsync({ family: "Inter", style: "Semi Bold" }); // スペースあり注意
await figma.loadFontAsync({ family: "Inter", style: "Bold" });

// SF Pro が必要な場合
await figma.loadFontAsync({ family: "SF Pro", style: "Regular" });
await figma.loadFontAsync({ family: "SF Pro", style: "Semibold" }); // スペースなし注意
```

## インスタンスのオーバーライド問題

`resetOverrides()` は全オーバーライドをリセットするため、色の Variable binding も消える。
対処: リセット後に sm バリアント等から fills を再コピーする。

```js
// resetOverrides後のfills復元パターン
const smVariant = buttonSet.children.find(v => v.name.replace('Size=xs', 'Size=sm') === targetName);
const smVector = smLeftIcon.children[0].children[0];
const xsVector = xsLeftIcon.children[0].children[0];
xsVector.fills = JSON.parse(JSON.stringify(smVector.fills));
```

## コンポーネント作成時のエラー

| 問題 | 原因 | 対処 |
|------|------|------|
| アイコンの色が変わらない | Icon はインスタンス。fills を直接変更不可 | 内部の VECTOR/BOOLEAN_OPERATION ノードを再帰走査して `fills` を Variable bind |
| テキストが幅いっぱいに広がらない | appendChild 前に sizing 設定 | `layoutSizingHorizontal = 'FILL'` は **appendChild 後** に設定。`layoutGrow = 1` も必要 |
| Variable が UI に表示されない | `setBoundVariable` の使い方が不正 | fills には `figma.variables.setBoundVariableForPaint()` を使用（`setBoundVariable` ではない） |
| Boolean Property が動作しない | レイヤー名と Property key が不一致 | `Object.keys(properties).find(key => key.startsWith('Name'))` で正確な key（#suffix 付き）を取得し、レイヤー名に設定 |
| Component Set のグリッドが崩れる | 手動配置のずれ | `figma_arrange_component_set` を使用。手動の場合は列幅 340px, 行高 120px |
| Variant がプロパティパネルに出ない | 命名形式の誤り | `Key=Value` 形式を厳守。タイポ・余分なスペースに注意 |
