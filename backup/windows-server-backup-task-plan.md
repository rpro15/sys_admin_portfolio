# План задачи Windows Server Backup

## Цель

Ежедневный backup файлового сервера в 01:00 через `backup/Backup-FileServer.ps1`.

## Параметры задачи

- Имя: `FileServer-Nightly-Backup`
- Учетная запись: `CORP\\svc_backup`
- Триггер: ежедневно, 01:00
- Команда: `powershell.exe`
- Аргументы: `-ExecutionPolicy Bypass -File C:\\Scripts\\Backup-FileServer.ps1`
- Повтор при ошибке: каждые 15 минут, до 3 попыток

## Контроль выполнения

- Код последнего запуска: `0x0`
- Есть новая версия в `wbadmin get versions`
- Обновился `backup-log.txt`
- Тест restore выполнен и задокументирован
