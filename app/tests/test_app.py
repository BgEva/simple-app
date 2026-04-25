import sys
import os

# Добавляем папку app в путь поиска модулей
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from main import app

def test_root():
#Создаем тестового клиента
    with app.test_client() as client:
#Отправляем GET запрос на корневой URL
        response = client.get('/')
#Проверяем, что статус ответа 200
        assert response.status_code == 200
#Проверяем, что сообщение в ответе соответствует ожидаемому
asser response.json['message'] == 'Hello, World!'


def test_health():
#Создаем тестового клиента
    with app.test_client() as client:
#Отправляем GET запрос на health URL
        response = client.get('/health')
#Проверяем, что статус ответа 200
        assert response.status_code == 200
#Проверяем, что сообщение в ответе соответствует ожидаемому
        assert response.json['status'] == 'ok'


def test_get_users_empty():
#Создаем тестового клиента
    with app.test_client() as client:
#Отправляем GET запрос на users URL
        response = client.get('/api/users')
#Проверяем, что статус ответа 200
        assert response.status_code == 200
#Проверяем, что список пользователей пуст
        assert response.json['users'] == []


def test_create_user_success():
#Создаем тестового клиента
    with app.test_client() as client:
#Отправляем POST запрос на users URL с данными пользователя
        response = client.post('/api/users', json={'name': 'Кирилл'})
#Проверяем, что статус ответа 201
        assert response.status_code == 201
#Проверяем, что пользователь создан
        assert response.json['name'] == 'Кирилл'
#Проверяем, что в ответе есть поле id
        assert 'id' in response.json


def test_create_user_missing_name():
#Создаем тестового клиента
    with app.test_client() as client:
#Отправляем POST запрос на users URL без данных пользователя
        response = client.post('/api/users', json={})
#Проверяем, что статус ответа 400
        assert response.status_code == 400
#Проверяем, что в ответе есть поле error
        assert response.json['error'] == "Missing 'name' field"

def test_delete_user():
#Создаем тестового клиента
        with app.test_client() as client:
#Созадем пользователя
        client.post('api/users', json=('name': 'Test'))
#Удаляем пользователя
        response = client.delete('api/users/1')
#Проверяем, что пользователь удалился
        assert response.status_code == 404



