# Neovim Configuration

個人用のNeovim設定です。主にLinux / WSLで使うことを想定しています。

プラグインは [lazy.nvim](https://github.com/folke/lazy.nvim) で管理します。言語サーバー（LSP）は自動導入せず、必要になった言語だけ個別にインストールする方針です。

## Requirements

- Neovim 0.11以上（`vim.lsp.config` / `vim.lsp.enable` を使用）
- Git
- 初回のプラグイン取得に必要なネットワーク接続

言語サーバー・LaTeX環境などは任意です。npm、Cargoなどのパッケージマネージャー自体の導入方法はここでは扱いません。

## Installation

### 1. 設定を配置する

Linux / WSL:

```bash
git clone https://github.com/monerinngu0/nvim.git ~/.config/nvim
```

既存の `~/.config/nvim` がある場合は、先にバックアップしてください。

### 2. Neovimを起動する

```bash
nvim
```

初回起動時に `lazy.nvim` を取得し、プラグインをインストールします。

```vim
:Lazy
:Lazy sync
:Lazy restore
```

`lazy-lock.json` にプラグインのコミットが記録されています。同じバージョン構成へ戻す場合は `:Lazy restore` を使います。

動作確認:

```vim
:checkhealth
:checkhealth vim.lsp
```

## Language Servers

LSPはNeovim組み込みのLSPクライアントと `nvim-lspconfig` を使います。**利用する言語だけ**導入してください。各コマンドを実行した後は、サーバーの実行ファイルがNeovimから見える `PATH` にあることを確認してください。

### C / C++ — clangd

Ubuntu / Debian / WSL:

```bash
sudo apt install clangd
clangd --version
```

CMakeプロジェクトでは、コンパイル情報を出力できます。

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

必要に応じて `build/compile_commands.json` をプロジェクトルートから参照できるようにしてください。

### Python — Pyright

```bash
npm install -g pyright
pyright --version
```

設定が使う実行ファイルは `pyright-langserver` です。Pythonのライブラリや仮想環境は各プロジェクト側で別途管理します。

### JavaScript / TypeScript — TypeScript Language Server

```bash
npm install -g typescript typescript-language-server
typescript-language-server --version
```

JavaScript、TypeScript、JSX、TSX向けです。プロジェクト固有の依存関係は各プロジェクトで管理します。

### Rust — rust-analyzer

rustupを利用している場合:

```bash
rustup component add rust-analyzer
rust-analyzer --version
```

### LaTeX — TexLab / vimtex

```bash
cargo install --locked texlab
texlab --version
```

PDFのビルド・プレビューには別途TeXディストリビューション、`latexmk`、PDFビューアが必要です。

**現在のLaTeX設定はメインPCのWSL環境向けです。** `lua/plugins/vimtex.lua` でWindows側のSumatraPDFへの絶対パスを指定しています。ほかのPCでLaTeXを使う場合だけパスを変更してください。VPSなど、LaTeXを使わない環境でこれらを導入する必要はありません。

## Plugins

| Plugin | 用途 |
| --- | --- |
| lazy.nvim | プラグイン管理 |
| nvim-lspconfig | LSP設定 |
| nvim-cmp / LuaSnip | 補完・スニペット |
| nvim-treesitter | 構文解析 |
| nvim-autopairs | 括弧補完 |
| oil.nvim | ファイル操作 |
| lualine.nvim | ステータスライン |
| vimtex | LaTeX編集 |

各プラグインのバージョン情報は `lazy-lock.json` にあります。

## Keymaps

### LSP（サーバー接続中）

| Key | Action |
| --- | --- |
| `gd` | 定義へ移動 |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<leader>rn` | 名前変更 |
| `<leader>ca` | コードアクション |

### Completion

| Key | Action |
| --- | --- |
| `Ctrl + Space` | 補完候補を表示 |
| `Ctrl + e` | 補完を中止 |
| `Enter` | 候補を確定 |
| `Tab` / `Shift + Tab` | 候補選択・スニペット移動 |
| `Ctrl + b` / `Ctrl + f` | 補完ドキュメントのスクロール |

### Files

| Key | Action |
| --- | --- |
| `-` | Oilで親ディレクトリを開く |
| `<leader>e` | Oilを開く |

`<leader>` は明示的に変更していないため、Neovimの既定値（`\`）です。

## Configuration

```text
.
├── init.lua
├── lazy-lock.json
└── lua/
    ├── options.lua
    ├── keymaps.lua
    ├── config/
    │   └── lazy.lua
    └── plugins/
        ├── lsp.lua
        ├── cmp.lua
        ├── treesitter.lua
        ├── vimtex.lua
        ├── oil.lua
        ├── autopairs.lua
        └── lualine.lua
```

- `init.lua`: 基本設定・モジュール読み込み
- `lua/options.lua`: エディタの設定
- `lua/keymaps.lua`: 基本キーマップ
- `lua/config/`: lazy.nvimなどの初期化
- `lua/plugins/`: プラグインごとの設定

## Updating

設定ファイル:

```bash
git -C ~/.config/nvim pull --ff-only
```

プラグイン:

```vim
:Lazy update
```

更新したプラグインを次の環境でも再現したい場合は、変更された `lazy-lock.json` をコミットしてください。

## Troubleshooting

**LSPが動かない場合**

1. 対応する言語サーバーが導入されているか確認する
2. 実行ファイルが `PATH` にあるか確認する
3. 対象ファイルを開いて `:LspInfo`（または `:checkhealth vim.lsp`）を確認する

**プラグインが動かない場合**

```vim
:Lazy
:Lazy sync
:checkhealth
```

**クリップボードが動かない場合**

`clipboard=unnamedplus` を使用しています。Linux / WSLでは別途クリップボードプロバイダーが必要な場合があります。`:checkhealth` で確認してください。

---

個人用の設定なので、すべての言語・ツールを一度にインストールする必要はありません。
