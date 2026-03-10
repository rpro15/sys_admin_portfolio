# Демо-видео (2-3 минуты)

## Ссылка (YouTube, unlisted)

- URL: `https://www.youtube.com/watch?v=YOUR_UNLISTED_VIDEO_ID`

## Сценарий записи

1. `wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/sys_admin_portfolio && export WINRM_PASSWORD="YOUR_PASSWORD" && ansible-playbook -i ansible/inventory.ini ansible/site.yml -e "ansible_password=$WINRM_PASSWORD"'`
2. Проверка пользователей в ADUC (из `examples/users.csv`)
3. Вход тестовым пользователем и доступ к папке
4. Проверка backup (`wbadmin get versions`)

## Чек-лист качества

- 1080p
- Читаемый терминал
- Замаскированы пароли и внутренние IP
