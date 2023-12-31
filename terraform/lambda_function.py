#########################################################################################
# lamda-function.py
#########################################################################################

import json
import socket
from datetime import datetime


def lambda_handler (event, context):

    print("Hello from Lambda!")
    
    ## This is to extract date time..
    now = datetime.now()
    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
    ## This is to extract the IP address...
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    
    print (dt_string)
    print (local_ip)
    
    data = {
        "ip": local_ip,
        "date": dt_string
        }
        
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(data)
    }