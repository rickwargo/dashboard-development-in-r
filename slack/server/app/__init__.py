from flask import Flask

app = Flask(__name__)

from app import humor
from app import dash
