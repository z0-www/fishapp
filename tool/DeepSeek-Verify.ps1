# 鱼者文游 V0.4.8 · 本地 DeepSeek 真实请求验证
# 只在本机显示遮蔽输入框；密钥只通过标准输入交给 dart 子进程，
# 发送目标固定为 https://api.deepseek.com，不写入文件、日志或聊天。
# 兼容 Windows PowerShell 5.1（双击 .cmd 即可运行）。
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$reportPath = Join-Path $root 'reports\v048_api_result.json'
$script:running = $false
$script:paidUsed = $false

function Resolve-DartPath {
  $cmd = Get-Command dart -ErrorAction SilentlyContinue
  if (-not $cmd) {
    throw '找不到 dart。请确认 Flutter SDK 的 bin 目录在 PATH 中。'
  }
  $path = $cmd.Source
  if ($path -like '*.bat') {
    $exe = Join-Path (Split-Path $path) 'cache\dart-sdk\bin\dart.exe'
    if (Test-Path -LiteralPath $exe) { return $exe }
  }
  return $path
}

try {
  $script:dartPath = Resolve-DartPath
} catch {
  [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, '鱼者文游') | Out-Null
  exit 1
}

$form = New-Object -TypeName System.Windows.Forms.Form
$form.Text = '鱼者文游 V0.4.8 · DeepSeek 真实请求验证'
$form.ClientSize = New-Object -TypeName System.Drawing.Size -ArgumentList 640, 520
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.TopMost = $true
$form.Font = New-Object -TypeName System.Drawing.Font -ArgumentList 'Microsoft YaHei UI', 9

$title = New-Object -TypeName System.Windows.Forms.Label
$title.Text = '真实 DeepSeek 请求验证（本机）'
$title.Font = New-Object -TypeName System.Drawing.Font -ArgumentList 'Microsoft YaHei UI', 13, ([System.Drawing.FontStyle]::Bold)
$title.SetBounds(14, 12, 610, 28)

$info = New-Object -TypeName System.Windows.Forms.Label
$info.Text = "密钥只用于本机向 https://api.deepseek.com 发起请求：不保存、不打印、不写入报告。`r`n若你的 Key 曾出现在聊天、文件或日志中，请先到官方平台删除它，再使用新 Key。`r`n报告只保留脱敏状态、模型名、Token 用量和正文预览。"
$info.SetBounds(14, 44, 610, 64)

$keyLabel = New-Object -TypeName System.Windows.Forms.Label
$keyLabel.Text = 'API Key（遮蔽显示）'
$keyLabel.SetBounds(14, 112, 300, 20)

$txtKey = New-Object -TypeName System.Windows.Forms.TextBox
$txtKey.UseSystemPasswordChar = $true
$txtKey.SetBounds(14, 134, 610, 26)
$txtKey.MaxLength = 512

$chkConsent = New-Object -TypeName System.Windows.Forms.CheckBox
$chkConsent.Text = '我同意本次最多 1 次付费请求（流式 JSON，输出上限 200 Token，约 USD 0.0002）'
$chkConsent.SetBounds(14, 170, 610, 24)

$btnFree = New-Object -TypeName System.Windows.Forms.Button
$btnFree.Text = '仅验证 Key 与模型（免费）'
$btnFree.SetBounds(14, 202, 220, 32)

$btnPaid = New-Object -TypeName System.Windows.Forms.Button
$btnPaid.Text = '同意并发送 1 次最小请求'
$btnPaid.SetBounds(242, 202, 240, 32)

$btnClose = New-Object -TypeName System.Windows.Forms.Button
$btnClose.Text = '关闭'
$btnClose.SetBounds(504, 202, 120, 32)

$lblStatus = New-Object -TypeName System.Windows.Forms.Label
$lblStatus.Text = '等待输入。'
$lblStatus.SetBounds(14, 244, 610, 20)

$resultLabel = New-Object -TypeName System.Windows.Forms.Label
$resultLabel.Text = '脱敏结果'
$resultLabel.SetBounds(14, 268, 300, 20)

$txtResult = New-Object -TypeName System.Windows.Forms.TextBox
$txtResult.Multiline = $true
$txtResult.ReadOnly = $true
$txtResult.ScrollBars = 'Vertical'
$txtResult.SetBounds(14, 290, 610, 216)
$txtResult.Font = New-Object -TypeName System.Drawing.Font -ArgumentList 'Consolas', 9

$form.Controls.AddRange(@($title, $info, $keyLabel, $txtKey, $chkConsent, $btnFree, $btnPaid, $btnClose, $lblStatus, $resultLabel, $txtResult))

