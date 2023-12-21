from PIL import Image, ImageDraw, ImageFont
from datetime import datetime
import os
import tempfile
import boto3

def add_text_to_image(bucket, key, private_ip_address):
    s3 = boto3.client('s3')

    # Download the image from S3
    temp_image_path = f'/tmp/{os.path.basename(key)}'
    s3.download_file(bucket, key, temp_image_path)

    # Open the image using Pillow
    image = Image.open(temp_image_path)
    draw = ImageDraw.Draw(image)
    font = ImageFont.load_default()

    # Get the current date and time
    current_datetime = datetime.now().strftime("%Y/%m/%d %H:%M:%S")

    # Add the text to the image
    text = f"Date on Webserver IP Address {private_ip_address} is {current_datetime}"
    draw.text((10, 10), text, (255, 255, 255), font=font)

    # Save the modified image
    modified_image_path = f'/tmp/modified_{os.path.basename(key)}'
    image.save(modified_image_path)

    # Upload the modified image back to the same S3 bucket
    modified_key = f'modified_{os.path.basename(key)}'
    s3.upload_file(modified_image_path, bucket, modified_key)

    return modified_key

def lambda_handler(event, context):
    # Replace with your S3 bucket and key
    s3_bucket = 'my-static-website46551jaffsfwerdjdf'
    s3_key = 'sbs_world_cup_image.jpg'
    
    # Get the private IP address of the Lambda function (replace with actual logic)
    private_ip_address = '127.0.0.1'

    # Add text to the image and get the modified image key
    modified_image_key = add_text_to_image(s3_bucket, s3_key, private_ip_address)

    return {
        'statusCode': 200,
        'body': f'Modified image key: {modified_image_key}'
    }
