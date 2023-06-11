import json
import requests
import glob
import os



def make_mockaroo_request():
    url = 'https://www.mockaroo.com/rest/schemas/download'
    headers = {
        'Content-Type': 'application/json'
    }
    with open('mockaroo-generate-data-payload.json') as fin:
        body = json.load(fin)
        response = requests.request("POST", url, headers=headers, json=body, stream=True)
        with open('1-mock-user-data-v0.json', 'wb') as fout:
            fout.write(response.content)

def post_user_registration_request(payload):
    headers = {
        'Content-Type': 'application/json'
    }
    url = "https://192.168.1.189:443/user/register"
    return requests.request("POST", url, headers=headers, json=payload, verify=False)


def make_user_registration_requests():
    path = os.getcwd()
    pattern = 'mock-user-data-v*.json'
    for filename in glob.glob(f'{path}/{pattern}'):
        with open(filename) as fin:
            mock_user_data = json.load(fin)
            for mock_user in mock_user_data:
                response = post_user_registration_request(mock_user)
                print(response)


if __name__ == '__main__':
    # make_mockaroo_request()
    make_user_registration_requests()



