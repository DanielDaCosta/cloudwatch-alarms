import sys
sys.path.insert(0, 'package/')
import json
import requests
import os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def parse_service_event(event, service='Service'):
    return [
        {
            'name': service,
            'value': event['Trigger']['Dimensions'][0]['value'],
            "inline": True
        },
        {
            'name': 'alarm',
            'value': event['AlarmName'],
            "inline": True
        },
        {
            'name': 'description',
            'value': event['AlarmDescription'],
            "inline": True
        },
        {
            'name': 'oldestState',
            'value': event['OldStateValue'],
            "inline": True
        },
        {
            'name': 'trigger',
            'value': event['Trigger']['MetricName'],
            "inline": True
        },
        {
            'name': 'event',
            'value': event['NewStateReason'],
            "inline": True
        }
    ]


def handler(event, context):
    webhook_url = os.getenv("WEBHOOK_URL")
    parsed_message = []
    for record in event.get('Records', []):
        sns_message = json.loads(record['Sns']['Message'])
        is_alarm = sns_message.get('Trigger', None)
        if is_alarm:
            if (is_alarm['Namespace'] == 'AWS/Lambda'):
                logging.info('Alarm from LAMBDA')
                parsed_message = parse_service_event(sns_message,
                                                     'Lambda')
        if not parsed_message:
            parsed_message = [{
                'name': 'Something not parsed happened',
                'value': json.dumps(sns_message)
            }]
        dicord_data = {
            'username': 'AWS',
            'avatar_url': 'https://a0.awsstatic.com/libra-css/images/logos/aws_logo_smile_1200x630.png',
            'embeds': [{
                'color': 16711680,
                'fields': parsed_message
            }]
        }

        headers = {'content-type': 'application/json'}
        response = requests.post(webhook_url, data=json.dumps(dicord_data),
                                 headers=headers)

        logging.info(f'Discord response: {response.status_code}')
        logging.info(response.content)
