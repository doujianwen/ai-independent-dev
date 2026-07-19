# 纠察组启动器 — 自动化脚本
# 用途：在指定阶段自动触发纠察组审查流程

param(
    [Parameter(Mandatory=True)]
    [ValidateSet('phase0', 'phase1', 'phase2', 'phase3')]
    [string],

    [Parameter(Mandatory=False)]
    [int] = 2,

    [Parameter(Mandatory=False)]
    [string] = ''
)

Continue = 'Stop'
 = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path
 = Join-Path  'logs'
 = Join-Path  'templates\review-log-template.md'
 = Join-Path  ('checklists/' +  + '-review-checklist.md')
 = Get-Date -Format 'yyyy-MM-dd'

Write-Host "=== AI 独立开发实战课 — 纠察组启动器 ===" -ForegroundColor Cyan
Write-Host ""

# 验证检查清单是否存在
if (-not (Test-Path )) {
    Write-Host "错误: 找不到检查清单 " -ForegroundColor Red
    exit 1
}
Write-Host "[OK] 检查清单已就绪: " -ForegroundColor Green

# 为每个纠察组成员创建日志文件
for ( = 1;  -le ; ++) {
     = Join-Path  "--cor-.log"
    
    # 复制模板并填充变量
     = Get-Content  -Raw -Encoding UTF8
     =  -replace '\{\{PHASE\}\}', (( -replace 'phase','').PadLeft(2,'0'))
     =  -replace '\{\{MEMBER_ID\}\}', ("COR-")
     =  -replace '\{\{DATE\}\}', 
     =  -replace '\{\{TIMESTAMP\}\}', (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    
    if () {
         =  -replace '\{\{SCENARIO\}\}', 
    } else {
         =  -replace '\{\{SCENARIO\}\}', '(待填写)'
    }

    Set-Content -Path  -Value  -Encoding UTF8
    Write-Host "[OK] 纠察组 COR- 日志已创建: " -ForegroundColor Green
}

Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 每个纠察组成员独立填写日志文件" -ForegroundColor White
Write-Host "  2. 汇总所有纠察组的结论" -ForegroundColor White
Write-Host "  3. 根据汇总结果决定: 通过 / 有条件通过 / 堵死" -ForegroundColor White
