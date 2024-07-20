# Desativa o compartilhamento protegido por senha
function Disable-PasswordProtectedSharing {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "restrictnullsessaccess" -Value 0
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "AllowInsecureGuestAuth" -Value 1
    Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True
}

# Agenda a tarefa para desativar o compartilhamento protegido por senha a cada 5 minutos
function Create-ScheduledTask {
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\caminho\para\seu\script\SetupTask.ps1"'
    $trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -RepeatIndefinitely -At (Get-Date).Date
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -TaskName "DisablePasswordProtectedSharingTask" -Action $action -Trigger $trigger -Settings $settings -Principal $principal
}

# Executa a função para desativar o compartilhamento protegido por senha
Disable-PasswordProtectedSharing

# Cria a tarefa agendada
Create-ScheduledTask
