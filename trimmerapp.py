import hashlib
from flask import Flask, jsonify, make_response, abort, request

app = Flask(__name__)

service_map = {}
user_map = {}

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

@app.errorhandler(409)
def not_found(error):
    return make_response(jsonify({'error': 'Record with such name already exists'}), 409)



@app.route('/v1/service/register', methods=['POST'])
def register_service():
    name = request.json.get('name')
    address = request.json.get('address')
    service_id = hashlib.md5(name).hexdigest()
    if service_id in service_map:
        abort(409)
    service = {'id': '7a9a595be6b992da61bcaf4b116e4a6a', 'name': name, 'address': address, 'queue': []}
    service_map[service_id] = service
    return jsonify(service), 201

@app.route('/v1/user/register', methods=['POST'])
def register_user():
    name = request.json.get('name')
    telephone = request.json.get('telephone')
    user_id = hashlib.md5(telephone).hexdigest()
    if user_id in user_map:
        abort(409)
    user = {'id': user_id, 'name': name, 'telephone': telephone}
    user_map[user_id] = user
    return jsonify(user), 201

@app.route('/v1/service/<service_id>/queue', methods=['GET'])
def get_service_queue(service_id):
    if service_id in service_map:
        return jsonify(queue=service_map[service_id]['queue']), 200
    abort(404)

@app.route('/v1/service/<service_id>/queue/add', methods=['POST'])
def add_to_queue(service_id):
    user_id = request.json.get('user_id')
    if service_id not in service_map or user_id not in user_map:
        abort(404)
    user = user_map[user_id]
    service = service_map[service_id]
    service['queue'].append(user)
    return jsonify(queue=service['queue']), 201


@app.route('/v1/service/<service_id>/queue/remove', methods=['DELETE'])
def remove_from_queue(service_id, user_id):
    user_id = request.json.get('user_id')
    if service_id not in service_map:
        abort(404)
    service = service_map[service_id]
    for user in service['queue']:
        if user['id'] == user_id:
            return 204
    abort(404)


if __name__ == '__main__':
    app.run()
