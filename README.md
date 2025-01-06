Configurando e Utilizando o Ambiente Docker para sua Aplicação Django

Este guia detalha como configurar e utilizar um ambiente Docker para sua aplicação Django com PostgreSQL. Ele usa dois arquivos principais: um Dockerfile para a construção da imagem da aplicação e um docker-compose.yml para gerenciar os serviços.

Pré-requisitos

Instalar o Docker.

Ter um arquivo requirements.txt com as dependências do projeto Django.
```
Arquivo Dockerfile

# Escolher uma imagem base com Python.
FROM python:3.11-slim

# Definir o diretório de trabalho no container.
WORKDIR /code

# Instalar as dependências do sistema.
RUN apt-get update && apt-get install -y libpq-dev

# Copiar os arquivos de dependências para o container.
COPY requirements.txt .

# Instalar as dependências do Python.
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código da aplicação para dentro do container.
COPY . .

# Expor a porta 8000 para a aplicação Django.
EXPOSE 8000

# Comando para rodar a aplicação Django.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
'''

O Dockerfile define como a imagem da aplicação será construída. Abaixo está o exemplo utilizado:
```
# Escolher uma imagem base com Python.
FROM python:3.11-slim

# Definir o diretório de trabalho no container.
WORKDIR /code

# Instalar as dependências do sistema.
RUN apt-get update && apt-get install -y libpq-dev

# Copiar os arquivos de dependências para o container.
COPY requirements.txt .

# Instalar as dependências do Python.
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o código da aplicação para dentro do container.
COPY . .

# Expor a porta 8000 para a aplicação Django.
EXPOSE 8000

# Comando para rodar a aplicação Django.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
'''

Arquivo docker-compose.yml

O docker-compose.yml define os serviços necessários para rodar a aplicação, incluindo o banco de dados PostgreSQL.
```
version: '3.9'

services:
  db:
    image: postgres:13
    container_name: postgres-db
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - pg-data:/var/lib/postgresql/data
    networks:
      - app-network

  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    environment:
      DATABASE_HOST: db
    depends_on:
      - db
    networks:
      - app-network

networks:
  app-network:

volumes:
  pg-data:

  ```

Configurando o Ambiente

1. Criar os Arquivos

Salve o conteúdo do Dockerfile e do docker-compose.yml no diretório raiz do seu projeto.

2. Adicionar Dependências

Certifique-se de que o arquivo requirements.txt contém todas as dependências do seu projeto Django (exemplo: Django, psycopg2).

3. Configurar o Banco de Dados

Atualize o settings.py do Django com as seguintes configurações de banco de dados:
```

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'myapp',
        'USER': 'user',
        'PASSWORD': 'password',
        'HOST': 'db',
        'PORT': 5432,
    }
}

```
Executando o Ambiente

1. Construir os Containers

No terminal, navegue até o diretório do projeto e execute:

docker-compose build

2. Iniciar os Serviços

Para iniciar os containers, execute:

docker-compose up

3. Acessar a Aplicação

A aplicação estará acessível em http://localhost:8000.

O banco de dados estará disponível na porta 5432.

4. Parar os Containers

Para parar os serviços, use:

docker-compose down

Persistência de Dados

O banco de dados utiliza um volume (pg-data) para persistir os dados, garantindo que as informações não sejam perdidas quando o container do PostgreSQL for reiniciado.

Debug e Logs

Para visualizar os logs dos containers:

docker-compose logs

Para acessar o shell do container Django:

docker exec -it <nome_do_container> /bin/bash

Com esses passos, você terá um ambiente Docker funcional para desenvolver e testar sua aplicação Django com PostgreSQL.

