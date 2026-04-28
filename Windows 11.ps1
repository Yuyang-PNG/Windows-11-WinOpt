#Requires -RunAsAdministrator
<#
╔══════════════════════════════════════════════════════════════════════╗
║           Windows 11 Deep Optimization Tool v2.4                  ║
║           Windows 11 深度优化工具 v2.4                             ║
╚══════════════════════════════════════════════════════════════════════╝

If you see this file in browser, follow these steps to run:

┌──────────────────────────────────────────────────────────────────────┐
│ Method 1: Right-click to run (Recommended)                         │
├──────────────────────────────────────────────────────────────────────┤
│ 1. Right-click this file                                            │
│ 2. Select "Run with PowerShell"                                     │
│ 3. If prompted "cannot run scripts", use Method 2                   │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│ Method 2: Terminal command                                          │
├──────────────────────────────────────────────────────────────────────┤
│ 1. Press Win + X, select "Windows PowerShell (Admin)"              │
│ 2. Copy and paste the command below, press Enter:                   │
│                                                                      │
│     Set-ExecutionPolicy Bypass -Scope Process -Force;               │
│     & "Full\Path\To\Windows 11.ps1"                                │
│                                                                      │
│ 3. Replace "Full\Path\To" with actual path                          │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│ Method 3: One-click command                                         │
├──────────────────────────────────────────────────────────────────────┤
│ Copy and paste into Admin PowerShell:                                │
│                                                                      │
│   Set-ExecutionPolicy Bypass -Scope Process -Force;                  │
│   & "$(Get-Location)\Windows 11.ps1"                                │
└──────────────────────────────────────────────────────────────────────┘

⚠️  Notes:
- Must run as Administrator
- Auto-backs up key configs to Desktop before changes
- Some optimizations require restart to take effect
- Recommend selecting "A" for all optimizations on first run

────────────────────────────────────────────────────────────────────────
#>
# Windows Deep Optimization Tool v2.4
# New: 1) More obscure optimizations  2) Smart download engine  3) Multi-language

[Console]::BackgroundColor = 'Black'
[Console]::ForegroundColor = 'White'
Clear-Host

# ========== Language Detection & Strings ==========
$script:currentLang = if ($env:PSUICulture) { $env:PSUICulture } else { (Get-Culture).Name }
$script:lang = @{
    systemLang = $script:currentLang
    isCJK = $script:currentLang -match "^zh|^ja|^ko"
}

$script:str = @{}

