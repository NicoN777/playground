import pandas as pd
import os
import glob


def load_data_frames():
    path = os.getcwd()
    pattern = 'mock-user-data-v*.json'
    return [pd.read_json(filename) for filename in glob.glob(f'{path}/{pattern}')]

def cleanse(data_frames):
    df = pd.concat(data_frames)
    no_id = df.drop(['id'], axis=1)
    unique_users = no_id.drop_duplicates()
    unique_users['id'] = range(1, len(unique_users) + 1)
    cols = list(unique_users.columns)
    cols.insert(0, cols.pop())
    final_df = unique_users[cols]
    # final_df.to_json('mock-user-data.json', orient='records')


if __name__ == '__main__':
    data_frames = load_data_frames()
    cleanse(data_frames)
