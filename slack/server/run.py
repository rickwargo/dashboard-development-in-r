#!/usr/bin/python3

from app import app


context = ('./server/pki/fullchain.pem', './server/pki/privkey.pem')
app.run(host='0.0.0.0', port=11443,
        debug=False, ssl_context=context, threaded=True)
