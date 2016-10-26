# workstation

O projeto se divide em um script (`setup.sh`) e um serviço (`workstation`).

### `setup.sh`
Script que facilita o setup inicial para distribuições do Ubuntu. Instala automaticamente o Docker com docker-compose e, opcionalmente, PhpStorm e NetBeans.

### `workstation`
Disponível para `upstart` e `systemd`, o serviço permite a inicialização de dois containers úteis do Docker:
- `proxy`: baseado na imagem do projeto [jwilder/nginx-proxy](http://github.com/jwilder/nginx-proxy), este container escuta portas `80` de outros containers que sobem com a variável de ambiente `VIRTUAL_HOST` e automaticamente faz um proxy do host do sistema para o container usando o nginx.
- `phpmyadmin`: facilita o gerenciamento de projetos que usam MySQL através do phpMyAdmin, centralizando diferentes hosts de containers em uma mesma instalação do phpMyAdmin.