function Format-Report {
  $lines = @()
  if (-not (Test-Path -LiteralPath $reportPath)) {
    $lines += '未生成报告文件。'
    return $lines
  }
  $r = Get-Content -LiteralPath $reportPath -Raw -Encoding UTF8 | ConvertFrom-Json
  $lines += "结果：$($r.result)"
  if ($null -ne $r.httpStatus) { $lines += "HTTP：$($r.httpStatus)" }
  if ($r.model) { $lines += "模型：$($r.model)" }
  if ($r.mode -eq 'models' -and $r.models) { $lines += "可用模型：$($r.models -join '、')" }
  if ($r.usage) {
    $parts = @()
    foreach ($name in 'prompt_tokens', 'completion_tokens', 'prompt_cache_hit_tokens', 'prompt_cache_miss_tokens', 'total_tokens') {
      $value = $r.usage.$name
      if ($null -ne $value) { $parts += "$name=$value" }
    }
    if ($parts.Count -gt 0) { $lines += 'Token 用量：' + ($parts -join '，') }
  }
  if ($null -ne $r.jsonValid) { $lines += "JSON 结构有效：$($r.jsonValid)" }
  if ($null -ne $r.elapsedMs) { $lines += "耗时：$($r.elapsedMs) ms" }
  if ($r.error) { $lines += "错误：$($r.error)" }
  if ($r.textPreview) {
    $lines += ''
    $lines += '正文预览：'
    $lines += $r.textPreview
  }
  return $lines
}

function Invoke-DeepSeekVerify([string]$mode, [bool]$paid) {
  if ($script:running) { return }
  $key = $txtKey.Text.Trim()
  if ($key -notmatch '^[\x21-\x7E]{8,512}$') {
    [System.Windows.Forms.MessageBox]::Show('请粘贴 8–512 位、不含空格的 API Key。', $form.Text) | Out-Null
    return
  }
  if ($paid -and -not $chkConsent.Checked) {
    [System.Windows.Forms.MessageBox]::Show('请先勾选费用同意。付费模式每次只发送 1 次最小请求。', $form.Text) | Out-Null
    return
  }
  if ($paid -and $script:paidUsed) {
    [System.Windows.Forms.MessageBox]::Show('本次窗口已发送过付费请求。请关闭窗口后重新打开，再显式同意一次。', $form.Text) | Out-Null
    return
  }
  $txtKey.Clear()
  $script:running = $true
  $btnFree.Enabled = $false
  $btnPaid.Enabled = $false
  $btnClose.Enabled = $false
  $lblStatus.Text = '正在连接 api.deepseek.com …'
  [System.Windows.Forms.Application]::DoEvents()
  if (Test-Path -LiteralPath $reportPath) { Remove-Item -LiteralPath $reportPath -Force }
  try {
    $dartArgs = @('run', 'tool/deepseek_verify.dart', "--$mode")
    if ($paid) { $dartArgs += '--confirm-cost' }
    $dartArgs += @('--yes', "--report=$reportPath")
    $psi = New-Object -TypeName System.Diagnostics.ProcessStartInfo
    $psi.FileName = $script:dartPath
    $psi.WorkingDirectory = $root
    $psi.Arguments = (($dartArgs | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' ')
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $proc.StandardInput.WriteLine($key)
    $proc.StandardInput.Close()
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $errTask = $proc.StandardError.ReadToEndAsync()
    if (-not $proc.WaitForExit(180000)) {
      try { $proc.Kill() } catch { }
      $lblStatus.Text = '请求超时（180 秒）。'
    }
    $out = $outTask.Result
    $err = $errTask.Result
    $key = $null
    if ($paid) {
      $script:paidUsed = $true
      $chkConsent.Checked = $false
    }
    $lines = Format-Report
    if ($out -and $out.Trim()) {
      $lines += ''
      $lines += '工具输出：'
      $lines += $out.Trim()
    }
    if ($err -and $err.Trim()) {
      $lines += ''
      $lines += '错误输出：'
      $lines += $err.Trim()
    }
    $txtResult.Text = ($lines -join "`r`n")
    if ($txtResult.Text -match '结果：success') {
      $lblStatus.Text = '完成：已收到真实响应。'
    } else {
      $lblStatus.Text = '完成：未通过，请查看下方脱敏结果。'
    }
    $shown = (($lines | Select-Object -First 16) -join "`r`n")
    [System.Windows.Forms.MessageBox]::Show($shown, '验证结果', 'OK', 'Information') | Out-Null
  } catch {
    $lblStatus.Text = '执行失败。'
    [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, '执行失败', 'OK', 'Error') | Out-Null
  } finally {
    $script:running = $false
    $btnFree.Enabled = $true
    $btnPaid.Enabled = $true
    $btnClose.Enabled = $true
  }
}

$btnFree.Add_Click({ Invoke-DeepSeekVerify 'models' $false })
$btnPaid.Add_Click({ Invoke-DeepSeekVerify 'stream' $true })
$btnClose.Add_Click({ $form.Close() })
$form.AcceptButton = $btnFree
$form.Add_Shown({ $txtKey.Focus() })

[void]$form.ShowDialog()