function Init-Language {
    param([string]$langCode)
    switch -Regex ($langCode) {
        "^zh" {
            $script:str = @{
                TitleMain      = "Windows 11 深度优化工具 v2.4"
                DescMain       = "每个优化项都可独立选择，建议全部启用以获得最佳性能。"
                RunAllPrompt   = "全部执行（推荐，自动选择所有优化项）"
                BaseLayer      = "基础优化层（原 v2.2 核心，建议全选）"
                EnhLayer       = "冷门增强层（v2.3 新增，按需选择）"
                ExpertLayer    = "极限冷门层（v2.4 新增，谨慎选择）"
                AppSection     = "常用应用下载安装（可选）"
                AppNote        = "以下应用均为官方/可信源直链下载，保存到桌面后需手动安装"
                AppName01      = "下载安装 Google Chrome (谷歌浏览器)"
                AppName02      = "下载安装 EdgeBlocker (Edge禁用工具)"
                AppName03      = "下载安装 7-Zip (开源压缩工具)"
                AppName04      = "下载安装 Everything (极速文件搜索)"
                AppName05      = "下载安装 VLC (万能视频播放器)"
                AppName06      = "下载安装 Notepad++ (高级文本编辑器)"
                AppName07      = "下载安装 TranslucentTB (任务栏透明美化)"
                AppName08      = "下载安装 HWiNFO (硬件检测工具)"
                AppName09      = "下载安装 Process Hacker 2 (高级进程管理器)"
                AppName10      = "下载安装 WinRAR (经典压缩软件)"
                Opt01Name      = "文件系统层优化 (NTFS)"
                Opt02Name      = "网络传输层优化 (TCP/IP)"
                Opt03Name      = "内存管理层优化 (MMAgent)"
                Opt04Name      = "调度器层优化"
                Opt05Name      = "多媒体调度层优化"
                Opt06Name      = "启动/时钟层优化 (BCD)"
                Opt07Name      = "电源层优化 (Ultimate Performance)"
                Opt08Name      = "I/O 与磁盘调度层优化"
                Opt09Name      = "内核与中断层优化"
                Opt10Name      = "网络深层优化 (DNS/缓存)"
                Opt11Name      = "服务精简 (诊断跟踪等)"
                Opt12Name      = "图形与显示层优化"
                Opt13Name      = "资源管理器响应优化"
                Opt14Name      = "CPU 调度深层优化"
                Opt15Name      = "Windows Update 优化 (禁用P2P)"
                Opt16Name      = "系统维护任务"
                Opt17Name      = "进程与句柄限制提升"
                Opt18Name      = "文件系统与预读优化"
                Opt19Name      = "系统响应与延迟优化"
                Opt20Name      = "后台与隐私精简"
                Opt21Name      = "高级网络微调"
                BackupDone     = "配置已备份"
                BackupDir      = "备份目录"
                Done           = "全部完成"
                NeedRestart    = "必须重启生效"
                PressExit      = "按任意键退出..."
                AppsDownloaded = "应用安装包已下载到"
                ManualInstall  = "请手动运行安装程序"
                AllSrcFailed   = "所有下载源均不可用，请手动下载"
                TestSrc        = "测试下载源"
                SelectSrc      = "选用下载源"
                Downloaded     = "已下载"
                MB             = "MB"
                AllSrcUnavail  = "所有源不可用"
                DownFailed     = "下载失败"
                DownTimeout    = "下载超时 (5分钟)"
                FileAbnormal   = "文件大小异常"
                FileNotGen     = "文件未生成"
                ChkFileSize    = "检查文件大小..."
                FileTooSmall   = "文件过小，可能下载不完整"
                SrcUnreachable = "源无法访问，跳过"
            }
        }
        "^ja" {
            $script:str = @{
                TitleMain      = "Windows 11 深度最適化ツール v2.4"
                DescMain       = "各項目は個別に選択可能、全項目有効で最高のパフォーマンス。"
                RunAllPrompt   = "全て実行（推奨、全項目自動選択）"
                BaseLayer      = "基本最適化レイヤー（v2.2 コア、全て推奨）"
                EnhLayer       = "特殊最適化レイヤー（v2.3 新規、が必要に応じて選択）"
                ExpertLayer    = "限界特殊レイヤー（v2.4 新規、慎重選択）"
                AppSection     = "常用アプリダウンロード（オプション）"
                AppNote        = "以下は公式/信頼できるソースからダウンロード、手動でインストール必要"
                AppName01      = "Google Chrome (谷歌ブラウザ) をダウンロード"
                AppName02      = "EdgeBlocker (Edge無効化ツール) をダウンロード"
                AppName03      = "7-Zip (オープンソース圧縮ツール) をダウンロード"
                AppName04      = "Everything (高速ファイル検索) をダウンロード"
                AppName05      = "VLC (万能プレーヤー) をダウンロード"
                AppName06      = "Notepad++ (高度なテキストエディタ) をダウンロード"
                AppName07      = "TranslucentTB (タスクバー透明化) をダウンロード"
                AppName08      = "HWiNFO (ハードウェア検出ツール) をダウンロード"
                AppName09      = "Process Hacker 2 (高度なタスクマネージャー) をダウンロード"
                AppName10      = "WinRAR (クラシック圧縮ツール) をダウンロード"
                Opt01Name      = "ファイルシステム最適化 (NTFS)"
                Opt02Name      = "ネットワーク転送層最適化 (TCP/IP)"
                Opt03Name      = "メモリ管理層最適化 (MMAgent)"
                Opt04Name      = "スケジューラ層最適化"
                Opt05Name      = "マルチメディアスケジューリング層最適化"
                Opt06Name      = "起動/時計層最適化 (BCD)"
                Opt07Name      = "電源層最適化 (Ultimate Performance)"
                Opt08Name      = "I/O とディスクスケジューリング最適化"
                Opt09Name      = "カーネルと割り込み層最適化"
                Opt10Name      = "ネット深層最適化 (DNS/キャッシュ)"
                Opt11Name      = "サービス削減 (診断追跡など)"
                Opt12Name      = "グラフィックスと表示層最適化"
                Opt13Name      = "エクスプローラー応答最適化"
                Opt14Name      = "CPU スケジューリング深層最適化"
                Opt15Name      = "Windows Update 最適化 (P2P無効化)"
                Opt16Name      = "システムメンテナンス"
                Opt17Name      = "プロセスとハンドル制限提升"
                Opt18Name      = "ファイルシステムとプリフェッチ最適化"
                Opt19Name      = "システム応答と遅延最適化"
                Opt20Name      = "バックグラウンドとプライバシー削減"
                Opt21Name      = "高度なネットワーク微調整"
                BackupDone     = "設定バックアップ完了"
                BackupDir      = "バックアップディレクトリ"
                Done           = "全て完了"
                NeedRestart    = "再起動が必要"
                PressExit      = "任意のキーを押して終了..."
                AppsDownloaded = "アプリインストールパッケージをダウンロードしました"
                ManualInstall  = "手動でインストールプログラムを実行してください"
                AllSrcFailed   = "全てのダウンロードソースが利用不可、手動でダウンロードしてください"
                TestSrc        = "ソースをテスト中"
                SelectSrc      = "ソースを選択"
                Downloaded     = "ダウンロード完了"
                MB             = "MB"
                AllSrcUnavail  = "全ソース利用不可"
                DownFailed     = "ダウンロード失敗"
                DownTimeout    = "ダウンロードタイムアウト (5分)"
                FileAbnormal   = "ファイルサイズ異常"
                FileNotGen     = "ファイルが生成되지 않음"
                ChkFileSize    = "ファイルサイズを確認中..."
                FileTooSmall   = "ファイルが小さすぎる、ダウンロード不完全の恐れ"
                SrcUnreachable = "ソースに到達できないスキップ"
            }
        }
        "^ko" {
            $script:str = @{
                TitleMain      = "Windows 11 심층 최적화 도구 v2.4"
                DescMain       = "각 항목은 개별적으로 선택 가능, 전체 활성화 시 최고의 성능."
                RunAllPrompt   = "전체 실행 (권장, 모든 항목 자동 선택)"
                BaseLayer      = "기본 최적화 레이어 (v2.2 코어, 전체 권장)"
                EnhLayer       = "특수 최적화 레이어 (v2.3 신규, 필요시 선택)"
                ExpertLayer    = "한계 특수 레이어 (v2.4 신규, 신중 선택)"
                AppSection     = "기본 앱 다운로드 (선택사항)"
                AppNote        = "이하는 공식/신뢰할 수 있는 소스에서 다운로드, 수동 설치 필요"
                AppName01      = "Google Chrome (구글 브라우저) 다운로드"
                AppName02      = "EdgeBlocker (Edge 비활성화 도구) 다운로드"
                AppName03      = "7-Zip (오픈소스 압축 도구) 다운로드"
                AppName04      = "Everything (고속 파일 검색) 다운로드"
                AppName05      = "VLC (만능 동영상 플레이어) 다운로드"
                AppName06      = "Notepad++ (고급 텍스트 편집기) 다운로드"
                AppName07      = "TranslucentTB (작업표시줄 투명화) 다운로드"
                AppName08      = "HWiNFO (하드웨어 감지 도구) 다운로드"
                AppName09      = "Process Hacker 2 (고급 작업 관리자) 다운로드"
                AppName10      = "WinRAR (클래식 압축 도구) 다운로드"
                Opt01Name      = "파일 시스템 최적화 (NTFS)"
                Opt02Name      = "네트워크 전송 레이어 최적화 (TCP/IP)"
                Opt03Name      = "메모리 관리 레이어 최적화 (MMAgent)"
                Opt04Name      = "스케줄러 레이어 최적화"
                Opt05Name      = "멀티미디어 스케줄링 레이어 최적화"
                Opt06Name      = "부팅/시계 레이어 최적화 (BCD)"
                Opt07Name      = "전원 레이어 최적화 (Ultimate Performance)"
                Opt08Name      = "I/O 및 디스크 스케줄링 최적화"
                Opt09Name      = "커널 및 인터럽트 레이어 최적화"
                Opt10Name      = "네트워크 심층 최적화 (DNS/캐시)"
                Opt11Name      = "서비스 축소 (진단 추적 등)"
                Opt12Name      = "그래픽 및 디스플레이 레이어 최적화"
                Opt13Name      = "탐색기 응답 최적화"
                Opt14Name      = "CPU 스케줄링 심층 최적화"
                Opt15Name      = "Windows Update 최적화 (P2P 비활성화)"
                Opt16Name      = "시스템 유지보수"
                Opt17Name      = "프로세스 및 핸들 제한 향상"
                Opt18Name      = "파일 시스템 및 프리패치 최적화"
                Opt19Name      = "시스템 응답 및 지연 최적화"
                Opt20Name      = "백그라운드 및 개인 정보 축소"
                Opt21Name      = "고급 네트워크 미세 조정"
                BackupDone     = "설정 백업 완료"
                BackupDir      = "백업 디렉토리"
                Done           = "전체 완료"
                NeedRestart    = "재시작 필요"
                PressExit      = "아무 키나 눌러 종료..."
                AppsDownloaded = "앱 설치 패키지 다운로드 완료"
                ManualInstall  = "수동으로 설치 프로그램 실행"
                AllSrcFailed   = "모든 다운로드 소스 이용 불가, 수동 다운로드 필요"
                TestSrc        = "소스 테스트 중"
                SelectSrc      = "소스 선택"
                Downloaded     = "다운로드 완료"
                MB             = "MB"
                AllSrcUnavail  = "모든 소스 이용 불가"
                DownFailed     = "다운로드 실패"
                DownTimeout    = "다운로드 시간 초과 (5분)"
                FileAbnormal   = "파일 크기 이상"
                FileNotGen     = "파일 생성 안됨"
                ChkFileSize    = "파일 크기 확인 중..."
                FileTooSmall   = "파일이 너무 작음, 다운로드 불완전 가능"
                SrcUnreachable = "소스 접근 불가, 건너뜀"
            }
        }
        default {
            $script:str = @{
                TitleMain      = "Windows 11 Deep Optimization Tool v2.4"
                DescMain       = "Each option can be selected independently. Enable all for best performance."
                RunAllPrompt   = "Run All (Recommended - auto-selects all options)"
                BaseLayer      = "Base Optimization Layer (v2.2 Core, recommend all)"
                EnhLayer       = "Enhanced Layer (v2.3 New, select as needed)"
                ExpertLayer    = "Expert Layer (v2.4 New, select carefully)"
                AppSection     = "Application Download (Optional)"
                AppNote        = "Downloaded from official/trusted sources. Run installer manually."
                AppName01      = "Download Google Chrome (Google Browser)"
                AppName02      = "Download EdgeBlocker (Disable Edge)"
                AppName03      = "Download 7-Zip (Open Source Compression)"
                AppName04      = "Download Everything (Fast File Search)"
                AppName05      = "Download VLC (Universal Media Player)"
                AppName06      = "Download Notepad++ (Advanced Text Editor)"
                AppName07      = "Download TranslucentTB (Taskbar Transparency)"
                AppName08      = "Download HWiNFO (Hardware Detection)"
                AppName09      = "Download Process Hacker 2 (Advanced Task Manager)"
                AppName10      = "Download WinRAR (Classic Compression)"
                Opt01Name      = "File System Optimization (NTFS)"
                Opt02Name      = "Network Transport Layer Optimization (TCP/IP)"
                Opt03Name      = "Memory Management Layer Optimization (MMAgent)"
                Opt04Name      = "Scheduler Layer Optimization"
                Opt05Name      = "Multimedia Scheduling Layer Optimization"
                Opt06Name      = "Boot/Clock Layer Optimization (BCD)"
                Opt07Name      = "Power Layer Optimization (Ultimate Performance)"
                Opt08Name      = "I/O and Disk Scheduling Layer Optimization"
                Opt09Name      = "Kernel and Interrupt Layer Optimization"
                Opt10Name      = "Network Deep Optimization (DNS/Cache)"
                Opt11Name      = "Service Trimming (Diagnostics/Tracking)"
                Opt12Name      = "Graphics and Display Layer Optimization"
                Opt13Name      = "Explorer Response Optimization"
                Opt14Name      = "CPU Scheduling Deep Optimization"
                Opt15Name      = "Windows Update Optimization (Disable P2P)"
                Opt16Name      = "System Maintenance"
                Opt17Name      = "Process and Handle Limit Increase"
                Opt18Name      = "File System and Prefetch Optimization"
                Opt19Name      = "System Response and Latency Optimization"
                Opt20Name      = "Background and Privacy Trimming"
                Opt21Name      = "Advanced Network Fine-tuning"
                BackupDone     = "Configuration backed up"
                BackupDir      = "Backup directory"
                Done           = "All Complete"
                NeedRestart    = "Restart required to take effect"
                PressExit      = "Press any key to exit..."
                AppsDownloaded = "Apps downloaded to"
                ManualInstall  = "Please run installer manually"
                AllSrcFailed   = "All sources unavailable, please download manually"
                TestSrc        = "Testing source"
                SelectSrc      = "Selected source"
                Downloaded     = "Downloaded"
                MB             = "MB"
                AllSrcUnavail  = "All sources unavailable"
                DownFailed     = "Download failed"
                DownTimeout    = "Download timeout (5 min)"
                FileAbnormal   = "File size abnormal"
                FileNotGen     = "File not generated"
                ChkFileSize    = "Checking file size..."
                FileTooSmall   = "File too small, download may be incomplete"
                SrcUnreachable = "Source unreachable, skipping"
            }
        }
    }
}

