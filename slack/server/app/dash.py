import re
import os
import os.path
import subprocess
from app import app
from flask import Flask, Response, send_from_directory, request, jsonify


@app.route('/images/<path:filename>', methods=['GET'])
def send_image(filename):
    return send_from_directory('/var/www/slack/images', filename)

@app.route('/dash', methods=['POST'])
def dashboard():
    if request.form.get('token') != 'YOURTOKENHERE':
        return None

    channel = request.form.get('channel_name')
    username = request.form.get('user_name')
    response_url = request.form.get('response_url')
    text = request.form.get('text')

    if 'help' in text:
        return Response(
            "You can specify the following /dash commands:\n"
            "• *energy*\n    Display the active energy burned averages by month.\n"
            "• *exercise*\n    Display the apple exercise time averages by month.\n"
            "• *stand*\n    Display the apple stand hours averages by month.\n"
            "• *help*\n    This helpful message.\n"
            ), 200

    if title(text):
        return get_dashboard(response_url, channel, username, text)
    else:
        return Response('Could not find dashboard: %s' % text)


def title(text):
    if 'energy' in text:
        return 'Active Energy Burned Dashboard'
    elif 'exercise' in text:
        return 'Apple Exercise Hours Dashboard'
    elif 'stand' in text:
        return 'Apple Stand Hours Dashboard'
    else:
        return ''


def get_dashboard(response_url, channel, username, text):
    command = 'Rscript'
    path2script = '/var/www/slack/dashbot.R'

    # Variable number of args in a list
    args = [text]

    # Build subprocess command
    cmd = [command, path2script] + args

    # check_output will run the command and store to result
    result = subprocess.check_output(cmd, universal_newlines=True)
    image = re.sub('.*/', '', result)

    return jsonify({
        # "response_type": "in_channel",
        "text": title(text),
        "attachments": [{
            "title": title(text),
            "image_url": "https://slack.epicminds.com:11443/images/" + image
        }]
    })
