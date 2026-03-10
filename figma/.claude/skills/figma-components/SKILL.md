---
name: figma-components
description: Figma全コンポーネント一覧のID・バリアント参照。コンポーネントを配置・操作する際に呼び出す。
---

# 全コンポーネント一覧 (Component Set ID + バリアント)

IDは変更の可能性あり。不明時は `figma_execute` で確認。

> **新規コンポーネント作成時**: `/figma-create-component` のワークフロー Step 7 に従い、このテーブル末尾に行を追加すること。

| # | コンポーネント | ID | バリアント |
|---|---|---|---|
| 1 | Button | `1625:1268` | Size: xs/sm/md/lg, Color: primary/secondary/tertiary/alert, State: default/hover/active/disabled |
| 2 | Input | `1625:11162` | Size: xs/sm/md/lg, State: default/focus/error/disabled/filled |
| 3 | Select | `1627:2381` | Size: xs/sm/md/lg, State: default/focus/error/disabled |
| 4 | Text Area | `1631:398` | Size: xs/sm/md/lg, State: default/focus/error/disabled/filled |
| 5 | IconButton | `1632:784` | Size: xs/sm/md/lg, Color: secondary/tertiary, State: default/hover/active/disabled |
| 6 | RadioButton | `1632:921` | Size: sm/md/lg, State: default/selected/disabled/selected-disabled |
| 7 | Checkbox | `1634:980` | Size: sm/md/lg, State: default/checked/disabled/checked-disabled |
| 8 | Alert | `1634:5472` | Status: success/warning/error/info |
| 9 | Toast | `1637:6265` | Status: success/warning/error/info, Close: true |
| 10 | ComboBox | `1641:1763` | State: default/focus/filled/error/disabled |
| 11 | ComboBox Menu | `1729:3087` | State: Default/Empty |
| 12 | Tabs / Nav | `1643:7299` | (単一) |
| 13 | Tab Item / Pill | `1649:19557` | State: active/enable/hover, Count: true/false |
| 14 | Tabs / Filter | `1649:19749` | (単一) |
| 15 | Switch | `1643:7626` | Size: sm/md/lg, On: true/false |
| 16 | Tooltip | `1643:7651` | Position: top/bottom/left/right |
| 17 | Popover | `1643:7758` | State: default/hover |
| 18 | Badge | `1715:5360` | Color: gray/red/orange/amber/teal/blue/violet |
| 19 | Detail Row | `1646:8409` | Type: text/link/links/badge |
| 20 | Table / Header | `1697:4067` | Type: text/checkbox/number |
| 21 | Table / Data | `1647:11480` | Type: text/link/badge/checkbox/button/icon/icon button/number/select/multiline text/multiline number/date icon |
| 22 | Table / Expand Header | `1756:10332` | Type: text/number |
| 23 | Table / Expand Data | `1756:10283` | Type: text/link/number |
| 24 | Table / Expand Row | `1756:10287` | (単一) |
| 25 | Table (組み立て済み) | `1757:12132` | Type: 発注書一覧/メンバー管理/アイテム一覧/CSV作成済みデータ/納品一覧/発注履歴/在庫一覧 |
| 26 | Pagination | `1647:13241` | (単一) |
| 27 | Header | `1712:5014` | (単一) |
| 28 | Title | `1714:5204` | Type: Page/Section/Sub |
| 29 | Calc | `1715:5529` | (単一) |
| 30 | Attachment | `1719:15146` | (単一) |
| 31 | PO Preview | `1715:11371` | 分納: True/False |
| 32 | Datepicker | `1728:2465` | Size: sm/md, State: default/focus/error/disabled/filled |
| 33 | Calendar | `1728:2692` | Type: Single/Range |
| 34 | Date Range Picker | `1728:2958` | Size: sm/md, State: default/focus/error/disabled/filled |
| 35 | Drawer | `1731:4922` | Type: Default |
| 36 | Drawer Message | `1731:4923` | Type: receive/send |
| 37 | Modal Dialog | `1643:7759` | Title (TEXT), Contents (SLOT) |
| 38 | Modal Footer | `1741:3492` | Countを表示 (BOOLEAN), Actions (SLOT) |
| 39 | Modal / Table | `1739:2687` | Filter (SLOT), Header (SLOT), Table (SLOT) |
| 40 | ItemSelect Row | `1739:2686` | State: default/hover |
| 41 | MemberSelect Row | `1746:7619` | State: default/hover |
| 42 | Routing | `1743:5412` | State: Unconfigured/Configured/Error/Add |
| 43 | Approval Tracker | `1743:5457` | State: Unconfirmed/Done/Reject |
| — | Icon / Slot | `1625:10308` | Size: xs/sm/md/lg/xl |