function Write-Title($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }
function Write-Ok($m)    { Write-Host "[OK] $m" -ForegroundColor Green }
function Write-Warn($m)  { Write-Host "[!] $m" -ForegroundColor Yellow }
function Write-Info($m)  { Write-Host "[i] $m" -ForegroundColor DarkGray }
function Write-Download($m) { Write-Host "[DL] $m" -ForegroundColor Magenta }

# ========== Initialize Language ==========
Init-Language $script:currentLang

# ========== Language Switch (Press L anytime to change) ==========
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   $($script:str.TitleMain)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Detected: $script:currentLang" -ForegroundColor DarkGray
Write-Host "Press [L] to switch language / 按 [L] 切换语言 / [L] Sprache wechseln`n" -ForegroundColor DarkGray
Write-Host "$($script:str.DescMain)`n" -ForegroundColor White

$langSwitch = $Host.UI.RawUI.ReadKey("IncludeKeyDown").Character
if ($langSwitch -eq "l" -or $langSwitch -eq "L" -or $langSwitch -eq "４") {
    Write-Host "`nSelect Language / 选择语言:" -ForegroundColor Yellow
    Write-Host "  [1] English"
    Write-Host "  [2] 简体中文"
    Write-Host "  [3] 繁體中文"
    Write-Host "  [4] 日本語"
    Write-Host "  [5] 한국어"
    Write-Host "  [6] Español"
    Write-Host "  [7] Français"
    Write-Host "  [8] Deutsch"
    Write-Host "  [9] Português"
    Write-Host "  [0] Русский"
    $langChoice = Read-Host "Choice / 选择"
    switch ($langChoice) {
        "1" { Init-Language "en-US" }
        "2" { Init-Language "zh-CN" }
        "3" { Init-Language "zh-TW" }
        "4" { Init-Language "ja-JP" }
        "5" { Init-Language "ko-KR" }
        "6" { Init-Language "es-ES" }
        "7" { Init-Language "fr-FR" }
        "8" { Init-Language "de-DE" }
        "9" { Init-Language "pt-BR" }
        "0" { Init-Language "ru-RU" }
        default { }
    }
    Clear-Host
}

