from flask import Flask
import boto3
import os

db = client = boto3.client('dynamodb')
app = Flask(__name__)


@app.route('/version', methods=['GET'])
def ver():
	return os.environ["VERSION"]

@app.route('/user/<string:user>/time', methods=['GET'])
def get_data(user):
    try:
        return {"minutes": db.get_item(
            TableName=os.environ["USER_TABLE"],
            Key={
                    "User":  {'S': user}
            },
            AttributesToGet=["Minutes"]
        )["Item"]["Minutes"]["N"]}
    except KeyError:
        return {"minutes": 0 }

if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=False)
    