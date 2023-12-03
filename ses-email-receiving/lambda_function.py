import json
import boto3
import base64

import email


cliente_s3 = boto3.client('s3')


def extract_attachments(email_message):

    attachments = []
    
    for part in email_message.walk():
        if part.get_content_maintype() == 'multipart':
            continue
        if part.get('Content-Disposition') is None:
            continue

        filename = part.get_filename()
        if filename:
            payload = part.get_payload(decode=True)
            
            attachments.append(
                {
                    'filename': filename,
                    'data': payload
                }
            )

    return attachments


def lambda_handler(event, context):
    
    
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    conteudo = cliente_s3.get_object(Bucket=bucket, Key=key)
    body = conteudo['Body'].read()
    
    mensagem = email.message_from_bytes(body)
    anexos = extract_attachments(mensagem)
    
    for anexo in anexos:
        cliente_s3.put_object(Body=anexo['data'], Bucket=bucket, Key=f'anexos/{anexo["filename"]}')
    
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
