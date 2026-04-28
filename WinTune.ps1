#Requires -RunAsAdministrator
#Requires -Version 5.1
<#
.SYNOPSIS
    WinTune Pro - Comprehensive Windows System Optimization & Management Suite
.DESCRIPTION
    Advanced PowerShell toolkit for Windows performance tuning, process management,
    system security, privacy hardening, storage optimization, and hardware monitoring.
    Auto-detects system language (zh-CN/en-US/ja-JP/ko-KR) for localized UI.
    Compatible with Windows 10/11 (PowerShell 5.1+ / PowerShell 7.x).
.VERSION
    2.1.0
.AUTHOR
    System Administrator
.NOTES
    Run as Administrator. Some changes require reboot to take full effect.
    Creates automatic system restore points before critical modifications.
#>

# ==================== Language Detection ====================
$script:Lang = (Get-WinSystemLocale).Name
if ($script:Lang -notmatch '^(zh|en|ja|ko)-') { $script:Lang = 'en-US' }

# ==================== Localization Strings ====================
$script:L = @{
    'zh-CN' = @{
        Title = 'WinTune Pro v{0} - 系统优化套件'
        AdminRequired = '此脚本需要管理员权限。请以管理员身份运行 PowerShell 后重试。'
        SelectOption = '请选择操作'
        PressEnter = '按 Enter 返回'
        InvalidOption = '无效选项'
        ExitMsg = '感谢使用 WinTune Pro！'
        ProcessPerformance = '进程与性能'
        SystemCleanup = '系统清理'
        Optimization = '系统优化'
        SecurityPrivacy = '安全与隐私'
        MonitoringInfo = '监控与信息'
        Opt1 = '一键游戏与开发环境优化'
        Opt2 = '自定义进程优先级绑定'
        Opt3 = '查看已绑定的优先级'
        Opt4 = '移除优先级绑定'
        Opt5 = '设置进程 CPU 亲和性'
        Opt6 = '启用游戏专注模式'
        Opt7 = '深度系统清理'
        Opt8 = '存储优化与健康检查'
        Opt9 = '管理启动项'
        Opt10 = '高级系统性能调优'
        Opt11 = '网络优化与 DNS'
        Opt12 = 'Windows 更新管理'
        Opt13 = '隐私安全加固'
        Opt14 = '右键菜单管理'
        Opt15 = '实时硬件监控'
        Opt16 = '系统信息报告'
        Opt17 = '查看操作日志'
        Exit = '退出'
        EnterProcessName = '输入进程名（如 notepad.exe）'
        EnterCpuPriority = 'CPU 优先级 (Idle/BelowNormal/Normal/AboveNormal/High/Realtime)'
        EnterIoPriority = 'IO 优先级 (Low/Normal/High/Critical，默认: High)'
        EnterToUnbind = '输入要解除绑定的进程名'
        EnterCores = '输入要使用的核心（逗号分隔，如 0,1,2,3）'
        ScanLargeFiles = '扫描大文件？ (y/n)'
        MinSizeMB = '最小大小 MB（默认: 500）'
        SelectDNS = '选择 DNS 提供商'
        ResetNetwork = '重置 Windows 网络栈？ (y/n)'
        EnterNumberRemove = '输入要移除的编号（或 0 取消）'
        EnterToggle = '输入要切换的项编号（或 0 取消）'
        LogInitialized = 'WinTune Pro 已初始化。日志: {0}'
        NoLogFound = '未找到日志文件'
        OK = '[OK]'
        Done = '完成'
        RebootRecommended = '建议重启系统'
        CreatingRestorePoint = '正在创建系统还原点...'
        RestorePointCreated = '系统还原点已创建'
        RestorePointFailed = '创建还原点失败'
        BackingUpRegistry = '正在备份注册表...'
        RegistryBackedUp = '注册表已备份'
        OptimizingNTFS = '正在优化 NTFS...'
        NTFSOptimized = 'NTFS 已优化'
        OptimizingTCP = '正在优化 TCP/IP...'
        TCPOptimized = 'TCP/IP 已优化'
        OptimizingMultimedia = '正在优化多媒体调度...'
        MultimediaOptimized = '多媒体调度已优化'
        ConfiguringPower = '正在配置电源计划...'
        PowerConfigured = '电源计划已配置'
        DisablingHibernation = '正在禁用休眠...'
        HibernationDisabled = '休眠已禁用'
        CleaningTemp = '正在清理临时文件...'
        TempCleaned = '临时文件已清理'
        RunningDiskCleanup = '正在运行磁盘清理...'
        DiskCleanupDone = '磁盘清理完成'
        CleaningWinSxS = '正在清理组件存储 (WinSxS)...'
        WinSxSCleaned = '组件存储已清理'
        StoppingProcesses = '正在停止后台进程...'
        ProcessStopped = '已停止: {0}'
        DisablingServices = '正在禁用服务...'
        ServiceDisabled = '服务 {0} 已禁用'
        EnablingGameMode = '正在启用游戏模式...'
        GameModeEnabled = '游戏模式已启用'
        DisablingGameDVR = '正在禁用 Game DVR...'
        GameDVRDisabled = 'Game DVR 已禁用'
        StoppingNonEssential = '正在停止非必要应用...'
        NonEssentialStopped = '非必要应用已停止'
        PrivacyHardening = '正在执行隐私加固...'
        TelemetryDisabled = '遥测已禁用'
        CortanaDisabled = 'Cortana 已禁用'
        ActivityHistoryDisabled = '活动历史已禁用'
        AdvertisingIDDisabled = '广告 ID 已禁用'
        LocationDisabled = '位置跟踪已禁用'
        DefenderOptimized = 'Defender 已优化'
        PrivacyDone = '隐私加固完成'
        StorageOptimized = '存储已优化'
        DiskHealth = '磁盘健康状态'
        NetworkOptimized = '网络已优化'
        DNSFlushed = 'DNS 缓存已刷新'
        NetworkReset = '网络栈已重置，需要重启'
        UpdatePaused = '更新已暂停 7 天'
        UpdateResumed = '更新已恢复'
        ActiveHoursSet = '活跃时段已设置为 8:00 - 23:00'
        ContextMenuManager = '右键菜单管理'
        HardwareMonitor = '硬件监控（按 Ctrl+C 退出）'
        SystemInfoReport = '系统信息报告'
        OperatingSystem = '操作系统'
        Processor = '处理器'
        Memory = '内存'
        Graphics = '显卡'
        Storage = '存储'
        Network = '网络'
        Uptime = '运行时间'
        AllCompleted = '全部完成'
    }
    'en-US' = @{
        Title = 'WinTune Pro v{0} - System Optimization Suite'
        AdminRequired = 'This script requires Administrator privileges. Please run PowerShell as Administrator and try again.'
        SelectOption = 'Select an option'
        PressEnter = 'Press Enter to return'
        InvalidOption = 'Invalid option'
        ExitMsg = 'Thank you for using WinTune Pro!'
        ProcessPerformance = 'Process & Performance'
        SystemCleanup = 'System Cleanup'
        Optimization = 'Optimization'
        SecurityPrivacy = 'Security & Privacy'
        MonitoringInfo = 'Monitoring & Info'
        Opt1 = 'One-Click Gaming & Dev Optimization'
        Opt2 = 'Custom Process Priority Binding'
        Opt3 = 'View Bound Priorities'
        Opt4 = 'Remove Priority Binding'
        Opt5 = 'Set Process CPU Affinity'
        Opt6 = 'Enable Gaming Focus Mode'
        Opt7 = 'Deep System Cleanup'
        Opt8 = 'Storage Optimization & Health Check'
        Opt9 = 'Manage Startup Items'
        Opt10 = 'Advanced System Performance Tuning'
        Opt11 = 'Network Optimization & DNS'
        Opt12 = 'Windows Update Management'
        Opt13 = 'Privacy & Security Hardening'
        Opt14 = 'Context Menu Manager'
        Opt15 = 'Real-Time Hardware Monitor'
        Opt16 = 'System Information Report'
        Opt17 = 'View Operation Log'
        Exit = 'Exit'
        EnterProcessName = 'Enter process name (e.g., notepad.exe)'
        EnterCpuPriority = 'CPU Priority (Idle/BelowNormal/Normal/AboveNormal/High/Realtime)'
        EnterIoPriority = 'IO Priority (Low/Normal/High/Critical, default: High)'
        EnterToUnbind = 'Enter process name to unbind'
        EnterCores = 'Enter cores to use (comma-separated, e.g., 0,1,2,3)'
        ScanLargeFiles = 'Scan for large files? (y/n)'
        MinSizeMB = 'Minimum size in MB (default: 500)'
        SelectDNS = 'Select DNS provider'
        ResetNetwork = 'Reset Windows network stack? (y/n)'
        EnterNumberRemove = 'Enter number to remove (or 0 to cancel)'
        EnterToggle = 'Enter item number to toggle (or 0 to cancel)'
        LogInitialized = 'WinTune Pro initialized. Log: {0}'
        NoLogFound = 'No log file found'
        OK = '[OK]'
        Done = 'Done'
        RebootRecommended = 'Restart recommended'
        CreatingRestorePoint = 'Creating system restore point...'
        RestorePointCreated = 'System restore point created'
        RestorePointFailed = 'Failed to create restore point'
        BackingUpRegistry = 'Backing up registry...'
        RegistryBackedUp = 'Registry backed up'
        OptimizingNTFS = 'Optimizing NTFS...'
        NTFSOptimized = 'NTFS optimized'
        OptimizingTCP = 'Optimizing TCP/IP...'
        TCPOptimized = 'TCP/IP optimized'
        OptimizingMultimedia = 'Optimizing multimedia scheduling...'
        MultimediaOptimized = 'Multimedia scheduling optimized'
        ConfiguringPower = 'Configuring power plan...'
        PowerConfigured = 'Power plan configured'
        DisablingHibernation = 'Disabling hibernation...'
        HibernationDisabled = 'Hibernation disabled'
        CleaningTemp = 'Cleaning temp files...'
        TempCleaned = 'Temp files cleaned'
        RunningDiskCleanup = 'Running disk cleanup...'
        DiskCleanupDone = 'Disk cleanup done'
        CleaningWinSxS = 'Cleaning Component Store (WinSxS)...'
        WinSxSCleaned = 'Component Store cleaned'
        StoppingProcesses = 'Stopping background processes...'
        ProcessStopped = 'Stopped: {0}'
        DisablingServices = 'Disabling services...'
        ServiceDisabled = 'Service {0} disabled'
        EnablingGameMode = 'Enabling Game Mode...'
        GameModeEnabled = 'Game Mode enabled'
        DisablingGameDVR = 'Disabling Game DVR...'
        GameDVRDisabled = 'Game DVR disabled'
        StoppingNonEssential = 'Stopping non-essential apps...'
        NonEssentialStopped = 'Non-essential apps stopped'
        PrivacyHardening = 'Applying privacy hardening...'
        TelemetryDisabled = 'Telemetry disabled'
        CortanaDisabled = 'Cortana disabled'
        ActivityHistoryDisabled = 'Activity history disabled'
        AdvertisingIDDisabled = 'Advertising ID disabled'
        LocationDisabled = 'Location tracking disabled'
        DefenderOptimized = 'Defender optimized'
        PrivacyDone = 'Privacy hardening completed'
        StorageOptimized = 'Storage optimized'
        DiskHealth = 'Disk Health'
        NetworkOptimized = 'Network optimized'
        DNSFlushed = 'DNS cache flushed'
        NetworkReset = 'Network stack reset, restart required'
        UpdatePaused = 'Updates paused for 7 days'
        UpdateResumed = 'Updates resumed'
        ActiveHoursSet = 'Active hours set to 8:00 - 23:00'
        ContextMenuManager = 'Context Menu Manager'
        HardwareMonitor = 'Hardware Monitor (Press Ctrl+C to exit)'
        SystemInfoReport = 'System Information Report'
        OperatingSystem = 'Operating System'
        Processor = 'Processor'
        Memory = 'Memory'
        Graphics = 'Graphics'
        Storage = 'Storage'
        Network = 'Network'
        Uptime = 'Uptime'
        AllCompleted = 'All completed'
    }
    'ja-JP' = @{
        Title = 'WinTune Pro v{0} - システム最適化スイート'
        AdminRequired = 'このスクリプトには管理者権限が必要です。PowerShell を管理者として実行してください。'
        SelectOption = '操作を選択してください'
        PressEnter = 'Enter キーを押して戻る'
        InvalidOption = '無効なオプション'
        ExitMsg = 'WinTune Pro をご利用いただきありがとうございます！'
        ProcessPerformance = 'プロセスとパフォーマンス'
        SystemCleanup = 'システムクリーンアップ'
        Optimization = '最適化'
        SecurityPrivacy = 'セキュリティとプライバシー'
        MonitoringInfo = '監視と情報'
        Opt1 = 'ゲームと開発環境のワンクリック最適化'
        Opt2 = 'カスタムプロセス優先度のバインド'
        Opt3 = 'バインドされた優先度を表示'
        Opt4 = '優先度バインドを解除'
        Opt5 = 'プロセス CPU アフィニティを設定'
        Opt6 = 'ゲームフォーカスモードを有効化'
        Opt7 = 'ディープシステムクリーンアップ'
        Opt8 = 'ストレージ最適化と健全性チェック'
        Opt9 = 'スタートアップ項目の管理'
        Opt10 = '高度なシステムパフォーマンス調整'
        Opt11 = 'ネットワーク最適化と DNS'
        Opt12 = 'Windows Update の管理'
        Opt13 = 'プライバシーとセキュリティの強化'
        Opt14 = 'コンテキストメニューマネージャー'
        Opt15 = 'リアルタイムハードウェアモニター'
        Opt16 = 'システム情報レポート'
        Opt17 = '操作ログを表示'
        Exit = '終了'
        EnterProcessName = 'プロセス名を入力（例: notepad.exe）'
        EnterCpuPriority = 'CPU 優先度 (Idle/BelowNormal/Normal/AboveNormal/High/Realtime)'
        EnterIoPriority = 'IO 優先度 (Low/Normal/High/Critical、デフォルト: High)'
        EnterToUnbind = 'バインドを解除するプロセス名を入力'
        EnterCores = '使用するコアを入力（カンマ区切り、例: 0,1,2,3）'
        ScanLargeFiles = '大きなファイルをスキャンしますか？ (y/n)'
        MinSizeMB = '最小サイズ MB（デフォルト: 500）'
        SelectDNS = 'DNS プロバイダーを選択'
        ResetNetwork = 'Windows ネットワークスタックをリセットしますか？ (y/n)'
        EnterNumberRemove = '削除する番号を入力（または 0 でキャンセル）'
        EnterToggle = '切り替える項目番号を入力（または 0 でキャンセル）'
        LogInitialized = 'WinTune Pro を初期化しました。ログ: {0}'
        NoLogFound = 'ログファイルが見つかりません'
        OK = '[OK]'
        Done = '完了'
        RebootRecommended = 'システムの再起動を推奨'
        CreatingRestorePoint = 'システム復元ポイントを作成中...'
        RestorePointCreated = 'システム復元ポイントを作成しました'
        RestorePointFailed = '復元ポイントの作成に失敗しました'
        BackingUpRegistry = 'レジストリをバックアップ中...'
        RegistryBackedUp = 'レジストリをバックアップしました'
        OptimizingNTFS = 'NTFS を最適化中...'
        NTFSOptimized = 'NTFS を最適化しました'
        OptimizingTCP = 'TCP/IP を最適化中...'
        TCPOptimized = 'TCP/IP を最適化しました'
        OptimizingMultimedia = 'マルチメディアスケジューリングを最適化中...'
        MultimediaOptimized = 'マルチメディアスケジューリングを最適化しました'
        ConfiguringPower = '電源プランを設定中...'
        PowerConfigured = '電源プランを設定しました'
        DisablingHibernation = '休止状態を無効化中...'
        HibernationDisabled = '休止状態を無効化しました'
        CleaningTemp = '一時ファイルをクリーンアップ中...'
        TempCleaned = '一時ファイルをクリーンアップしました'
        RunningDiskCleanup = 'ディスククリーンアップを実行中...'
        DiskCleanupDone = 'ディスククリーンアップ完了'
        CleaningWinSxS = 'コンポーネントストア (WinSxS) をクリーンアップ中...'
        WinSxSCleaned = 'コンポーネントストアをクリーンアップしました'
        StoppingProcesses = 'バックグラウンドプロセスを停止中...'
        ProcessStopped = '停止しました: {0}'
        DisablingServices = 'サービスを無効化中...'
        ServiceDisabled = 'サービス {0} を無効化しました'
        EnablingGameMode = 'ゲームモードを有効化中...'
        GameModeEnabled = 'ゲームモードを有効化しました'
        DisablingGameDVR = 'Game DVR を無効化中...'
        GameDVRDisabled = 'Game DVR を無効化しました'
        StoppingNonEssential = '不要なアプリを停止中...'
        NonEssentialStopped = '不要なアプリを停止しました'
        PrivacyHardening = 'プライバシー強化を適用中...'
        TelemetryDisabled = 'テレメトリーを無効化しました'
        CortanaDisabled = 'Cortana を無効化しました'
        ActivityHistoryDisabled = 'アクティビティ履歴を無効化しました'
        AdvertisingIDDisabled = '広告 ID を無効化しました'
        LocationDisabled = '位置情報追跡を無効化しました'
        DefenderOptimized = 'Defender を最適化しました'
        PrivacyDone = 'プライバシー強化が完了しました'
        StorageOptimized = 'ストレージを最適化しました'
        DiskHealth = 'ディスクの健全性'
        NetworkOptimized = 'ネットワークを最適化しました'
        DNSFlushed = 'DNS キャッシュをフラッシュしました'
        NetworkReset = 'ネットワークスタックをリセットしました。再起動が必要です'
        UpdatePaused = '更新を 7 日間一時停止しました'
        UpdateResumed = '更新を再開しました'
        ActiveHoursSet = 'アクティブ時間を 8:00 - 23:00 に設定しました'
        ContextMenuManager = 'コンテキストメニューマネージャー'
        HardwareMonitor = 'ハードウェアモニター（Ctrl+C で終了）'
        SystemInfoReport = 'システム情報レポート'
        OperatingSystem = 'オペレーティングシステム'
        Processor = 'プロセッサ'
        Memory = 'メモリ'
        Graphics = 'グラフィックス'
        Storage = 'ストレージ'
        Network = 'ネットワーク'
        Uptime = '稼働時間'
        AllCompleted = 'すべて完了'
    }
    'ko-KR' = @{
        Title = 'WinTune Pro v{0} - 시스템 최적화 스위트'
        AdminRequired = '이 스크립트에는 관리자 권한이 필요합니다. PowerShell 을 관리자 권한으로 실행해 주세요.'
        SelectOption = '작업을 선택하세요'
        PressEnter = 'Enter 키를 눌러 돌아가기'
        InvalidOption = '잘못된 옵션'
        ExitMsg = 'WinTune Pro 를 이용해 주셔서 감사합니다!'
        ProcessPerformance = '프로세스 및 성능'
        SystemCleanup = '시스템 정리'
        Optimization = '최적화'
        SecurityPrivacy = '보안 및 개인정보'
        MonitoringInfo = '모니터링 및 정보'
        Opt1 = '원클릭 게임 및 개발 환경 최적화'
        Opt2 = '사용자 정의 프로세스 우선순위 바인딩'
        Opt3 = '바인딩된 우선순위 보기'
        Opt4 = '우선순위 바인딩 제거'
        Opt5 = '프로세스 CPU 선호도 설정'
        Opt6 = '게임 집중 모드 활성화'
        Opt7 = '심층 시스템 정리'
        Opt8 = '스토리지 최적화 및 상태 확인'
        Opt9 = '시작 프로그램 관리'
        Opt10 = '고급 시스템 성능 튜닝'
        Opt11 = '네트워크 최적화 및 DNS'
        Opt12 = 'Windows 업데이트 관리'
        Opt13 = '개인정보 및 보안 강화'
        Opt14 = '컨텍스트 메뉴 관리자'
        Opt15 = '실시간 하드웨어 모니터'
        Opt16 = '시스템 정보 보고서'
        Opt17 = '작업 로그 보기'
        Exit = '종료'
        EnterProcessName = '프로세스 이름 입력 (예: notepad.exe)'
        EnterCpuPriority = 'CPU 우선순위 (Idle/BelowNormal/Normal/AboveNormal/High/Realtime)'
        EnterIoPriority = 'IO 우선순위 (Low/Normal/High/Critical, 기본값: High)'
        EnterToUnbind = '바인딩을 제거할 프로세스 이름 입력'
        EnterCores = '사용할 코어 입력 (쉼표로 구분, 예: 0,1,2,3)'
        ScanLargeFiles = '대용량 파일을 스캔할까요? (y/n)'
        MinSizeMB = '최소 크기 MB (기본값: 500)'
        SelectDNS = 'DNS 공급자 선택'
        ResetNetwork = 'Windows 네트워크 스택을 재설정할까요? (y/n)'
        EnterNumberRemove = '제거할 번호 입력 (또는 0 취소)'
        EnterToggle = '전환할 항목 번호 입력 (또는 0 취소)'
        LogInitialized = 'WinTune Pro 가 초기화되었습니다. 로그: {0}'
        NoLogFound = '로그 파일을 찾을 수 없습니다'
        OK = '[OK]'
        Done = '완료'
        RebootRecommended = '시스템 재시작 권장'
        CreatingRestorePoint = '시스템 복원 지점 생성 중...'
        RestorePointCreated = '시스템 복원 지점이 생성되었습니다'
        RestorePointFailed = '복원 지점 생성 실패'
        BackingUpRegistry = '레지스트리 백업 중...'
        RegistryBackedUp = '레지스트리가 백업되었습니다'
        OptimizingNTFS = 'NTFS 최적화 중...'
        NTFSOptimized = 'NTFS 최적화 완료'
        OptimizingTCP = 'TCP/IP 최적화 중...'
        TCPOptimized = 'TCP/IP 최적화 완료'
        OptimizingMultimedia = '멀티미디어 스케줄링 최적화 중...'
        MultimediaOptimized = '멀티미디어 스케줄링 최적화 완료'
        ConfiguringPower = '전원 계획 구성 중...'
        PowerConfigured = '전원 계획 구성 완료'
        DisablingHibernation = '최대 절전 모드 비활성화 중...'
        HibernationDisabled = '최대 절전 모드가 비활성화되었습니다'
        CleaningTemp = '임시 파일 정리 중...'
        TempCleaned = '임시 파일 정리 완료'
        RunningDiskCleanup = '디스크 정리 실행 중...'
        DiskCleanupDone = '디스크 정리 완료'
        CleaningWinSxS = '구성 요소 저장소(WinSxS) 정리 중...'
        WinSxSCleaned = '구성 요소 저장소 정리 완료'
        StoppingProcesses = '백그라운드 프로세스 중지 중...'
        ProcessStopped = '중지됨: {0}'
        DisablingServices = '서비스 비활성화 중...'
        ServiceDisabled = '서비스 {0} 비활성화됨'
        EnablingGameMode = '게임 모드 활성화 중...'
        GameModeEnabled = '게임 모드가 활성화되었습니다'
        DisablingGameDVR = 'Game DVR 비활성화 중...'
        GameDVRDisabled = 'Game DVR 이 비활성화되었습니다'
        StoppingNonEssential = '비필수 앱 중지 중...'
        NonEssentialStopped = '비필수 앱 중지 완료'
        PrivacyHardening = '개인정보 보호 강화 적용 중...'
        TelemetryDisabled = '원격 측정이 비활성화되었습니다'
        CortanaDisabled = 'Cortana 가 비활성화되었습니다'
        ActivityHistoryDisabled = '활동 기록이 비활성화되었습니다'
        AdvertisingIDDisabled = '광고 ID 가 비활성화되었습니다'
        LocationDisabled = '위치 추적이 비활성화되었습니다'
        DefenderOptimized = 'Defender 최적화 완료'
        PrivacyDone = '개인정보 보호 강화 완료'
        StorageOptimized = '스토리지 최적화 완료'
        DiskHealth = '디스크 상태'
        NetworkOptimized = '네트워크 최적화 완료'
        DNSFlushed = 'DNS 캐시가 플러시되었습니다'
        NetworkReset = '네트워크 스택이 재설정되었습니다. 재시작 필요'
        UpdatePaused = '업데이트가 7 일간 일시 중지되었습니다'
        UpdateResumed = '업데이트가 재개되었습니다'
        ActiveHoursSet = '활성 시간이 8:00 - 23:00 으로 설정되었습니다'
        ContextMenuManager = '컨텍스트 메뉴 관리자'
        HardwareMonitor = '하드웨어 모니터 (Ctrl+C 로 종료)'
        SystemInfoReport = '시스템 정보 보고서'
        OperatingSystem = '운영 체제'
        Processor = '프로세서'
        Memory = '메모리'
        Graphics = '그래픽'
        Storage = '스토리지'
        Network = '네트워크'
        Uptime = '가동 시간'
        AllCompleted = '모든 작업 완료'
    }
}

