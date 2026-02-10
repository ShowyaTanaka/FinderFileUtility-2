---
name: create_view
description: View、ViewModel等のウィンドウに表示するコンポーネントを実装する際に利用する。ウィンドウ生成などのロジックについてはここでは含まない。
---

## 概要
View、ViewModel等の、UIに関連するコンポーネントを作成する際に守るルールをここに書いておく。UIを作成する際には、これらを遵守したうえで実装すること。

## ルール
以下に示すルールに従ってください。
- コンポーネントを判断し、Viewsディレクトリ下に各ウィンドウごとにフォルダを作成し、View、ViewModelを実装してください。
- UIのパーツは更に分割し、Elementsディレクトリを作成したうえでそこに実装してください。

以下は構成例です。
- 画面の大枠
    - FinderFileUtility 2/Views/ConfigMenu/ConfigMenuView.swift
    - FinderFileUtility 2/Views/ConfigMenu/ConfigMenuViewModel.swift
- 画面内のパーツ(例:モーダル)
    - FinderFileUtility 2/Views/ConfigMenu/Elements/EditFileModalView.swift

コンポーネントの判断、設置すべきディレクトリの特定には`.agents/common_references/production_file_structure.md`を利用してください.