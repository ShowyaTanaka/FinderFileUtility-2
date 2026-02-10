# AGENTS.md
## 1. 目的
このファイルは,AIエージェント専用の指示書です.
あなたが作業時に必要とする情報やルールをまとめています.

## 2. 基本ルール
- README.mdは人間用です.参照する必要はありません.
- ツール類はMCPとSkillsで渡します.もしそれだけだと足りなさそうなら,私に指示を仰いでください.
- 他のclassやstructのメソッドを呼び出す場合は,直接呼び出すのではなく依存性注入により実装を行ってください.その際に,protocolが定義されていない場合は`create_business_logic`のskillに従ってprotocolを実装してください.

## 3. 技術スタック
- Swift
- SwiftUI
- FinderSync Extension
