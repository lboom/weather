#!/usr/bin/env python
from flask import Flask, jsonify
from datetime import datetime
import requests
import sqlite3
import os

api_key=os.environ['API_KEY']

def get_temp(key):
    """ grab current temp in imperial and update sqlite DB """
    owp = "https://api.openweathermap.org/data/2.5/weather?" \
            "id=5746545&units=imperial&appid={}".format(key)
    try:
        req = requests.get(owp)
    except requests.exceptions.RequestException as err:
        print("Something went wrong: ", err)
    return req.json()['main']['temp']

api = Flask(__name__)

@api.route('/temperature', methods=['GET'])
def return_temp():
    return jsonify(get_temp(api_key))

if __name__ == '__main__':
    api.run(host='0.0.0.0', port=5000)