# Helper to get localized string
function Get-LString {
    param([string]$Key)
    $lang = $script:Lang
    if (-not $script:L.ContainsKey($lang)) { $lang = 'en-US' }
    if ($script:L[$lang].ContainsKey($Key)) { return $script:L[$lang][$Key] }
    if ($script:L['en-US'].ContainsKey($Key)) { return $script:L['en-US'][$Key] }
    return $Key
}

# ==================== Configuration & Globals ====================
$script:Version = "2.1.0"
$script:LogPath = "$env:TEMP\WinTune-Pro.log"
$script:BackupPath = "$env:TEMP\WinTune-Backups"
$script:ConfigPath = "$env:TEMP\WinTune-Config.json"

# Color scheme
$colors = @{
    Success = "Green"
    Info    = "Cyan"
    Warn    = "Yellow"
    Error   = "Red"
    Detail  = "DarkGray"
    Accent  = "Magenta"
}

# ==================== Logging & Utilities ====================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR","SUCCESS")][string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $script:LogPath -Value $logEntry -ErrorAction SilentlyContinue
    switch ($Level) {
        "SUCCESS" { Write-Host $Message -ForegroundColor $colors.Success }
        "WARN"    { Write-Host $Message -ForegroundColor $colors.Warn }
        "ERROR"   { Write-Host $Message -ForegroundColor $colors.Error }
        default   { Write-Host $Message -ForegroundColor $colors.Info }
    }
}

