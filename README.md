# WinOpt-Toolbox

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207.x-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

> **Windows 原生深度优化工具箱**
>
> 全部调用 Windows 内置 API / 命令，零第三方依赖，一行命令远程执行，不落硬盘。

这不是网上抄来抄去的"清理垃圾/加速球"套路。这里收集的是**只有老系统管理员才知道的冷门调参**——从 NTFS 内核缓存、TCP 拥塞控制算法、多媒体调度器到进程优先级绑定，全部走微软原生接口。

---

## 一行命令执行（内存执行，不下载）

管理员 PowerShell 终端粘贴：

```powershell
$ProgressPreference='SilentlyContinue'; irm https://raw.githubusercontent.com/你的用户名/WinOpt-Toolbox/main/WinOpt.ps1 | iex
```

> `irm ... | iex` = 下载到内存直接解释执行，**不保存本地文件**，不污染系统。

---

## 功能模块

| 模块 | 说明 | 风险 |
|:---|:---|:---:|
| **进程优先级绑定** | 通过 `Image File Execution Options` 永久指定程序的 CPU / IO 优先级，重启后依然生效 | 🟢 安全 |
| **一键游戏编译优化** | 自动绑定 Steam、VS Code、Node、Python、浏览器、编译器等常见软件 | 🟢 安全 |
| **后台清理** | 停止 SearchIndexer、OneDrive、WPS 云服务等无用进程，禁用对应服务 | 🟡 注意 |
| **系统安全优化** | NTFS 内核缓存 / TCP CTCP 拥塞控制 / Nagle&ACK 优化 / 多媒体调度 / 卓越性能电源计划 | 🟢 安全 |
| **实时进程监控** | 类 Linux `top` 实时刷新，按 CPU 占用排序 | 🟢 安全 |

---

## 详细功能原理

### 1. 进程优先级绑定（Image File Execution Options）

Windows 从 NT 3.1 就支持的机制，但 99% 的用户不知道。在注册表 `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\程序名\PerfOptions` 下写入 `CpuPriorityClass` 和 `IoPriority`，**系统调度器在创建进程时自动应用**，不需要后台常驻工具。

- `CpuPriorityClass`: 1(Idle) ~ 10(Realtime)
- `IoPriority`: 0(Low) ~ 3(Critical)

### 2. NTFS 文件系统层优化

| 命令 | 作用 |
|:---|:---|
| `fsutil behavior set disablelastaccess 1` | 禁用"最后访问时间"更新，遍历大目录时减少磁盘 IO |
| `fsutil behavior set disable8dot3 1` | 禁用 DOS 短文件名生成，大目录响应更快 |
| `fsutil behavior set memoryusage 2` | 扩大 NTFS 内核缓存池（lookaside list），频繁文件操作减少内核态等待 |
| `fsutil behavior set mftzone 2` | 预留 400MB MFT 区域，减少主文件表碎片化 |

### 3. TCP/IP 网络栈优化

| 命令 | 作用 |
|:---|:---|
| `netsh int tcp set global congestionprovider=ctcp` | 切换为 Compound TCP，高带宽延迟网络更激进 |
| `netsh int tcp set global autotuninglevel=experimental` | 窗口缩放开到最大 |
| `TcpNoDelay = 1` | 禁用 Nagle 算法，降低交互延迟 |
| `TcpAckFrequency = 1` | 立即 ACK，不再延迟 200ms 凑批量 |

### 4. 多媒体调度器

`SystemResponsiveness` 默认保留 20% CPU 给多媒体播放，改为 10%，让更多 CPU 给前台游戏/程序。

### 5. 卓越性能电源计划

微软隐藏的电源方案，比"高性能"更激进：禁用核心停车（Core Parking）、最小化 C-State、睿频零延迟响应。

---

## 仓库结构

```
WinOpt-Toolbox/
├── WinOpt.ps1              # 主脚本（交互式菜单）
├── WinOpt-Silent.ps1       # 静默版（适合自动化/嵌入）
├── restore.ps1             # 一键还原所有改动
├── docs/
│   ├── PRIORITY.md         # 优先级绑定技术详解
│   ├── NTFS.md             # 文件系统优化原理
│   └── NETWORK.md          # TCP/IP 调参手册
└── README.md
```

---

## 安全与还原

**执行前自动备份**：
- BCD 启动配置 → `WinOpt_Backup_时间\bcd_backup.bcd`
- 注册表 PriorityControl → `PriorityControl.reg`
- 注册表 Tcpip\Parameters → `TcpipParameters.reg`

**一键还原**：
```powershell
irm https://raw.githubusercontent.com/你的用户名/WinOpt-Toolbox/main/restore.ps1 | iex
```

---

## 系统要求

- Windows 10 1607+ / Windows 11
- PowerShell 5.1 或 PowerShell 7.x
- 管理员权限（脚本头部 `#Requires -RunAsAdministrator`）

---

## 免责声明

本仓库脚本仅用于学习 Windows 系统底层机制与 API 调用。  
修改系统配置存在风险，请自行承担。建议先在虚拟机测试。  
作者不对任何因使用本脚本导致的系统问题负责。

---

## 相关阅读

- [Microsoft Docs: Image File Execution Options](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/gflags-overview)
- [Microsoft Docs: SetSystemFileCacheSize](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-setsystemfilecachesize)
- [Microsoft Docs: Windows Filtering Platform](https://learn.microsoft.com/en-us/windows/win32/fwp/windows-filtering-platform-start-page)
