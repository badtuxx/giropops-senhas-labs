# Giropops Senhas

Esse repositório foi criado com as maravilhosas pessoas que estavam no chat da live da LINUXtips na Twitch.

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

#### Como estamos usando os componentes

Estamos utilizando o Docker para que seja possível criar um cluster Kubernetes utilizando o Kind. Teremos um cluster Kubernetes com 03 nodes, sendo um control plane e dois workers.
Estamos utilizando o ArgoCD para que seja possível utilizar GitOps para realizar o deploy de nossas aplicações.
Até o momento, temos os seguintes serviços:

- Giropops-Senhas que é uma app escrita em Python, onde temos uma API criada em Flask para que seja possível gerar senhas customizadas
- Redis para que possa armazenar as senhas geradas temporariamente

Estamos usando o Locust para simular carga em nossos serviços.

### Instalando

<<<**ADICIONAR AQUI O VIDEO DE INSTALAÇÃO**>>>

Para fazer a instalação de todos os componentes, basta clonar esse repositório e utilizar o comando make para realizar o deploy de tudo.

```bash
git clone https://github.com/badtuxx/giropops-senhas.git
```

Agora acesse o seguinte diretório:

```bash
cd giropops-senhas
```

Agora basta utilizar o make para que ela faça o deploy de tudo, desde a criação do cluster até o deploy das nossas apps utilizando o ArgoCD.

```bash
make all
```

Pronto, tudo instalado!

Você pode instalar componentes separadamente, por exemplo:

```bash
make kind
```

Para limpar e remover tudo o que instalamos:

```bash
make clean
```

Pronto!
Lembrese, estamos ainda no começo do projeto, muito mais componentes serão adicionados.


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

