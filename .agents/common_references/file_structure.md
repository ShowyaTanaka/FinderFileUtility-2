## コンポーネント構成
このアプリは、主に3つののコンポーネントで構成されています。
1. FinderFileUtility 2
- アプリの設定を管理するGUIコンポーネントです.与えられた情報を元にUserDefaultsの値を変えたり,設定画面を出したりするのが主な役目です.
- こちらには実際のファイル操作などのビジネスロジックを含んでいません.
2. FFU2 Extension
- FinderSync Extension.あとに説明するFFU2 DaemonにCFNotificationCenter経由で情報を渡すのが主な役目です.
3. FFU2 Daemon
- バックグラウンドで動作し,FFU2 Extensionで得た情報から実際の操作を行います.
  - 操作の例
    - ウィンドウを生成し,ユーザーがわかるよう視覚化する
    - 実際にファイルを作成する
- ビジネスロジックの多くはここに収集されます.

### テストフォルダの構成
上に上げたコンポーネントはそれぞれ以下のフォルダに入っています
- FinderFileUtility 2: FinderFileUtility 2
- FFU2 Extension: FFU2 Extension
- FFU2 Daemon: FFU2 Daemon
各コンポーネントのテストは以下のフォルダに入っています
- FinderFileUtility 2
  - FinderFileUtility 2 Tests
    - ViewModel等のテスト。将来的にはViewInspectorを用いたViewのユニットテストも導入
  - FinderFileUtility 2 UITests
    - e2eテスト。現状は実装していません
- FFU2 Daemon
  - FFU2 DaemonTests
    - ViewModel等のユニットテストを置く。