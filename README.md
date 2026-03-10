# Sys Admin Portfolio (Home-Lab)

![GitHub last commit](https://img.shields.io/github/last-commit/rpro15/sys_admin_portfolio?style=flat)
![GitHub repo size](https://img.shields.io/github/repo-size/rpro15/sys_admin_portfolio?style=flat)
![GitHub top language](https://img.shields.io/github/languages/top/rpro15/sys_admin_portfolio?style=flat)

Практический проект по системному администрированию (Home-Lab).

## Оглавление

- [Коротко о проекте](#коротко-о-проекте)
- [Что демонстрирует проект](#что-демонстрирует-проект)
- [Схема сети](#схема-сети)
- [Технологии](#технологии)
- [Что я настроил и устранил лично](#что-я-настроил-и-устранил-лично)
- [Быстрая проверка репозитория за 5 минут](#быстрая-проверка-репозитория-за-5-минут)
- [Структура репозитория](#структура-репозитория)
- [Запуск и проверка стенда](#запуск-и-проверка-стенда)
- [Скриншоты](#скриншоты)
- [Демо-видео](#демо-видео)
- [Важно](#важно)

## Коротко о проекте

Домашний стенд с сегментацией сети (VLAN 10/20), доменом Active Directory, DNS/DHCP, автоматизацией через PowerShell и Ansible, а также сценарием резервного копирования и тестового восстановления.

## Что демонстрирует проект

- Развертывание и администрирование AD DS, DNS, DHCP.
- Массовое создание пользователей и настройку домашних папок с правами NTFS.
- Автоматизацию рутинных задач через Ansible и PowerShell.
- Базовые сетевые навыки: VLAN, DHCP scopes, экспорт конфигов оборудования.
- Практику backup/restore и оформление эксплуатационной документации.

## Схема сети

- Исходник: `docs/home-lab-network.drawio`
- Экспорт для README: `docs/home-lab-network.png`

## Технологии

- Windows Server 2019/2022 (AD DS, DNS, DHCP, Windows Server Backup)
- PowerShell 5.1+
- Ansible (WinRM)
- MikroTik RouterOS
- D-Link CLI
- Git / GitHub

## Что я настроил и устранил лично

- Поднял доменную инфраструктуру и структуру OU (`Corp`, `OfficeUsers`, `Servers`).
- Автоматизировал онбординг пользователей из CSV (`AD-CreateUsers.ps1`) с домашними папками и ACL.
- Настроил DHCP scopes для VLAN10/VLAN20 и базовую GPO для рабочих станций.
- Подготовил конфиги сети для MikroTik и D-Link с разделением трафика по VLAN.
- Настроил nightly backup файлового сервера и проверил сценарий тестового восстановления.
- Оформил рабочие артефакты: шаблон тикета, выездной отчет, сценарий демонстрации.

## Быстрая проверка репозитория за 5 минут

1. Откройте `README.md` и `docs/home-lab-network.drawio` для понимания архитектуры стенда.
2. Просмотрите `AD-CreateUsers.ps1` и `examples/users.csv` (массовое создание пользователей + home folders + ACL).
3. Просмотрите `ansible/site.yml` и `ansible/inventory.ini` (автоматизация ролей AD/DNS/DHCP, OU/GPO).
4. Просмотрите `network/mikrotik-export.rsc` и `network/dlink-cli-dump.txt` (VLAN 10/20 и DHCP scopes).
5. Просмотрите `backup/Backup-FileServer.ps1` и `backup/test-restore-report.md` (backup/restore-практика и evidence).

## Структура репозитория

- `AD-CreateUsers.ps1` - массовое создание учетных записей AD из CSV.
- `examples/users.csv` - пример входных данных.
- `ansible/site.yml` и `ansible/inventory.ini` - плейбук и инвентарь.
- `network/` - экспорт конфигов MikroTik и CLI-дамп D-Link.
- `backup/` - скрипт бэкапа, план задачи, шаблон отчета по restore.
- `docs/` - шаблон тикета, пример выездного отчета, схема сети.
- `demo/` - сценарий демо-видео (2-3 минуты).
- `run-ansible.ps1` - запуск Ansible через WSL одной командой из PowerShell.
- `certificates/` - опционально: сканы сертификатов.

## Запуск и проверка стенда

1. Запустить playbook через WSL без хранения пароля в файле:
	`wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/sys_admin_portfolio && export WINRM_PASSWORD="YOUR_PASSWORD" && ansible-playbook -i ansible/inventory.ini ansible/site.yml -e "ansible_password=$WINRM_PASSWORD"'`.
	Упрощенный вариант одной командой из PowerShell:
	`./run-ansible.ps1 -Action playbook -PromptPassword -VerboseOutput`.
2. Показать пользователей, созданных из `examples/users.csv`.
3. Показать доступ тестового пользователя к домашней/общей папке.
4. Коротко показать результат backup (`wbadmin get versions`).

## Скриншоты

- `docs/screenshots/01-ansible-playbook-run.png`
- `docs/screenshots/02-ad-users-created.png`
- `docs/screenshots/03-shared-folder-access.png`

![Запуск Ansible playbook](docs/screenshots/01-ansible-playbook-run.png)
![Созданные пользователи AD](docs/screenshots/02-ad-users-created.png)
![Доступ к общей папке](docs/screenshots/03-shared-folder-access.png)

## Демо-видео

- YouTube (unlisted): ссылка хранится в `demo/README.md`

## Важно

- Не публикуйте реальные пароли и внутренние чувствительные данные.
- Перед публикацией замените плейсхолдеры на значения вашего стенда.