"""Small lab-only HTTP API. Python's built-in server is not a production server."""
from http.server import BaseHTTPRequestHandler, HTTPServer
from prometheus_client import Counter, CONTENT_TYPE_LATEST, generate_latest

REQUESTS = Counter('lab_api_requests_total', 'Requests to the lab greeting endpoint')

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/metrics':
            body, mime = generate_latest(), CONTENT_TYPE_LATEST
        elif self.path == '/health':
            body, mime = b'{"status":"ok"}\n', 'application/json'
        elif self.path == '/hello':
            REQUESTS.inc()
            body, mime = b'{"message":"Hello from the Network Nuts lab"}\n', 'application/json'
        else:
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header('Content-Type', mime)
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

if __name__ == '__main__':
    HTTPServer(('0.0.0.0', 8000), Handler).serve_forever()
