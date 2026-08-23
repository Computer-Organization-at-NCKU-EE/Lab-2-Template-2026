# Lab 2 — RISC-V Assembly and Bare-Metal Programming

本作業只評量兩個 RV32I 組合語言函式。**不需繳交 Report，也不需加入、修改或繳交
ISA Simulator。**正式批改使用助教固定版本的工具鏈與模擬器。

## 你要修改的檔案

只能在下列兩個固定路徑完成作業；檔名與大小寫不可變更：

- `asm-prog-assignment/merge.S`
- `asm-prog-assignment/sudoku.S`

請勿修改 `.classroom50.yaml`、`.github/` 或嘗試產生自己的 `result.json`。其他檔案可用於
本機閱讀與練習，但不列入正式提交內容。

## 開發環境

課程沿用[官方 Lab 文件](https://computer-organization-at-ncku-ee.github.io/lab-documents/)
的 Docker 流程。Windows 請在 WSL 終端機執行；macOS 請在 Terminal 執行。

### 1. 安裝 Docker

依課程文件的 **How to install Docker** 完成 Docker 安裝，並確認 `docker version` 可正常執行。

### 2. 下載課程映像

```sh
docker pull ghcr.io/computer-organization-at-ncku-ee/co-docker-env:latest
```

這個 `co-docker-env:latest` 映像只供學生互動式開發。正式批改使用另一個公開映像
`ghcr.io/computer-organization-at-ncku-ee/co-lab2-grader-v2@sha256:<助教公告的 digest>`，並鎖定不可變的
digest，不會在批改時臨時使用最新版或 release tag。

### 3. 建立並進入課程容器

```sh
git clone https://github.com/Computer-Organization-at-NCKU-EE/Docker-Environment.git
cd Docker-Environment
./create.sh comporg
./attach.sh
```

`attach.sh` 由 `create.sh` 產生。第一次執行前應先確認上一個 `docker pull` 成功，避免腳本改從
未鎖定版本的 Dockerfile 建置。官方腳本固定使用 `linux/amd64`；Apple Silicon 會由 Docker
Desktop 執行架構模擬。

### 4. 在容器內取得個人作業

依 Classroom50 顯示的網址 clone 個人的 private repository，並在該目錄工作：

```sh
cd /home/ubuntu/workspace
git clone <你的 Classroom50 repository URL>
cd <repository 目錄>
```

## 本機建置

在課程容器與作業 repository 根目錄執行：

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target ArraySort Sudoku --parallel
```

成功時會在 `build/asm-prog-assignment/` 產生執行檔、`.disasm` 與 `.hex`。公開 C driver 只提供
基本 smoke test；正式分數以 Classroom50 的逐案例結果為準。本 repository 不再建置學生
自己的 ISS，也沒有會無限等待 guest halt 的舊版 checker。

作業正式發布後，也可以在 repository 根目錄執行 `bash ./grade-local.sh`，使用與 Classroom50
相同且已鎖定 digest 的 Lab 2 grader image。結果會寫入 `grading-output/`；本機結果只供除錯
與複查，不得用來覆蓋正式成績。若助教確認批改器有缺陷，必須以同一新版批改器重批全班，
不會只替個別學生改用本機結果。

## 題目一：Array Sort

公開介面等同：

```c
void array_sort(int32_t *array, uint32_t size);
```

- `a0` 是 signed 32-bit 整數陣列起點，`a1` 是元素數量。
- `arr_size` 範圍為 0 到 128；即使為 0，也會傳入有效且對齊的指標。
- 必須在原陣列中由小到大排序，使用 signed 比較。
- 不要求 stable sort，也不限制演算法；Insertion Sort、Merge Sort 等正確實作均可得分。

## 題目二：4×4 Sudoku

公開介面等同：

```c
void sudoku_solver(int32_t *board);
```

- `a0` 指向 16 個 signed 32-bit 整數，採 row-major 排列。
- `1` 到 `4` 是固定線索，**`0` 是唯一的空格表示值**。
- 輸入保證合法且至少有一組解；不測非法或無解盤面。
- 必須保留所有原始非零線索，並填出列、行及每個 2×2 宮格皆合法的盤面。
- 多解盤面接受任何合法解，不限制是否使用 backtracking。

## RV32I 與 ABI 規範

- ISA／ABI：`rv32i`／`ilp32`；來源直接交給 GNU assembler，不使用 C preprocessor。
- 入口與返回時須遵守 RISC-V psABI；若使用 `s0`–`s11`、`sp` 或 `ra`，必須正確保存與還原。
- `sp` 執行期間維持 16-byte alignment；不得破壞 `gp` 或 `tp`。
- 只能存取傳入陣列、自己的合法資料與 stack；不得直接寫入 ROM、未授權 RAM 或 MMIO。
- 可使用 assembler macro 與能展開成 RV32I 的 pseudo-instruction；不得使用 `.include` 或
  `.incbin`。
- 唯一允許的外部 runtime symbol 是 `my_printf`，但完成兩題皆不需要呼叫它。

## 配分

總分 100 分：

| 區段 | 分數 | 重點 |
|---|---:|---|
| Compilation | 10 | `merge.S` 與 `sudoku.S` 各 5 分，分開組譯、連結及 RV32I 稽核 |
| Array Sort | 45 | 功能 40 分；ABI／記憶體規範 5 分 |
| Sudoku | 45 | 功能 40 分；ABI／記憶體規範 5 分 |

每一題各占 50 分：該題的 Compilation 5 分，加上功能與 ABI／記憶體規範 45 分。
某一題編譯失敗只會使該題的編譯、功能與 ABI 分數為零，另一題仍會正常批改並可取得完整
50 分。因此固定的「只有一題語法錯誤、另一題完全正確」測試必須得到 50 分。功能測試包括
邊界值、signed 極值、重複元素、最大長度、已完成／稀疏／多解 Sudoku，以及固定且可重現
的 corpus。無限迴圈由 ISS 的 instruction cap 判定該案例未通過；非法指令或越界存取也會
得到明確的執行失敗結果。外層 wall watchdog 只用來偵測批改基礎設施異常；若它觸發，
該次批改視為基礎設施錯誤，不會把學生程式記為零分。

## Classroom50 繳交流程

本作業採 **submit-only** 模式；一般 `git push` 只備份進度，不會產生正式分數。

1. 安裝 [GitHub CLI](https://cli.github.com/) 與 Classroom50 student extension：

   ```sh
   gh extension install foundation50/gh-student
   gh student login
   ```

2. 接受 `Computer-Organization-at-NCKU-EE` 中的正式 Lab 2 作業：

   ```sh
   gh student accept Computer-Organization-at-NCKU-EE Classroom-Beta lab2
   ```

3. 完成修改後先保存進度：

   ```sh
   git add asm-prog-assignment/merge.S asm-prog-assignment/sudoku.S
   git commit -m "Complete Lab 2"
   git push
   ```

4. 在 repository 內建立正式提交：

   ```sh
   gh student submit
   ```

提交後，Classroom50 會建立 `submit/...` tag，啟動自動批改，並在 GitHub Release 顯示總分與
逐案例回饋。截止時間本身只標示遲交；助教執行 **Close submission** 後才會停止接受新版本。
正式成績以平台在 **Close submission 前接受且成功完成批改的最後一次 submission event**
為準，不採 commit 日期，也不採本機結果。Classroom50 的學生 repository、workflow 與
Release 並非密碼學上的成績來源證明；這是本課採用平台時已接受的限制。若提交結果可疑，
助教可用同一個正式 image digest 重現批改以進行調查，但不會因此選擇性更換計分版本。

詳細操作請參考 [Classroom50 Student Guide](https://github.com/foundation50/classroom50/wiki/CLI-Student-Guide)。

## 繳交前檢查

- 兩個指定 `.S` 都能在乾淨的 `build/` 中組譯與連結。
- Sudoku 使用 `0` 表示空格，且不覆寫原始線索。
- 沒有新增 `.include`、`.incbin`、額外 runtime dependency 或學生版 ISS。
- 已 push 最新 commit，並另執行一次 `gh student submit`。
- GitHub Actions 完成，Release 顯示的是預期 commit，而非較舊版本。

## Template provenance

This student skeleton was exported from https://github.com/Computer-Organization-at-NCKU-EE/Lab-2-Template at commit `560c3eacf3d91597d5c139f99e17cdffd927e3c5` after written course authorization was verified. This notice records origin; it does not create or imply a general open-source licence.
