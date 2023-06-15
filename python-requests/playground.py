import json
import requests
import glob
import os

def post_user_registration_request(payload):
    headers = {
        'Content-Type': 'application/json'
    }
    url = "https://192.168.1.189:443/user/register"
    return requests.request("POST", url, headers=headers, json=payload, verify=False)


def make_user_registration_requests():
    path = os.getcwd()
    pattern = 'mock-user-data.json'
    for filename in glob.glob(f'{path}/{pattern}'):
        with open(filename) as fin:
            mock_user_data = json.load(fin)
            for mock_user in mock_user_data:
                response = post_user_registration_request(mock_user)
                print(response)


if __name__ == '__main__':
    make_user_registration_requests()