function Ask-Choice($id, $desc, $default = $true) {
    $yn = if ($default) { "Y/n" } else { "y/N" }
    Write-Host "[$id] $desc [$yn] " -NoNewline -ForegroundColor Yellow
    $r = Read-Host
    if ([string]::IsNullOrWhiteSpace($r)) { $r = if ($default) { "y" } else { "n" } }
    return $r -match "^[yY]"
}

$runAll = Ask-Choice "A" $script:str.RunAllPrompt $false

if ($runAll) {
    $opt_FS        = $true
    $opt_Network   = $true
    $opt_Memory    = $true
    $opt_Scheduler = $true
    $opt_MM        = $true
    $opt_BCD       = $true
    $opt_Power     = $true
    $opt_IO        = $true
    $opt_Kernel    = $true
    $opt_NetDeep   = $true
    $opt_Services  = $true
    $opt_Graphics  = $true
    $opt_Explorer  = $true
    $opt_CPUDeep   = $true
    $opt_WU        = $true
    $opt_Maintenance = $true
    $opt_Extra1    = $true
    $opt_Extra2    = $true
    $opt_Extra3    = $true
    $opt_Extra4    = $true
    $opt_Extra5    = $true
} else {
    Write-Host "`n--- $($script:str.BaseLayer) ---" -ForegroundColor Cyan
    $opt_FS        = Ask-Choice "01" $script:str.Opt01Name
    $opt_Network   = Ask-Choice "02" $script:str.Opt02Name
    $opt_Memory    = Ask-Choice "03" $script:str.Opt03Name
    $opt_Scheduler = Ask-Choice "04" $script:str.Opt04Name
    $opt_MM        = Ask-Choice "05" $script:str.Opt05Name
    $opt_BCD       = Ask-Choice "06" $script:str.Opt06Name
    $opt_Power     = Ask-Choice "07" $script:str.Opt07Name

    Write-Host "`n--- $($script:str.EnhLayer) ---" -ForegroundColor Cyan
    $opt_IO        = Ask-Choice "08" $script:str.Opt08Name
    $opt_Kernel    = Ask-Choice "09" $script:str.Opt09Name
    $opt_NetDeep   = Ask-Choice "10" $script:str.Opt10Name
    $opt_Services  = Ask-Choice "11" $script:str.Opt11Name
    $opt_Graphics  = Ask-Choice "12" $script:str.Opt12Name
    $opt_Explorer  = Ask-Choice "13" $script:str.Opt13Name
    $opt_CPUDeep   = Ask-Choice "14" $script:str.Opt14Name
    $opt_WU        = Ask-Choice "15" $script:str.Opt15Name
    $opt_Maintenance = Ask-Choice "16" $script:str.Opt16Name

    Write-Host "`n--- $($script:str.ExpertLayer) ---" -ForegroundColor Cyan
    $opt_Extra1    = Ask-Choice "17" $script:str.Opt17Name $false
    $opt_Extra2    = Ask-Choice "18" $script:str.Opt18Name $false
    $opt_Extra3    = Ask-Choice "19" $script:str.Opt19Name $false
    $opt_Extra4    = Ask-Choice "20" $script:str.Opt20Name $false
    $opt_Extra5    = Ask-Choice "21" $script:str.Opt21Name $false
}