function Test-Admin {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).
        IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-SystemRestorePoint {
    param([string]$Description = "WinTune Pro Auto-Backup")
    Write-Log (Get-LString 'CreatingRestorePoint') "INFO"
    try {
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description $Description -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Log (Get-LString 'RestorePointCreated') "SUCCESS"
        return $true
    } catch {
        Write-Log (Get-LString 'RestorePointFailed') "WARN"
        return $false
    }
}

function Export-RegistryBackup {
    param([string]$KeyPath, [string]$Name)
    if (-not (Test-Path $script:BackupPath)) { New-Item -Path $script:BackupPath -ItemType Directory -Force | Out-Null }
    $file = Join-Path $script:BackupPath "$Name-$(Get-Date -Format 'yyyyMMdd-HHmmss').reg"
    reg export $KeyPath "$file" /y 2>&1 | Out-Null
    if (Test-Path $file) { Write-Log (Get-LString 'RegistryBackedUp') "SUCCESS" }
}

function Show-Header {
    param([string]$Title)
    Clear-Host
    $width = 60
    $pad = [math]::Max(0, ($width - $Title.Length) / 2)
    Write-Host "=".PadRight($width, "=") -ForegroundColor $colors.Accent
    Write-Host $Title.PadLeft($Title.Length + $pad).PadRight($width) -ForegroundColor $colors.Accent
    Write-Host "=".PadRight($width, "=") -ForegroundColor $colors.Accent
    Write-Host ""
}

