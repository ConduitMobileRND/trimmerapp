from flask import Flask, jsonify, make_response, abort, request

app = Flask(__name__)

service_map = {}

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
    if name not in service_map:
        abort(409)
    service = {'name': name, 'address': address, 'queue': {}}
    service_map[name] = service
    return jsonify(service), 201


@app.route('/v1/service/<int:service_id>/queue', methods=['GET'])
def get_service_queue(service_id):
    abort(404)

@app.route('/v1/service/<int:service_id>/queue/add', methods=['POST'])
def add_to_queue(service_id):
    abort(404)

@app.route('/v1/service/<int:service_id>/queue/get', methods=['GET'])
def get_from_queue(service_id):
    abort(404)

@app.route('/v1/service/<int:service_id>/queue/remove', methods=['DELETE'])
def remove_from_queue(service_id):
    abort(404)


if __name__ == '__main__':
    app.run()
