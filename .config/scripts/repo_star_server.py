#!/usr/bin/env python3
import http.server
import socketserver
import json
import os
import subprocess

# --- Configuration ---
PORT = 9786
# Use an absolute path to your file
FILE_PATH = os.path.expanduser("~/Repos/repo_stars.yaml")
# ---------------------


def is_duplicate(url_to_check):
    """Check if the URL already exists in the file."""
    if not os.path.exists(FILE_PATH):
        return False

    try:
        with open(FILE_PATH, "r") as f:
            content = f.read()
            # We search for the specific URL line format to ensure accuracy
            if f'url: "{url_to_check}"' in content:
                return True
    except Exception as e:
        print(f"Error reading file for duplicate check: {e}")

    return False


class StarHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        # Read the JSON data sent from the browser
        content_length = int(self.headers["Content-Length"])
        post_data = self.rfile.read(content_length)

        try:
            data = json.loads(post_data)
            yaml_content = data.get("yaml", "")
            url = data.get("url")

            if not url:
                self.send_response(400)
                self.end_headers()
                return

            if is_duplicate(url):
                self.send_response(200)  # 200 OK, but notifies it's a duplicate
                self.end_headers()
                self.wfile.write(b"Duplicate entry ignored")

                subprocess.run(
                    [
                        "notify-send",
                        "-a",
                        "Starred",
                        "-u",
                        "low",
                        "-r",
                        "9997",
                        "-i",
                        "capture",
                        "-t",
                        "5000",
                        "Already Saved",
                        f"This repo exists in your database.",
                    ]
                )
                return

            # Write to file if not duplicate
            if yaml_content:
                with open(FILE_PATH, "a") as f:
                    # Write content + two newlines (one to end line, one for a gap)
                    f.write(yaml_content + "\n\n")

                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"Saved to file")

                subprocess.run(
                    [
                        "notify-send",
                        "-a",
                        "Starred",
                        "-u",
                        "low",
                        "-r",
                        "9997",
                        "-i",
                        "capture",
                        "-t",
                        "5000",
                        "Entry Saved",
                        f"{url}",
                    ]
                )
            else:
                self.send_response(400)
                self.end_headers()

        except Exception as e:
            print(f"Error: {e}")
            self.send_response(500)
            self.end_headers()

    # Suppress default logging to keep console clean
    def log_message(self, format, *args):
        return


if __name__ == "__main__":
    # Ensure directory exists
    os.makedirs(os.path.dirname(FILE_PATH), exist_ok=True)

    with socketserver.TCPServer(("127.0.0.1", PORT), StarHandler) as httpd:
        print(f"Repo Star Server running on port {PORT}...")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass
        print("Server stopped.")
