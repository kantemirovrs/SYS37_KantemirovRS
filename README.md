# Дипломная работа по профессии «Системный администратор». Группа SYS-37. Кантемиров Роман
#
# Инфраструктура.
#
![a10.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a10.png)
#
# Сайт:
#
# Созданы два веб-серера с nginx без внешних интерфейсов: 1. web_a  в зоне ru-central1-a 2. web_b в зоне ru-central1-b:
![a11.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a11.png)
#
# Создана Target Group, в неё включены web_a и web_b:
![a12.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a12.png)
#
# Создан Application load balancer для распределения трафика на веб-сервера web_a и web_b: 
![a13.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a13.png)
#
# Создан HTTP-router:
![a14.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a14.png)
#
# Тест сайт curl -v <публичный IP балансера>:80 (158.160.177.147:80):
![a15.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a15.png)
#
![a16.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/a16.png)
#
# Мониторинг:
#
# Создана ВМ 89.169.152.121, на ней развёрнут Zabbix. На сервера web_a и web_b установлены Zabbix Agent-ы, агенты отправляют метрики в Zabbix-сервер:
![b11.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/b11.png)
#
![b12.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/b12.png)
#
# Настроены дешборды с отображением метрик:
![b13.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/b13.png)
#
# Логи:
#
# Cоздана ВМ, на ней развернут Elasticsearch:
![c11.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/c11.png)
#
![c12.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/c12.png)
#
# Cоздана ВМ, на ней развернута Kibana:
![c13.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/c13.png)
#
# Запущены и настроены filebeat:
![c14.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/c14.png)
# 
# Запущены и настроены filebeat:
![c15.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/c15.png)
#
# Сеть:
#
# Развёрнута сеть develop-fops-24-01. В ней две подсети: develop-fops-24-01-ru-central1-a и develop-fops-24-01-ru-central1-b:
![d11.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d11.png)
#
# Созданы группы безопасности:
![d12.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d12.png)
#
# Создана ВМ bastion с публичным адресом, в которой будет открыт только один порт — ssh:
![d13.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d13.png)
![d14.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d14.png)
#
# Реализована концепция "bastion host" - "Jump host":
![d15.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d15.png)
#
#Исходящий доступ в интернет для ВМ внутреннего контура через NAT-шлюз:
![d16.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/d16.png)
#
# Резервное копирование:
#
# Создан шедулер на создание snapshot дисков всех ВМ:
![e11.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/e11.png)
#
![e12.png](https://github.com/kantemirovrs/SYS37_KantemirovRS/blob/main/img/e12.png)
