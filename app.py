from flask import Flask, jsonify, json, render_template
import os
from flask_cors import CORS, cross_origin



#################################################
# Flask Setup
#################################################
app = Flask(__name__)
cors = CORS(app, resources={r"/foo": {"origins": "http://localhost:5000"}})
# CORS(app)

# path_file = os.path.join("data_records.json")
path_file = os.path.join("static", "data", "data_records.json")


with open(path_file) as f:
  data = json.load(f)

@app.route('/')
def home():

    return render_template("index.html")

@app.route('/api/v1/data')
@cross_origin(origin='localhost', headers=['Content- Type', 'Authorization'])
def data_json():

    return jsonify(data)


if __name__ == "__main__":
    # @TODO: Create your app.run statement here
    app.run(debug=True)