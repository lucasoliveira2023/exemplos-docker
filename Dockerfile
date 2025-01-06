# Escolher uma imagem base com Python.
FROM python:3.11-slim  # Imagem do Python 3.11 baseada no Alpine, mais leve.

# Definir o diretório de trabalho no container.
WORKDIR /code  # O diretório onde o código será copiado e onde os comandos serão executados dentro do container.

# Instalar as dependências do sistema.
RUN apt-get update && apt-get install -y libpq-dev  # Instala a biblioteca libpq-dev para conexão com PostgreSQL.

# Copiar os arquivos de dependências para o container.
COPY requirements.txt .  # Copia o arquivo requirements.txt para o diretório de trabalho.

# Instalar as dependências do Python.
RUN pip install --no-cache-dir -r requirements.txt  # Instala as dependências listadas no requirements.txt.

# Copiar o código da aplicação para dentro do container.
COPY . .  # Copia o código da aplicação para o diretório de trabalho no container.

# Expor a porta 8000 para a aplicação Django.
EXPOSE 8000  # A aplicação Django ficará acessível na porta 8000.

# Comando para rodar a aplicação Django.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]  # Inicia o servidor Django.
