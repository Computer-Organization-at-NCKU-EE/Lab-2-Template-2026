# Lab 2 — RISC-V Assembly and Bare-Metal Programming

本作業只評量兩個 RV32I 組合語言函式。**不需繳交 Report，也不需加入、修改或繳交
ISA Simulator。**正式批改使用助教固定版本的工具鏈與模擬器。

## Quick Start：只在課程容器內完成作業

本作業使用 Classroom50 官方流程。**作業只 clone 一次，之後在同一個課程容器、
同一份資料夾中編輯、編譯與提交。**不要 clone 公開 Template 來作答。

```text
WSL／主機 Terminal：啟動課程容器
                 ↓
VS Code 連入課程容器：登入 → 接受作業 → clone → 編輯 → 編譯 → 提交
                 ↓
瀏覽器：查看 Classroom50／GitHub 批改結果
```

### 1. [主機] 啟動課程容器

先安裝 Docker、Git、VS Code 與 VS Code 的 **Dev Containers** 擴充套件。
Windows 另外需要 WSL，並在 Docker Desktop 啟用該 Ubuntu 的 WSL integration。

Windows 請開啟 **Ubuntu／WSL 終端機**；macOS／Linux 請開啟主機 Terminal。
啟動 Docker 後，先確認：

```sh
docker version
git --version
```

`docker version` 必須同時顯示 Client 與 Server。若找不到 Docker 或無法連線，
先修復 Docker／WSL 連線，不要繼續建立作業。

第一次建立課程環境時執行：

```sh
cd ~
docker pull ghcr.io/computer-organization-at-ncku-ee/co-docker-env:latest
git clone https://github.com/Computer-Organization-at-NCKU-EE/Docker-Environment.git
cd Docker-Environment
./create.sh comporg
./attach.sh
```

這裡 clone 的是**環境啟動腳本，不是學生作業**。若已有 `Docker-Environment`，
直接進入既有目錄；若已建立 `comporg-dev-container`，使用既有 `./attach.sh` 即可，
不用重複 clone 或重建。

看到容器提示字元後，輸入以下指令離開這個 shell，讓後續操作統一在 VS Code：

```sh
exit
```

`exit` 只離開這次 shell，不會刪除或停止背景容器。先 pull 成功再執行官方腳本；
`attach.sh` 由 `create.sh` 產生。課程映像沿用官方 `linux/amd64` 環境。

### 2. [VS Code] 連入容器，開啟固定工作區

1. 開啟 VS Code，按 `Ctrl+Shift+P`（macOS：`Cmd+Shift+P`）。
2. 選擇 **Dev Containers: Attach to Running Container...**。
3. 選擇 **comporg-dev-container**。
4. 在新開的容器視窗選擇 **File → Open Folder...**，開啟 `/home/ubuntu/workspace`。
5. 選擇 **Terminal → New Terminal**；若不是 bash，使用終端機右側「＋」旁的下拉選單開啟 **bash**。

**從現在起，所有作業指令都在這個 VS Code 容器視窗的終端機執行。**
左下角應顯示 `Container …`，不是只有 `WSL: Ubuntu` 或一般 Windows 視窗。
以左下角的連線狀態為準，不要只看 GitHub 頭像或 Linux 使用者名稱。

`/home/ubuntu/workspace` 是課程的持久化 volume。不要在 Windows 或 WSL 再 clone
第二份作業，也不要另開 Windows／WSL 版本的同名資料夾來編輯。

### 3. [容器] 安裝 GitHub CLI 並登入自己的帳號

第一次使用此容器時執行：

```sh
sudo apt-get update
sudo apt-get install -y gh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
gh extension install foundation50/gh-student --pin v1.33.0
gh student login
gh api user --jq .login
```

`sudo` 若詢問課程容器密碼，輸入 `1234`。依各次 device code 提示，在主機瀏覽器完成授權；
若容器無法自動開啟瀏覽器，手動開啟畫面提供的網址即可。最後一行必須顯示**自己的
GitHub 帳號**。這與 Windows、WSL 或 VS Code 的登入可能不同。

若此容器已安裝並登入，不必重裝；確認最後一行的帳號正確即可。課程目前使用
`gh-student v1.33.0`，不需要為了更新提示自行升級。

### 4. [容器] 接受作業，只 clone 一份到固定路徑

待助教公告作業開放後執行：

```sh
gh student accept Computer-Organization-at-NCKU-EE fall-2026 lab2
```

完成後會提供你個人的 private repository URL。把下方的 `YOUR_REPOSITORY_URL`
換成畫面提供的 **HTTPS URL**，再執行（不要原樣複製佔位文字）：

```sh
cd /home/ubuntu/workspace
git clone YOUR_REPOSITORY_URL lab2
cd lab2
```

若 `lab2` 資料夾已存在，先確認它是不是你原本的 Lab 2 作業；不要刪除或再建立第二份。

接著在**目前容器視窗**選擇 **File → Open Folder...**，開啟：

