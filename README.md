<p align="center">
<img alt="Discord" src="https://img.shields.io/discord/769953234965889026?label=Pessoas%20no%20Discord&style=plastic">
</p>

<p align="center">
  <a href="http://youtube.com/linuxtips?sub_confirmation=1">
    <img alt="YouTube Channel Subscribers" src="https://img.shields.io/youtube/channel/subscribers/UCJnKVGmXRXrH49Tvrx5X0Sw?style=social">
  </a>
  <a href="http://youtube.com/linuxtips?sub_confirmation=1">
    <img alt="YouTube Channel Views" src="https://img.shields.io/youtube/channel/views/UCJnKVGmXRXrH49Tvrx5X0Sw?style=social">
  </a>
  <a href="http://twitch.tv/linuxtips?sub_confirmation=1">
    <img alt="Twitch Status" src="https://img.shields.io/twitch/status/linuxtips?style=social">
  </a>
  <a href="http://github.com/badtuxx">
    <img alt="GitHub followers" src="https://img.shields.io/github/followers/badtuxx?style=social">
  </a>
  <a href="http://twitter.com/badtux_">
    <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/badtux_?style=social">
  </a>
  <a href="http://twitter.com/linuxtipsbr">
    <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/LINUXtipsBR?style=social">
  </a>
</p>

<p align="center">
  <a href="https://hub.docker.com/r/linuxtips/alertmanager_alpine">
    <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/linuxtips/alertmanager_alpine?label=alertmanager_alpine%20image%20pulls&style=plastic">
  </a>
  <a href="https://hub.docker.com/r/linuxtips/prometheus_alpine">
    <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/linuxtips/prometheus_alpine?label=prometheus_alpine%20image%20pulls&style=plastic">
  </a>
  <a href="https://hub.docker.com/r/linuxtips/node-exporter_alpine">
    <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/linuxtips/node-exporter_alpine?label=node-exporter_alpine%20image%20pulls&style=plastic">
  </a>
</p>

<p align="center">
  <a href="https://github.com/badtuxx/DescomplicandoKubernetes">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/descomplicandokubernetes?label=Descomplicando%20Kubernetes&style=social">
  </a>
  <a href="https://github.com/badtuxx/descomplicandoDocker">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/descomplicandoDocker?label=Descomplicando%20Docker&style=social">
  </a>
  <a href="https://github.com/badtuxx/descomplicandoPrometheus">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/descomplicandoPrometheus?label=Descomplicando%20Prometheus&style=social">
  </a>
  <a href="https://github.com/badtuxx/CertifiedContainersExpert">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/CertifiedContainersExpert?label=CertifiedContainersExpert&style=social">
  </a>
  <a href="https://github.com/badtuxx/DescomplicandoGit">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/DescomplicandoGit?label=Descomplicando%20Git&style=social">
  </a>
  <a href="https://github.com/badtuxx/DescomplicandoArgoCD">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/DescomplicandoArgoCD?label=Descomplicando%20ArgoCD&style=social">
  </a>
  <a href="https://github.com/badtuxx/Giropops-Monitoring">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/Giropops-Monitoring?label=Giropops%20Monitoring&style=social">
  </a>
  <a href="https://github.com/badtuxx/DescomplicandoHelm">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/DescomplicandoHelm?label=Descomplicando%20Helm&style=social">
  </a>
                <a href="https://github.com/badtuxx/convencendo-seu-chefe">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/badtuxx/convencendo-seu-chefe?label=convencendo-seu-chefe&style=social">
</p>

# Giropops Senhas

Esse repositório foi criado com as maravilhosas pessoas que estavam no chat da live da LINUXtips na Twitch.


## DEMO

Como ter a stack completa de componentes da nossa solução em 5 minutos.