function Pause-Return {
    Read-Host "`n$(Get-LString 'PressEnter')"
}

# ==================== Module 1: Process & Priority Management ====================

function Set-PermanentPriority {
    param(
        [Parameter(Mandatory=$true)][string]$ProcessName,
        [Parameter(Mandatory=$true)][ValidateSet("Idle","BelowNormal","Normal","AboveNormal","High","Realtime")][string]$CpuPriority,
        [ValidateSet("Low","Normal","High","Critical")][string]$IoPriority = "High",
        [ValidateSet("Default","Eco","Low","Medium","High")][string]$PowerThrottle = "Default"
    )
    $cpuMap = @{ "Idle"=1; "BelowNormal"=3; "Normal"=5; "AboveNormal"=6; "High"=8; "Realtime"=10 }
    $ioMap  = @{ "Low"=0; "Normal"=1; "High"=2; "Critical"=3 }
    $powerMap = @{ "Default"=0; "Eco"=1; "Low"=2; "Medium"=3; "High"=4 }
    $basePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
    $targetPath = Join-Path (Join-Path $basePath $ProcessName) "PerfOptions"

    if (-not (Test-Path (Split-Path $targetPath))) { New-Item -Path (Split-Path $targetPath) -Force | Out-Null }
    if (-not (Test-Path $targetPath)) { New-Item -Path $targetPath -Force | Out-Null }

    Set-ItemProperty -Path $targetPath -Name "CpuPriorityClass" -Value $cpuMap[$CpuPriority] -Type DWord
    Set-ItemProperty -Path $targetPath -Name "IoPriority" -Value $ioMap[$IoPriority] -Type DWord
    if ($PowerThrottle -ne "Default") {
        Set-ItemProperty -Path $targetPath -Name "PowerThrottlingOff" -Value $powerMap[$PowerThrottle] -Type DWord
    }
    Write-Log "$(Get-LString 'OK') $ProcessName -> CPU=$CpuPriority IO=$IoPriority Power=$PowerThrottle" "SUCCESS"
}

function Get-BoundPriorities {
    $basePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
    $cpuMap = @{ 1="Idle"; 3="BelowNormal"; 5="Normal"; 6="AboveNormal"; 8="High"; 10="Realtime" }
    $ioMap  = @{ 0="Low"; 1="Normal"; 2="High"; 3="Critical" }

    $results = Get-ChildItem $basePath -ErrorAction SilentlyContinue | Where-Object {
        Test-Path "$($_.PSPath)\PerfOptions"
    } | ForEach-Object {
        $props = Get-ItemProperty "$($_.PSPath)\PerfOptions" -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            ProcessName = $_.PSChildName
            CpuPriority = if ($props.CpuPriorityClass) { $cpuMap[[int]$props.CpuPriorityClass] } else { "-" }
            IoPriority  = if ($props.IoPriority) { $ioMap[[int]$props.IoPriority] } else { "-" }
            Path        = $_.PSPath
        }
    }
    if ($results) { $results | Format-Table -AutoSize } else { Write-Log (Get-LString 'NoLogFound') "WARN" }
}

function Remove-PriorityBinding {
    param([string]$ProcessName)
    $path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$ProcessName\PerfOptions"
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force
        Write-Log "$(Get-LString 'OK') $(Get-LString 'Done'): $ProcessName" "SUCCESS"
    } else {
        Write-Log "[!] $(Get-LString 'NoLogFound'): $ProcessName" "WARN"
    }
}

function Set-ProcessAffinity {
    param(
        [string]$ProcessName,
        [int[]]$Cores
    )
    $mask = 0
    foreach ($c in $Cores) { $mask = $mask -bor ([math]::Pow(2, $c)) }
    Get-Process $ProcessName -ErrorAction SilentlyContinue | ForEach-Object {
        $_.ProcessorAffinity = [IntPtr]::new([long]$mask)
        Write-Log "Affinity set for $($_.ProcessName) (PID: $($_.Id)) -> Cores: $($Cores -join ',')" "SUCCESS"
    }
}