# ========== Application Download Selection ==========
Write-Host "`n--- $($script:str.AppSection) ---" -ForegroundColor Cyan
Write-Info $script:str.AppNote

$dl_Chrome      = Ask-Choice "APP-1" $script:str.AppName01 $false
$dl_EdgeBlocker = Ask-Choice "APP-2" $script:str.AppName02 $false
$dl_7zip        = Ask-Choice "APP-3" $script:str.AppName03 $false
$dl_Everything  = Ask-Choice "APP-4" $script:str.AppName04 $false
$dl_VLC         = Ask-Choice "APP-5" $script:str.AppName05 $false
$dl_Notepad     = Ask-Choice "APP-6" $script:str.AppName06 $false
$dl_TB          = Ask-Choice "APP-7" $script:str.AppName07 $false
$dl_HWiNFO      = Ask-Choice "APP-8" $script:str.AppName08 $false
$dl_ProcessHacker = Ask-Choice "APP-9" $script:str.AppName09 $false
$dl_WinRAR      = Ask-Choice "APP-10" $script:str.AppName10 $false

# ========== Backup ==========
$backupDir = "$env:USERPROFILE\Desktop\WinOpt_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
bcdedit /export "$backupDir\bcd_backup.bcd" | Out-Null
reg export "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "$backupDir\PriorityControl.reg" /y | Out-Null
reg export "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "$backupDir\TcpipParameters.reg" /y | Out-Null
Write-Ok "$($script:str.BackupDone): $backupDir"