[![asciicast](https://asciinema.org/a/j1rIYp1VxWMV9P4dTaJtpm0Ei.svg)](https://asciinema.org/a/j1rIYp1VxWMV9P4dTaJtpm0Ei)

&nbsp;

## Descrição do projeto

O objetivo do projeto é ter um ambiente completo para que as pessoas possam estudar os seguintes tópicos:

- Micro-serviços
- Observabilidade
- Kubernetes
- GitOps
- Infra-As-Code
- Platform Engineering
- DevOps
- Desenvolvimento

## Instalando o projeto

### Componentes Utilizados

- Docker
- Kind
- ArgoCD
- Giropops-Senha
- Locust
- Python
- Flask
- Prometheus
- Grafana
- AlertManager
- MetalLB
- Istio
- Kiali
- Chaos Mesh
- Kubernetes-Dashboard

#### Como estamos usando os componentes

Estamos utilizando o **Docker** para que seja possível criar um cluster **Kubernetes** utilizando o **Kind**. Teremos um cluster **Kubernetes** com 03 nodes, sendo um control plane e dois workers.
Estamos utilizando o **ArgoCD** para que seja possível utilizar **GitOps** para realizar o deploy de nossas aplicações.
Até o momento, temos os seguintes serviços:

- **Giropops-Senhas** que é uma app escrita em **Python**, onde temos uma API criada em Flask para que seja possível gerar senhas customizadas
- **Redis** para que possa armazenar as senhas geradas temporariamente

Estamos usando o **Locust** para simular carga em nossos serviços.

Estamos utilizando o **MetalLB** para que seja possível expor nossos serviços para o mundo externo, sendo uma alternativa para criação de LoadBalancer no **Kubernetes**.

Temos o **Istio** para que seja possível realizar o **Service Mesh** em nossos serviços e o **Kiali** para visualizar o tráfego entre os serviços.

E para realizar os testes de caos e assim testar a resiliencia de nossa infra e de nossa apps, estamos utilizando o sensacional Chaos Mesh. Ele é um operator e possui uma excelente UI para que possamos criar e visualizar como estão os nossos chaos tests.

Para que seja possível visualizar todos os detalhes sobre o nosso cluster, estamos utilizando o **Kubernetes Dashboard**.

Após a instalação de todos os componentes, é necessário gerar um token para ter acesso ao dashboard. Para isso, basta executar o seguinte comando:

```bash
make dashboard-token
```

### Instalando

Para fazer a instalação de todos os componentes, basta clonar esse repositório e utilizar o comando make para realizar o deploy de tudo.

```bash
git clone https://github.com/badtuxx/giropops-senhas.git
```

&nbsp;
Agora acesse o seguinte diretório:

```bash
cd giropops-senhas
```

&nbsp;

Agora basta utilizar o make para que ela faça o deploy de tudo, desde a criação do cluster até o deploy das nossas apps utilizando o ArgoCD.

```bash
make all
```
&nbsp;

Pronto, tudo instalado!

Você pode instalar componentes separadamente, por exemplo:

```bash
make kind
```

&nbsp;

Após a instalação de todos os componentes, é necessário gerar um token para ter acesso ao dashboard. Para isso, basta executar o seguinte comando:

```bash
make dashboard-token
```

&nbsp;

Para limpar e remover tudo o que instalamos:

```bash
make clean
```
&nbsp;

Pronto!
Lembrese, estamos ainda no começo do projeto, muito mais componentes serão adicionados.

&nbsp;

## Rodar projeto giropops-senhas localhost

1. Instalar dependências

`pip install -r requirements.txt`

Recomendado:\
Rodar projeto com virtualenv `virtualenv venv`\
Iniciar ambiente `source venv/bin/activate`

`pip install -r requirements.txt`

se não tiver instalado, instalar com pip `pipx install virtualenv`

2. Iniciar Redis local

`docker container run --name redis -p 6379:6379 -v redis:/data -d redis`\
`export REDIS_HOST=127.0.0.1`

Se deseja rodar com Dockerfile, faça export para nome do container.\
`export REDIS_HOST=redis`

3. Rodar projeto

`export FLASK_DEBUG=1`\
`flask run`

4. Compilar CSS, necessário apenas se realizar mudanças de classes ou no arquivo static/css/styles.css

Com NodeJS instalado, rodar:\
`npx tailwindcss -i ./static/css/styles.css -o ./static/css/output.css`

Para rodar no modo watch, caso esteja realizando mudanças de estilização\
`npx tailwindcss -i ./static/css/styles.css -o ./static/css/output.css --watch`

