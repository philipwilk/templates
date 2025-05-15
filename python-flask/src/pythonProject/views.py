from flask import render_template, Flask, request


def create_app():
    """
    Flask app creation factory; adds routes to the app.

    Returns
    -------
    { Flask }
      The built flask app.
    """
    app = Flask(__name__)
    # QoL param for enabling debugging logging/mode
    # debug = app.config["DEBUG"]

    @app.route("/", methods=["POST", "GET"])
    def index():
        if request.method == "POST":
            data = [request.form.get("data")]
            print(data)
        return render_template("index.html")

    @app.route("/generate", methods=["POST"])
    def generate():
        data = request.form.get("data")

        return f'<img src="https://www.python.org/static/img/python-logo.png" alt="qr code generated for {data}">'

    return app
