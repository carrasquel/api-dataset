import os
from flask import Flask

from flask_autocrud import AutoCrud
from flask_sqlalchemy import SQLAlchemy

POSTGRES_USER = os.getenv("POSTGRES_USER")
SMTP_PORT = os.getenv("SMTP_PORT")
SENDGRID_MOCK_HOST = os.getenv("SENDGRID_MOCK_HOST")

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost:5432/dellstore'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['AUTOCRUD_METADATA_ENABLED'] = True

db = SQLAlchemy(app)
AutoCrud(app, db)

app.run(host="0.0.0.0", debug=True)