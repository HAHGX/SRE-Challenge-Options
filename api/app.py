import os
import pickle
import pandas as pd
from flask import Flask, request, jsonify

app = Flask(__name__)

# Cargar el modelo serializado
model_path = os.path.join(os.getcwd(), "models", "pickle_model.pkl")
with open(model_path, "rb") as f:
    model = pickle.load(f)

# Endpoint para realizar predicciones
@app.route("/predict", methods=["POST"])
def predict():
    # Obtener los datos del formulario enviado
    data = request.form.to_dict()
    # Crear un DataFrame de pandas con los datos
    df = pd.DataFrame(data, index=[0])
    # Realizar la predicción con el modelo cargado
    prediction = model.predict(df)[0]
    # Devolver la respuesta en formato JSON
    return jsonify({"prediction": int(prediction)})

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
