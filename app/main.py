from flask import Flask, jsonify, request

app = Flask(__name__)

# Хранилище пользователей(словарь)
users = {} 
next_id = 1 # ID следующего пользователя

@app.route('/')
def hello():
    return jsonify({"message": "Hello, World!"})

@app.route('/health')
def health():
    return jsonify({"status": "OK"}), 200

@app.route('/api/users', methods=['GET'])
def get_users():
    return jsonify({"users": list(users.values())})

@app.route('/api/users', methods=['POST'])
def create_user():
    global next_id
    data = request.get_json()
    
    #проверка, есть ли поле name
    if not data or 'name' not in data:
        return jsonify({"error": "Name is required"}), 400
    
    #создание нового пользователя
    user = {
        'id': next_id,
        'name': data['name']
    }
    #добавление нового пользователя в словарь
    users[next_id] = user
    #увеличение ID на 1
    next_id += 1
    #возвращение нового пользователя и статуса 201 (Created)
    return jsonify(user), 201

@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = users.get(user_id)
    if user is None:
        return jsonify({"error": "User not found"}), 404

    return jsonify(user)

@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    if user_id in users:
        del users[user_id]
        return '', 204

    return jsonify({"error": "User not found"}), 404
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    