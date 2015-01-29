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
    service = {'id': service_id, 'name': name, 'address': address, 'queue': []}
    service_map[service_id] = service
    return jsonify(service), 201

@app.route('/v1/user/register', methods=['POST'])
def register_service():
    name = request.json.get('name')
    telephone = request.json.get('telephone')
    user_id = hashlib.md5(telephone).hexdigest()
    if user_id in service_map:
        abort(409)
    user = {'id': user_id, 'name': name, 'telephone': telephone}
    user_map[user_id] = user
    return jsonify(user), 201

@app.route('/v1/service/<service_id>/queue', methods=['GET'])
def get_service_queue(service_id):
    if service_id in service_map:
        return jsonify(service_map[service_id]), 200
    abort(404)

@app.route('/v1/service/<service_id>/queue/add', methods=['POST'])
def add_to_queue(service_id):
    user_id = request.json.get('user_id')
    if service_id not in service_map or user_id not in user_map:
        abort(404)

    user = user_map[user_id]
    service = service_map[service_id]
    service[service_id]['queue'].put(user)
    return jsonify(service[service_id]['queue']), 201


@app.route('/v1/service/<service_id>/queue/remove/<user_id>', methods=['DELETE'])
def remove_from_queue(service_id, user_id):
    abort(404)


if __name__ == '__main__':
    app.run()