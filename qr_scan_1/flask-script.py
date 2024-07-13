from bs4 import BeautifulSoup
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Function to load the blacklist from a file into a set
def load_blacklist(filename):
    with open(filename, 'r') as file:
        blacklist = set(line.strip() for line in file)
    return blacklist

# Function to add a URL to the blacklist file
def add_to_blacklist(filename, url):
    with open(filename, 'a') as file:
        file.write(url + '\n')

# Function to check if a URL is malicious using VirusTotal
def check_url_virustotal(url):
    # Replace 'YOUR_API_KEY' with your actual VirusTotal API key
    api_key = '3cb7007f6fef5e0cc2f1a26bfda652f4a1d456957867b4da889c207c0dfdfff7'
    url_endpoint = 'https://www.virustotal.com/vtapi/v2/url/report'

    params = {'apikey': api_key, 'resource': url}
    response = requests.get(url_endpoint, params=params)
    result = response.json()
    if result['response_code'] == 1:
        return result['positives'] > 0  # Return True if URL is malicious, False otherwise
    else:
        return False  # No information available

# Function to analyze HTML content for phishing attempts and inappropriate content
def fetch_html(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.content
    else:
        return None
def analyze_html_content(html_content):
    features = {
        "has_scripts": False,
        "has_forms": False,
        "is_phishing_attempt": False,
        "is_inappropriate_content": False
    }
    soup = BeautifulSoup(html_content, 'html.parser')

    if soup.find_all("script"):
        features["has_scripts"] = True
    if soup.find_all("form"):
        features["has_forms"] = True

    keywords = ["phishing", "scam", "fraud"]  
    content_text = soup.get_text()
    for keyword in keywords:
        if keyword in content_text:
            features["is_phishing_attempt"] = True

    inappropriate_keywords = ["adult", "hate"]  
    for keyword in inappropriate_keywords:
        if keyword in content_text:
            features["is_inappropriate_content"] = True

    return features

@app.route('/qr_scan_1/result.dart', methods=['POST'])
def check_url():
    data = request.get_json()
    url_input = data.get('url')

    if not url_input:
        return jsonify(error='URL not provided in JSON data.'), 400

    blacklist = load_blacklist('/home/jikson/MYAPP/qr_scan_1/blacklist.txt')
    if url_input in blacklist:
        return jsonify(message='The URL  Malicious and already blacklisted.'), 200
    else:
        if check_url_virustotal(url_input):
            add_to_blacklist('/home/jikson/MYAPP/qr_scan_1/blacklist.txt', url_input)
            return jsonify(message='The URL is malicious and has been added to the blacklist.'), 200
        else:
            return jsonify(message='The URL is not Malicious and not blacklisted.'), 200

@app.route('/qr_scan_1/Analysis.dart', methods=['POST'])
def analyze():
    data = request.get_json()

    if 'url' not in data:
        return jsonify({"error": "URL not provided."}), 400

    url = data.get('url')
    if url:
        html_content = fetch_html(url)
        if html_content:
            analysis_results = analyze_html_content(html_content)
            return jsonify({
                "message": "Analysis completed",
                "url": url,
                "analysis_results": analysis_results
            })
        else:
            return jsonify({"error": "Failed to fetch HTML content from URL."}), 500
    else:
        return jsonify({"error": "Invalid URL provided."}), 400

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=7000)