# ========== 1. File System Layer ==========
if ($opt_FS) {
    Write-Title $script:str.Opt01Name
    fsutil behavior set disablelastaccess 1 | Out-Null
    fsutil behavior set disable8dot3 1 | Out-Null
    fsutil behavior set memoryusage 2 | Out-Null
    fsutil behavior set mftzone 2 | Out-Null
    fsutil behavior set disabledeletenotify 0 | Out-Null
    Write-Ok "NTFS $($script:str.Done)"
}

# ========== 2. Network Transport Layer ==========
if ($opt_Network) {
    Write-Title $script:str.Opt02Name
    netsh int tcp set global autotuninglevel=experimental | Out-Null
    netsh int tcp set global rss=enabled | Out-Null
    netsh int tcp set heuristics disabled | Out-Null
    netsh int tcp set global congestionprovider=ctcp | Out-Null
    netsh int tcp set global chimney=disabled | Out-Null
    netsh int tcp set global timestamps=disabled | Out-Null
    netsh int tcp set global ecncapability=disabled | Out-Null

    $tcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    reg add $tcpParams /v EnableDynamicBacklog /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f | Out-Null
    reg add $tcpParams /v MaxUserPort /t REG_DWORD /d 65534 /f | Out-Null
    reg add $tcpParams /v TcpNoDelay /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TcpAckFrequency /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TcpDelAckTicks /t REG_DWORD /d 0 /f | Out-Null
    Write-Ok "TCP/IP $($script:str.Done) (Nagle/ACK $($script:str.Opt10Name))"
}

# ========== 3. Memory Management Layer ==========
if ($opt_Memory) {
    Write-Title $script:str.Opt03Name
    Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue | Out-Null
    Disable-MMAgent -PageCombining -ErrorAction SilentlyContinue | Out-Null
    Set-MMagent -MaxOperationAPIFiles 4096 -ErrorAction SilentlyContinue | Out-Null
    Disable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue | Out-Null
    Enable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue | Out-Null
    Write-Ok "MMAgent $($script:str.Done)"
}

# ========== 4. Scheduler Layer ==========
if ($opt_Scheduler) {
    Write-Title $script:str.Opt04Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x18 /f | Out-Null
    Write-Ok "Foreground $($script:str.Opt04Name)"
}

# ========== 5. Multimedia Scheduling Layer ==========
if ($opt_MM) {
    Write-Title $script:str.Opt05Name
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f | Out-Null
    Write-Ok "Multimedia reserved CPU to 10%"
}

# ========== 6. BCD Boot/Clock Layer ==========
if ($opt_BCD) {
    Write-Title $script:str.Opt06Name
    bcdedit /set disabledynamictick yes | Out-Null
    bcdedit /set useplatformtick yes | Out-Null
    bcdedit /set tscsyncpolicy enhanced | Out-Null
    bcdedit /set uselegacyapicmode no | Out-Null
    bcdedit /set usephysicaldestination no | Out-Null
    Write-Ok "BCD Clock $($script:str.Done)"
}

# ========== 7. Power Layer ==========
if ($opt_Power) {
    Write-Title $script:str.Opt07Name
    $ult = powercfg /list | Select-String -Pattern "Ultimate Performance" -SimpleMatch
    if (-not $ult) {
        $ult = powercfg /list | Select-String -Pattern "卓越性能" -SimpleMatch
    }
    if (-not $ult) {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        Write-Ok "Unlock Ultimate Performance"
        $ult = powercfg /list | Select-String -Pattern "Ultimate Performance" -SimpleMatch
        if (-not $ult) {
            $ult = powercfg /list | Select-String -Pattern "卓越性能" -SimpleMatch
        }
    }
    if ($ult) {
        if ($ult.Line -match '([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})') {
            $ultGuid = $Matches[1]
            powercfg /setactive $ultGuid | Out-Null
            Write-Ok "Activated Ultimate Performance ($ultGuid)"
        } else {
            Write-Warn "Cannot extract GUID, run powercfg /setactive manually"
        }
    } else {
        Write-Warn "Ultimate Performance not found, check manually"
    }
}

# ========== 8. I/O and Disk Scheduling Layer ==========
if ($opt_IO) {
    Write-Title $script:str.Opt08Name
    reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d N /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQPriority /t REG_DWORD /d 1 /f | Out-Null
    Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Ok "SysMain (Superfetch) disabled, I/O priority optimized"
}

