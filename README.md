# Lab 2 — RISC-V Assembly and Bare-Metal Programming

本作業只評量兩個 RV32I 組合語言函式。**不需繳交 Report，也不需加入、修改或繳交
ISA Simulator。**正式批改使用助教固定版本的工具鏈與模擬器。

## Quick Start：學生完整操作流程

這份作業使用 Classroom50 官方流程。第一次操作時，請依序完成以下步驟；不要直接在公開
Template repository 作答。

### 1. 在 WSL／Terminal 啟動課程 Docker 環境

```sh
docker pull ghcr.io/computer-organization-at-ncku-ee/co-docker-env:latest
git clone https://github.com/Computer-Organization-at-NCKU-EE/Docker-Environment.git
cd Docker-Environment
./create.sh comporg
./attach.sh
```

Windows 請在 WSL 執行。若以前已 clone `Docker-Environment`，不必重複 clone，直接進入該
目錄並使用既有腳本即可。

### 2. 在課程 container 登入 Classroom50

官方課程 image 目前沒有預裝 GitHub CLI，因此第一次建立 container 時先執行：

```sh
sudo apt-get update
sudo apt-get install -y gh
gh auth login --hostname github.com --git-protocol https --web
gh extension install foundation50/gh-student --pin v1.33.0
gh student login
gh auth status
gh student accept Computer-Organization-at-NCKU-EE fall-2026 lab2
```

`sudo` 若詢問課程 container 密碼，請輸入 `1234`。GitHub 可能先後顯示兩次 device code；
兩次都應在瀏覽器登入**自己的學生帳號**完成授權。最後用 `gh auth status` 確認 Active account
確實是本人，再執行 `accept`。

`accept` 會建立你的 private repository，並在最後印出 `git clone` 指令。請執行畫面印出的
指令，再進入剛建立的 repository：

```sh
cd /home/ubuntu/workspace
git clone <accept 指令顯示的 repository URL>
cd <你的 Lab 2 repository>
```

### 3. 只修改兩個指定檔案

```text
asm-prog-assignment/merge.S
asm-prog-assignment/sudoku.S
```

### 4. 建置並進行本機測試

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target ArraySort Sudoku --parallel
```

這一步只確認兩份程式能組譯與連結。正式的 43 項完整測試由 Classroom50 在 submit 後執行。
課程 container 內沒有 Docker daemon，因此**不要在 container 內執行 `grade-local.sh`**；它不是
學生完成本作業的必要步驟。

### 5. Commit、push，然後正式 submit

```sh
git config user.name "你的 GitHub 帳號"
git config user.email "你的電子郵件"
git add asm-prog-assignment/merge.S asm-prog-assignment/sudoku.S
git commit -m "Complete Lab 2"
git push
gh student submit
```

第一次 commit 前，請把前兩行引號內的內容換成自己的資料；這只設定目前的 Lab 2 repository。
**只有 `git push` 不會觸發本作業的正式批改。**每次修改後若要取得新分數，都必須再執行
一次 `gh student submit`。

### 6. 查看批改結果

`gh student submit` 完成後會顯示 Actions 與 Releases 連結。也可以執行：

```sh
gh run list --workflow autograde.yaml --limit 3
```

請先確認最新的 Actions run 成功，再到最新 GitHub Release 查看總分與 43 個測試結果。
通常需要等待一至數分鐘。若長時間停在 `queued`，先查看
[GitHub Status](https://www.githubstatus.com/)，不要連續重複 submit。

## 你要修改的檔案

只能在下列兩個固定路徑完成作業；檔名與大小寫不可變更：

- `asm-prog-assignment/merge.S`
- `asm-prog-assignment/sudoku.S`

請勿修改 `.classroom50.yaml`、`.github/` 或嘗試產生自己的 `result.json`。其他檔案可用於
本機閱讀、建置與練習，並會保留在你的 repository；正式 grader 只讀取上述兩個固定路徑。

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
`ghcr.io/computer-organization-at-ncku-ee/co-lab2-grader-v2@sha256:f0ff938b7c554c1d021d5e91e31dfcbaeb810b88892dec6c0c404fac530b42db`，並鎖定不可變的
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

先依上方 Quick Start 的步驟 2 完成 GitHub CLI 安裝與登入。執行
`gh student accept Computer-Organization-at-NCKU-EE fall-2026 lab2` 後，使用它印出的網址
clone 個人的 private repository，並在該目錄工作：

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

`grade-local.sh` 是需要 Docker daemon 的選用工具，無法直接在上述課程 container 內執行，
也不是學生完成作業的必要步驟。學生只需完成本節的 CMake smoke test，再用 Classroom50
取得正式完整測試結果。若助教另外要求使用本機 grader，會提供獨立操作方式。

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

第一次接受作業請完整依照本文件最前面的 Quick Start；不要跳過安裝、登入或帳號確認。
之後每次要取得新分數時，在個人作業 repository 內依序執行：

1. 先完成修改與 CMake build，再保存進度：

   ```sh
   git add asm-prog-assignment/merge.S asm-prog-assignment/sudoku.S
   git commit -m "Complete Lab 2"
   git push
   ```

2. 建立正式提交：

   ```sh
   gh student submit
   ```

3. 查看最新批改狀態：

   ```sh
   gh run list --workflow autograde.yaml --limit 3
   ```

提交後，Classroom50 會建立 `submit/...` tag，啟動自動批改，並在 GitHub Release 顯示總分與
逐案例回饋。本作業截止時間為 **2026 年 10 月 21 日 23:59:00（臺灣時間，UTC+8；對應
`2026-10-21T15:59:00Z`）**。請在截止前完成 `gh student submit`，並確認 GitHub Actions
成功且 Release 顯示預期的 commit。助教執行 **Close submission** 後會鎖定 Classroom50 的
正常接受與提交介面，但既有 Git repository 並不會因此變成唯讀。

本作業使用 Classroom50 官方 Skeleton。一般 `git push` 只保存進度；`gh student submit`
才會建立本作業需要的 submission tag、執行完整批改並發布新的成績 Release。Regrade 只會
重新批改既有 submission，不會自動批改你在 `main` 上尚未 submit 的新 commit。

截止後是否接受提交與正式成績選取方式，以課程公告為準。遇到提交異常時，請保留 commit
SHA、Actions URL、Release URL 及錯誤畫面，再聯絡助教。

詳細操作請參考 [Classroom50 Student Guide](https://github.com/foundation50/classroom50/wiki/CLI-Student-Guide)。

## 繳交前檢查

- 兩個指定 `.S` 都能在乾淨的 `build/` 中組譯與連結。
- Sudoku 使用 `0` 表示空格，且不覆寫原始線索。
- 沒有新增 `.include`、`.incbin`、額外 runtime dependency 或學生版 ISS。
- 已 push 最新 commit，並另執行一次 `gh student submit`。
- GitHub Actions 完成，Release 顯示的是預期 commit，而非較舊版本。
- 若 `git status` 顯示本機 branch 落後遠端，下一次修改前先執行 `git pull --ff-only`。

## Template provenance

This student skeleton was exported from https://github.com/Computer-Organization-at-NCKU-EE/Lab-2-Template at commit `560c3eacf3d91597d5c139f99e17cdffd927e3c5` after written course authorization was verified. This notice records origin; it does not create or imply a general open-source licence.