function Optimize-GamingAndDev {
    Show-Header (Get-LString 'Opt1')
    New-SystemRestorePoint "Gaming-Dev Optimization"

    $bindings = @(
        @{Name="steam.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="EpicGamesLauncher.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="Battle.net.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="TapTap.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="GenshinImpact.exe"; Cpu="High"; Io="High"},
        @{Name="YuanShen.exe"; Cpu="High"; Io="High"},
        @{Name="HonkaiStarRail.exe"; Cpu="High"; Io="High"},
        @{Name="ZZZ.exe"; Cpu="High"; Io="High"},
        @{Name="chrome.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="msedge.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="firefox.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="brave.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="vivaldi.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="Code.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="devenv.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="MSBuild.exe"; Cpu="High"; Io="High"},
        @{Name="dotnet.exe"; Cpu="High"; Io="High"},
        @{Name="node.exe"; Cpu="High"; Io="High"},
        @{Name="npm.exe"; Cpu="High"; Io="High"},
        @{Name="python.exe"; Cpu="High"; Io="High"},
        @{Name="javaw.exe"; Cpu="High"; Io="High"},
        @{Name="cargo.exe"; Cpu="High"; Io="High"},
        @{Name="clang.exe"; Cpu="High"; Io="High"},
        @{Name="gcc.exe"; Cpu="High"; Io="High"},
        @{Name="go.exe"; Cpu="High"; Io="High"},
        @{Name="php.exe"; Cpu="High"; Io="High"},
        @{Name="git.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="docker.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="Weixin.exe"; Cpu="AboveNormal"; Io="Normal"},
        @{Name="wps.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="wallpaper64.exe"; Cpu="AboveNormal"; Io="High"},
        @{Name="obs64.exe"; Cpu="High"; Io="High"},
        @{Name="Streamlabs OBS.exe"; Cpu="High"; Io="High"}
    )

    foreach ($b in $bindings) {
        Set-PermanentPriority -ProcessName $b.Name -CpuPriority $b.Cpu -IoPriority $b.Io
    }
    Write-Log "`n$(Get-LString 'AllCompleted'). $(Get-LString 'RebootRecommended')" "SUCCESS"
}

# ==================== Module 2: System Cleanup & Maintenance ====================

function Clear-SystemJunk {
    Show-Header (Get-LString 'Opt7')
    New-SystemRestorePoint "System Cleanup"

    Write-Log (Get-LString 'StoppingProcesses') "INFO"
    $processes = @(
        "ArmouryCrate.UserSessionHelper","ArmourySocketServer","ArmourySwAgent",
        "wpscloudsvr","HipsDaemon","HipsTray","OfficeClickToRun",
        "SearchProtocolHost","SearchIndexer","OneDrive",
        "YourPhone","PhoneExperienceHost",
        "MicrosoftEdgeUpdate","GoogleUpdate",
        "AdobeARM","AdobeGCClient",
        "RtkAudUService64","NahimicService"
    )
    foreach ($p in $processes) {
        Get-Process $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        if ($?) { Write-Log "  $(Get-LString 'ProcessStopped' -f $p)" "SUCCESS" }
    }

    Write-Log (Get-LString 'DisablingServices') "INFO"
    $services = @(
        @{Name="WSearch"; Startup="Disabled"},
        @{Name="ClickToRunSvc"; Startup="Disabled"},
        @{Name="DiagTrack"; Startup="Disabled"},
        @{Name="dmwappushservice"; Startup="Disabled"},
        @{Name="MapsBroker"; Startup="Disabled"},
        @{Name="WMPNetworkSvc"; Startup="Disabled"},
        @{Name="XblAuthManager"; Startup="Disabled"},
        @{Name="XblGameSave"; Startup="Disabled"},
        @{Name="XboxNetApiSvc"; Startup="Disabled"},
        @{Name="PhoneSvc"; Startup="Disabled"},
        @{Name="Fax"; Startup="Disabled"},
        @{Name="WbioSrvc"; Startup="Disabled"},
        @{Name="icssvc"; Startup="Manual"},
        @{Name="TabletInputService"; Startup="Manual"}
    )
    foreach ($s in $services) {
        $svc = Get-Service $s.Name -ErrorAction SilentlyContinue
        if ($svc) {
            Stop-Service $s.Name -Force -ErrorAction SilentlyContinue
            Set-Service $s.Name -StartupType $s.Startup -ErrorAction SilentlyContinue
            Write-Log "  $(Get-LString 'ServiceDisabled' -f $s.Name)" "SUCCESS"
        }
    }

    Write-Log (Get-LString 'CleaningTemp') "INFO"
    $tempPaths = @(
        $env:TEMP,
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch",
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\ThumbCacheToDelete",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
    )
    foreach ($tp in $tempPaths) {
        if (Test-Path $tp) {
            Get-ChildItem $tp -Recurse -Force -ErrorAction SilentlyContinue |
                Where-Object { -not $_.PSIsContainer } |
                Remove-Item -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Log (Get-LString 'TempCleaned') "SUCCESS"

    Write-Log (Get-LString 'RunningDiskCleanup') "INFO"
    $cleanMgr = @{
        "Active Setup Temp Folders" = 2; "BranchCache" = 2; "Downloaded Program Files" = 2
        "Internet Cache Files" = 2; "Memory Dump Files" = 2; "Old ChkDsk Files" = 2
        "Previous Installations" = 2; "Recycle Bin" = 2; "Service Pack Cleanup" = 2
        "Setup Log Files" = 2; "System error memory dump files" = 2
        "System error minidump files" = 2; "Temporary Files" = 2
        "Temporary Setup Files" = 2; "Thumbnail Cache" = 2; "Update Cleanup" = 2
        "Windows Error Reporting Archive Files" = 2
        "Windows Error Reporting Queue Files" = 2
        "Windows Error Reporting System Archive Files" = 2
        "Windows Error Reporting System Queue Files" = 2
        "Windows Upgrade Log Files" = 2
    }
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    foreach ($item in $cleanMgr.GetEnumerator()) {
        $path = Join-Path $regPath $item.Key
        if (Test-Path $path) {
            Set-ItemProperty -Path $path -Name "StateFlags0001" -Value $item.Value -Type DWord -ErrorAction SilentlyContinue
        }
    }
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden
    Write-Log (Get-LString 'DiskCleanupDone') "SUCCESS"

    Write-Log (Get-LString 'CleaningWinSxS') "INFO"
    dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase 2>&1 | Out-Null
    Write-Log (Get-LString 'WinSxSCleaned') "SUCCESS"

    Write-Log "`n$(Get-LString 'AllCompleted'). $(Get-LString 'RebootRecommended')" "SUCCESS"
}

# ==================== Module 3: Advanced System Optimization ====================

function Optimize-SystemPerformance {
    Show-Header (Get-LString 'Opt10')
    New-SystemRestorePoint "System Performance Optimization"
    Export-RegistryBackup "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCP-Backup"
    Export-RegistryBackup "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "Multimedia-Backup"

    Write-Log (Get-LString 'OptimizingNTFS') "INFO"
    fsutil behavior set disablelastaccess 1 | Out-Null
    fsutil behavior set disable8dot3 1 | Out-Null
    fsutil behavior set memoryusage 2 | Out-Null
    fsutil behavior set encryptpagingfile 0 | Out-Null
    Write-Log (Get-LString 'NTFSOptimized') "SUCCESS"

    Write-Log (Get-LString 'OptimizingTCP') "INFO"
    netsh int tcp set global autotuninglevel=experimental | Out-Null
    netsh int tcp set global rss=enabled | Out-Null
    netsh int tcp set global congestionprovider=ctcp | Out-Null
    netsh int tcp set global ecncapability=enabled | Out-Null
    netsh int tcp set global timestamps=disabled | Out-Null
    netsh int tcp set global initialrto=2000 | Out-Null
    netsh int tcp set global rsc=enabled | Out-Null
    netsh int tcp set global maxcoalescedelay=10 | Out-Null

    $tcpParams = "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    reg add $tcpParams /v TcpNoDelay /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TcpAckFrequency /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TCPDelAckTicks /t REG_DWORD /d 0 /f | Out-Null
    reg add $tcpParams /v DefaultTTL /t REG_DWORD /d 64 /f | Out-Null
    reg add $tcpParams /v MaxUserPort /t REG_DWORD /d 65534 /f | Out-Null
    reg add $tcpParams /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f | Out-Null
    reg add $tcpParams /v SackOpts /t REG_DWORD /d 1 /f | Out-Null
    reg add $tcpParams /v TcpWindowSize /t REG_DWORD /d 64240 /f | Out-Null
    Write-Log (Get-LString 'TCPOptimized') "SUCCESS"

    Write-Log (Get-LString 'OptimizingMultimedia') "INFO"
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f | Out-Null
    Write-Log (Get-LString 'MultimediaOptimized') "SUCCESS"

    Write-Log "Optimizing Memory Management..." "INFO"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IOPageLockLimit /t REG_DWORD /d 983040 /f | Out-Null
    Write-Log "Memory management optimized" "SUCCESS"

    Write-Log (Get-LString 'ConfiguringPower') "INFO"
    $ult = powercfg /list | Select-String "Ultimate Performance|卓越性能|究極のパフォーマンス|최고의 성능"
    if (-not $ult) {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        Write-Log "  Ultimate Performance unlocked" "SUCCESS"
        $ult = powercfg /list | Select-String "Ultimate Performance|卓越性能|究極のパフォーマンス|최고의 성능"
    }
    if ($ult -and $ult.Line -match '([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})') {
        powercfg /setactive $Matches[1] | Out-Null
        powercfg -setacvalueindex $Matches[1] SUB_PROCESSOR PROCTHROTTLEMIN 100 | Out-Null
        powercfg -setacvalueindex $Matches[1] SUB_PROCESSOR PROCTHROTTLEMAX 100 | Out-Null
        powercfg -setacvalueindex $Matches[1] SUB_DISK DISKIDLE 0 | Out-Null
        powercfg -setacvalueindex $Matches[1] SUB_SLEEP STANDBYIDLE 0 | Out-Null
        powercfg -setacvalueindex $Matches[1] SUB_SLEEP HIBERNATEIDLE 0 | Out-Null
        powercfg /setactive $Matches[1] | Out-Null
        Write-Log (Get-LString 'PowerConfigured') "SUCCESS"
    }

    Write-Log (Get-LString 'DisablingHibernation') "INFO"
    powercfg /hibernate off | Out-Null
    Write-Log (Get-LString 'HibernationDisabled') "SUCCESS"

    Write-Log "`n$(Get-LString 'AllCompleted'). $(Get-LString 'RebootRecommended')" "SUCCESS"
}

# ==================== Module 4: Privacy & Security Hardening ====================

function Harden-Privacy {
    Show-Header (Get-LString 'Opt13')
    New-SystemRestorePoint "Privacy Hardening"

    Write-Log (Get-LString 'PrivacyHardening') "INFO"

    Write-Log "Disabling Telemetry..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
    Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
    Set-Service dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Log (Get-LString 'TelemetryDisabled') "SUCCESS"

    Write-Log "Disabling Cortana..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f | Out-Null
    Write-Log (Get-LString 'CortanaDisabled') "SUCCESS"

    Write-Log "Disabling Activity History..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f | Out-Null
    Write-Log (Get-LString 'ActivityHistoryDisabled') "SUCCESS"

    Write-Log "Disabling Advertising ID..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f | Out-Null
    Write-Log (Get-LString 'AdvertisingIDDisabled') "SUCCESS"

    Write-Log "Disabling Location Tracking..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableWindowsLocationProvider /t REG_DWORD /d 1 /f | Out-Null
    Write-Log (Get-LString 'LocationDisabled') "SUCCESS"

    Write-Log "Optimizing Windows Defender..." "INFO"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpyNetReporting /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f | Out-Null
    Write-Log (Get-LString 'DefenderOptimized') "SUCCESS"

    Write-Log "`n$(Get-LString 'PrivacyDone')" "SUCCESS"
}

# ==================== Module 5: Storage Optimization ====================

function Optimize-Storage {
    Show-Header (Get-LString 'Opt8')

    Write-Log "Running SSD TRIM..." "INFO"
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Write-Log (Get-LString 'StorageOptimized') "SUCCESS"

    Write-Log (Get-LString 'DiskHealth') "INFO"
    Get-PhysicalDisk | ForEach-Object {
        $health = Get-StorageReliabilityCounter -PhysicalDisk $_ -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            DeviceId = $_.DeviceId
            FriendlyName = $_.FriendlyName
            MediaType = $_.MediaType
            HealthStatus = $_.HealthStatus
            SizeGB = [math]::Round($_.Size / 1GB, 2)
            Temperature = if ($health) { $health.Temperature } else { "N/A" }
            Wear = if ($health) { $health.Wear } else { "N/A" }
        }
    } | Format-Table -AutoSize

    $scan = Read-Host (Get-LString 'ScanLargeFiles')
    if ($scan -eq "y") {
        $size = Read-Host (Get-LString 'MinSizeMB')
        if (-not $size) { $size = 500 }
        $minBytes = [int]$size * 1MB
        Write-Log "Scanning for files larger than ${size}MB on C:\..." "INFO"
        Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue -Force |
            Where-Object { $_.Length -gt $minBytes } |
            Select-Object FullName, @{N="SizeMB";E={[math]::Round($_.Length / 1MB, 2)}} |
            Sort-Object SizeMB -Descending |
            Select-Object -First 20 |
            Format-Table -AutoSize
    }
}

# ==================== Module 6: Network Optimization ====================

function Optimize-Network {
    Show-Header (Get-LString 'Opt11')

    Write-Log "Configuring DNS..." "INFO"
    $dnsOptions = @(
        "Cloudflare (1.1.1.1 / 1.0.0.1)",
        "Google (8.8.8.8 / 8.8.4.4)",
        "Quad9 (9.9.9.9 / 149.112.112.112)",
        "AliDNS (223.5.5.5 / 223.6.6.6)",
        "Custom"
    )
    for ($i = 0; $i -lt $dnsOptions.Count; $i++) {
        Write-Host "  $($i+1). $($dnsOptions[$i])" -ForegroundColor $colors.Detail
    }
    $dnsChoice = Read-Host "`n$(Get-LString 'SelectDNS')"
    $dnsServers = switch ($dnsChoice) {
        1 { @("1.1.1.1","1.0.0.1") }
        2 { @("8.8.8.8","8.8.4.4") }
        3 { @("9.9.9.9","149.112.112.112") }
        4 { @("223.5.5.5","223.6.6.6") }
        5 { @(Read-Host "Primary DNS"; Read-Host "Secondary DNS") }
        default { @("1.1.1.1","1.0.0.1") }
    }

    $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.HardwareInterface -eq $true } | Select-Object -First 1
    if ($adapter) {
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $dnsServers
        Write-Log "DNS set on $($adapter.Name) -> $($dnsServers -join ', ')" "SUCCESS"
    }

    Write-Log "Flushing DNS cache..." "INFO"
    Clear-DnsClientCache
    ipconfig /flushdns | Out-Null
    Write-Log (Get-LString 'DNSFlushed') "SUCCESS"

    $reset = Read-Host (Get-LString 'ResetNetwork')
    if ($reset -eq "y") {
        Write-Log "Resetting network stack..." "INFO"
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        Write-Log (Get-LString 'NetworkReset') "SUCCESS"
    }
}

# ==================== Module 7: Hardware Monitoring ====================

function Show-HardwareMonitor {
    Show-Header (Get-LString 'Opt15')

    $ohwmPath = "C:\Program Files\OpenHardwareMonitor\OpenHardwareMonitorLib.dll"
    $hasSensors = $false
    if (Test-Path $ohwmPath) {
        try {
            Add-Type -Path $ohwmPath -ErrorAction SilentlyContinue
            $computer = New-Object OpenHardwareMonitor.Hardware.Computer
            $computer.CPUEnabled = $true
            $computer.GPUEnabled = $true
            $computer.RAMEnabled = $true
            $computer.HDDEnabled = $true
            $computer.Open()
            $hasSensors = $true
        } catch { }
    }

    try {
        while ($true) {
            $cpu = Get-Counter "\Processor(_Total)\% Processor Time" -ErrorAction SilentlyContinue
            $mem = Get-Counter "\Memory\Available MBytes" -ErrorAction SilentlyContinue
            $disk = Get-Counter "\PhysicalDisk(_Total)\% Disk Time" -ErrorAction SilentlyContinue
            $net = Get-Counter "\Network Interface(*)\Bytes Total/sec" -ErrorAction SilentlyContinue

            $totalMem = (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1MB
            $availMem = $mem.CounterSamples[0].CookedValue
            $usedMem = $totalMem - $availMem
            $memPercent = [math]::Round(($usedMem / $totalMem) * 100, 1)

            Clear-Host
            Write-Host "=== $(Get-LString 'HardwareMonitor') ===" -ForegroundColor $colors.Accent
            Write-Host "CPU: $([math]::Round($cpu.CounterSamples[0].CookedValue, 1))%" -ForegroundColor $(if ($cpu.CounterSamples[0].CookedValue -gt 80) { $colors.Error } else { $colors.Success })
            Write-Host "MEM: $([math]::Round($usedMem, 0)) / $([math]::Round($totalMem, 0)) MB ($memPercent%)" -ForegroundColor $(if ($memPercent -gt 85) { $colors.Error } else { $colors.Success })
            Write-Host "DISK: $([math]::Round($disk.CounterSamples[0].CookedValue, 1))%" -ForegroundColor $colors.Info

            if ($net.CounterSamples) {
                $netTotal = ($net.CounterSamples | Measure-Object CookedValue -Sum).Sum
                Write-Host "NET: $([math]::Round($netTotal * 8 / 1MB, 2)) Mbps" -ForegroundColor $colors.Info
            }

            Write-Host "`n--- Top CPU ---" -ForegroundColor $colors.Accent
            Get-Process | Sort-Object CPU -Descending | Select-Object -First 8 | ForEach-Object {
                $cpuUsage = if ($_.CPU) { [math]::Round($_.CPU, 1) } else { 0 }
                $memUsage = [math]::Round($_.WorkingSet64 / 1MB, 0)
                Write-Host "$($_.ProcessName.PadRight(20)) CPU:${cpuUsage}  MEM:${memUsage}MB" -ForegroundColor $colors.Detail
            }

            if ($hasSensors) {
                Write-Host "`n--- Sensors ---" -ForegroundColor $colors.Accent
                foreach ($hw in $computer.Hardware) {
                    $hw.Update()
                    foreach ($sensor in $hw.Sensors) {
                        if ($sensor.SensorType -eq "Temperature" -and $sensor.Value) {
                            $color = if ($sensor.Value -gt 80) { $colors.Error } elseif ($sensor.Value -gt 65) { $colors.Warn } else { $colors.Success }
                            Write-Host "$($hw.Name) - $($sensor.Name): $($sensor.Value) C" -ForegroundColor $color
                        }
                    }
                }
            }

            Write-Host "`n$(Get-LString 'PressEnter') / Ctrl+C" -ForegroundColor $colors.Detail
            Start-Sleep -Seconds 2
        }
    } finally {
        if ($hasSensors -and $computer) { $computer.Close() }
    }
}

# ==================== Module 8: Startup Management ====================

function Manage-StartupItems {
    Show-Header (Get-LString 'Opt9')

    $startupPaths = @(
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
    )

    $items = @()
    foreach ($path in $startupPaths) {
        if (Test-Path $path) {
            Get-ItemProperty $path -ErrorAction SilentlyContinue | Get-Member -MemberType NoteProperty |
                Where-Object { $_.Name -notmatch "^(PSPath|PSParentPath|PSChildName|PSDrive|PSProvider)$" } |
                ForEach-Object {
                    $val = (Get-ItemProperty $path -Name $_.Name -ErrorAction SilentlyContinue).$($_.Name)
                    $items += [PSCustomObject]@{
                        Name = $_.Name
                        Command = $val
                        Location = $path
                    }
                }
        }
    }

    Get-ScheduledTask | Where-Object { $_.Triggers -and ($_.Triggers | Where-Object { $_.TriggerType -eq "Logon" -or $_.TriggerType -eq "Boot" }) } |
        ForEach-Object {
            $items += [PSCustomObject]@{
                Name = $_.TaskName
                Command = ($_.Actions | Select-Object -First 1).Execute
                Location = "Task Scheduler"
            }
        }

    Write-Host "Startup Items:" -ForegroundColor $colors.Accent
    $items | ForEach-Object -Begin { $i = 1 } {
        Write-Host "  $i. $($_.Name)" -ForegroundColor $colors.Info
        Write-Host "     -> $($_.Command)" -ForegroundColor $colors.Detail
        $i++
    }

    $remove = Read-Host "`n$(Get-LString 'EnterNumberRemove')"
    if ($remove -gt 0 -and $remove -le $items.Count) {
        $target = $items[$remove - 1]
        if ($target.Location -eq "Task Scheduler") {
            Disable-ScheduledTask -TaskName $target.Name -Confirm:$false | Out-Null
        } else {
            Remove-ItemProperty -Path $target.Location -Name $target.Name -Force
        }
        Write-Log "Removed: $($target.Name)" "SUCCESS"
    }
}

# ==================== Module 9: Game Mode ====================

function Enable-GameMode {
    Show-Header (Get-LString 'Opt6')
    New-SystemRestorePoint "Game Mode"

    Write-Log (Get-LString 'EnablingGameMode') "INFO"
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f | Out-Null
    Write-Log (Get-LString 'GameModeEnabled') "SUCCESS"

    Write-Log (Get-LString 'DisablingGameDVR') "INFO"
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f | Out-Null
    Write-Log (Get-LString 'GameDVRDisabled') "SUCCESS"

    Write-Log "Configuring fullscreen optimizations..." "INFO"
    reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKCU\SYSTEM\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f | Out-Null
    Write-Log "Fullscreen optimizations configured" "SUCCESS"

    Write-Log (Get-LString 'StoppingNonEssential') "INFO"
    $nonEssential = @("OneDrive","Teams","Slack","Discord","Telegram","Spotify","Steam")
    foreach ($proc in $nonEssential) {
        Get-Process $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Write-Log (Get-LString 'NonEssentialStopped') "SUCCESS"

    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
    Write-Log "High performance power plan activated" "SUCCESS"

    Write-Log "`n$(Get-LString 'AllCompleted')!" "SUCCESS"
}

# ==================== Module 10: System Information ====================

function Show-SystemInfo {
    Show-Header (Get-LString 'Opt16')

    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host (Get-LString 'OperatingSystem') -ForegroundColor $colors.Accent
    Write-Host "  Name:        $($os.Caption)" -ForegroundColor $colors.Info
    Write-Host "  Version:     $($os.Version)" -ForegroundColor $colors.Info
    Write-Host "  Build:       $([System.Environment]::OSVersion.Version.Build)" -ForegroundColor $colors.Info
    Write-Host "  Arch:        $($os.OSArchitecture)" -ForegroundColor $colors.Info

    $cpu = Get-CimInstance Win32_Processor
    Write-Host "`n$(Get-LString 'Processor')" -ForegroundColor $colors.Accent
    Write-Host "  Model:       $($cpu.Name)" -ForegroundColor $colors.Info
    Write-Host "  Cores:       $($cpu.NumberOfCores)" -ForegroundColor $colors.Info
    Write-Host "  Threads:     $($cpu.NumberOfLogicalProcessors)" -ForegroundColor $colors.Info
    Write-Host "  Base Clock:  $([math]::Round($cpu.MaxClockSpeed / 1000, 2)) GHz" -ForegroundColor $colors.Info

    $ram = Get-CimInstance Win32_PhysicalMemory
    $totalRam = ($ram | Measure-Object Capacity -Sum).Sum / 1GB
    Write-Host "`n$(Get-LString 'Memory')" -ForegroundColor $colors.Accent
    Write-Host "  Total:       $([math]::Round($totalRam, 2)) GB" -ForegroundColor $colors.Info
    Write-Host "  Modules:     $($ram.Count)" -ForegroundColor $colors.Info
    $ram | ForEach-Object {
        Write-Host "  Slot:        $([math]::Round($_.Capacity / 1GB, 2)) GB @ $($_.Speed) MHz" -ForegroundColor $colors.Detail
    }

    $gpu = Get-CimInstance Win32_VideoController
    Write-Host "`n$(Get-LString 'Graphics')" -ForegroundColor $colors.Accent
    $gpu | ForEach-Object {
        Write-Host "  Adapter:     $($_.Name)" -ForegroundColor $colors.Info
        Write-Host "  VRAM:        $([math]::Round($_.AdapterRAM / 1GB, 2)) GB" -ForegroundColor $colors.Info
        Write-Host "  Resolution:  $($_.CurrentHorizontalResolution) x $($_.CurrentVerticalResolution)" -ForegroundColor $colors.Info
    }

    $disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    Write-Host "`n$(Get-LString 'Storage')" -ForegroundColor $colors.Accent
    $disks | ForEach-Object {
        $free = [math]::Round($_.FreeSpace / 1GB, 2)
        $total = [math]::Round($_.Size / 1GB, 2)
        $used = $total - $free
        $pct = [math]::Round(($used / $total) * 100, 1)
        $color = if ($pct -gt 90) { $colors.Error } elseif ($pct -gt 75) { $colors.Warn } else { $colors.Success }
        Write-Host "  $($_.DeviceID)         ${used}GB / ${total}GB (${pct}%)" -ForegroundColor $color
    }

    $netAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    Write-Host "`n$(Get-LString 'Network')" -ForegroundColor $colors.Accent
    $netAdapters | ForEach-Object {
        $ip = Get-NetIPAddress -InterfaceIndex $_.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
        Write-Host "  $($_.Name): $($_.InterfaceDescription)" -ForegroundColor $colors.Info
        Write-Host "  MAC: $($_.MacAddress)  IP: $($ip.IPAddress)" -ForegroundColor $colors.Detail
    }

    $uptime = (Get-Date) - $os.LastBootUpTime
    Write-Host "`n$(Get-LString 'Uptime'): $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m" -ForegroundColor $colors.Accent
}

# ==================== Module 11: Windows Update Management ====================

function Manage-WindowsUpdate {
    Show-Header (Get-LString 'Opt12')

    Write-Host "1. Check for updates" -ForegroundColor $colors.Info
    Write-Host "2. Install pending updates" -ForegroundColor $colors.Info
    Write-Host "3. Pause updates for 7 days" -ForegroundColor $colors.Info
    Write-Host "4. Resume updates" -ForegroundColor $colors.Info
    Write-Host "5. Set active hours (8:00 - 23:00)" -ForegroundColor $colors.Info

    $choice = Read-Host "`n$(Get-LString 'SelectOption')"
    switch ($choice) {
        "1" {
            Write-Log "Checking for updates..." "INFO"
            Install-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue | Out-Null
            Get-WUList | Format-Table -AutoSize
        }
        "2" {
            Write-Log "Installing updates..." "INFO"
            Get-WUInstall -AcceptAll -AutoReboot -ErrorAction SilentlyContinue
        }
        "3" {
            reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d ((Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ssZ")) /f | Out-Null
            Write-Log (Get-LString 'UpdatePaused') "SUCCESS"
        }
        "4" {
            reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /f | Out-Null
            Write-Log (Get-LString 'UpdateResumed') "SUCCESS"
        }
        "5" {
            reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursStart /t REG_DWORD /d 8 /f | Out-Null
            reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v ActiveHoursEnd /t REG_DWORD /d 23 /f | Out-Null
            Write-Log (Get-LString 'ActiveHoursSet') "SUCCESS"
        }
    }
}

# ==================== Module 12: Context Menu Manager ====================

function Manage-ContextMenu {
    Show-Header (Get-LString 'Opt14')

    $menuItems = @(
        @{Name="Open with VS Code"; Key="VSCode"; Path="HKCR\*\shell\VSCode"; Command='"C:\Program Files\Microsoft VS Code\Code.exe" "%1"'},
        @{Name="Open PowerShell here"; Key="PowerShell"; Path="HKCR\Directory\shell\PowerShell"; Command="powershell.exe -noexit -command Set-Location -literalPath '%L'"},
        @{Name="Copy as Path"; Key="CopyPath"; Path="HKCR\*\shell\copypath"; Command="cmd /c echo %1 | clip"}
    )

    Write-Host "Context Menu Items:" -ForegroundColor $colors.Accent
    for ($i = 0; $i -lt $menuItems.Count; $i++) {
        $exists = Test-Path $menuItems[$i].Path
        $status = if ($exists) { "[INSTALLED]" } else { "[NOT INSTALLED]" }
        Write-Host "  $($i+1). $($menuItems[$i].Name) $status" -ForegroundColor $colors.Info
    }

    $choice = Read-Host "`n$(Get-LString 'EnterToggle')"
    if ($choice -gt 0 -and $choice -le $menuItems.Count) {
        $item = $menuItems[$choice - 1]
        if (Test-Path $item.Path) {
            Remove-Item -Path $item.Path -Recurse -Force
            Write-Log "Removed: $($item.Name)" "SUCCESS"
        } else {
            New-Item -Path $item.Path -Force | Out-Null
            New-Item -Path "$($item.Path)\command" -Force | Out-Null
            Set-ItemProperty -Path "$($item.Path)\command" -Name "(Default)" -Value $item.Command
            Write-Log "Added: $($item.Name)" "SUCCESS"
        }
    }
}

# ==================== Main Menu ====================

function Show-MainMenu {
    while ($true) {
        Show-Header (Get-LString 'Title' -f $script:Version)

        Write-Host "  [$(Get-LString 'ProcessPerformance')]" -ForegroundColor $colors.Accent
        Write-Host "  1.  $(Get-LString 'Opt1')" -ForegroundColor $colors.Info
        Write-Host "  2.  $(Get-LString 'Opt2')" -ForegroundColor $colors.Info
        Write-Host "  3.  $(Get-LString 'Opt3')" -ForegroundColor $colors.Info
        Write-Host "  4.  $(Get-LString 'Opt4')" -ForegroundColor $colors.Info
        Write-Host "  5.  $(Get-LString 'Opt5')" -ForegroundColor $colors.Info
        Write-Host "  6.  $(Get-LString 'Opt6')" -ForegroundColor $colors.Info
        Write-Host ""
        Write-Host "  [$(Get-LString 'SystemCleanup')]" -ForegroundColor $colors.Accent
        Write-Host "  7.  $(Get-LString 'Opt7')" -ForegroundColor $colors.Info
        Write-Host "  8.  $(Get-LString 'Opt8')" -ForegroundColor $colors.Info
        Write-Host "  9.  $(Get-LString 'Opt9')" -ForegroundColor $colors.Info
        Write-Host ""
        Write-Host "  [$(Get-LString 'Optimization')]" -ForegroundColor $colors.Accent
        Write-Host " 10.  $(Get-LString 'Opt10')" -ForegroundColor $colors.Info
        Write-Host " 11.  $(Get-LString 'Opt11')" -ForegroundColor $colors.Info
        Write-Host " 12.  $(Get-LString 'Opt12')" -ForegroundColor $colors.Info
        Write-Host ""
        Write-Host "  [$(Get-LString 'SecurityPrivacy')]" -ForegroundColor $colors.Accent
        Write-Host " 13.  $(Get-LString 'Opt13')" -ForegroundColor $colors.Info
        Write-Host " 14.  $(Get-LString 'Opt14')" -ForegroundColor $colors.Info
        Write-Host ""
        Write-Host "  [$(Get-LString 'MonitoringInfo')]" -ForegroundColor $colors.Accent
        Write-Host " 15.  $(Get-LString 'Opt15')" -ForegroundColor $colors.Info
        Write-Host " 16.  $(Get-LString 'Opt16')" -ForegroundColor $colors.Info
        Write-Host " 17.  $(Get-LString 'Opt17')" -ForegroundColor $colors.Info
        Write-Host ""
        Write-Host "  0.  $(Get-LString 'Exit')" -ForegroundColor $colors.Warn

        $choice = Read-Host "`n$(Get-LString 'SelectOption')"
        switch ($choice) {
            "1" { Optimize-GamingAndDev; Pause-Return }
            "2" {
                $exe = Read-Host (Get-LString 'EnterProcessName')
                $cpu = Read-Host (Get-LString 'EnterCpuPriority')
                $io = Read-Host (Get-LString 'EnterIoPriority')
                if (-not $io) { $io = "High" }
                Set-PermanentPriority -ProcessName $exe -CpuPriority $cpu -IoPriority $io
                Pause-Return
            }
            "3" { Get-BoundPriorities; Pause-Return }
            "4" {
                $exe = Read-Host (Get-LString 'EnterToUnbind')
                Remove-PriorityBinding -ProcessName $exe
                Pause-Return
            }
            "5" {
                $exe = Read-Host (Get-LString 'EnterProcessName')
                $cores = (Read-Host (Get-LString 'EnterCores')).Split(",") | ForEach-Object { [int]$_ }
                Set-ProcessAffinity -ProcessName $exe -Cores $cores
                Pause-Return
            }
            "6" { Enable-GameMode; Pause-Return }
            "7" { Clear-SystemJunk; Pause-Return }
            "8" { Optimize-Storage; Pause-Return }
            "9" { Manage-StartupItems; Pause-Return }
            "10" { Optimize-SystemPerformance; Pause-Return }
            "11" { Optimize-Network; Pause-Return }
            "12" { Manage-WindowsUpdate; Pause-Return }
            "13" { Harden-Privacy; Pause-Return }
            "14" { Manage-ContextMenu; Pause-Return }
            "15" { Show-HardwareMonitor }
            "16" { Show-SystemInfo; Pause-Return }
            "17" {
                if (Test-Path $script:LogPath) { Get-Content $script:LogPath -Tail 50 | ForEach-Object { Write-Host $_ } }
                else { Write-Log (Get-LString 'NoLogFound') "WARN" }
                Pause-Return
            }
            "0" {
                Write-Log (Get-LString 'ExitMsg') "SUCCESS"
                exit
            }
            default { Write-Log (Get-LString 'InvalidOption') "WARN"; Start-Sleep -Seconds 1 }
        }
    }
}

# ==================== Initialization ====================

if (-not (Test-Admin)) {
    Write-Host (Get-LString 'AdminRequired') -ForegroundColor $colors.Error
    exit 1
}

"WinTune Pro v$script:Version [$script:Lang] - Started at $(Get-Date)" | Out-File $script:LogPath -Force
Write-Log (Get-LString 'LogInitialized' -f $script:LogPath) "SUCCESS"

Show-MainMenu