# ========== 9. Kernel and Interrupt Layer ==========
if ($opt_Kernel) {
    Write-Title $script:str.Opt09Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f | Out-Null
    Write-Ok "Kernel memory management $($script:str.Done)"
}

# ========== 10. Network Deep Optimization ==========
if ($opt_NetDeep) {
    Write-Title $script:str.Opt10Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 86400 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRecentDocsNetHood /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v SackOpts /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDataRetransmissions /t REG_DWORD /d 3 /f | Out-Null
    Write-Ok "DNS cache / TCP retrans / network discovery delay optimized"
}

# ========== 11. Service Trimming ==========
if ($opt_Services) {
    Write-Title $script:str.Opt11Name
    $diagServices = @("DiagTrack", "dmwappushservice")
    foreach ($svc in $diagServices) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
    Write-Ok "Diagnostic tracking services disabled"
}

# ========== 12. Graphics Layer ==========
if ($opt_Graphics) {
    Write-Title $script:str.Opt12Name
    reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
    Write-Ok "GameDVR / fullscreen optimization adjusted"
}

# ========== 13. Explorer Response Optimization ==========
if ($opt_Explorer) {
    Write-Title $script:str.Opt13Name
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableThumbnailCache /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_SZ /d NotSpecified /f | Out-Null
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f | Out-Null
    Write-Ok "Explorer thumbnail/folder type/tray optimized"
}

# ========== 14. CPU Scheduling Deep Optimization ==========
if ($opt_CPUDeep) {
    Write-Title $script:str.Opt14Name
    powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 | Out-Null
    powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 | Out-Null
    powercfg /setacvalueindex scheme_current sub_processor 465e1f50-b610-473a-ab58-00d1077dc418 2 | Out-Null
    powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 | Out-Null
    powercfg /setactive scheme_current | Out-Null
    Write-Ok "CPU core parking / USB suspension / performance boost mode optimized"
}

# ========== 15. Windows Update Optimization ==========
if ($opt_WU) {
    Write-Title $script:str.Opt15Name
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DOAbsoluteMaxCacheSize /t REG_DWORD /d 0 /f | Out-Null
    Write-Ok "P2P update / Delivery Optimization disabled"
}

# ========== 16. System Maintenance ==========
if ($opt_Maintenance) {
    Write-Title $script:str.Opt16Name
    cd C:\Windows\System32; lodctr /R | Out-Null
    cd C:\Windows\SysWOW64; lodctr /R | Out-Null
    rundll32.exe advapi32.dll,ProcessIdleTasks
    Write-Ok "Maintenance $($script:str.Done)"
}

# ========== 17-21 Expert Optimizations ==========
if ($opt_Extra1) {
    Write-Title $script:str.Opt17Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxFreeTcbs /t REG_DWORD /d 65536 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxHashTableSize /t REG_DWORD /d 65536 /f | Out-Null
    Write-Ok $script:str.Opt17Name
}

if ($opt_Extra2) {
    Write-Title $script:str.Opt18Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout" /v EnableAutoLayout /t REG_DWORD /d 0 /f | Out-Null
    Write-Ok $script:str.Opt18Name
}

if ($opt_Extra3) {
    Write-Title $script:str.Opt19Name
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogPeriod /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f | Out-Null
    Write-Ok $script:str.Opt19Name
}

if ($opt_Extra4) {
    Write-Title $script:str.Opt20Name
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f | Out-Null
    Write-Ok $script:str.Opt20Name
}

if ($opt_Extra5) {
    Write-Title $script:str.Opt21Name
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 64240 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v GlobalMaxTcpWindowSize /t REG_DWORD /d 64240 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxConnectionsPerServer /t REG_DWORD /d 16 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /t REG_DWORD /d 3 /f | Out-Null
    Write-Ok $script:str.Opt21Name
}

# ========== Smart Download Engine ==========
$dlDir = "$env:USERPROFILE\Desktop\WinOpt_Apps_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if ($dl_Chrome -or $dl_EdgeBlocker -or $dl_7zip -or $dl_Everything -or $dl_VLC -or $dl_Notepad -or $dl_TB -or $dl_HWiNFO -or $dl_ProcessHacker -or $dl_WinRAR) {
    New-Item -ItemType Directory -Path $dlDir -Force | Out-Null
    Write-Title $script:str.AppSection
    Write-Info "$($script:str.BackupDir): $dlDir"
}

$script:is64Bit = [Environment]::Is64BitOperatingSystem

function Test-DownloadUrl($url, $timeoutSec = 5) {
    try {
        $request = [System.Net.WebRequest]::Create($url)
        $request.Method = "HEAD"
        $request.Timeout = $timeoutSec * 1000
        $request.AllowAutoRedirect = $true
        $request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        $response = $request.GetResponse()
        $status = [int]$response.StatusCode
        $response.Close()
        return ($status -ge 200 -and $status -lt 400)
    } catch {
        return $false
    }
}