```text
/home/ubuntu/workspace/lab2
```

再選 **Terminal → New Terminal**。後續所有編譯與 Git 指令，都在這個作業根目錄執行。
可以用 `pwd` 確認位置，用 `git remote -v` 確認連到自己的學生 repository，
而不是公開 Template。

### 5. [同一容器、同一份作業] 編輯並編譯

在 VS Code 左側 Explorer 開啟並修改：

- `asm-prog-assignment/merge.S`
- `asm-prog-assignment/sudoku.S`

修改後先 **File → Save All**，再在下方終端機執行：

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target ArraySort Sudoku --parallel
```

若 VS Code 自動跳出 **Select a Kit**，按 `Esc` 關閉；本流程使用上面的 CMake 指令，
不必另選 compiler Kit。成功時會看到 `Built target ArraySort` 與 `Built target Sudoku`，
產物放在 `build/asm-prog-assignment/`。

**編譯成功只代表能組譯、連結，不代表答案正確。**原始空骨架也能編譯成功。
43 項完整測試會在下一步 submit 後由 Classroom50 執行。

不需要安裝自訂 `lab2` 工具、bootstrap 或 doctor，也不需要自己安裝 ISS。
`grade-local.sh` 需要 Docker daemon，不屬於學生主流程；**不要在課程容器內執行它**。

### 6. [同一容器、同一份作業] 保存並提交

第一次 commit 前設定此 repository 的作者資料，把引號內文字換成自己的資料：

```sh
git config user.name "你的 GitHub 帳號"
git config user.email "你的 Git 電子郵件"
```

電子郵件可使用 GitHub 提供的 noreply 位址。這兩行設定 commit 作者，不會切換登入帳號。

每次修改、儲存並編譯後，依序執行；每一行成功後再執行下一行：

```sh
git status
git add asm-prog-assignment/merge.S asm-prog-assignment/sudoku.S
git commit -m "Complete Lab 2"
git push
gh student submit
git pull --ff-only
```

只加入上述兩份程式，不用提交 `build/`。若顯示 `nothing to commit`，
先確認檔案已儲存；如果這版程式原本就已 commit，可以略過 commit，繼續提交。
若 push 或 submit 失敗，先處理錯誤，不要把它當成成功。

**`git push` 只保存進度；`gh student submit` 才會建立新提交並觸發批改。**
最後的 `git pull --ff-only` 同步 Classroom50 建立的 submission snapshot，
供下一次修改使用；若同步失敗，保留錯誤訊息詢問助教，不要 force push。

### 7. [瀏覽器] 查看本次結果，再回到同一容器修改

提交後，在自己的 GitHub repository 開啟 **Actions** 查看本次 `Autograding`，
完成後到 **Releases** 查看對應 `submit/...` 的總分與 43 個測試結果。
也可在容器終端機查看最近的批改：

```sh
gh run list --workflow autograde.yaml --limit 3
```

Actions 綠色代表批改流程成功執行，**不是取得 100 分**。請查看這次 submission 的結果，
不要只看舊分數。Classroom50 頁面可能稍後才同步。
若長時間停在 `queued`，查看 [GitHub Status](https://www.githubstatus.com/)，不要連續重複 submit。

需要修正時，直接回到本容器的 `/home/ubuntu/workspace/lab2`，重複步驟 5–7。
**Regrade 只重批已提交版本，不會替尚未 submit 的新 commit 建立提交。**

### 下次繼續作業：回到原容器，不再 clone

先啟動 Docker。在主機終端機執行：

```sh
docker start comporg-dev-container
```

再依步驟 2 用 VS Code 連入同一容器，直接開啟 `/home/ubuntu/workspace/lab2`。
不需要重新接受作業、clone 或重裝工具。若顯示找不到容器，先詢問助教，
不要刪除 workspace volume 或恢復 Docker 原廠設定。

## 你要修改的檔案

只在下列兩個固定路徑完成作業，檔名與大小寫不可變更：

- `asm-prog-assignment/merge.S`
- `asm-prog-assignment/sudoku.S`

其他檔案可用於閱讀與建置；不要修改 `.classroom50.yaml`、`.github/` 或自行產生成績。
正式 grader 只讀取上述兩份程式。

## 環境補充（不是另一條操作流程）

課程容器使用 `co-docker-env:latest`，完整安裝背景可參考
[官方 Lab 文件](https://computer-organization-at-ncku-ee.github.io/lab-documents/)。
學生請依本頁 Quick Start 操作，不需要額外在 WSL 建立作業副本。

Classroom50 使用的批改映像與開發容器不同；學生不需要自行啟動它：

```text
ghcr.io/computer-organization-at-ncku-ee/co-lab2-grader-v2@sha256:f0ff938b7c554c1d021d5e91e31dfcbaeb810b88892dec6c0c404fac530b42db
```

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

## 提交政策與截止時間

接受、編譯、提交與查看結果均依本頁 Quick Start，不需要另走其他流程。

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
