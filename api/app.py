from flask import Flask, jsonify
from flask_restx import Api, Resource, fields
from onnx_model import SklearnOnnx
import asyncio

# Path to your ONNX model
MODEL_LOCATION = 'pipeline_tfidfnb.onnx'

# Initialize Flask application
app = Flask(__name__)

# Initialize Flask-RESTx API
api = Api(app, version='1.0', title='Prediction API', description='Make predictions using ONNX model for top k search query')

# Initialize your SklearnOnnx model
sklearn_model = SklearnOnnx(MODEL_LOCATION)

# Define input and output models
input_model = api.model('Input', {'query': fields.String(required=True), 'topk': fields.Integer()})
output_model = api.model('Output', {'categories': fields.List(fields.String), 'probabilities': fields.List(fields.Float)})

# Create prediction resource
@api.route('/predict')
class Prediction(Resource):
    @api.expect(input_model, validate=True)
    @api.marshal_with(output_model)
    async def post(self):
        try:
            loop = asyncio.get_event_loop()
            data = api.payload
            query = data.get('query')
            topk = data.get('topk', 10)  # Default topk value is 10

            # Asynchronously call the predict method
            cats, proba = await loop.run_in_executor(None, sklearn_model.predict, query, topk)
            return {'categories': cats, 'probabilities': proba}

        except Exception as e:
            error_message = "An error occurred: " + str(e)
            # Returning an appropriate error response with a 500 Internal Server Error status code
            return jsonify({'error': error_message}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
