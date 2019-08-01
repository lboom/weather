#!/usr/bin/env python
from flask import Flask, jsonify
import datetime
import requests
import sqlite3
import os

api_key=os.environ['API_KEY']

def check_db():
    """ return current DB entry or update """
    c = conn_db()
    query = "SELECT temp, timestamp FROM weather WHERE city='PDX'"
    cur = c.cursor()
    cur.execute(query)
    cached = cur.fetchone()
    c.close()
    if compare_ts(cached[1]):
        return cached
    else:
        update_temp(api_key)
        # call self here
        #check_db()

def convert_ts(ts):
    """ convert datetime ts to human readable """
    return datetime.datetime.fromtimestamp(ts).replace(microsecond=0).isoformat()

def compare_ts(ts):
    """ check current ts in DB """
    return True

def conn_db():
    """ db connection """
    try:
        con = sqlite3.connect('pdx_weather.db')
        return con
    except Error as err:
        print("Unable to connect: ", err)

    return None

def update_temp(key):
    """ grab current temp in imperial and update sqlite DB """
    owp = "https://api.openweathermap.org/data/2.5/weather?" \
            "id=5746545&units=imperial&appid={}".format(key)
    try:
        req = requests.get(owp)
    except requests.exceptions.RequestException as err:
        print("Something went wrong: ", err)
    pdx_temp = req.json()['main']['temp']
    ts = datetime.datetime.now().timestamp()

    # update record
    query = "UPDATE weather SET temp=(?), timestamp=(?) WHERE city='PDX'"
    c = conn_db()
    cur = c.cursor()
    cur.execute(query, (pdx_temp, ts))
    c.commit()
    c.close()

    return

api = Flask(__name__)

@api.route('/temperature', methods=['GET'])
def return_temp():
    current_temp = check_db()
    ts = current_temp[1]
    c_temp = current_temp[0]
    return jsonify({"query_time": convert_ts(ts), "temperature": c_temp })

if __name__ == '__main__':
    api.run(host='0.0.0.0', port=5000)
