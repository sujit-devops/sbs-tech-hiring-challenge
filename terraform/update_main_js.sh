#!/bin/bash

# Retrieve the API Gateway URL from Terraform output
api_url=$(terraform output -raw api_gateway_invoke_url)

# Replace the placeholder in main.js with the actual API Gateway URL
sed -i "s|__API_URL__|$api_url|g" main.js
