Setting Up and Running Rasa and the Project

Requirements:
* Python: Supported versions are Python 3.7 - 3.10 (Python 3.11 is not supported).
* Virtualenv: Using a virtual environment is recommended for isolating project dependencies.


1. Set Up Python and Create a Virtual Environment

Virtualenv (рекомендуется): использование виртуальной среды для изоляции окружения и зависимостей проекта.
1. Убедитесь, что pip установлен. Выполните команду:
python -m ensurepip --upgrade
Установите virtualenv, если он ещё не установлен:
pip install virtualenv
Создайте виртуальное окружение:
python -m venv rasa_env
Активируйте виртуальное окружение:
source rasa_env/bin/activate

Установите Rasa через pip:
pip install rasa
Установите библиотеку Transformers для работы с предобученными LLM моделями, такими как BERT, GPT:
pip install transformers
Проверьте, что Rasa и окружение установлено, выполните команду:
rasa --version

Выполните тренировку модели на новой конфигурации:
rasa train 

Запустите сервер действий Rasa
```
rasa run actions
```

Запустите ассистента:
```
rasa run --cors "*"
```

Загрузите и установите все необходимые зависимости 
```
npm install
```

Соберите проект
```
npm run build
```

Запустите проект
```
npm run start
```