function Get-BestUrl($urlList) {
    foreach ($url in $urlList) {
        Write-Info "$($script:str.TestSrc): $($url.Split('/')[2]) ..."
        if (Test-DownloadUrl $url) {
            Write-Ok "$($script:str.SelectSrc): $($url.Split('/')[2])"
            return $url
        }
    }
    return $null
}

function Download-AppSmart($name, $urlList, $outFile) {
    $bestUrl = Get-BestUrl $urlList
    if (-not $bestUrl) {
        Write-Warn $script:str.AllSrcFailed
        return $null
    }
    $outPath = Join-Path $dlDir $outFile
    try {
        $job = Start-Job -ScriptBlock {
            param($url, $out)
            Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -MaximumRedirection 10
        } -ArgumentList $bestUrl, $outPath
        $completed = $job | Wait-Job -Timeout 300
        if (-not $completed) {
            Stop-Job $job
            Remove-Job $job
            throw $script:str.DownTimeout
        }
        Receive-Job $job | Out-Null
        Remove-Job $job
        if (Test-Path $outPath) {
            $size = (Get-Item $outPath).Length
            if ($size -gt 1024) {
                Write-Download "$name $($script:str.Downloaded): $outPath ($([math]::Round($size/1MB,2)) $($script:str.MB))"
                return $outPath
            } else {
                Remove-Item $outPath -Force
                throw $script:str.FileAbnormal
            }
        }
        throw $script:str.FileNotGen
    } catch {
        Write-Warn "$name $($script:str.DownFailed): $_"
        if (Test-Path $outPath) { Remove-Item $outPath -Force }
        return $null
    }
}

# App download configs with multiple mirrors
if ($dl_Chrome) {
    Download-AppSmart "Google Chrome" @("https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi", "https://redirector.gvt1.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi") "Chrome.msi"
}
if ($dl_EdgeBlocker) {
    Download-AppSmart "EdgeBlocker" @("https://www.sordum.org/files/download/edge-blocker/EdgeBlocker.zip") "EdgeBlocker.zip"
}
if ($dl_7zip) {
    $urls = if ($script:is64Bit) { @("https://www.7-zip.org/a/7z2408-x64.exe", "https://d.7-zip.org/a/7z2408-x64.exe") } else { @("https://www.7-zip.org/a/7z2408.exe") }
    Download-AppSmart "7-Zip" $urls $(if ($script:is64Bit) { "7zip.exe" } else { "7zip-x86.exe" })
}
if ($dl_Everything) {
    $urls = if ($script:is64Bit) { @("https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe") } else { @("https://www.voidtools.com/Everything-1.4.1.1024.x86-Setup.exe") }
    Download-AppSmart "Everything" $urls $(if ($script:is64Bit) { "Everything.exe" } else { "Everything-x86.exe" })
}
if ($dl_VLC) {
    Download-AppSmart "VLC" @("https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.exe", "https://mirror.aarnet.edu.au/pub/videolan/vlc/3.0.21/win64/vlc-3.0.21-win64.exe") "VLC.exe"
}
if ($dl_Notepad) {
    Download-AppSmart "Notepad++" @("https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.1/npp.8.7.1.Installer.x64.exe") "Notepad++.exe"
}
if ($dl_TB) {
    Download-AppSmart "TranslucentTB" @("https://github.com/TranslucentTB/TranslucentTB/releases/download/2024.1/TranslucentTB-portable.zip") "TranslucentTB.zip"
}
if ($dl_HWiNFO) {
    Download-AppSmart "HWiNFO" @("https://www.sac.sk/download/utildiag/hwi_800.exe") "HWiNFO.exe"
}
if ($dl_ProcessHacker) {
    $urls = if ($script:is64Bit) { @("https://github.com/processhacker/processhacker/releases/download/v2.39/processhacker-2.39-setup.exe") } else { @("https://github.com/processhacker/processhacker/releases/download/v2.39/processhacker-2.39-setup-x86.exe") }
    Download-AppSmart "Process Hacker 2" $urls $(if ($script:is64Bit) { "ProcessHacker.exe" } else { "ProcessHacker-x86.exe" })
}
if ($dl_WinRAR) {
    $urls = if ($script:is64Bit) { @("https://www.rarlab.com/rar/winrar-x64-701.exe") } else { @("https://www.rarlab.com/rar/wrar701.exe") }
    Download-AppSmart "WinRAR" $urls $(if ($script:is64Bit) { "WinRAR.exe" } else { "WinRAR-x86.exe" })
}

# ========== Completion ==========
Write-Title $script:str.Done
Write-Warn $script:str.NeedRestart
if ($dl_Chrome -or $dl_EdgeBlocker -or $dl_7zip -or $dl_Everything -or $dl_VLC -or $dl_Notepad -or $dl_TB -or $dl_HWiNFO -or $dl_ProcessHacker -or $dl_WinRAR) {
    Write-Info "$($script:str.AppsDownloaded): $dlDir"
    Write-Info $script:str.ManualInstall
}
Write-Host $script:str.PressExit -NoNewline
$null = [Console]::ReadKey($true)
