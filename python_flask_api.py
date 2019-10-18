import sys
from collections import namedtuple
from flask import Flask, jsonify, json, request

app = Flask(__name__)
@app.route('/')
def index():
    return "Welcome to Stock data Collector.!"

# {"index" : 125}
@app.route('/data', methods=['POST'])
def form_example():
    if request.method == 'POST':
        req_data = request.get_json()
        print(req_data)
        trend = req_data['trend']
        gap = req_data['gap']
        result_1 = req_data['result_1']
        distance = req_data['distance']
        result_2 = req_data['result_2']
        add_data(trend, gap, result_1, distance, result_2)
        return "done"

def save_buy_data(data):
    f = open("buy_data.csv","a+")
    f.write(str(data[0]) + ',' + str(data[1]) + ',' + str(data[2]) + ',' + str(data[3]) + '\n')
    f.close()

def save_sell_data(data):
    f = open("sell_data.csv","a+")
    f.write(str(data[0]) + ',' + str(data[1]) + ',' + str(data[2]) + ',' + str(data[3]) + '\n')
    f.close()

def add_data(trend, gap, result_1, distance, result_2):
    buy_data = namedtuple("buy_data", "gap result_1 distance result_2")
    sell_data = namedtuple("sell_data", "gap result_1 distance result_2")

    if trend == 1:
        new_buy_req = buy_data(gap, result_1, distance, result_2)
        save_buy_data(new_buy_req)
    else:
        new_sell_req = sell_data(gap, result_1, distance, result_2)
        save_sell_data(new_sell_req)

app.run(port=5000)