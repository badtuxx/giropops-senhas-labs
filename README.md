# Giropops Senhas

Esse repositório foi criado com as maravilhosas pessoas que estavam no chat da live da LINUXtips na Twitch.

## Descrição do projeto

O projeto em Python com Flask tem como objetivo gerar senhas seguras e aleatórias para uso em diversas situações, incluindo acesso a contas online e sistemas de segurança. Com base em algoritmos de criptografia confiáveis, a aplicação utiliza técnicas de geração de senhas aleatórias para garantir que as senhas criadas sejam difíceis de serem adivinhadas ou descobertas por hackers. Além disso, o projeto tem uma interface simples e amigável para o usuário, permitindo que as senhas sejam geradas com facilidade e rapidez. A utilização do Flask permite que a aplicação seja escalável e customizável de acordo com as necessidades do usuário

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

### Tech Stack

- Python
- Flask
- Redis
- Tailwindcss
