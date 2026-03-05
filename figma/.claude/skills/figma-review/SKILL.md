---
name: figma-review
description: Figma画面のセルフレビューチェックリスト。画面作成・修正完了後に呼び出して品質確認を行う。
---

# セルフレビューチェックリスト

画面の作成・修正完了後、以下を全て確認すること。

## 必須チェック項目

- [ ] **Variable バインド**: 全gap/padding/colorがVariableバインド済み（ハードコード値なし）
- [ ] **ローカルコンポーネント**: リモートコンポーネント未使用（`importComponentByKeyAsync` 不使用）
- [ ] **テキストスタイル**: 全テキストノードにローカルテキストスタイル適用済み
- [ ] **レイヤー名**: 汎用レイヤー名（Frame N, Rectangle N 等）なし
- [ ] **Toast配置**: 右下16px、Absolute配置
- [ ] **フレーム幅**: 1440px
- [ ] **座標**: 参考デザインと座標被りなし
- [ ] **UIテキスト**: 「〜してください」→「〜しましょう」、ボタンラベルに不要な「する」なし、1文テキストに不要な「。」なし

## 確認用コードスニペット

### ハードコード値の検出

```js
// フレーム内でVariableバインドされていないcolorを検出
function checkHardcodedColors(node) {
  if (node.fills && node.fills.length > 0) {
    const hasBound = node.fills.some(f => f.boundVariables?.color);
    if (!hasBound && node.fills[0].type === 'SOLID') {
      return { id: node.id, name: node.name, type: 'fills' };
    }
  }
  return null;
}
```

### 汎用レイヤー名の検出

```js
// 汎用名パターン
const genericPattern = /^(Frame|Rectangle|Ellipse|Group|Line|Vector|Text)\s+\d+$/;
function findGenericNames(node, results = []) {
  if (genericPattern.test(node.name)) {
    results.push({ id: node.id, name: node.name });
  }
  if (node.children) node.children.forEach(c => findGenericNames(c, results));
  return results;
}
```
